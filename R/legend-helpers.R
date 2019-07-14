#' Helper to flush ggplot2 plot components to the left
#'
#' Stolen from the BBC (don't tell Scotland Yard)
#'
#' @param gg ggplot2 plot
#' @param components ggplot2 named gtable components to operate on
#' @family Econodist legend helpers
#' @export
left_align <- function(gg, components){
  grob <- ggplot2::ggplotGrob(gg)
  n <- length(components)
  grob$layout$l[grob$layout$name %in% components] <- 2
  grob
}

#' Create a legend grob that can be used with econodist charts
#'
#' @param family font family
#' @param label_size size of legend text
#' @param tenth_col color for the tenth bar
#' @param med_col color for the median point
#' @param ninetieth_col color for the ninetieth bar
#' @param label_col color of the legend text
#' @family Econodist legend helpers
#' @export
econodist_legend_grob <- function(family = "EconSansCndLig",
                             label_size = 10,
                             tenth_col = econ_tenth,
                             med_col = econ_median,
                             ninetieth_col = econ_ninetieth,
                             label_col = econ_text_col) {

  x_pos <- unit(4, "points")
  y_pos <- unit(label_size / 2, "points")
  yq <- unit(label_size / 4, "points")

  segmentsGrob(
    x0 = x_pos, y0 = y_pos + yq,
    x1 = x_pos, y1 = y_pos - yq,
    default.units = "points",
    gp = gpar(
      lwd = 3 * ggplot2::.pt,
      lty = "solid",
      lineend = "square",
      col = tenth_col
    )
  ) -> tenth_seg

  x_pos <- x_pos + convertUnit(grobWidth(tenth_seg), "points") + unit(6, "points")

  textGrob(
    label = "10th percentile",
    x = x_pos, y = y_pos,
    hjust = 0, vjust = 0.5,
    gp = gpar(
      fontfamily = family,
      fontsize = label_size,
      col = label_col
    )
  ) -> tenth_text

  x_pos <- x_pos + convertUnit(grobWidth(tenth_text), "points") + unit(label_size, "points")

  pointsGrob(
    x = x_pos, y = y_pos,
    size = unit(label_size, "points"), pch = 19,
    gp = gpar(
      col = med_col,
      fill = med_col
    )
  ) -> med_pt

  x_pos <- x_pos + convertUnit(grobWidth(med_pt), "points") + unit(8, "points")

  textGrob(
    label = "Median",
    x = x_pos, y = y_pos,
    hjust = 0, vjust = 0.5,
    gp = gpar(
      fontfamily = family,
      fontsize = label_size,
      col = label_col
    )
  ) -> med_text

  x_pos <- x_pos + convertUnit(grobWidth(med_text), "points") + unit(label_size, "points")

  segmentsGrob(
    x0 = x_pos, y0 = y_pos - yq,
    x1 = x_pos, y1 = y_pos + yq,
    gp = gpar(
      lwd = 3 * ggplot2::.pt,
      lty = "solid",
      lineend = "square",
      col = ninetieth_col
    )
  ) -> ninth_seg

  x_pos <- x_pos + grobWidth(ninth_seg)  + unit(8, "points")

  textGrob(
    label = "90th percentile",
    x = x_pos, y = y_pos,
    hjust = 0, vjust = 0.5,
    gp = gpar(
      fontfamily = family,
      fontsize = label_size,
      col = label_col
    )
  ) -> ninth_text

  vp <- viewport(default.units = "points")

  gTree(
    name = "econodist_legend",
    children = gList(
      tenth_seg, tenth_text,
      med_pt, med_text,
      ninth_seg, ninth_text
    ),
    childrenvp = vp
  )

}

#' Helper utility to get an econodist legend into a ggplot2 plot
#'
#' @param gg ggplot2 plot object to add
#' @param legend legend grob (any grob, really)
#' @param below which named gtable element to stick it below?
#' @param legend_height height of the legend row
#' @param spacer height of the spacer that is put below `legend`?
#' @family Econodist legend helpers
#' @export
add_econodist_legend <- function(gg, legend, below = "subtitle",
                                 legend_height = unit(16, "points"),
                                 spacer = unit(10, "points")) {

  if (!inherits(gg, "gtable")) gg <- ggplot2::ggplotGrob(gg)

  st <- gg$layout[gg$layout$name == below,]
  gtable::gtable_add_rows(
    gtable::gtable_add_grob(
      gtable::gtable_add_rows(gg, legend_height, st$b),
      legend, t = st$b + 1, l = st$l, b = st$b + 1, r = st$r
    ),
    spacer, st$b + 1
  )

}
