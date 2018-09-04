context("Cell Counts (don't drop 0's")
library(sl3)
library(tmle3)
data(sample_rf_data)
data <- sample_rf_data
nodes <- list(
  strata = c("study_id"),
  W = c(
    "apgar1", "apgar5", "gagebrth", "mage",
    "meducyrs", "sexn"
  ),
  A = "parity_cat",
  Y = "haz01"
)

# set up structural positivity issue
sample_rf_data <- sample_rf_data[!(study_id=="4"&parity_cat=="[0,1)")]
sample_rf_data <- sample_rf_data[-1*bad_cell]

tl_params <- list(count_A=TRUE, count_Y=TRUE)
obscounts <- get_obs_counts(sample_rf_data, nodes, tl_params)

# verify that there is a zero for the zero cell
expected_zeros <- obscounts[(study_id=="4"&parity_cat=="[0,1)")]
test_that("zero cells get counts", expect_equal(expected_zeros$n_cell,c(0,0)))


# verify that things behave well for continuous Y
data$Ycont <- rnorm(nrow(data))
nodes$Y <- "Ycont"
tl_params <- list(count_A=TRUE, count_Y=FALSE)
obscounts <- get_obs_counts(sample_rf_data, nodes, tl_params)
test_that("Y can be excluded from cells", expect_equal(max(obscounts$n_cell),113))
