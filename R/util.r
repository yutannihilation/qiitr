#' Utililies
#'
#' @import jsonlite
#'
#' @examples
#' tag(name = "R", version = ">3.1")
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
qiita_payload <- function(body = NULL, title = NULL, tags = NULL, gist = NULL, private = NULL, tweet = NULL) {
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
#' @export
qiita_api <- function(verb, url, path, token, payload = NULL, query = NULL) {
  res <- httr::VERB(verb, url = url, path = path,
             config = httr::add_headers(`Content-Type`  = "application/json",
                                        `Authorization` = paste("Bearer", token)),
             body = payload, query = query)

  # FIXME: specifying `type` is a temporal workaround to avoid error with mime::guess_type()
  httr::content(res, encoding = "UTF-8", type = "application/json")
}

