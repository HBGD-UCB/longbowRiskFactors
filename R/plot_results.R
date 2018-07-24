#' @import ggplot2
#' @export
tsm_plot <- function(formatted_results){
  tsms <- formatted_results[type=="TSM"]
  intervention <- tsms$intervention_variable[1]
  outcome <- tsms$outcome_variable[1]
  #todo: generalize faceting
  ggplot(tsms,aes_string(x="intervention_level", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+facet_wrap(~strata_label)+
    xlab(intervention)+ylab("Estimate")+theme_bw()+ggtitle("Treatment Specific Means")+
    theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5))
}

#' @import ggplot2
#' @export
rr_plot <- function(formatted_results){
  rrs <- formatted_results[type=="RR"]

  if(nrow(rrs)==0){
    return(invisible(NULL))
  }

  intervention <- rrs$intervention_variable[1]
  outcome <- rrs$outcome_variable[1]
  baseline <- rrs$baseline_level[1]
  rrs[baseline_level==intervention_level, ci_lower:=NA]
  rrs[baseline_level==intervention_level, ci_upper:=NA]
  rrs[baseline_level==intervention_level, intervention_level:=sprintf("%s (ref)",intervention_level)]

  #todo: generalize faceting
  ggplot(rrs,aes_string(x="intervention_level", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+facet_wrap(~strata_label)+
    xlab(intervention)+ylab("Estimate")+theme_bw()+ggtitle(sprintf("Relative Risks\nBaseline=%s",baseline))+
    theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5))
}

#' @import ggplot2
#' @export
ate_plot <- function(formatted_results){
  ates <- formatted_results[type=="ATE"]

  if(nrow(ates)==0){
    return(invisible(NULL))
  }

  intervention <- ates$intervention_variable[1]
  outcome <- ates$outcome_variable[1]
  baseline <- ates$baseline_level[1]
  ates[baseline_level==intervention_level, ci_lower:=NA]
  ates[baseline_level==intervention_level, ci_upper:=NA]
  ates[baseline_level==intervention_level, intervention_level:=sprintf("%s (ref)",intervention_level)]

  #todo: generalize faceting
  ggplot(ates,aes_string(x="intervention_level", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+facet_wrap(~strata_label)+
    xlab(intervention)+ylab("Estimate")+theme_bw()+ggtitle(sprintf("Average Treatment Effects\nBaseline=%s",baseline))+
    theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5))
}
#' @import ggplot2
#' @export
par_plot <- function(formatted_results){
  pars <- formatted_results[type=="PAR"]
  
  if(nrow(pars)==0){
    return(invisible(NULL))
  }
  
  outcome <- pars$outcome_variable[1]
  baseline <- pars$intervention_level[1]
  #todo: generalize x

  ggplot(pars,aes_string(x="strata_label", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+
    xlab("")+ylab("Estimate")+theme_bw()+coord_flip()+
    ggtitle(sprintf("Population Attributable Risks\nBaseline=%s",baseline))
}

#' @import ggplot2
#' @export
paf_plot <- function(formatted_results){
  pafs <- formatted_results[type=="PAF"]
  
  if(nrow(pafs)==0){
    return(invisible(NULL))
  }

  outcome <- pafs$outcome_variable[1]
  baseline <- pafs$intervention_level[1]
  #todo: generalize x

  ggplot(pafs,aes_string(x="strata_label", y="estimate", ymin="ci_lower", ymax="ci_upper"))+
    geom_point()+geom_errorbar()+
    xlab("")+ylab("Estimate")+theme_bw()+theme_bw()+coord_flip()+
    ggtitle(sprintf("Population Attributable Fractions\nBaseline=%s",baseline))
}
