#' Qiita Tag API
#'
#'
#'
#' @name tag
#' @param url URL of Qiita (If you're not using Qiita:Team, this should be "https://qiita.com").
#' @param token Qiita API token.
#' @param user_id User ID.
#' @param tag_id Tag ID.
#' @param per_page Number of items per one page.
#' @param page_offset Page offset.
#' @param page_limit Max number of pages to aquire.
#' @export
qiita_get_tags <- function(url, token, tag_id = NULL, user_id = NULL,
                          per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if(!is.null(tag_id) && !is.null(user_id))
    stop("You cannot specify tag_id and user_id both")

  if(is.null(tag_id) && is.null(user_id)) {
    path <- "/api/v2/tags"
    result <- qiita_api("GET", url = url, path = path, token = token,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  # Get an tag by ID (No pagenation is needed)
  if(!is.null(tag_id)){
    path <- paste0("/api/v2/tags/%s", tag_id, sep = "/")
    result <- qiita_api("GET", url = url, path = path, token = token)
    return(result)
  }

  if(!is.null(user_id)){
    path <- paste0("/api/v2/users/%s/following_tags", user_id, sep = "/")
    result <- qiita_get_following_tag(url, token, user_id,
                                      per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

#' @rdname tag
#' @export
qiita_get_tags_followed_by_user <- function(url, token, user_id,
                                    per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/following_tags", user_id)
  qiita_api("GET", url = url, path = path, token = token,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname tag
#' @export
qiita_delete_tags_following <- function(url, token, tag_id) {
  path <- sprintf("/api/v2/tags/:tag_id/following", tag_id)
  qiita_api("DELETE", url = url, path = path, token = token)
}

#' @rdname tag
#' @export
qiita_get_tags_following <- function(url, token, tag_id,
                                per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/tags/:tag_id/following", tag_id)
  qiita_api("GET", url = url, path = path, token = token,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname tag
#' @export
qiita_put_tags_following <- function(url, token, tag_id) {
  path <- sprintf("/api/v2/tags/:tag_id/following", tag_id)
  qiita_api("PUT", url = url, path = path, token = token)
}
