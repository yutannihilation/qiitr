#' Qiita Item (Article) API
#'
#' @name qiita_item
#' @param item_id item(article) ID
#' @param query query string
#' @param user_id user ID
#' @param per_page number of items per one page
#' @param page_offset page offset
#' @param page_limit max number of pages to aquire.
#' @param tag_id tag ID
#' @param title title of the item
#' @param body body of the item
#' @param tags tags of the item
#' @param private private or not
#' @param coediting If \code{TRUE}, the post will be editable by team members.
#' @param gist push to gist or not
#' @param tweet tweet or not
#' @export
qiita_get_items <- function (item_id = NULL, tag_id = NULL, user_id = NULL, query = NULL,
                            per_page = 100L, page_offset = 0L, page_limit = 1L) {
  num_of_not_nulls <- sum(!sapply(list(item_id, tag_id, user_id), is.null))

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

  # Get an item by ID (No pagenation is needed)
  if (!is.null(item_id)) {
    path <- sprintf("/api/v2/items/%s", item_id)
    result <- qiita_api("GET", path = path)
    return(result)
  }

  # Get items by tag
  if (!is.null(tag_id)) {
    path <- sprintf("/api/v2/tags/%s/items", tag_id)
    result <- qiita_api("GET", path = path,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  # Get items by user
  if (!is.null(user_id)) {
    path <- sprintf("/api/v2/users/%s/items", user_id)
    result <- qiita_api("GET", path = path,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)

    return(result)
  }
}

#' @rdname qiita_item
#' @export
qiita_post_items <- function(title, body, tags = qiita_tag("R"),
                            coediting = FALSE, private = FALSE, gist = FALSE, tweet = FALSE) {
  path    <- "/api/v2/items"
  payload <- qiita_payload(
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
qiita_delete_items <- function(item_id) {
  path <- sprintf("/api/v2/items/%s", item_id)
  qiita_api("GET", path = path)
}

#' @rdname qiita_item
#' @export
qiita_patch_items <- function(item_id, title, body,
                             tags = list(qiita_tag("R")), private = FALSE) {
  path <- sprintf("/api/v2/items/%s", item_id)
  payload <- qiita_payload(
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
qiita_delete_stocks <- function(item_id) {
  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("DELETE", path = path)
}

#' @rdname qiita_item
#' @export
qiita_get_stocks <- function(item_id = NULL, user_id = NULL,
                            per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if (!is.null(item_id) && !is.null(user_id))
    stop("You cannot specify item_id and user_id both")
  if (is.null(item_id) && is.null(user_id))
    stop("Please specify item_id or user_id")

  if (!is.null(item_id)) {
    path <- sprintf("/api/v2/items/%s/stock", item_id)
    result <- qiita_api("GET", path = path,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  if (!is.null(user_id)) {
    path <- sprintf("/api/v2/users/%s/stocks", user_id)
    result <- qiita_api("GET", path = path,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

#' @rdname qiita_item
#' @export
qiita_put_stocks <- function(item_id) {
  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("PUT", path = path)
}
