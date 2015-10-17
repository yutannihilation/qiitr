#' Qiita Comment API
#'
#' @name comment
#' @param url URL of Qiita (If you're not using Qiita:Team, this should be "https://qiita.com")
#' @param token Qiita API token
#' @param comment_id comment ID
#' @param item_id item(article) ID
#' @param per_page number of items per one page
#' @param page_offset page offset
#' @param page_limit max number of pages to aquire.
#' @param body body of the item
#' @export
qiita_get_comment <- function(url, token, comment_id = NULL, item_id = NULL,
                              per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if(!is.null(comment_id) && !is.null(item_id)) stop("You cannot specify comment_id and item_id both")
  if(is.null(comment_id) && is.null(item_id))   stop("Please specify commend_id or item_id")

  # Get a comment by ID (No pagenation is needed)
  if(!is.null(comment_id)){
    path <- sprintf("/api/v2/comments/%s", comment_id)
    result <- qiita_api("GET", url = url, path = path, token = token)
    return(result)
  }

  if(!is.null(item_id)) {
    path <- sprintf("/api/v2/items/%s/comments", item_id)
    result <- qiita_api("GET", url = url, path = path, token = token,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

#' @rdname comment
#' @export
qiita_delete_comment <- function(url, token, comment_id) {
  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("DELETE", url = url, path = path, token = token)
}

#' @rdname comment
#' @export
qiita_patch_comment <- function(url, token, comment_id, body) {
  path <- sprintf("/api/v2/comments/%s", comment_id)
  qiita_api("PATCH", url = url, path = path, token = token,
            payload = qiita_payload(body = body))
}

#' @rdname comment
#' @export
qiita_post_comment <- function(url, token, item_id, body) {
  path <- sprintf("/api/v2/items/%s/comments", item_id)
  qiita_api("POST", url = url, path = path, token = token,
            payload = qiita_payload(body = body))
}
