
#' Defines a tmle (minus the data)
#'
#' Current limitations:
#' @importFrom R6 R6Class
#' @importFrom tmle3 tmle3_Spec Param_delta
#'
#' @export
#
tmle3_Spec_risk <- R6Class(
  classname = "tmle3_Spec_risk",
  portable = TRUE,
  class = TRUE,
  inherit = tmle3_Spec,
  public = list(
    initialize = function(baseline_level = NULL, ...) {
      super$initialize(baseline_level = baseline_level, ...)
    },
    make_tmle_task = function(data, node_list, ...) {
       # bound Y if continuous
      Y_node <- node_list$Y
      Y_vals <- unlist(data[, Y_node, with = FALSE])
      Y_variable_type <- variable_type(x = Y_vals)
      if (Y_variable_type$type == "continuous") {
        min_Y <- min(Y_vals)
        max_Y <- max(Y_vals)
        range <- max_Y - min_Y
        lower <- min_Y # - 0.1 * range
        upper <- max_Y # + 0.1 * range
        Y_variable_type <- variable_type(
          type = "continuous",
          bounds = c(lower, upper)
        )
      }
      
       # todo: export and use sl3:::get_levels
      A_node <- node_list$A
      A_vals <- unlist(data[, A_node, with = FALSE])
      if (is.factor(A_vals)) {
        A_levels <- sort(unique(A_vals))
        A_levels <- factor(A_levels, levels(A_vals))
      } else {
        A_levels <- sort(unique(A_vals))
      }
      A_variable_type <- variable_type(
        type = "categorical",
        levels = unique(A_vals)
      )
      
      # make tmle_task
      npsem <- list(
        define_node("W", node_list$W),
        define_node("A", node_list$A, c("W"), A_variable_type),
        define_node("Y", node_list$Y, c("A", "W"), Y_variable_type)
      )
      
      if(!is.null(node_list$id)){
        tmle_task <- tmle3_Task$new(data, npsem = npsem, id=node_list$id, ...)  
      } else {
        tmle_task <- tmle3_Task$new(data, npsem = npsem, ...)
      }

      return(tmle_task)

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


      if(is.null(self$options$effect_scale)){
        outcome_type <- tmle_task$npsem$Y$variable_type$type
        private$.options$effect_scale <- ifelse(outcome_type=="continuous", "additive", "multiplicative")
      }

      if(self$options$effect_scale=="multiplicative"){
        # define RR params
        rr_params <- lapply(tsm_params, function(comparison_param){
          Param_delta$new(likelihood, delta_param_RR, list(baseline_param, comparison_param))
        })

        mean_param <- Param_mean$new(likelihood)

        # define PAR/PAF params
        par <- Param_delta$new(likelihood, delta_param_PAR, list(baseline_param, mean_param))
        paf <- Param_delta$new(likelihood, delta_param_PAF, list(baseline_param, mean_param))

        tmle_params <- c(tsm_params, mean_param, rr_params, par, paf)
      } else {
        # define ATE params
        ate_params <- lapply(tsm_params, function(comparison_param){
          Param_delta$new(likelihood, delta_param_ATE, list(baseline_param, comparison_param))
        })

        mean_param <- Param_mean$new(likelihood)
        tmle_params <- c(tsm_params, mean_param, ate_params)

      }

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
tmle_risk <- function(baseline_level = NULL) {
  # todo: unclear why this has to be in a factory function
  tmle3_Spec_risk$new(baseline_level = baseline_level)
}
