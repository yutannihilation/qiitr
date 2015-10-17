#' Qiita Item API
#'
#' @name item
#' @param url URL of Qiita (If you're not using Qiita:Team, this should be "https://qiita.com")
#' @param token Qiita API token
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
#' @param gist push to gist or not
#' @param private private or not
#' @param tweet tweet or not
#' @export
qiita_get_item <- function (url, token,
                            item_id = NULL, tag_id = NULL, user_id = NULL, query = NULL,
                            per_page = 100L, page_offset = 0L, page_limit = 1L) {
  num_of_not_nulls <- sum(!sapply(list(item_id, tag_id, user_id), is.null))

  if (num_of_not_nulls > 1)
    stop("You cannot specify more-than-one conditions")

  # Get newest items
  if (num_of_not_nulls == 0) {
    path <- "/api/v2/items"
    result <- qiita_api("GET", url = url, path = path, token = token,
                        query = list(query = query),
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  # Get an item by ID (No pagenation is needed)
  if (!is.null(item_id)) {
    path <- sprintf("/api/v2/items/%s", item_id)
    result <- qiita_api("GET", url = url, path = path, token = token)
    return(result)
  }

  # Get items by tag
  if (!is.null(tag_id)) {
    path <- sprintf("/api/v2/tags/%s/items", tag_id)
    result <- qiita_api("GET", url = url, path = path, token = token,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  # Get items by user
  if (!is.null(user_id)) {
    path <- sprintf("/api/v2/users/%s/items", user_id)
    result <- qiita_api("GET", url = url, path = path, token = token,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)

    return(result)
  }
}

#' @rdname item
#' @export
qiita_post_item <- function(url, token, title, body, tags = list(qiita_tag("R")),
                            gist = FALSE, private = FALSE, tweet = FALSE) {
  path    <- "/api/v2/items"
  payload <- qiita_payload(
    body = body,
    title = title,
    tags = tags,
    gist = gist,
    private = private,
    tweet = tweet
  )

  qiita_api("POST", url = url, path = path, token = token,
            payload = payload)
}

#' @rdname item
#' @export
qiita_delete_item <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s", item_id)
  qiita_api("GET", url = url, path = path, token = token)
}

#' @rdname item
#' @export
qiita_patch_item <- function(url, token,
                             item_id, title, body,
                             tags = list(qiita_tag("R")), private = FALSE) {
  path <- sprintf("/api/v2/items/%s", item_id)
  payload <- qiita_payload(
    body = body,
    title = title,
    tags = tags,
    private = private
  )

  qiita_api("PATCH", url = url, path = path, token = token,
            payload = payload)
}

#' @rdname item
#' @export
qiita_delete_stock <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("DELETE", url = url, path = path, token = token)
}

#' @rdname item
#' @export
qiita_get_stock <- function(url, token, item_id = NULL, user_id = NULL,
                            per_page = 100L, page_offset = 0L, page_limit = 1L) {
  if (!is.null(item_id) && !is.null(user_id))
    stop("You cannot specify item_id and user_id both")
  if (is.null(item_id) && is.null(user_id))
    stop("Please specify item_id or user_id")

  if (!is.null(item_id)) {
    path <- sprintf("/api/v2/items/%s/stock", item_id)
    result <- qiita_api("GET", url = url, path = path, token = token,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }

  if (!is.null(user_id)) {
    path <- sprintf("/api/v2/users/%s/stocks", user_id)
    result <- qiita_api("GET", url = url, path = path, token = token,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit)
    return(result)
  }
}

#' @rdname item
#' @export
qiita_put_stock <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("PUT", url = url, path = path, token = token)
}
