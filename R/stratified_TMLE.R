#' collapse strata columns into a single strata identifier
#' @import data.table
#' @export
collapse_strata <- function(data, nodes)
{
  # get strata levels
  strata <- data[,nodes$strata, with=FALSE]
  strata <- unique(strata)
  set(strata, , "strata_id", 1:nrow(strata))

  # format strata labels
  suppressWarnings({
    long <- melt(strata, id.vars="strata_id", measure.vars=c())
  })
  set(long, , "label", sprintf("%s: %s",long$variable, long$value))
  collapsed <- long[, list(strata_label=paste(label, collapse=", ")), by=list(strata_id)]

  # build map
  strata_map <- merge(strata, collapsed, by="strata_id")
  strata_map$strata_id <- NULL
  strata_map <- setkey(strata_map, "strata_label")
  strata_labels <- strata_map[data, strata_label, on=eval(nodes$strata)]
  set(data, , "strata_label", strata_labels)
  return(strata_map)
}

#' @export
tmle_for_stratum <- function(strata_row, data, nodes, baseline_level, learner_list){
  strata_row
  stratum_label <- strata_row$strata_label
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

  max_covariates <- floor(strata_row$min_cell/10)
  stratum_nodes_reduced <- reduce_covariates(stratum_data, nodes, max_covariates)

  tmle_spec <- tmle_risk(baseline_level=baseline_level)


  if(length(stratum_nodes_reduced$W)==0){
    learner_list <- list(Y=make_learner(Lrnr_glm), A=make_learner(Lrnr_mean))
  }

  tmle_fit <- tmle3(tmle_spec, stratum_data, stratum_nodes_reduced, learner_list)

  results <- tmle_fit$summary

  stratum_ids <- stratum_data[1, c(nodes$strata, "strata_label"), with = FALSE]
  results <- cbind(stratum_ids,results)


  # add data about nodes
  node_data <- as.data.table(lapply(stratum_nodes_reduced[c("W","A","Y")],paste,collapse=", "))
  if(is.null(node_data$W)){
    node_data$W="unadjusted"
  }

  set(results, , names(node_data), node_data)

  return(results)
}

#' @export
#' @importFrom data.table rbindlist
stratified_tmle <- function(data, nodes, baseline_level, learner_list, strata){

  strata_row <- strata[1,]
  results <- strata[,tmle_for_stratum(.SD, data, nodes,
                                          baseline_level, learner_list),
                        by=seq_len(nrow(strata))]


  return(results)
}
