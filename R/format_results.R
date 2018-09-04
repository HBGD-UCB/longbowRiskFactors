#' @export
get_obs_counts <- function(data, nodes, tl_params){
  count_nodes <- c(nodes$strata)

  # get nodes that define the "cells" for each strata
  cell_nodes <- c()
  if(tl_params$count_A) { cell_nodes <- c(cell_nodes,nodes$A)}
  if(tl_params$count_Y) { cell_nodes <- c(cell_nodes,nodes$Y)}

  # enumerate all expected cells
  cell_data <- data[,c(nodes$strata,cell_nodes), with = FALSE]
  cells <- do.call(CJ, lapply(cell_data, unique))

  # count cells in each strata
  counts <- setkey(cell_data)[cells, list(n_cell=.N), by=.EACHI]
  counts[,n:=sum(n_cell), by = eval(nodes$strata)]
  return(counts)
}

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
format_results <- function(results, data, nodes){
  # extract intervention levels
  intervention_levels <- get_intervention_levels(results$param)
  set(results, , names(intervention_levels), intervention_levels)



  # pull out useful columns
  keep_cols <- c(nodes$strata, "W", "A", "Y",
                 "type", "param",
                 "intervention", "baseline",
                 "psi_transformed", "lower_transformed", "upper_transformed",
                 "tmle_est","se")
  nice_names <- c(nodes$strata, "adjustment_set", "intervention_variable", "outcome_variable",
                "type", "parameter",
                "intervention_level","baseline_level",
                "estimate","ci_lower","ci_upper",
                "untransformed_estimate","untransformed_se")
  formatted <- results[,keep_cols, with=FALSE]
  setnames(formatted, nice_names)

  # add collapsed strata label for plotting
  strata_map <- collapse_strata(data, nodes)
  formatted <- merge(strata_map,formatted, by=nodes$strata)

  return(formatted)
}
