#' A more current Economist-style ggplot2 theme
#'
#' @param econ_text_col color for text elements
#' @param econ_plot_bg_col plot background color
#' @param econ_grid_col plot grid color
#' @param econ_font core plot font
#' @param light_font light font used in various polaces
#' @param bold_font bold font used in various places
#' @note You *need* their fonts installed. You can get them from
#'       [here](https://github.com/economist-components/component-typography)
#' @export
theme_econodist <- function(econ_text_col = "#3b454a",
                       econ_plot_bg_col = "#d7e6ee",
                       econ_grid_col = "#bbcad2",
                       econ_font = "EconSansCndReg",
                       light_font = "EconSansCndLig",
                       bold_font = "EconSansCndBol") {

  theme_minimal(base_family = econ_font) +
    theme(
      plot.title = element_text(family = bold_font),
      plot.subtitle = element_text(family = light_font, 12),
      plot.caption = element_text(family = light_font, 10, colour = econ_text_col, lineheight = 1.1),
      plot.background = element_rect(fill = econ_plot_bg_col, colour = econ_plot_bg_col),
      panel.background = element_rect(fill = econ_plot_bg_col, colour = econ_plot_bg_col),
      axis.ticks = element_blank(),
      axis.ticks.x = element_blank(),
      axis.ticks.y = element_blank(),
      axis.text = element_text(family = light_font, colour = econ_text_col),
      axis.text.x = element_text(family = light_font, size = 10, colour = econ_text_col),
      axis.text.y = element_text(hjust = 0, family = light_font, size = 10, colour = econ_text_col),
      axis.line.x = element_blank(),
      axis.line.y = element_line(colour = econ_grid_col, size = 0.5),
      plot.margin = margin(10, 15, 10, 12),
      panel.grid.major.x = element_line(linetype = "solid", size = 0.4, colour = econ_grid_col),
      panel.grid.major.y = element_line(linetype = "solid", size = 0.4, colour = econ_grid_col),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank()
    )
}
