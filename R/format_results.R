#' Extract intervention levels from parameter names
#' @importFrom stringr str_match_all
#' @importFrom data.table as.data.table
get_intervention_levels <- function(param_names){
  matches <- str_extract_all(param_names, "A=([^\\}]*)",simplify="TRUE")
  matches <- gsub("A=","",matches)
  matches[matches==""]=NA
  matches <- as.data.table(matches)
  setnames(matches, c("intervention", "baseline"))

  return(matches)
}

#' @export
format_results <- function(results,nodes){
  # extract intervention levels
  intervention_levels <- get_intervention_levels(results$param)
  set(results, , names(intervention_levels), intervention_levels)

  # get nodes
  node_data <- as.data.table(lapply(nodes[c("W","A","Y")],paste,collapse=", "))
  set(results, , names(node_data), node_data)

  # todo: add collapsed strata
  # # get counts
  # n <- data[,list(n=.N),by=eval(nodes$strata)]
  # nA <- data[,list(nA=.N),by=eval(c(nodes$strata,nodes$A))]
  # nAY  <- data[,list(nA=.N),by=eval(c(nodes$strata,nodes$A,nodes$Y))]
  # #todo: generalize
  # nAY <- dcast(nAY, study_id+parity_cat~haz01, value.var="nA")

  keep_cols <- c(nodes$strata, "W", "A", "Y",
                 "type", "param",
                 "intervention", "baseline",
                 "psi_transformed", "lower_transformed", "upper_transformed")
  formatted <- results[,keep_cols, with=FALSE]
}
