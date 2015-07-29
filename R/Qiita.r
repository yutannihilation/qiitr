#' An R6 Class for Qiita API
#'
#' @docType class
#' @import R6 pryr
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

    qiita_idiom = function(api_name, ...) {
      fun_args <- c(list(url = self$url, token = self$token), list(...))
      do.call(sprintf("qiita_%s", api_name), fun_args)
    },

    # Comment API
    get_comment    = function(comment_id = NULL, item_id = NULL) self$qiita_idiom("get_comment", comment_id = comment_id, item_id = item_id),
    delete_comment = function(comment_id = NULL)                 self$qiita_idiom("delete_comment", comment_id = comment_id),
    patch_comment  = function(comment_id = NULL, body = NULL)    self$qiita_idiom("patch_comment", comment_id = comment_id, body = body),
    post_comment   = function(comment_id = NULL, body = NULL)    self$qiita_idiom("post_comment", comment_id = comment_id, body = body)
  )
)
