library(jsonlite)
params <- fromJSON("/tmp/0498a9dd-4619-4470-9349-9a876a538baa/inputs.json")
## ----setup, include=FALSE------------------------------------------------
library(knitr)
knitr::opts_chunk$set(echo = FALSE, message=FALSE, eval.after = 'fig.cap')
options(scipen=999)

## ----params, warning=FALSE, message=FALSE--------------------------------
library(devtools)
load_all("~/longbowRiskFactors")
library(longbowtools)
library(sl3)
library(tmle3)
library(data.table)
library(stringr)
data <- get_tl_data()
nodes <- get_tl_nodes()
library(future)
tl_params <- get_tl_params()

message(nodes)
message(tl_params)
if(tl_params$parallelize){

  workers=availableCores()/2
  plan(multicore, workers=workers)
} else {
  workers = 1
  plan(sequential)
}

if(length(nodes$W)==0){
  nodes$W=NULL
}

## ----preprocessing-------------------------------------------------------

# drop strata variables not present in data
nodes$strata <- intersect(nodes$strata, names(data))

# drop missing values
processed <- process_missing(data, nodes,complete_nodes = c("id","strata","A","Y"))
data <- processed$data
nodes <- processed$node_list


# convert character columns to factors
char_to_factor <-function(data){
  classes <- sapply(data,data.class)
  char_cols <- names(classes)[which(classes=="character")]
  set(data, , char_cols, data[,lapply(.SD, as.factor), .SDcols = char_cols])
}

char_to_factor(data)

#define learners
if(length(nodes$W)>0){
  qlib <- make_learner_stack("Lrnr_mean",
                             "Lrnr_glm_fast",
                             list("Lrnr_xgboost", nthread=1))

  glib <- make_learner_stack("Lrnr_mean",
                             list("Lrnr_xgboost", nthread=1))



  # qlib <- glib <- make_learner_stack("Lrnr_mean")
  mn_metalearner <- make_learner(Lrnr_solnp, loss_function = loss_loglik_multinomial, learner_function = metalearner_linear_multinomial)
  metalearner <- make_learner(Lrnr_nnls)
  Q_learner <- make_learner(Lrnr_sl, qlib, metalearner)
  g_learner <- make_learner(Lrnr_sl, glib, mn_metalearner)
} else {
  Q_learner <- make_learner(Lrnr_glm)
  g_learner <- make_learner(Lrnr_mean)
}

learner_list <- list(Y=Q_learner, A=g_learner)


## ----print_adjustment_set, results = "asis"------------------------------
if(length(nodes$W)==0){
  cat("unadjusted\n")
} else {
  for(covariate in nodes$W){
    cat(sprintf("* %s\n",covariate))
  }
}

## ----print_strata_variables, results = "asis"----------------------------
for(strata_variable in nodes$strata){
  cat(sprintf("* %s\n",strata_variable))
}

strata <- collapse_strata(data, nodes)


## ----data_summary--------------------------------------------------------
obs_counts <- get_obs_counts(data, nodes, tl_params)
kable(obs_counts)

if(params$output_directory!=""){
  counts_file <- file.path(params$output_directory, "obs_counts.rdata")

  save(obs_counts, file=counts_file)
}


## ----print_strata, results = "asis"--------------------------------------
strata_levels <- sort(unique(strata$strata_label))
for(stratum in strata_levels){
  cat(sprintf("* %s\n",stratum))
}

## ----drop_strata, results = "asis"---------------------------------------
count_cols <- setdiff(names(obs_counts), unlist(nodes))
min_counts <- obs_counts[,list(min_cell=min(unlist(.SD))), .SDcols=count_cols,
                         by=eval(nodes$strata)]

#todo: this could be a script parameter
cell_cutoff <- 5
dropped_strata <- min_counts[min_cell < cell_cutoff]

