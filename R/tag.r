#' Qiita Tag API
#'
#' Get, follow or unfollow tags via Qiita API.
#'
#' @name qiita_tag
#' @param tag_id Tag ID (e.g. \code{"R"}, \code{"dplyr"}).
#' @param user_id User ID (e.g. \code{"yutannihilation"}).
#' @param per_page Number of items per one page.
#' @param page_offset Page offset.
#' @param page_limit Max number of pages to aquire.
#' @examples
#' \dontrun{
#' # get a tag by Tag IDs
#' qiita_get_tags(tag_id = "R")
#'
#' # get tags by user ID
#' qiita_get_tags(user_id = "yutannihilation")
#'
#' # follow a tag
#' qiita_follow_tag("RStudio")
#'
#' # unfollow a tag
#' qiita_unfollow_tag("RStudio")
#' }
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
    result <- purrr::map(tag_id, qiita_get_single_tag_by_id)
    return(result)
  }

  if(!is.null(user_id)){
    result <- qiita_get_tags_followed_by_user(user_id,
                                      per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

qiita_get_single_tag_by_id <- function(tag_id) {
  path <- sprintf("/api/v2/tags/%s", tag_id)
  qiita_api("GET", path = path)
}

qiita_get_tags_followed_by_user <- function(user_id,
                                    per_page = 100L, page_offset = 0L, page_limit = 1L) {
  path <- sprintf("/api/v2/users/%s/following_tags", user_id)
  qiita_api("GET", path = path,
            per_page = per_page, page_offset = page_offset, page_limit = page_limit)
}

#' @rdname qiita_tag
#' @export
qiita_follow_tag <- function(tag_id) {
  if(!purrr::is_scalar_character(tag_id)) stop("tag_id must be a scalar character!")

  path <- sprintf("/api/v2/tags/%s/following", tag_id)
  qiita_api("PUT", path = path)
}


#' @rdname qiita_tag
#' @export
qiita_unfollow_tag <- function(tag_id) {
  if(!purrr::is_scalar_character(tag_id)) stop("tag_id must be a scalar character!")

  path <- sprintf("/api/v2/tags/%s/following", tag_id)
  qiita_api("DELETE", path = path)
}

#' @rdname qiita_tag
#' @export
qiita_is_following_tag <- function(tag_id) {
  if(!purrr::is_scalar_character(tag_id)) stop("tag_id must be a scalar character!")

 path <- sprintf("/api/v2/tags/%s/following", tag_id)
 qiita_api("GET", path = path, .expect204 = TRUE)
}
