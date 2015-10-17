#' Utililies
#'
#' @import jsonlite
#'
#' @examples
#' qiita_tag(name = "R", version = ">3.1")
#'
#' @param name tag name
#' @param version version
#'
#' @export
qiita_tag <- function(name, version = NULL) {
  x <- list()
  x$name    <- name
  x$version <- version
  x
}

#' @export
qiita_payload <- function(body = NULL, title = NULL, tags = NULL,
                          gist = NULL, private = NULL, tweet = NULL) {
    payload <- list()

    payload$body   <- body
    payload$title  <- title
    payload$tags   <- tags
    payload$private <- private
    payload$tweet  <- tweet

    jsonlite::toJSON(payload, auto_unbox = TRUE)
  }



#' @title A httr Wrapper for Qiita API
#'
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
