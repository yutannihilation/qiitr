#' Qiita Item (Article) API
#'
#' Get, post, delete, stock or unstock articles via Qiita API.
#'
#' @name qiita_item
#'
#' @param item_id Item (Article) ID.
#' @param query Query string (e.g. \code{"dplyr user:yutannihlation"}).
#' @param user_id User ID (e.g. \code{"yutannihilation"}).
#' @param per_page Number of items per one page.
#' @param page_offset Number of offset pages.
#' @param page_limit Max number of pages to retrieve.
#' @param tag_id Tag IDs (e.g. \code{"R"}).
#' @param body Content body.
#' @param title Title.
#' @param tags Tags. Use \code{qiita_util_tag} to generate tag objects.
#' @param private If \code{TRUE}, the post will be private.
#' @param coediting If \code{TRUE}, the post will be editable by team members.
#' @param gist If \code{TRUE}, post the code to Gist.
#' @param tweet If \code{TRUE}, notify on Twitter.
#'
#' @examples
#' \dontrun{
#' # get items by item ID
#' qiita_get_items(item_id = "7a78d897810446dd6a3b")
#'
#' # get items by tag ID
#' qiita_get_items(tag_id = c("dplyr", "tidyr"), per_pages = 10L, page_limit = 1L)
#'
#' # get items by user ID
#' qiita_get_items(user_id = "yutannihilation")
#'
#' # Post an item. Note that the post is private by default.
#' # You should manually check if the post is valid before make it public.
#' item <- qiita_post_item(title = "test", body = "This is an example.")
#'
#' # update the post
#' qiita_update_item(item$id, title = "test", body = "**This is a strong example!**")
#'
#' # delete the post
#' qiita_delete_item(item$id)
#' }
#'
#' @export
qiita_get_items <- function (item_id = NULL, tag_id = NULL, user_id = NULL, query = NULL,
                            per_page = 100L, page_offset = 0L, page_limit = 1L) {
  num_of_not_nulls <- sum(!purrr::map_lgl(list(item_id, tag_id, user_id), is.null))

  if (num_of_not_nulls > 1)
    stop("You cannot specify more-than-one conditions")

  # Get newest items
  if (num_of_not_nulls == 0) {
    path <- "/api/v2/items"
    result <- qiita_api("GET", path = path,
                        query = list(query = query),
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  # Get items by ID (No pagenation is needed)
  if (!is.null(item_id)) {
    result <- purrr::map(item_id, qiita_get_single_item)
    return(result)
  }

  # Get items by tag
  if (!is.null(tag_id)) {
    result <- purrr::map(tag_id, qiita_get_items_by_tag,
                         per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(purrr::flatten(result))
  }

  # Get items by user
  if (!is.null(user_id)) {
    result <- purrr::map(user_id, qiita_get_items_by_user,
                         per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(purrr::flatten(result))

  }
}

qiita_get_single_item <- function(item_id) {
  path <- sprintf("/api/v2/items/%s", item_id)
  qiita_api("GET", path = path)
}

qiita_get_items_by_tag <- function(tag_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/tags/%s/items", tag_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

qiita_get_items_by_user <- function(user_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/users/%s/items", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname qiita_item
#' @export
qiita_post_item <- function(title, body, tags = qiita_util_tag("R"),
                            coediting = FALSE, private = TRUE, gist = FALSE, tweet = FALSE) {
  if(!purrr::is_scalar_character(title)) stop("title must be a scalar character!")
  if(!purrr::is_scalar_character(body)) stop("body must be a scalar character!")

  path    <- "/api/v2/items"
  payload <- qiita_util_payload(
    body = body,
    title = title,
    tags = tags,
    private = private,
    coediting = coediting,
    gist = gist,
    tweet = tweet
  )

  qiita_api("POST", path = path,
            payload = payload)
}

#' @rdname qiita_item
#' @export
qiita_delete_item <- function(item_id) {
  if(!purrr::is_scalar_character(item_id)) stop("item_id must be a scalar character!")

  path <- sprintf("/api/v2/items/%s", item_id)
  qiita_api("DELETE", path = path)
}

#' @rdname qiita_item
#' @export
qiita_update_item <- function(item_id, title, body,
                              tags = list(qiita_util_tag("R")), private = TRUE) {
  if(!purrr::is_scalar_character(item_id)) stop("item_id must be a scalar character!")
  if(!purrr::is_scalar_character(title)) stop("title must be a scalar character!")
  if(!purrr::is_scalar_character(body)) stop("body must be a scalar character!")

  path <- sprintf("/api/v2/items/%s", item_id)
  payload <- qiita_util_payload(
    body = body,
    title = title,
    tags = tags,
    private = private
  )

  qiita_api("PATCH", path = path,
            payload = payload)
}

#' @rdname qiita_item
#' @export
qiita_stock_item <- function(item_id) {
  if(!purrr::is_scalar_character(item_id)) stop("item_id must be a scalar character!")

  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("PUT", path = path)
}

#' @rdname qiita_item
#' @export
qiita_unstock_item <- function(item_id) {
  if(!purrr::is_scalar_character(item_id)) stop("item_id must be a scalar character!")

  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("DELETE", path = path)
}

#' @rdname qiita_item
#' @export
qiita_is_stocked_item <- function(item_id) {
  if(!purrr::is_scalar_character(item_id)) stop("item_id must be a scalar character!")

  path <- sprintf("/api/v2/items/%s/stock", item_id)
  result <- qiita_api("GET", path = path, .expect204 = TRUE)
}

#' @rdname qiita_item
#' @export
qiita_get_stocks <- function(user_id,
                             per_page = 100L, page_offset = 0L, page_limit = 1L) {

  result <- purrr::map(user_id, qiita_get_stocks_by_single_user,
                       per_page = per_page, page_offset = page_offset, page_limit = page_limit)
  return(result)
}

qiita_get_stocks_by_single_user <- function(user_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/users/%s/stocks", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}
