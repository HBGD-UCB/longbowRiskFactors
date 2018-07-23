#' Defines a tmle (minus the data)
#'
#' Current limitations:
#' @importFrom R6 R6Class
#' @importFrom tmle3 tmle3_Spec Param_delta
#'
#' @export
#
tmle3_Spec_risk_binary <- R6Class(
  classname = "tmle3_Spec_TSM_all",
  portable = TRUE,
  class = TRUE,
  inherit = tmle3_Spec,
  public = list(
    initialize = function(baseline_level = NULL, ...) {
      super$initialize(baseline_level=baseline_level, ...)
    },
    make_params = function(tmle_task, likelihood) {
      # todo: export and use sl3:::get_levels
      A_vals <- tmle_task$get_tmle_node("A")
      if (is.factor(A_vals)) {
        A_levels <- sort(unique(A_vals))
        A_levels <- factor(A_levels, levels(A_vals))
      } else {
        A_levels <- sort(unique(A_vals))
      }
      tsm_params <- lapply(A_levels, function(A_level) {
        intervention <- define_lf(LF_static, "A", value = A_level)
        tsm <- Param_TSM$new(likelihood, intervention)
        return(tsm)
      })

      # separate baseline and comparisons
      baseline_level <- self$options$baseline_level
      if(is.null(baseline_level)){
        baseline_level = A_levels[[1]]
      }
      baseline_index <- which(A_levels==baseline_level)
      baseline_param <-tsm_params[[baseline_index]]
      comparison_params <- tsm_params[-1*baseline_index]

      # define RR params
      rr_params <- lapply(tsm_params, function(comparison_param){
        Param_delta$new(likelihood, delta_param_RR, list(baseline_param, comparison_param))
      })

      mean_param <- Param_mean$new(likelihood)

      # define PAR/PAF params
      par <- Param_delta$new(likelihood, delta_param_PAR, list(baseline_param, mean_param))
      paf <- Param_delta$new(likelihood, delta_param_PAF, list(baseline_param, mean_param))

      tmle_params <- c(tsm_params, mean_param, rr_params, par, paf)

      return(tmle_params)
    }
  ),
  active = list(),
  private = list()
)

#' Risk Measures for Binary Outcomes
#'
#' Estimates TSMs, RRs, PAR, and PAF
#'
#' O=(W,A,Y)
#' W=Covariates
#' A=Treatment (binary or categorical)
#' Y=Outcome binary
#' @importFrom sl3 make_learner Lrnr_mean
#' @export
tmle_risk_binary <- function(baseline_level = NULL) {
  # todo: unclear why this has to be in a factory function
  tmle3_Spec_risk_binary$new(baseline_level = baseline_level)
}
