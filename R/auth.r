#' Authorization with Qiita
#'
#' qiitr uses \code{QIITA_ACCESSTOKEN} environmental variable for authoriation. You can issue
#' a personal access token at \url{https://qiita.com/settings/applications}.
#' To set the envvar permanently, write \code{QIITA_ACCESSTOKEN = (your access token)} to a file
#' and save it as \code{.Renviron} on current directory or the home directory (For more info,
#' see \link[base]{Startup}). To set the variable temporarily, use \code{qiita_set_accesstoken}.
#'
#' @name qiita_auth
#' @export
qiita_set_accesstoken <- function() {
  if(!identical(Sys.getenv("QIITA_ACCESSTOKEN"), "")) {
    warning("QIITA_ACCESSTOKEN envvar is already set. Abort.")
    return(FALSE)
  }

  if(!interactive()) stop("Use Sys.setenv or .Renviron in noninteractive session.")

  msg <- "Personal access token for Qiita:"
  if(rstudioapi::isAvailable()) {
    token <- rstudioapi::askForPassword(msg)
  } else {
    cat(msg)
    token <- readLines(n = 1)
  }

  if(is.null(token) || identical(token, "")) {
    warning("Input was empty. Abort.")
    return(FALSE)
  }

  Sys.setenv(QIITA_ACCESSTOKEN = token)
  message(
    sprintf("To set QIITA_ACCESSTOKEN permanently, write the following line to a file and save it
as '.Renviron' on current directory or Sys.getenv('R_USER'):
QIITA_ACCESSTOKEN='%s'", token)
  )
}
