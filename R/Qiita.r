#' An R6 Class for Qiita API
#'
#' @docType class
#' @import R6
#' @export
Qiita <- R6::R6Class(
  "Qiita",
  public = list(
    token = NA,
    url   = NA,

    initialize = function(token, url = "https://qiita.com") {
      self$token <- token
      self$url   <- url
    },

    get_tag           = function(tag_id = NULL, user_id = NULL, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_tag(url = self$url, token = self$token, tag_id = tag_id, user_id = user_id,
                    per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    get_following_tag = function(user_id, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_following_tag(url = self$url, token = self$token, user_id = user_id,
                              per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    delete_tagfollow  = function(tag_id) qiita_delete_tagfollow(url = self$url, token = self$token, tag_id = tag_id),
    get_tagfollow     = function(tag_id, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_tagfollow(url = self$url, token = self$token, tag_id = tag_id,
                          per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    put_tagfollow     = function(tag_id) qiita_put_tagfollow(url = self$url, token = self$token, tag_id = tag_id),
    get_stocker       = function(item_id, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_stocker(url = self$url, token = self$token, item_id = item_id,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    get_user          = function(user_id) qiita_get_user(url = self$url, token = self$token, user_id = user_id),
    get_followee      = function(user_id, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_followee(url = self$url, token = self$token, user_id = user_id,
                         per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    get_follower      = function(user_id, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_follower(url = self$url, token = self$token, user_id = user_id,
                         per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    delete_userfollow = function(user_id) qiita_delete_userfollow(url = self$url, token = self$token, user_id = user_id),
    get_userfollow    = function(user_id, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_userfollow(url = self$url, token = self$token, user_id = user_id,
                           per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    put_userfollow    = function(user_id) qiita_put_userfollow(url = self$url, token = self$token, user_id = user_id),
    get_authenticated_user = function() qiita_get_authenticated_user(url = self$url, token = self$token),
    get_comment       = function(comment_id = NULL, item_id = NULL, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_comment(url = self$url, token = self$token, comment_id = comment_id, item_id = item_id,
                        per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    delete_comment    = function(comment_id) qiita_delete_comment(url = self$url, token = self$token, comment_id = commend_id),
    patch_comment     = function(commend_id, body) qiita_patch_comment(url = self$url, token = self$token, commend_id = commend_id, body = body),
    post_comment      = function(item_id, body) qiita_post_comment(url = self$url, token = self$token, item_id = item_id, body = body),
    get_item          = function(item_id = NULL, tag_id = NULL, user_id = NULL, query = NULL, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_item(url = self$url, token = self$token, item_id = item_id, tag_id = tag_id, user_id = user_id, query = query,
                     per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    post_item         = function(title, body, tags = list(qiita_tag("R")), gist = FALSE, private = FALSE, tweet = FALSE) qiita_post_item(url = self$url, token = self$token, title = title, body = body, tags = tags, gist = gist, private = private, tweet = tweet),
    delete_item       = function(item_id) qiita_delete_item(url = self$url, token = self$token, item_id = item_id),
    patch_item        = function(item_id, title, body, tags = list(qiita_tag("R")), private = FALSE) qiita_patch_item(url = self$url, token = self$token, item_id = item_id, title = title, body = body, tags = tags, private = private),
    delete_stock      = function(item_id) qiita_delete_stock(url = self$url, token = self$token, item_id = item_id),
    get_stock         = function(item_id = NULL, user_id = NULL, per_page = 100L, page_offset = 0L, page_limit = 1L)
      qiita_get_stock(url = self$url, token = self$token, item_id = item_id, user_id = user_id,
                      per_page = per_page, page_offset = page_offset, page_limit = page_limit),
    put_stock         = function(item_id) qiita_put_stock(url = self$url, token = self$token, item_id = item_id)
  )
)
