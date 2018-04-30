tmle_for_stratum <- function(stratum_data, nodes, baseline_level, learner_list){
  tmle_fit <- tmle3(tmle_risk_binary(), stratum_data, nodes, learner_list)
  return(tmle_fit$summary)
}

#' @export
#' @importFrom data.table rbindlist
stratified_tmle <- function(data, nodes, baseline_level, learner_list){
  strata <- data[,nodes$strata, with=FALSE]
  strata <- strata[!duplicated(strata)]
  n_strata <- nrow(strata)
  all_results <- lapply(1:n_strata, function(row){
    stratum <- strata[row]
    cat("tmle for:\n")
    print(stratum)
    stratum_data <- merge(stratum,data,by=names(stratum))
    results <- tmle_for_stratum(stratum_data, nodes, NULL, learner_list)
    results <- cbind(stratum,results)

    return(results)
  })

  results <- rbindlist(all_results)
  return(results)
}
