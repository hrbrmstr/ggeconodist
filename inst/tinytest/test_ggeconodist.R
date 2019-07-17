library(ggeconodist)

ggplot(mammogram_costs, aes(x = city)) +
  geom_econodist(
    aes(ymin = tenth, median = median, ymax = ninetieth),
    stat = "identity",
  ) -> gg

gb <- ggplotGrob(gg)

expect_true(inherits(gb, "gtable"))
expect_true(identical(dim(gb$layout), c(18L, 7L)))

add_econodist_legend(
  gg,
  econodist_legend_grob(
    tenth_col = "#b07aa1",
    ninetieth_col = "#591a4f",
  ),
  below = "subtitle",
  just = "right"
) -> gt

expect_true("econodist-legend" %in% gt$layout$name)
