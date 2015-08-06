#' Qiita User API
#'
#' @param url URL of Qiita (If you're not using Qiita:Team, this should be "https://qiita.com")
#' @param token Qiita API token
#' @param user_id user id
#' @param item_id item id
#' @export
qiita_get_stocker <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s/stockers", item_id)
  qiita_api("GET", url = url, path = path, token = token)
}

#' @export
qiita_get_user <- function(url, token, user_id) {
  path <- paste0("/api/v2/users", tag_id, sep = "/")
  qiita_api("GET", url = url, path = path, token = token)
}

#' @export
qiita_get_followee <- function(url, token, user_id) {
  path <- sprintf("/api/v2/users/%s/followees", user_id)
  qiita_api("GET", url = url, path = path, token = token)
}

#' @export
qiita_get_follower <- function(url, token, user_id) {
  path <- sprintf("/api/v2/users/%s/follower", user_id)
  qiita_api("GET", url = url, path = path, token = token)
}

#' @export
qiita_delete_userfollow <- function(url, token, user_id) {
  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("DELETE", url = url, path = path, token = token)
}

#' @export
qiita_get_userfollow <- function(url, token, user_id) {
  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("GET", url = url, path = path, token = token)
}

#' @export
qiita_put_userfollow <- function(url, token, user_id) {
  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("PUT", url = url, path = path, token = token)
}

#' @export
qiita_get_authenticated_user <- function(url, token) {
  path <- "/api/v2/authenticated_user"
  qiita_api("GET", url = url, path = path, token = token)
}
