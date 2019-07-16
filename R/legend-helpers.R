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
                                  tenth_lab = "10th percentile",
                                  tenth_col = econ_tenth,
                                  med_lab = "Median",
                                  med_col = econ_median,
                                  ninetieth_lab = "90th percentile",
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
    label = tenth_lab,
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
    label = med_lab,
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
    label = ninetieth_lab,
    x = x_pos, y = y_pos,
    hjust = 0, vjust = 0.5,
    gp = gpar(
      fontfamily = family,
      fontsize = label_size,
      col = label_col
    )
  ) -> ninth_text

  width <- x_pos + grobWidth(ninth_text)

  vp <- viewport(x = 0, just = "left", default.units = "points", width = width)

  gTree(
    name = "econodist-legend",
    children = gList(
      tenth_seg, tenth_text,
      med_pt, med_text,
      ninth_seg, ninth_text
    ),
    childrenvp = vp,
    vp = viewport(x = 0, just = "left", width = width)
  )

}

#' Helper utility to get an econodist legend into a ggplot2 plot
#'
#' @param gg ggplot2 plot object to add
#' @param legend legend grob (any grob, really)
#' @param below which named gtable element to stick it below?
#' @param just legend position: "`left`" (aligned with left veritcal axis),
#'        "`center`" (center of plot panel), or "`right`" (aligned with right
#'        vertical axis). Uses [pmatch()] so partial matching is supported.
#' @param legend_height height of the legend row
#' @param spacer height of the spacer that is put below `legend`?
#' @family Econodist legend helpers
#' @export
add_econodist_legend <- function(gg, legend, below = "subtitle",
                                 just = c("left", "center", "right"),
                                 legend_height = unit(16, "points"),
                                 spacer = unit(10, "points")) {

  choices <- c("left", "center", "right")
  just <- choices[pmatch(just[1], choices, duplicates.ok = FALSE)]

  if (!inherits(gg, "gtable")) gg <- ggplot2::ggplotGrob(gg)

  st <- gg$layout[gg$layout$name == below,]

  gtable::gtable_add_rows(
    gtable::gtable_add_grob(
      gtable::gtable_add_rows(gg, legend_height, st$b),
      legend, t = st$b + 1, l = st$l, b = st$b + 1, r = st$r,
      name = "econodist-legend"
    ),
    spacer, st$b + 1
  ) -> gg2

  w <- gg2$grobs[[which(gg2$layout$name == "econodist-legend")]]$vp$width
  hw <- unit(as.numeric(convertUnit(w, "points"))/2, "points")
  switch(
    just,
    left = gg2$grobs[[which(gg2$layout$name == "econodist-legend")]]$vp$x <-
      unit(0, "npc"),
    right = gg2$grobs[[which(gg2$layout$name == "econodist-legend")]]$vp$x <-
      unit(1, "npc") - w,
    center = gg2$grobs[[which(gg2$layout$name == "econodist-legend")]]$vp$x <-
      unit(0.5, "npc") - hw
  )

  gg2

}
