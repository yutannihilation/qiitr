#' Qiita User API
#'
#' @name user
#' @param user_id user ID
#' @param item_id item(article) ID
#' @param per_page number of items per one page
#' @param page_offset page offset
#' @param page_limit max number of pages to aquire.
#' @export
qiita_get_stocker <- function(item_id,
                              per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/items/%s/stockers", item_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_get_user <- function(user_id,
                           per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- paste0("/api/v2/users", user_id, sep = "/")
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_get_followee <- function(user_id,
                               per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/followees", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_get_follower <- function(user_id,
                               per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/follower", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_delete_userfollow <- function(user_id) {
  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("DELETE", path = path)
}

#' @rdname user
#' @export
qiita_get_userfollow <- function(user_id,
                                 per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_put_userfollow <- function(user_id) {
  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("PUT", path = path)
}

#' @rdname user
#' @export
qiita_get_authenticated_user <- function() {
  path <- "/api/v2/authenticated_user"
  qiita_api("GET", path = path)
}
