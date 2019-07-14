
ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

new_data_frame <- function(x = list(), n = NULL) {
  if (length(x) != 0 && is.null(names(x))) stop("Elements must be named", call. = FALSE)
  lengths <- vapply(x, length, integer(1))
  if (is.null(n)) {
    n <- if (length(x) == 0 || min(lengths) == 0) 0 else max(lengths)
  }
  for (i in seq_along(x)) {
    if (lengths[i] == n) next
    if (lengths[i] != 1) stop("Elements must equal the number of rows or 1", call. = FALSE)
    x[[i]] <- rep(x[[i]], n)
  }

  class(x) <- "data.frame"
  attr(x, "row.names") <- .set_row_names(n)
  x
}

data_frame <- function(...) {
  new_data_frame(list(...))
}
