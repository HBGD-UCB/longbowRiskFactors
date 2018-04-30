#' collapse strata columns into a single strata identifier
#' @import data.table
#' @export
collapse_strata <- function(data, nodes)
{
  nodes$strata <- c("study_id")
  strata <- data[,nodes$strata, with=FALSE]
  strata <- strata[!duplicated(strata)]
  set(strata, , "strata_id", 1:nrow(strata))
  long <- melt(strata, id.vars="strata_id", measure.vars=c())
  set(long, , "label", sprintf("%s: %s",long$variable, long$value))
  collapsed <- long[, list(strata_label=paste(label, collapse=", ")), by=list(strata_id)]
  strata_map <- merge(strata, collapsed, by="strata_id")
  strata_map$strata_id <- NULL
  return(strata_map)
}

tmle_for_stratum <- function(stratum_data, nodes, baseline_level, learner_list){
  tmle_spec <- tmle_risk_binary(baseline_level=baseline_level)
  tmle_fit <- tmle3(tmle_spec, stratum_data, nodes, learner_list)
  return(tmle_fit$summary)
}

#' @export
#' @importFrom data.table rbindlist
stratified_tmle <- function(data, nodes, baseline_level, learner_list){
  #todo: make this fallback to standard tmle if no stratifying variables
  strata <- collapse_strata(data, nodes)
  n_strata <- nrow(strata)
  all_results <- lapply(1:n_strata, function(row){
    stratum <- strata[row]
    message("tmle for:\t",stratum$strata_label)


    stratum_data <- merge(stratum,data,by=nodes$strata)
    results <- tmle_for_stratum(stratum_data, nodes, baseline_level, learner_list)
    results <- cbind(stratum,results)

    return(results)
  })

  results <- rbindlist(all_results)
  return(results)
}
