#' Qiita Item API
#'
#' @export
qiita_get_item <-
function (url, token, item_id = NULL, tag_id = NULL, user_id = NULL, 
          query = NULL) 
{
  if (is.null(item_id) && is.null(tag_id) && is.null(user_id)) {
    path_tmp <- "/api/v2/items"
    tmp <- httr::VERB("GET", url = url, path = path_tmp, 
                      config = httr::add_headers(`Content-Type` = "application/json", 
                                                 Authorization = paste("Bearer", token)), 
                      query = list(query = query))
    total <- as.numeric(tmp$all_headers[[2]]$headers$`total-count`)
    res <- NULL
    for(p in seq(trunc(total/100)+1)){
      path <- sprintf("/api/v2/items/%s/?per_page=100&page=%s", item_id, p)
      res <- c(res, qiita_api("GET", url = url, path = path, token = token,
                              query = list(query = query)))
    }
    return(res)
  }
  if (sum(!sapply(list(item_id, tag_id, user_id, query), is.null)) > 
      1) {
    stop("You cannot specify more-than-one conditions")
  }
  if (!is.null(item_id)) {
    path_tmp <- sprintf("/api/v2/items/%s", item_id)
    tmp <- httr::VERB("GET", url = url, path = path_tmp, 
                      config = httr::add_headers(`Content-Type` = "application/json", 
                                                 Authorization = paste("Bearer", token))
                      )
    total <- as.numeric(tmp$all_headers[[2]]$headers$`total-count`)
    res <- NULL
    for(p in seq(trunc(total/100)+1)){
      path <- sprintf("/api/v2/items/%s/?per_page=100&page=%s", item_id, p)
      res <- c(res, qiita_api("GET", url = url, path = path, token = token))
    }
    return(res)
    }
  if (!is.null(tag_id)) {
    path_tmp <- sprintf("/api/v2/tags/%s/items", tag_id)
    tmp <- httr::VERB("GET", url = url, path = path_tmp, 
                      config = httr::add_headers(`Content-Type` = "application/json", 
                                                 Authorization = paste("Bearer", token))
    )
    total <- as.numeric(tmp$all_headers[[2]]$headers$`total-count`)
    res <- NULL
    for(p in seq(trunc(total/100)+1)){
      path <- sprintf("/api/v2/tags/%s/items/?per_page=100&page=%s", tag_id, p)
      res <- c(res, qiita_api("GET", url = url, path = path, token = token))
    }
    return(res)  }
  if (!is.null(user_id)) {
    path_tmp <- sprintf("/api/v2/users/%s/items", user_id)
    tmp <- httr::VERB("GET", url = url, path = path_tmp, 
                      config = httr::add_headers(`Content-Type` = "application/json", 
                                                 Authorization = paste("Bearer", token))
    )
    
    total <- as.numeric(tmp$all_headers[[2]]$headers$`total-count`)
    res <- NULL
    for(p in seq(trunc(total/100)+1)){
      path <- sprintf("/api/v2/users/%s/items/?per_page=100&page=%s", user_id, p)
      res <- c(res, qiita_api("GET", url = url, path = path, token = token))
    }
    return(res)
    }
}


#' @export
qiita_post_item <- function(url, token, title, body, tags = list(qiita_tag("R")),
                            gist = FALSE, private = FALSE, tweet = FALSE) {
  path    <- "/api/v2/items"
  payload <- qiita_payload(body = body,
                           title = title,
                           tags = tags,
                           gist = gist,
                           private = private,
                           tweet = tweet)

  qiita_api("POST", url = url, path = path, token = token, payload = payload)
}

#' @export
qiita_delete_item <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s", item_id)
  return(qiita_api("GET", url = url, path = path, token = token))
}

#' @export
qiita_patch_item <- function(url, token, item_id, title, body, tags = list(qiita_tag("R")),
                             private = FALSE) {
  path <- sprintf("/api/v2/items/%s", item_id)
  payload <- qiita_payload(body = body,
                           title = title,
                           tags = tags,
                           private = private)

  qiita_api("PATCH", url = url, path = path, token = token, payload = payload)
}

#' @export
qiita_delete_stock <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s/stock", item_id)
  qiita_api("DELETE", url = url, path = path, token = token)
}

#' @export
qiita_get_stock <- function(url, token, item_id = NULL, user_id = NULL) {
  if(!is.null(item_id) && !is.null(user_id)) stop("You cannot specify item_id and user_id both")
  if(is.null(item_id) && is.null(user_id))   stop("Please specify item_id or user_id")

  if(!is.null(item_id)){
    path <- sprintf("/api/v2/items/%s/stock", item_id)
    return(qiita_api("GET", url = url, path = path, token = token))
  }

  if(!is.null(user_id)) {
    path <- sprintf("/api/v2/users/%s/stocks", user_id)
    return(qiita_api("GET", url = url, path = path, token = token))
  }
}

#' @export
qiita_put_stock <- function(url, token, item_id) {
  path <- sprintf("/api/v2/items/%s/stock", item_id)
  return(qiita_api("PUT", url = url, path = path, token = token))
}
