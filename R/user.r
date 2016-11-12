#' Qiita User API
#'
#' @name user
#' @param user_id User ID (e.g. \code{"yutannihilation"}).
#' @param item_id Item (article) ID.
#' @param per_page Number of items per one page.
#' @param page_offset Number of offset pages.
#' @param page_limit Max number of pages to retrieve.
#' @export
qiita_get_stockers <- function(item_id,
                              per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/items/%s/stockers", item_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_get_users <- function(user_id,
                           per_page = 100L, page_offset = 0L, page_limit = 1L) {
  purrr::map(user_id, qiita_get_single_user,
             per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

qiita_get_single_user <- function(user_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/users/%s", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_get_followees <- function(user_id,
                               per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/followees", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_get_followers <- function(user_id,
                               per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/follower", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname user
#' @export
qiita_follow_user <- function(user_id) {
  if(!purrr::is_scalar_character(user_id)) stop("user_id must be a scalar character!")

  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("PUT", path = path)
}

#' @rdname user
#' @export
qiita_unfollow_user <- function(user_id) {
  if(!purrr::is_scalar_character(user_id)) stop("user_id must be a scalar character!")

  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("DELETE", path = path)
}

#' @rdname user
#' @export
qiita_is_following_user <- function(user_id) {
  if(!purrr::is_scalar_character(user_id)) stop("user_id must be a scalar character!")

  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("GET", path = path, .expect204 = TRUE)
}

#' @rdname user
#' @export
qiita_get_authenticated_user <- function() {
  path <- "/api/v2/authenticated_user"
  qiita_api("GET", path = path)
}
