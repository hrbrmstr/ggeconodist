draw_key_econodist <- function(data, params, size) {

  grobTree(
    rectGrob(
      height = 0.5, width = 0.75,
      gp = gpar(
        fill = alpha(
          data$fill %||% params$fill %||% NA,
          data$alpha %||% params$alpha %||% NA
        ),
        col = data$colour %||% params$colour %||% NA
      )
    ),
    pointsGrob(
      x = 0.5, y = 0.5, size = unit(0.25, "npc"),
      pch = data$shape,
      gp = gpar(
        col = data$median_col %||% params$median_col %||% NA
      )
    ),
    rectGrob(
      x = 0.25,
      height = 0.75, width = 0.125,
      gp = gpar(
        fill = data$tenth_col %||% params$tenth_col %||% NA,
        col = NA
      )
    ),
    rectGrob(
      x = 0.75,
      height = 0.75, width = 0.125,
      gp = gpar(
        fill = data$ninetieth_col %||% params$ninetieth_col %||% NA,
        col = NA
      )
    )
  )

}

#' Econodist geom / stat
#'
#' Like [ggplot2::geom_boxplot()] you can either pass in pre-computed
#' values for "ymin", "median", and "ymax" or a single y column
#' which will then use [stat_econodist()] to compute the needed
#' statistics.
#'
#' @param mapping Set of aesthetic mappings created by `aes()` or
#'   `aes_()`. If specified and `inherit.aes = TRUE` (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply `mapping` if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If `NULL`, the default, the data is inherited from the plot
#'    data as specified in the call to `ggplot()`.
#'
#'    A `data.frame`, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    `fortify()` for which variables will be created.
#'
#'    A `function` will be called with a single argument,
#'    the plot data. The return value must be a `data.frame.`, and
#'    will be used as the layer data.
#' @param stat ggplot2 stat to use
#' @param geom ggplot2 geom to use
#' @param position Position adjustment, either as a string, or the result of a call to a position adjustment function.
#' @param tenth_col,median_col,ninetieth_col,median_point_size colors for geom components
#' @param endcap_adjust multipler to make endcaps wider/thinner
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'   a warning. If `TRUE`, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'   `NA`, the default, includes if any aesthetics are mapped.
#'   `FALSE` never includes, and `TRUE` always includes.
#'   It can also be a named logical vector to finely select the aesthetics to
#'   display.
#' @param inherit.aes If `FALSE`, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behaviour from
#'   the default plot specification, e.g. `borders()`.
#' @param ... other arguments passed on to `layer()`. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   `color = "red"` or `size = 3`. They may also be parameters
#'   to the paired geom/stat.
#' @export
#' @examples
#' ggplot(mammogram_costs, aes(x = city)) +
#'   geom_econodist(
#'     aes(ymin = tenth, median = median, ymax = ninetieth),
#'     stat = "identity",
#'   ) +
#'   scale_y_comma(expand = c(0,0), position = "right", limits = range(0, 800)) +
#'   coord_flip() +
#'   labs(
#'     x = NULL, y = NULL
#'   )
geom_econodist <- function(mapping = NULL,
                           data = NULL,
                           stat = "econodist",
                           position = "dodge2",
                           tenth_col = econ_tenth,
                           median_col = econ_median,
                           ninetieth_col = econ_ninetieth,
                           median_point_size = NULL,
                           endcap_adjust = 1.5,
                           ...,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE) {

  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomEconodist,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      tenth_col = tenth_col,
      median_col = median_col,
      ninetieth_col = ninetieth_col,
      median_point_size = median_point_size,
      endcap_adjust = endcap_adjust,
      ...
    )
  )
}

#' @rdname geom_econodist
#' @export
GeomEconodist <- ggproto(
  `_class` = "GeomEconodist",
  `_inherit` = Geom,

  extra_params = c("na.rm", "width",
                   "tenth_col", "median_col", "ninetieth_col",
                   "median_point_size", "endcap_adjust"),

  default_aes = aes(
    colour = NA, fill = econ_main, size = 1, weight = 1,
    alpha = 0.2, shape = 19, linetype = "solid", stroke = 1
  ),

  required_aes = c("x", "ymin", "median", "ymax"),

  setup_data = function(data, params) {

    data$width <- data$width %||%
      params$width %||% (ggplot2::resolution(data$x, FALSE) * 0.6)

    data$xmin <- data$x - data$width / 2
    data$xmax <- data$x + data$width / 2

    data

  },

  draw_group = function(data, panel_params, coord,
                        tenth_col = econ_tenth,
                        median_col = econ_median,
                        ninetieth_col = econ_ninetieth,
                        median_point_size = NULL,
                        endcap_adjust = 1.5) {

    if (nrow(data) != 1) {
      stop(
        "It looks like you may have forgotten a grouping aesthetic, i.e. aes(group = ...)",
        call. = FALSE
      )
    }

    transform(
      data,
      y = median,
      fill = alpha(fill, alpha)
    ) -> d_range

    transform(
      data,
      y = median,
      alpha = 1,
      colour = median_col,
      size = median_point_size %||% (width * 3),
      fill = alpha(fill, alpha),
      shape = "circle"
    ) -> d_median

    transform(
      data,
      x = xmin,
      xend = xmax,
      y = ymin,
      yend = ymin,
      size = size * (endcap_adjust %||% 1.5),
      alpha = NA,
      colour = tenth_col
    ) -> d_tenth

    transform(
      data,
      x = xmin,
      xend = xmax,
      y = ymax,
      yend = ymax,
      size = size * (endcap_adjust %||% 1.5),
      alpha = NA,
      colour = ninetieth_col
    ) -> d_ninetieth

    ggname("geom_econodist", grobTree(
      GeomRect$draw_panel(d_range, panel_params, coord),
      GeomSegment$draw_panel(d_tenth, panel_params, coord),
      GeomSegment$draw_panel(d_ninetieth, panel_params, coord),
      GeomPoint$draw_panel(d_median, panel_params, coord)
    ))

  },

  draw_key = draw_key_econodist

)
