#' @rdname geom_econodist
#' @export
stat_econodist <- function(mapping = NULL, data = NULL,
                           geom = "econodist", position = "dodge2",
                           ...,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatEconodist,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname geom_econodist
#' @export
StatEconodist <- ggproto(
  `_class` = "StatEconodist",
  `_inherit` = Stat,

  required_aes = c("y"),

  setup_data = function(data, params) {

    data$x <- data$x %||% 0

    ggplot2::remove_missing(
      data,
      na.rm = FALSE,
      vars = "x",
      name = "stat_econodist"
    )

  },

  setup_params = function(data, params) {

    params$width <- params$width %||% (resolution(data$x %||% 0) * 0.75)

    if (is.double(data$x) && !has_groups(data) && any(data$x != data$x[1L])) {
      warning("Continuous x aesthetic -- did you forget aes(group=...)?", call. = FALSE)
    }

    params

  },

  compute_group = function(data, scales, width = NULL, na.rm = FALSE) {

    qs <- c(0.10, 0.5, 0.90)

    stats <- as.numeric(stats::quantile(data$y, qs))
    names(stats) <- c("tenth", "median", "ninetieth")

    if (length(unique(data$x)) > 1) width <- diff(range(data$x)) * 0.9

    xdf <- new_data_frame(as.list(stats))
    xdf$x <- if (is.factor(data$x)) data$x[1] else mean(range(data$x))
    xdf$width <- width

    xdf

  }

)
