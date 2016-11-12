#' Generate Payload And Tag For Qiita API
#'
#' @name util
#'
#' @param name Tag name
#' @param versions Versions (e.g. \code{3.1}, \code{>3.2}).
#' @param body Content body.
#' @param title Title.
#' @param tags Tags. Use \code{qiita_tag} to generate tag objects.
#' @param private If \code{TRUE}, the post will be private.
#' @param coediting If \code{TRUE}, the post will be editable by team members.
#' @param gist If \code{TRUE}, post the code to Gist.
#' @param tweet If \code{TRUE}, notify on Twitter.
#'
#' @examples
#' qiita_tag(name = "R", versions = ">3.1")
#'
#' qiita_payload(body = "foo",
#'               title = "test",
#'               tags = list(
#'                   qiita_tag(name = "R", versions = ">3.1"),
#'                   qiita_tag(name = "dplyr")
#'               ),
#'               private = TRUE)
#'
#' @export
qiita_tag <- function(name, versions = NULL) {
  x <- list()
  class(x) <- c("qiita_tag", "list")

  x$name    <- name
  x$versions <- I(versions)
  x
}

#' @rdname util
#' @export
qiita_payload <- function(body = NULL, title = NULL, tags = NULL,
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
#' @param verb method type (GET, POST, DELETE, etc..)
#' @param url URL of Qiita (If you're not using Qiita:Team, this should be "https://qiita.com")
#' @param token Qiita API token
#' @param path path of API
#' @param payload JSON payload
#' @param query URI quer
#' @param per_page number of items/tags/users/etc. in one page
#' @param page_offset page number to start
#' @param page_limit the number of pages where no more requests will be sent
#' @export
qiita_api <- function(verb, url, path, token, payload = NULL, query = NULL,
                      per_page = 100L, page_offset = 0L, page_limit = 1L) {

  if (is.null(query)) query <- list()
  query$per_page <- per_page
  query$page     <- start_page <- 1 + page_offset

  header <- httr::add_headers(`Content-Type`  = "application/json",
                              `Authorization` = paste("Bearer", token))

  res <- httr::VERB(
    verb, url = url, path = path,
    config = header, body = payload, query = query
  )

  # FIXME: specifying `type` is a temporal workaround to avoid error with mime::guess_type()
  result <-
    httr::content(res, encoding = "UTF-8", type = "application/json")

  total_count <- as.integer(res$headers$`total-count`)
  total_page  <- ceiling(total_count / per_page)
  end_page    <- min(total_page, page_offset + page_limit)

  message(sprintf("total count is %d (= %d pages)", total_count, total_page))

  if (end_page <= start_page) {
    return(result)
  }

  for (p in seq(start_page + 1, end_page)) {
    message(sprintf("getting page %s...", p))
    query$page <- p

    res <- httr::VERB(
      verb, url = url, path = path,
      config = header, body = payload, query = query
    )

    result <- c(
      result,
      httr::content(res, encoding = "UTF-8", type = "application/json")
    )
  }

  result
}
