#' Qiita Comments API
#'
#' Get, write, update or delete comments via Qiita API.
#'
#' @name qiita_comment
#' @param comment_id Comment ID.
#' @param item_id Item (article) ID.
#' @param per_page Number of items per one page.
#' @param page_offset Number of offset pages.
#' @param page_limit Max number of pages to retrieve.
#' @param body body of the item
#' @examples
#' \dontrun{
#' # get a comment by id
#' qiita_get_comments(comment_id = "1fdbb164e19d79e10203")
#'
#' # get comments by item id
#' qiita_get_comments(item_id = "b4130186e1e095719dcb")
#'
#' # post a comment to some item
#' qiita_post_comment(item_id = "123456789", body = "Thank you!!!")
#' }
#' @export
qiita_get_comments <- function(comment_id = NULL, item_id = NULL,
                              per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if(!is.null(comment_id) && !is.null(item_id)) stop("You cannot specify comment_id and item_id both")
  if(is.null(comment_id) && is.null(item_id))   stop("Please specify commend_id or item_id")

  # Get a comment by ID (No pagenation is needed)
  if(!is.null(comment_id)){
    result <- purrr::map(comment_id, qiita_get_single_comment_by_id)
    return(result)
  }

  if(!is.null(item_id)) {
    result <- purrr::map(item_id, qiita_get_comments_by_item,
                         per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(purrr::flatten(result))
  }
}

qiita_get_single_comment_by_id <- function(comment_id) {
  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("GET", path = path)
}

qiita_get_comments_by_item <- function(item_id, per_page, page_offset, page_limit) {
  path <- sprintf("/api/v2/items/%s/comments", item_id)
  result <- qiita_api("GET", path = path,
                      per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname qiita_comment
#' @export
qiita_delete_comment <- function(comment_id) {
  if(!purrr::is_scalar_character(comment_id)) stop("comment_id must be a scalar character!")

  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("DELETE", path = path)
}

#' @rdname qiita_comment
#' @export
qiita_update_comment <- function(comment_id, body) {
  if(!purrr::is_scalar_character(comment_id)) stop("comment_id must be a scalar character!")
  if(!purrr::is_scalar_character(body)) stop("body must be a scalar character!")

  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("PATCH", path = path,
            payload = qiita_util_payload(body = body))
}

#' @rdname qiita_comment
#' @export
qiita_post_comment <- function(item_id, body) {
  if(!purrr::is_scalar_character(item_id)) stop("item_id must be a scalar character!")
  if(!purrr::is_scalar_character(body)) stop("body must be a scalar character!")

  path <- sprintf("/api/v2/items/%s/comments", item_id)
  qiita_api("POST", path = path,
            payload = qiita_util_payload(body = body))
}
