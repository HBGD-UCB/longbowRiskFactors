---
title: "Risk Factor Analysis"
output: 
  html_document:
    keep_md: TRUE
    self_contained: true
required_packages:  ['github://HBGD-UCB/longbowRiskFactors','github://jeremyrcoyle/skimr@vector_types', 'github://tlverse/delayed']
params:
  roles:
    value:
      - exclude
      - strata
      - id
      - W
      - A
      - Y
  data: 
    value: 
      type: 'web'
      uri: 'https://raw.githubusercontent.com/HBGD-UCB/longbowRiskFactors/master/inst/sample_data/birthwt_data.rdata'
  nodes:
    value:
      strata: ['study_id', 'mrace']
      id: ['subjid']
      W: ['apgar1', 'apgar5', 'gagebrth', 'mage', 'meducyrs', 'sexn']
      A: ['parity_cat']
      Y: ['haz01']
  script_params:
    value:
      parallelize:
        input: checkbox
        value: FALSE
      count_A:
        input: checkbox
        value: TRUE
      count_Y:
        input: checkbox
        value: FALSE        
      baseline_level:
        input: 'character'
        value: "[1,2)"
  output_directory:
    value: ''

---







## Methods
## Outcome Variable

**Outcome Variable:** haz01

## Predictor Variables

**Intervention Variable:** parity_cat

**Adjustment Set:**

* gagebrth
* mage
* sexn
* apgar1
* apgar5
* meducyrs
* delta_apgar1
* delta_apgar5
* delta_meducyrs

## Stratifying Variables

The analysis was stratified on these variable(s):

* study_id
* mrace

## Data Summary

 study_id  mrace   parity_cat    n_cell     n
---------  ------  -----------  -------  ----
        4  White   [0,1)             47   275
        4  White   [1,2)             70   275
        4  White   [2,3)             62   275
        4  White   [3,13]            96   275
        3  White   [0,1)             51   269
        3  White   [1,2)             67   269
        3  White   [2,3)             48   269
        3  White   [3,13]           103   269
        2  White   [0,1)             42   254
        2  White   [1,2)             67   254
        2  White   [2,3)             45   254
        2  White   [3,13]           100   254
        5  White   [0,1)             46   252
        5  White   [1,2)             59   252
        5  White   [2,3)             46   252
        5  White   [3,13]           101   252
        1  White   [0,1)             50   263
        1  White   [1,2)             58   263
        1  White   [2,3)             56   263
        1  White   [3,13]            99   263
        1  Black   [0,1)              4    26
        1  Black   [1,2)              8    26
        1  Black   [2,3)              6    26
        1  Black   [3,13]             8    26
        3  Black   [0,1)              2    27
        3  Black   [1,2)             10    27
        3  Black   [2,3)              2    27
        3  Black   [3,13]            13    27
        4  Black   [0,1)              1    19
        4  Black   [1,2)              7    19
        4  Black   [2,3)              4    19
        4  Black   [3,13]             7    19
        5  Black   [0,1)              2    21
        5  Black   [1,2)              3    21
        5  Black   [2,3)              8    21
        5  Black   [3,13]             8    21
        2  Black   [0,1)              3    22
        2  Black   [1,2)              3    22
        2  Black   [2,3)              4    22
        2  Black   [3,13]            12    22


The following strata were considered:

* study_id: 1, mrace: Black
* study_id: 1, mrace: White
* study_id: 2, mrace: Black
* study_id: 2, mrace: White
* study_id: 3, mrace: Black
* study_id: 3, mrace: White
* study_id: 4, mrace: Black
* study_id: 4, mrace: White
* study_id: 5, mrace: Black
* study_id: 5, mrace: White

### Dropped Strata

Some strata were dropped due to rare outcomes:

* study_id: 1, mrace: Black
* study_id: 3, mrace: Black
* study_id: 4, mrace: Black
* study_id: 5, mrace: Black
* study_id: 2, mrace: Black

## Methods Detail

We're interested in the causal parameters $E[Y_a]$ for all values of $a \in \mathcal{A}$. These parameters represent the mean outcome if, possibly contrary to fact, we intervened to set all units to have $A=a$. Under the randomization and positivity assumptions, these are identified by the statistical parameters $\psi_a=E_W[E_{Y|A,W}(Y|A=a,W)]$.  In addition, we're interested in the mean of $Y$, $E[Y]$ under no intervention (the observed mean). We will estimate these parameters by using SuperLearner to fit the relevant likelihood factors -- $E_{Y|A,W}(Y|A=a,W)$ and $p(A=a|W)$, and then updating our likelihood fit using a joint TMLE.

For unadjusted analyses ($W=\{\}$), initial likelihoods were estimated using Lrnr_glm to estimate the simple $E(Y|A)$ and Lrnr_mean to estimate $p(A)$. For adjusted analyses, a small library containing Lrnr_glmnet, Lrnr_xgboost, and Lrnr_mean was used.

