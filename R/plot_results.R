#' @import ggplot2
#' @export
tsm_plot <- function(formatted_results){
  tsms <- formatted_results[type=="TSM"]
  intervention <- tsms$intervention_variable[1]
  outcome <- tsms$outcome_variable[1]
  #todo: generalize faceting
  ggplot(tsms,aes_string(x="intervention_level", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+facet_wrap(~study_id, labeller=label_both)+
    xlab(intervention)+ylab(outcome)+theme_bw()+ggtitle("Treatment Specific Means")
}

#' @import ggplot2
#' @export
rr_plot <- function(formatted_results){
  rrs <- formatted_results[type=="RR"]
  intervention <- rrs$intervention_variable[1]
  outcome <- rrs$outcome_variable[1]
  baseline <- rrs$baseline_line[1]
  #todo: generalize faceting
  ggplot(rrs,aes_string(x="intervention_level", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+facet_wrap(~study_id, labeller=label_both)+
    xlab(intervention)+ylab(outcome)+theme_bw()+ggtitle(sprintf("Relative Risks -- Baseline=%s",baseline))
}

#' @import ggplot2
#' @export
par_plot <- function(formatted_results){
  pars <- formatted_results[type=="PAR"]
  outcome <- pars$outcome_variable[1]
  baseline <- pars$baseline_level[1]
  #todo: generalize x

  ggplot(pars,aes_string(x="study_id", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+
    ylab(outcome)+theme_bw()+coord_flip()+
    ggtitle(sprintf("Population Attributable Risks -- Baseline=%s",baseline))
}

#' @import ggplot2
#' @export
paf_plot <- function(formatted_results){
  pafs <- formatted_results[type=="PAF"]
  outcome <- pafs$outcome_variable[1]
  baseline <- pafs$baseline_level[1]
  #todo: generalize x

  ggplot(pafs,aes_string(x="study_id", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+
    ylab(outcome)+theme_bw()+theme_bw()+coord_flip()+
    ggtitle(sprintf("Population Attributable Fractions -- Baseline=%s",baseline))
}
