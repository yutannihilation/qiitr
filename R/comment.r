#' Qiita Comment API
#'
#' @name comment
#' @param comment_id comment ID
#' @param item_id item(article) ID
#' @param per_page number of items per one page
#' @param page_offset page offset
#' @param page_limit max number of pages to aquire.
#' @param body body of the item
#' @export
qiita_get_comments <- function(comment_id = NULL, item_id = NULL,
                              per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if(!is.null(comment_id) && !is.null(item_id)) stop("You cannot specify comment_id and item_id both")
  if(is.null(comment_id) && is.null(item_id))   stop("Please specify commend_id or item_id")

  # Get a comment by ID (No pagenation is needed)
  if(!is.null(comment_id)){
    path <- sprintf("/api/v2/comments/%s", comment_id)
    result <- qiita_api("GET", path = path)
    return(result)
  }

  if(!is.null(item_id)) {
    path <- sprintf("/api/v2/items/%s/comments", item_id)
    result <- qiita_api("GET", path = path,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

#' @rdname comment
#' @export
qiita_delete_comments <- function(comment_id) {
  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("DELETE", path = path)
}

#' @rdname comment
#' @export
qiita_patch_comments <- function(comment_id, body) {
  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("PATCH", path = path,
            payload = qiita_payload(body = body))
}

#' @rdname comment
#' @export
qiita_post_comments <- function(item_id, body) {
  path <- sprintf("/api/v2/items/%s/comments", item_id)
  qiita_api("POST", path = path,
            payload = qiita_payload(body = body))
}