Having estimated these parameters, we will then use the delta method to estimate relative risks and attributable risks relative to a prespecified baseline level of $A$.

todo: add detail about dropping strata with rare outcomes, handling missingness







# Results Detail

## Results Plots
![](longbow_RiskFactors_files/figure-html/plot_tsm-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_rr-1.png)<!-- -->



![](longbow_RiskFactors_files/figure-html/plot_paf-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_par-1.png)<!-- -->

## Results Table

### Parameter: TSM


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   [0,1)                NA                0.9731120   0.9390145   1.0072095
        1  White   [1,2)                NA                0.9050159   0.8433234   0.9667085
        1  White   [2,3)                NA                0.8772328   0.8067237   0.9477418
        1  White   [3,13]               NA                0.8406881   0.7750610   0.9063153
        2  White   [0,1)                NA                0.4911290   0.4090512   0.5732068
        2  White   [1,2)                NA                0.4773915   0.3943631   0.5604199
        2  White   [2,3)                NA                0.2111253   0.1365749   0.2856756
        2  White   [3,13]               NA                0.2536494   0.1831765   0.3241223
        3  White   [0,1)                NA                0.5747513   0.4920920   0.6574106
        3  White   [1,2)                NA                0.4283942   0.3467211   0.5100674
        3  White   [2,3)                NA                0.3595175   0.2732754   0.4457596
        3  White   [3,13]               NA                0.3725377   0.2988196   0.4462558
        4  White   [0,1)                NA                0.6443941   0.5771453   0.7116429
        4  White   [1,2)                NA                0.4883776   0.4232341   0.5535211
        4  White   [2,3)                NA                0.5813428   0.5230848   0.6396008
        4  White   [3,13]               NA                0.3176987   0.2578609   0.3775364
        5  White   [0,1)                NA                0.5349282   0.4723544   0.5975021
        5  White   [1,2)                NA                0.4302103   0.3632100   0.4972105
        5  White   [2,3)                NA                0.4036459   0.3339995   0.4732922
        5  White   [3,13]               NA                0.3784930   0.3061228   0.4508633


### Parameter: E(Y)


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   NA                   NA                0.6577947   0.5960367   0.7195527
        2  White   NA                   NA                0.4803150   0.4153958   0.5452341
        3  White   NA                   NA                0.5613383   0.4985612   0.6241154
        4  White   NA                   NA                0.5163636   0.4526929   0.5800343
        5  White   NA                   NA                0.5317460   0.4660920   0.5974001


### Parameter: RR


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   [0,1)                [1,2)             1.0752430   0.9957098   1.1611289
        1  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        1  White   [2,3)                [1,2)             0.9693009   0.8716661   1.0778717
        1  White   [3,13]               [1,2)             0.9289208   0.8356458   1.0326073
        2  White   [0,1)                [1,2)             1.0287762   0.8086268   1.3088615
        2  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        2  White   [2,3)                [1,2)             0.4422476   0.2990748   0.6539600
        2  White   [3,13]               [1,2)             0.5313236   0.3842673   0.7346574
        3  White   [0,1)                [1,2)             1.3416411   1.0586434   1.7002900
        3  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        3  White   [2,3)                [1,2)             0.8392212   0.6184947   1.1387200
        3  White   [3,13]               [1,2)             0.8696142   0.6594725   1.1467179
        4  White   [0,1)                [1,2)             1.3194588   1.1271680   1.5445537
        4  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        4  White   [2,3)                [1,2)             1.1903552   1.0189800   1.3905528
        4  White   [3,13]               [1,2)             0.6505185   0.5230286   0.8090846
        5  White   [0,1)                [1,2)             1.2434112   1.0250889   1.5082314
        5  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        5  White   [2,3)                [1,2)             0.9382525   0.7426218   1.1854188
        5  White   [3,13]               [1,2)             0.8797862   0.6860147   1.1282904


### Parameter: PAR


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower     ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  -----------
        1  White   [1,2)                NA                -0.2472212   -0.3141989   -0.1802435
        2  White   [1,2)                NA                 0.0029234   -0.0712967    0.0771436
        3  White   [1,2)                NA                 0.1329441    0.0592783    0.2066099
        4  White   [1,2)                NA                 0.0279860   -0.0318534    0.0878255
        5  White   [1,2)                NA                 0.1015358    0.0315662    0.1715054


### Parameter: PAF


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower     ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  -----------
        1  White   [1,2)                NA                -0.3758334   -0.5062106   -0.2567417
        2  White   [1,2)                NA                 0.0060865   -0.1608171    0.1489925
        3  White   [1,2)                NA                 0.2368342    0.0997409    0.3530505
        4  White   [1,2)                NA                 0.0541983   -0.0659088    0.1607717
        5  White   [1,2)                NA                 0.1909479    0.0602212    0.3034900

