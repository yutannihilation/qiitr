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
#' @param per_page number of items/tags/users/etc. in one page
#' @param page number of the page (This param is ignored when get_all is TRUE)
#' @param get_all whethear or not to get all items/tags/users/etc.
#' @export
qiita_api <- function(verb, url, path, token, payload = NULL, query = NULL, per_page = 100, page = 1, get_all = FALSE) {
  if(any(c("per_page", "page") %in% names(query))) warning("per_page and page in query is overwritten")

  if(is.null(query)) query <- list()
  query$per_page <- per_page
  query$page     <- ifelse(get_all, 1, page) #When getting all pages, attempts should start from page 1

  header <- httr::add_headers(`Content-Type`  = "application/json",
                              `Authorization` = paste("Bearer", token))

  res <- httr::VERB(verb, url = url, path = path,
             config = header, body = payload, query = query)

  # FIXME: specifying `type` is a temporal workaround to avoid error with mime::guess_type()
  result <- httr::content(res, encoding = "UTF-8", type = "application/json")

  total_count <- res$headers$`total-count`
  cat("total count is", total_count)

  if(total_count > per_page && get_all) {
    for(p in seq(2, trunc(total_count/per_page)+1)) {
      query$page <- p

      res <- httr::VERB(verb, url = url, path = path,
                        config = header, body = payload, query = query)

      result <- c(result, httr::content(res, encoding = "UTF-8", type = "application/json"))
    }
  }

  result
}
