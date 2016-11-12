#' Qiita Tag API
#'
#' Get tags via Qiita API.
#'
#' @name tag
#' @param user_id User ID.
#' @param tag_id Tag ID.
#' @param per_page Number of items per one page.
#' @param page_offset Page offset.
#' @param page_limit Max number of pages to aquire.
#' @export
qiita_get_tags <- function(tag_id = NULL, user_id = NULL,
                          per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if(!is.null(tag_id) && !is.null(user_id))
    stop("You cannot specify tag_id and user_id both")

  if(is.null(tag_id) && is.null(user_id)) {
    path <- "/api/v2/tags"
    result <- qiita_api("GET", path = path,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  # Get an tag by ID (No pagenation is needed)
  if(!is.null(tag_id)){
    path <- sprintf("/api/v2/tags/%s", tag_id)
    result <- qiita_api("GET", path = path)
    return(result)
  }

  if(!is.null(user_id)){
    result <- qiita_get_tags_followed_by_user(user_id,
                                      per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

#' @rdname tag
#' @export
qiita_get_tags_followed_by_user <- function(user_id,
                                    per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/following_tags", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname tag
#' @export
qiita_delete_tags_following <- function(tag_id) {
  path <- sprintf("/api/v2/tags/%s/following", tag_id)
  qiita_api("DELETE", path = path)
}

#' @rdname tag
#' @export
qiita_get_tags_following <- function(tag_id,
                                per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/tags/%s/following", tag_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname tag
#' @export
qiita_put_tags_following <- function(tag_id) {
  path <- sprintf("/api/v2/tags/%s/following", tag_id)
  qiita_api("PUT", path = path)
}
