#' @export
get_obs_counts <- function(data, nodes){
  to_count <- data[,c(nodes$strata,nodes$A,nodes$Y), with=FALSE]
  setnames(to_count, c(nodes$strata, "A", "Y"))
  set(to_count, ,"Y", paste("nAY",to_count$Y,sep=""))
  count_cats <- do.call(CJ, lapply(to_count, unique))

  counts <- setkey(to_count)[count_cats, list(nAY=.N), by=.EACHI]
  counts[,nA:=sum(nAY), by=eval(c(nodes$strata, "A"))]
  counts[,n:=sum(nAY), by=eval(c(nodes$strata))]
  cast_form <- sprintf("%s~%s",paste(c(nodes$strata,"A","n", "nA"), collapse="+"),"Y")
  counts_wide <- dcast(counts, cast_form, value.var="nAY", fill=0)
  counts_wide <- counts_wide[n!=0]
  return(counts_wide)
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

  # get nodes
  node_data <- as.data.table(lapply(nodes[c("W","A","Y")],paste,collapse=", "))
  if(is.null(node_data$W)){
    node_data$W="unadjusted"
  }

  set(results, , names(node_data), node_data)

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
