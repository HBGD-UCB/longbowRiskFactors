context("TMLE Adjustment Set Munging")
library(sl3)
library(tmle3)
data(sample_rf_data)
nodes <- list(
  strata = c("study_id"),
  W = c(
    "apgar1", "apgar5", "gagebrth", "mage",
    "meducyrs", "sexn"
  ),
  A = "parity_cat",
  Y = "haz01"
)

# drop missing values
processed <- process_missing(sample_rf_data, nodes, complete_nodes = c("strata","A","Y"))
data <- processed$data
nodes <- processed$node_list

qlib <- make_learner_stack("Lrnr_mean",
                           "Lrnr_glm_fast",
                           "Lrnr_glmnet",
                           list("Lrnr_xgboost", nthread=1))

glib <- make_learner_stack("Lrnr_mean",
                           "Lrnr_glmnet",
                           list("Lrnr_xgboost", nthread=1))


# qlib <- glib <- make_learner_stack("Lrnr_mean")

mn_metalearner <- make_learner(Lrnr_solnp, loss_function = loss_loglik_multinomial, learner_function = metalearner_linear_multinomial)
metalearner <- make_learner(Lrnr_nnls)
Q_learner <- make_learner(Lrnr_sl, qlib, metalearner)
g_learner <- make_learner(Lrnr_sl, glib, mn_metalearner)

learner_list <- list(Y=Q_learner, A=g_learner)

# tmle3_Fit$debug(".tmle_fit")
tmle_spec<-tmle_risk(baseline_level="[1,2)")
tmle_task <- tmle_spec$make_tmle_task(data, nodes)

initial_likelihood <- tmle_spec$make_initial_likelihood(tmle_task,
                                                        learner_list)
likelihood_time <- proc.time()
updater <- tmle_spec$make_updater()
targeted_likelihood <- tmle_spec$make_targeted_likelihood(initial_likelihood,
                                                          updater)
tmle_params <- tmle_spec$make_params(tmle_task, targeted_likelihood)
updater$tmle_params <- tmle_params
params_time <- proc.time()
fit <- fit_tmle3(tmle_task, targeted_likelihood, tmle_params,
                 updater)
fit_time <- proc.time()
fit$set_timings(start_time, task_time, likelihood_time, params_time,
                fit_time)

data[sample(nrow(data),40),study_id:=6]
strata <- collapse_strata(data, nodes)
stratum_label=strata[6,strata_label]