if(nrow(dropped_strata)>0){
  cat("### Dropped Strata\n\nSome strata were dropped due to rare outcomes:\n\n")
  # get strata labels for dropped_strata
  dropped_labels <- strata[dropped_strata, strata_label, on=eval(nodes$strata)]
  dropped_labels <- dropped_labels[!is.na(dropped_labels)]

  for(stratum in dropped_labels){
    cat(sprintf("* %s\n",stratum))
  }

  #actually drop these strata
  data <- data[!(strata_label%in%dropped_labels)]
  strata <- strata[!(strata_label%in%dropped_labels)]
}

if(nrow(data)==0){
  cat("\n\nALL STRATA DROPPED. JOB FINISHED\n")
  knit_exit()
}

## ----stratified_tmle, message=FALSE--------------------------------------
baseline_level <- tl_params$baseline_level
if(is.null(baseline_level)||is.na(baseline_level)){
  baseline_level = NULL
}

stratum_label <- "agecat: 24 months, studyid: ki1114097-CMIN, country: BANGLADESH"

tmle_for_stratum( stratum_label, data, nodes, baseline_level, learner_list)

message("tmle for:\t",stratum_label)

#subset data
stratum_data <- data[strata_label==stratum_label]

# kludge to drop if Y or A is constant
# we need this because we no longer consistently detect this in obs_counts
if((length(unique(unlist(stratum_data[,nodes$Y, with=FALSE])))<=1)||
   (length(unique(unlist(stratum_data[,nodes$A, with=FALSE])))<=1)){
  message("outcome or treatment is constant. Skipping")
  print(table(stratum_data[,c(nodes$A,nodes$Y),with=FALSE]))
  return(NULL)
}

stratum_nodes_reduced <- reduce_covariates(stratum_data, nodes)

tmle_spec <- tmle_risk(baseline_level=baseline_level)

tmle_task <- tmle_spec$make_tmle_task(stratum_data, stratum_nodes_reduced)
Qtask <- tmle_task$get_regression_task("Y")
Qlearner <- learner_list$Y
Qfit <- Qlearner$train(Qtask)
gtask <- tmle_task$get_regression_task("A")
glearner <- learner_list$A
glearner1 <- glearner$params$learners[[2]]
gfit <- glearner1$train(gtask)
gfit$predict()


task_time <- proc.time()
initial_likelihood <- tmle_spec$make_initial_likelihood(tmle_task,
                                                        learner_list)
likelihood_time <- proc.time()
updater <- tmle_spec$make_updater()
targeted_likelihood <- tmle_spec$make_targeted_likelihood(initial_likelihood,
                                                          updater)
tmle_params <- tmle_spec$make_params(tmle_task, targeted_likelihood)

results <- stratified_tmle(data, nodes, baseline_level, learner_list, strata)
formatted_results <- format_results(results, data, nodes)


## ----save_results--------------------------------------------------------
if(params$output_directory!=""){
  results_file <- file.path(params$output_directory, "results.rdata")

  save(formatted_results, file=results_file)
}

## ----plot_tsm, warning=FALSE, message=FALSE------------------------------
tsm_plot(formatted_results)

## ----plot_rr, warning=FALSE, message=FALSE-------------------------------
rr_plot(formatted_results)

## ----plot_ate, warning=FALSE, message=FALSE------------------------------
ate_plot(formatted_results)

## ----plot_paf, warning=FALSE, message=FALSE------------------------------
paf_plot(formatted_results)

## ----plot_par, warning=FALSE, message=FALSE------------------------------
par_plot(formatted_results)

## ----results_tables, results="asis"--------------------------------------
parameter_types <- unique(formatted_results$type)
for(parameter_type in parameter_types){
  cat(sprintf("\n\n### Parameter: %s\n", parameter_type))
  print_cols <- c(nodes$strata, "intervention_level", "baseline_level",
                  "estimate", "ci_lower", "ci_upper")
  subset <- formatted_results[type==parameter_type, print_cols, with=FALSE]

  k <- kable(subset)
  print(k)
}

