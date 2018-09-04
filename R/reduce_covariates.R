
rank_covariates_univariate <- function(data, covariates, outcome){
  if(length(covariates)==0){
    return(c())
  }
  Y <- unlist(data[,outcome, with=FALSE])


  dev_ratios <- sapply(covariates, function(covariate){
    x <- unlist(data[,covariate, with=FALSE])
    if(length(unique(x))==1){
      return(1)
    }
    if(is.factor(x)){
      x <- sl3::factor_to_indicators(factor(x))
    }
    fit <- glm.fit(x,Y)
    dev_ratio <- fit$deviance/fit$null
  })

  cov_df <- data.table(covariates, dev_ratios)

  #drop covariates whose performance matches null model (constant)
  cov_df <- cov_df[dev_ratios!=1]

  covariates_sorted <- cov_df[order(dev_ratios),covariates]
  return(covariates_sorted)
}

#' @export
reduce_covariates <- function(data, nodes, max_covariates=0){
  covariate_rank <- rank_covariates_univariate(data, nodes$W, nodes$Y)
  max_covariates <- min(max_covariates, length(covariate_rank))
  nodes$W <- covariate_rank[seq_len(max_covariates)]

  return(nodes)
}
