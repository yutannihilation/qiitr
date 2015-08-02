#' Qiita User API
#'
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
