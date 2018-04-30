#' @export
tsm_plot <- function(formatted){
  tsms <- formatted[type=="TSM"]
  intervention <- tsms$A[1]
  outcome <- tsms$Y[1]
  #todo: generalize faceting
  ggplot(tsms,aes(x=intervention, y=psi_transformed, ymin=lower_transformed, ymax=upper_transformed))+
    geom_point()+geom_errorbar()+facet_wrap(~study_id, labeller=label_both)+
    xlab(intervention)+ylab(outcome)+theme_bw()+ggtitle("Treatment Specific Means")
}

#' @export
rr_plot <- function(formatted){
  rrs <- formatted[type=="RR"]
  intervention <- rrs$A[1]
  outcome <- rrs$Y[1]
  baseline <- rrs$baseline[1]
  #todo: generalize faceting
  ggplot(rrs,aes(x=intervention, y=psi_transformed, ymin=lower_transformed, ymax=upper_transformed))+
    geom_point()+geom_errorbar()+facet_wrap(~study_id, labeller=label_both)+
    xlab(intervention)+ylab(outcome)+theme_bw()+ggtitle(sprintf("Relative Risks -- Baseline=%s",baseline))
}

#' @export
par_plot <- function(formatted){
  pars <- formatted[type=="PAR"]
  outcome <- pars$Y[1]
  baseline <- pars$intervention[1]
  #todo: generalize x

  ggplot(pars,aes(x=study_id, y=psi_transformed, ymin=lower_transformed, ymax=upper_transformed))+
    geom_point()+geom_errorbar()+
    ylab(outcome)+theme_bw()+ggtitle(sprintf("Population Attributable Risks -- Baseline=%s",baseline))
}

#' @export
paf_plot <- function(formatted){
  pafs <- formatted[type=="PAF"]
  outcome <- pafs$Y[1]
  baseline <- pafs$intervention[1]
  #todo: generalize x

  ggplot(pafs,aes(x=study_id, y=psi_transformed, ymin=lower_transformed, ymax=upper_transformed))+
    geom_point()+geom_errorbar()+
    ylab(outcome)+theme_bw()+ggtitle(sprintf("Population Attributable Risks -- Baseline=%s",baseline))
}
