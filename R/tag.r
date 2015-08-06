#' Qiita Tagging API
#'
#' @param url URL of Qiita (If you're not using Qiita:Team, this should be "https://qiita.com")
#' @param token Qiita API token
#' @param user_id user id
#' @param tag_id tag id
#' @export
qiita_get_tag <- function(url, token, tag_id = NULL, user_id = NULL) {
  if(!is.null(tag_id) && !is.null(user_id)) stop("You cannot specify tag_id and user_id both")

  if(is.null(tag_id) && is.null(user_id)) {
    path <- "/api/v2/tags"
    return(qiita_api("GET", url = url, path = path, token = token))
  }

  if(!is.null(tag_id)){
    path <- paste0("/api/v2/tags", tag_id, sep = "/")
    qiita_api("GET", url = url, path = path, token = token)
  }

  if(!is.null(user_id)){
    qiita_get_following_tag(url, token, user_id)
  }
}

#' @export
qiita_get_following_tag <- function(url, token, user_id) {
  path <- sprintf("/api/v2/users/%s/following_tags", user_id)
  qiita_api("GET", url = url, path = path, token = token,
            payload = qiita_payload(body = tag))
}

#' @export
qiita_delete_tagfollow <- function(url, token, tag_id) {
  path <- sprintf("/api/v2/tags/:tag_id/following", tag_id)
  qiita_api("DELETE", url = url, path = path, token = token)
}

#' @export
qiita_get_tagfollow <- function(url, token, tag_id) {
  path <- sprintf("/api/v2/tags/:tag_id/following", tag_id)
  qiita_api("GET", url = url, path = path, token = token)
}

#' @export
qiita_put_tagfollow <- function(url, token, tag_id) {
  path <- sprintf("/api/v2/tags/:tag_id/following", tag_id)
  qiita_api("PUT", url = url, path = path, token = token)
}
