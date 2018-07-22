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
      W: []
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
        value: TRUE        
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

unadjusted

## Stratifying Variables

The analysis was stratified on these variable(s):

* study_id
* mrace

## Data Summary

 study_id  mrace   parity_cat    haz01   n_cell     n
---------  ------  -----------  ------  -------  ----
        4  White   [0,1)             0       17   275
        4  White   [0,1)             1       30   275
        4  White   [1,2)             0       37   275
        4  White   [1,2)             1       33   275
        4  White   [2,3)             0       24   275
        4  White   [2,3)             1       38   275
        4  White   [3,13]            0       55   275
        4  White   [3,13]            1       41   275
        3  White   [0,1)             0       16   269
        3  White   [0,1)             1       35   269
        3  White   [1,2)             0       28   269
        3  White   [1,2)             1       39   269
        3  White   [2,3)             0       23   269
        3  White   [2,3)             1       25   269
        3  White   [3,13]            0       51   269
        3  White   [3,13]            1       52   269
        2  White   [0,1)             0       14   254
        2  White   [0,1)             1       28   254
        2  White   [1,2)             0       30   254
        2  White   [1,2)             1       37   254
        2  White   [2,3)             0       26   254
        2  White   [2,3)             1       19   254
        2  White   [3,13]            0       62   254
        2  White   [3,13]            1       38   254
        5  White   [0,1)             0       21   252
        5  White   [0,1)             1       25   252
        5  White   [1,2)             0       27   252
        5  White   [1,2)             1       32   252
        5  White   [2,3)             0       19   252
        5  White   [2,3)             1       27   252
        5  White   [3,13]            0       51   252
        5  White   [3,13]            1       50   252
        1  White   [0,1)             0        7   263
        1  White   [0,1)             1       43   263
        1  White   [1,2)             0       22   263
        1  White   [1,2)             1       36   263
        1  White   [2,3)             0       24   263
        1  White   [2,3)             1       32   263
        1  White   [3,13]            0       37   263
        1  White   [3,13]            1       62   263
        1  Black   [0,1)             0        2    26
        1  Black   [0,1)             1        2    26
        1  Black   [1,2)             0        4    26
        1  Black   [1,2)             1        4    26
        1  Black   [2,3)             0        5    26
        1  Black   [2,3)             1        1    26
        1  Black   [3,13]            0        2    26
        1  Black   [3,13]            1        6    26
        3  Black   [0,1)             0        1    27
        3  Black   [0,1)             1        1    27
        3  Black   [1,2)             0        6    27
        3  Black   [1,2)             1        4    27
        3  Black   [2,3)             0        1    27
        3  Black   [2,3)             1        1    27
        3  Black   [3,13]            0        5    27
        3  Black   [3,13]            1        8    27
        4  Black   [0,1)             0        0    19
        4  Black   [0,1)             1        1    19
        4  Black   [1,2)             0        3    19
        4  Black   [1,2)             1        4    19
        4  Black   [2,3)             0        4    19
        4  Black   [2,3)             1        0    19
        4  Black   [3,13]            0        2    19
        4  Black   [3,13]            1        5    19
        5  Black   [0,1)             0        0    21
        5  Black   [0,1)             1        2    21
        5  Black   [1,2)             0        0    21
        5  Black   [1,2)             1        3    21
        5  Black   [2,3)             0        3    21
        5  Black   [2,3)             1        5    21
        5  Black   [3,13]            0        1    21
        5  Black   [3,13]            1        7    21
        2  Black   [0,1)             0        0    22
        2  Black   [0,1)             1        3    22
        2  Black   [1,2)             0        1    22
        2  Black   [1,2)             1        2    22
        2  Black   [2,3)             0        3    22
        2  Black   [2,3)             1        1    22
        2  Black   [3,13]            0        1    22
        2  Black   [3,13]            1       11    22


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


```
## Warning: Removed 5 rows containing missing values (geom_errorbar).
```

![](longbow_RiskFactors_files/figure-html/plot_rr-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_paf-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_par-1.png)<!-- -->

## Results Table

