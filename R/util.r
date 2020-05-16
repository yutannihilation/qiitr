#' Generate Payload And Tag For Qiita API
#'
#' @name qiita_util
#'
#' @param name Tag name
#' @param versions Versions (e.g. \code{3.1}, \code{>3.2}).
#' @param body Content body.
#' @param title Title.
#' @param tags Tags. Use \code{qiita_util_tag} to generate tag objects.
#' @param private If \code{TRUE}, the post will be private.
#' @param coediting If \code{TRUE}, the post will be editable by team members.
#' @param gist If \code{TRUE}, post the code to Gist.
#' @param tweet If \code{TRUE}, notify on Twitter.
#'
#' @examples
#' qiita_util_tag(name = "R", versions = ">3.1")
#'
#' qiita_util_payload(body = "foo",
#'                    title = "test",
#'                    tags = list(
#'                      qiita_util_tag(name = "R", versions = ">3.1"),
#'                      qiita_util_tag(name = "dplyr")
#'                    ),
#'                    private = TRUE)
#'
#' @export
qiita_util_tag <- function(name, versions = NULL) {
  x <- list()
  class(x) <- c("qiita_tag", "list")

  x$name     <- name
  x$versions <- if(is.null(versions)) I(list()) else I(versions)
  x
}

#' @rdname qiita_util
#' @export
qiita_util_payload <- function(body = NULL, title = NULL, tags = NULL,
                          private = NULL, coediting = NULL,
                          gist = NULL, tweet = NULL) {
  # tag must be wrapped with list.
  if(inherits(tags, "qiita_tag")) tags <- list(tags)

  payload <- list()

  payload$body   <- body
  payload$title  <- title
  payload$tags   <- tags
  payload$private <- private
  payload$coediting <- coediting
  payload$gist   <- gist
  payload$tweet  <- tweet

  jsonlite::toJSON(payload, auto_unbox = TRUE)
}



#' Send A Request To Qiita API
#'
#' An \link[httr]{httr} Wrapper for Qiita API.
#'
#' @name qiita_api
#' @import httr
#' @param verb Method type (e.g. GET, POST, DELETE).
#' @param path Path of API.
#' @param payload JSON payload.
#' @param query Query strings.
#' @param per_page Number of entries (e.g. items, tags, users) in one page.
#' @param page_offset Number of offset pages.
#' @param page_limit Max number of pages to retrieve.
#' @param .expect204
#'   If \code{TRUE}, return \code{TRUE} for status code 204 and \code{FALSE} for status code 404.
#' @export
qiita_api <- function(verb, path, payload = NULL, query = NULL,
                      per_page = 100L, page_offset = 0L, page_limit = 1L,
                      .expect204 = FALSE) {

  # Set QIITA_URL envvar to access Qiita API.
  url <- Sys.getenv("QIITA_URL")
  if(identical(url, "")) url <- "https://qiita.com/"

  # Set QIITA_ACCESSTOKEN envvar before.
  token <- Sys.getenv("QIITA_ACCESSTOKEN")
  if(identical(token, "")) {
    warning("Please set QIITA_ACCESSTOKEN envvar to use APIs that needs authorization.")
  }

  if (is.null(query)) query <- list()
  query$per_page <- per_page
  query$page     <- start_page <- 1 + page_offset

  header <- httr::add_headers(`Content-Type`  = "application/json",
                              `Authorization` = paste("Bearer", token))

  res <- httr::VERB(
    verb, url = url, path = path,
    config = header, body = payload, query = query
  )

  # for qiita_is_following_{user,tag}
  if (.expect204) {
    status_code <- httr::status_code(res)
    if(identical(status_code, 204L)) return(TRUE)
    if(identical(status_code, 404L)) return(FALSE)
    stop(sprintf("Unknown status code %d: ", status_code))
  }

  # FIXME: specifying `type` is a temporal workaround to avoid error with mime::guess_type()
  first_result <- qiia_api_content(res)

  total_count <- as.integer(res$headers$`total-count`)
  total_page  <- ceiling(total_count / per_page)
  end_page    <- as.integer(min(total_page, page_offset + page_limit))

  message(sprintf("total count is %d (= %d pages)", total_count, total_page))

  if (end_page <= start_page) {
    return(first_result)
  }

  result <- vector("list", end_page - start_page + 1)
  result[[1]] <- first_result

  # start with page 2 as we already have page 1.
  for (i in seq(2, length(result))) {
    p <- i + start_page - 1
    message(sprintf("getting page %s...", p))
    query$page <- p

    res <- httr::VERB(
      verb, url = url, path = path,
      config = header, body = payload, query = query
    )

    result[[i]] <- qiia_api_content(res)
  }

  purrr::flatten(result)
}

qiia_api_content <- function(res) {
  status_code <- httr::status_code(res)

  if (status_code >= 400) {
    stop(sprintf("API returns an error (HTTP %d):\n    %s",
                 status_code,  httr::content(res, encoding = "UTF-8", as = "text")))
  }

  httr::content(res, encoding = "UTF-8", type = "application/json")
}
