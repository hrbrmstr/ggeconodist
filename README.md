
[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/ggeconodist.svg?branch=master)](https://travis-ci.org/hrbrmstr/ggeconodist)
[![Coverage
Status](https://codecov.io/gh/hrbrmstr/ggeconodist/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/ggeconodist)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/ggeconodist)](https://cran.r-project.org/package=ggeconodist)

# ggeconodist

Create Diminutive Distribution Charts

## Description

‘The Economist’ has a unique boxplot aesthetic f or communicating
distrribution characteristics. Tools are provided to create similar
charts in ‘ggplot2’.

Inspired by:
<https://www.economist.com/united-states/2019/06/29/will-transparent-pricing-make-americas-health-care-cheaper>

## What’s Inside The Tin

  - `add_econodist_legend`: Helper utility to get an econodist legend
    into a ggplot2 plot
  - `econodist_legend_grob`: Create a legend grob that can be used with
    econodist charts
  - `geom_econodist`: Econodist geom / stat
  - `left_align`: Helper to flush ggplot2 plot components to the left
  - `mammogram_costs`: Cost of a mammogram in various U.S. Citites
    (2016, USD)
  - `theme_econodist`: A more current Economist-style ggplot2 theme

The following functions are implemented:

## Installation

``` r
install.packages("ggeconodist", repos = "https://cinc.rud.is")
# or
devtools::install_git("https://git.rud.is/hrbrmstr/ggeconodist.git")
# or
devtools::install_git("https://git.sr.ht/~hrbrmstr/ggeconodist")
# or
devtools::install_gitlab("hrbrmstr/ggeconodist")
# or
devtools::install_bitbucket("hrbrmstr/ggeconodist")
# or
devtools::install_github("hrbrmstr/ggeconodist")
```

## Usage

``` r
library(ggeconodist)

# current version
packageVersion("ggeconodist")
## [1] '0.1.0'
```

### The whole shebang

**YOU WILL NEED** to install [these
fonts](https://github.com/economist-components/component-typography) to
use the built-in theme. More on how to do that at some point.

``` r
ggplot(mammogram_costs, aes(x = city)) +
  geom_econodist(
    aes(ymin = tenth, median = median, ymax = ninetieth),
    stat = "identity", show.legend = TRUE
  ) +
  scale_y_continuous(expand = c(0,0), position = "right", limits = range(0, 800)) +
  coord_flip() +
  labs(
    x = NULL, y = NULL,
    title = "Mammoscams",
    subtitle = "United States, prices for a mammogram*\nBy metro area, 2016, $",
    caption = "*For three large insurance companies\nSource: Health Care Cost Institute"
  ) +
  theme_econodist() -> gg

grid.newpage()
left_align(gg, c("subtitle", "title", "caption")) %>% 
  add_econodist_legend(econodist_legend_grob(), below = "subtitle") %>% 
  grid.draw()
```

<img src="README_files/figure-gfm/unnamed-chunk-1-1.png" width="672" />

## ggeconodist Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |       10 | 0.91 | 338 | 0.93 |          68 | 0.75 |      125 | 0.77 |
| Rmd  |        1 | 0.09 |  27 | 0.07 |          23 | 0.25 |       38 | 0.23 |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