### Parameter: TSM


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   [0,1)                NA                0.8600000   0.7539632   0.9660368
        1  White   [1,2)                NA                0.6206897   0.4914888   0.7498905
        1  White   [2,3)                NA                0.5714286   0.4282442   0.7146130
        1  White   [3,13]               NA                0.6262626   0.5245085   0.7280168
        2  White   [0,1)                NA                0.6666667   0.4976849   0.8356484
        2  White   [1,2)                NA                0.5522388   0.4242955   0.6801821
        2  White   [2,3)                NA                0.4222222   0.2868287   0.5576157
        2  White   [3,13]               NA                0.3800000   0.2813965   0.4786035
        3  White   [0,1)                NA                0.6862745   0.5411703   0.8313787
        3  White   [1,2)                NA                0.5820896   0.4550769   0.7091022
        3  White   [2,3)                NA                0.5208333   0.3741927   0.6674740
        3  White   [3,13]               NA                0.5048544   0.4045685   0.6051402
        4  White   [0,1)                NA                0.6382979   0.4723100   0.8042858
        4  White   [1,2)                NA                0.4714286   0.3454121   0.5974451
        4  White   [2,3)                NA                0.6129032   0.4884371   0.7373694
        4  White   [3,13]               NA                0.4270833   0.3215223   0.5326444
        5  White   [0,1)                NA                0.5434783   0.3837324   0.7032241
        5  White   [1,2)                NA                0.5423729   0.4086237   0.6761221
        5  White   [2,3)                NA                0.5869565   0.4350512   0.7388618
        5  White   [3,13]               NA                0.4950495   0.3922351   0.5978639


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
        1  White   [0,1)                [1,2)             1.3855556   1.0878519   1.7647294
        1  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        1  White   [2,3)                [1,2)             0.9206349   0.6648297   1.2748658
        1  White   [3,13]               [1,2)             1.0089787   0.7752766   1.3131288
        2  White   [0,1)                [1,2)             1.2072072   0.8563366   1.7018417
        2  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        2  White   [2,3)                [1,2)             0.7645646   0.5147736   1.1355653
        2  White   [3,13]               [1,2)             0.6881081   0.4859423   0.9743807
        3  White   [0,1)                [1,2)             1.1789844   0.8700702   1.5975772
        3  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        3  White   [2,3)                [1,2)             0.8947650   0.6266209   1.2776535
        3  White   [3,13]               [1,2)             0.8673139   0.6456871   1.1650124
        4  White   [0,1)                [1,2)             1.3539652   0.9327819   1.9653273
        4  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        4  White   [2,3)                [1,2)             1.3000978   0.9296597   1.8181428
        4  White   [3,13]               [1,2)             0.9059343   0.6294338   1.3038972
        5  White   [0,1)                [1,2)             1.0020380   0.6827414   1.4706596
        5  White   [1,2)                [1,2)             1.0000000   1.0000000   1.0000000
        5  White   [2,3)                [1,2)             1.0822011   0.7569283   1.5472525
        5  White   [3,13]               [1,2)             0.9127475   0.6611983   1.2599973


### Parameter: PAR


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower    ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  ----------
        1  White   [1,2)                NA                 0.0371050   -0.0778393   0.1520494
        2  White   [1,2)                NA                -0.0719238   -0.1813214   0.0374737
        3  White   [1,2)                NA                -0.0207513   -0.1304654   0.0889629
        4  White   [1,2)                NA                 0.0449351   -0.0642770   0.1541472
        5  White   [1,2)                NA                -0.0106269   -0.1282009   0.1069472


### Parameter: PAF


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower    ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  ----------
        1  White   [1,2)                NA                 0.0564082   -0.1355076   0.2158877
        2  White   [1,2)                NA                -0.1497431   -0.4024015   0.0573961
        3  White   [1,2)                NA                -0.0369675   -0.2520491   0.1411666
        4  White   [1,2)                NA                 0.0870221   -0.1512301   0.2759670
        5  White   [1,2)                NA                -0.0199848   -0.2669555   0.1788433

