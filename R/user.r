#' Qiita User API
#'
#' Get, follow or unfollow users via Qiita API.
#'
#' @name qiita_user
#' @param user_id User ID (e.g. \code{"yutannihilation"}).
#' @param item_id Item (article) ID.
#' @param per_page Number of items per one page.
#' @param page_offset Number of offset pages.
#' @param page_limit Max number of pages to retrieve.
#'
#' @examples
#' \dontrun{
#' # get a user by id
#' qiita_get_users("yutannihilation")
#'
#' # follow a user
#' qiita_follow_user("user1")
#'
#' # unfollow a user
#' qiita_unfollow_user("user1")
#'
#' # get the current user
#' qiita_get_authenticated_user()
#' }
#'
#' @export
qiita_get_stockers <- function(item_id,
                              per_page = 100L, page_offset = 0L, page_limit = 1L) {
  result <- purrr::map(item_id, qiita_get_stockers_by_single_item,
             per_page = per_page, page_offset = page_offset, page_limit = page_limit)
  return(purrr::flatten(result))
}

qiita_get_stockers_by_single_item <- function(item_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/items/%s/stockers", item_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname qiita_user
#' @export
qiita_get_users <- function(user_id) {
  purrr::map(user_id, qiita_get_single_user)
}

qiita_get_single_user <- function(user_id) {
  path <- sprintf("/api/v2/users/%s", user_id)
  qiita_api("GET", path = path)
}

#' @rdname qiita_user
#' @export
qiita_get_followees <- function(user_id,
                               per_page = 100L, page_offset = 0L, page_limit = 1L) {
  result <- purrr::map(user_id, qiita_get_followees_by_single_user,
                       per_page = per_page, page_offset = page_offset, page_limit = page_limit)
  return(purrr::flatten(result))
}

qiita_get_followees_by_single_user <- function(user_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/users/%s/followees", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname qiita_user
#' @export
qiita_get_followers <- function(user_id,
                               per_page = 100L, page_offset = 0L, page_limit = 1L) {
  result <- purrr::map(user_id, qiita_get_followers_by_single_user,
                       per_page = per_page, page_offset = page_offset, page_limit = page_limit)
  return(purrr::flatten(result))
}

qiita_get_followers_by_single_user <- function(user_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/users/%s/followers", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname qiita_user
#' @export
qiita_follow_user <- function(user_id) {
  if(!purrr::is_scalar_character(user_id)) stop("user_id must be a scalar character!")

  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("PUT", path = path)
}

#' @rdname qiita_user
#' @export
qiita_unfollow_user <- function(user_id) {
  if(!purrr::is_scalar_character(user_id)) stop("user_id must be a scalar character!")

  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("DELETE", path = path)
}

#' @rdname qiita_user
#' @export
qiita_is_following_user <- function(user_id) {
  if(!purrr::is_scalar_character(user_id)) stop("user_id must be a scalar character!")

  path <- sprintf("/api/v2/users/%s/following", user_id)
  qiita_api("GET", path = path, .expect204 = TRUE)
}

#' @rdname qiita_user
#' @export
qiita_get_authenticated_user <- function() {
  path <- "/api/v2/authenticated_user"
  qiita_api("GET", path = path)
}
