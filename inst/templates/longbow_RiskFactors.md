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
* study_id: 2, mrace: Black
* study_id: 3, mrace: Black
* study_id: 4, mrace: Black
* study_id: 5, mrace: Black

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

## Data Summary

 study_id  mrace   A           n    nA   nAY0   nAY1
---------  ------  -------  ----  ----  -----  -----
        1  Black   [0,1)      26     4      2      2
        1  Black   [1,2)      26     8      4      4
        1  Black   [2,3)      26     6      5      1
        1  Black   [3,13]     26     8      2      6
        1  White   [0,1)     263    50      7     43
        1  White   [1,2)     263    58     22     36
        1  White   [2,3)     263    56     24     32
        1  White   [3,13]    263    99     37     62
        2  Black   [0,1)      22     3      0      3
        2  Black   [1,2)      22     3      1      2
        2  Black   [2,3)      22     4      3      1
        2  Black   [3,13]     22    12      1     11
        2  White   [0,1)     254    42     14     28
        2  White   [1,2)     254    67     30     37
        2  White   [2,3)     254    45     26     19
        2  White   [3,13]    254   100     62     38
        3  Black   [0,1)      27     2      1      1
        3  Black   [1,2)      27    10      6      4
        3  Black   [2,3)      27     2      1      1
        3  Black   [3,13]     27    13      5      8
        3  White   [0,1)     269    51     16     35
        3  White   [1,2)     269    67     28     39
        3  White   [2,3)     269    48     23     25
        3  White   [3,13]    269   103     51     52
        4  Black   [0,1)      19     1      0      1
        4  Black   [1,2)      19     7      3      4
        4  Black   [2,3)      19     4      4      0
        4  Black   [3,13]     19     7      2      5
        4  White   [0,1)     275    47     17     30
        4  White   [1,2)     275    70     37     33
        4  White   [2,3)     275    62     24     38
        4  White   [3,13]    275    96     55     41
        5  Black   [0,1)      21     2      0      2
        5  Black   [1,2)      21     3      0      3
        5  Black   [2,3)      21     8      3      5
        5  Black   [3,13]     21     8      1      7
        5  White   [0,1)     252    46     21     25
        5  White   [1,2)     252    59     27     32
        5  White   [2,3)     252    46     19     27
        5  White   [3,13]    252   101     51     50

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
        1  White   NA                   NA                0.6577947   0.6439418   0.6716476
        2  White   NA                   NA                0.4803150   0.4652098   0.4954201
        3  White   NA                   NA                0.5613383   0.5520632   0.5706134
        4  White   NA                   NA                0.5163636   0.5041734   0.5285539
        5  White   NA                   NA                0.5317460   0.5271936   0.5362985


### Parameter: RR


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   [0,1)                [1,2)             1.3855556   1.0878519   1.7647294
        1  White   [2,3)                [1,2)             0.9206349   0.6648297   1.2748658
        1  White   [3,13]               [1,2)             1.0089787   0.7752766   1.3131288
        2  White   [0,1)                [1,2)             1.2072072   0.8563366   1.7018417
        2  White   [2,3)                [1,2)             0.7645646   0.5147736   1.1355653
        2  White   [3,13]               [1,2)             0.6881081   0.4859423   0.9743807
        3  White   [0,1)                [1,2)             1.1789844   0.8700702   1.5975772
        3  White   [2,3)                [1,2)             0.8947650   0.6266209   1.2776535
        3  White   [3,13]               [1,2)             0.8673139   0.6456871   1.1650124
        4  White   [0,1)                [1,2)             1.3539652   0.9327819   1.9653273
        4  White   [2,3)                [1,2)             1.3000978   0.9296597   1.8181428
        4  White   [3,13]               [1,2)             0.9059343   0.6294338   1.3038972
        5  White   [0,1)                [1,2)             1.0020380   0.6827414   1.4706596
        5  White   [2,3)                [1,2)             1.0822011   0.7569283   1.5472525
        5  White   [3,13]               [1,2)             0.9127475   0.6611983   1.2599973


### Parameter: PAR


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower    ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  ----------
        1  White   [1,2)                NA                 0.0371050   -0.0933203   0.1675304
        2  White   [1,2)                NA                -0.0719238   -0.2008368   0.0569891
        3  White   [1,2)                NA                -0.0207513   -0.1480989   0.1065964
        4  White   [1,2)                NA                 0.0449351   -0.0820623   0.1719325
        5  White   [1,2)                NA                -0.0106269   -0.1444558   0.1232021


### Parameter: PAF


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower    ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  ----------
        1  White   [1,2)                NA                 0.0564082   -0.1640371   0.2351056
        2  White   [1,2)                NA                -0.1497431   -0.4528291   0.0901138
        3  White   [1,2)                NA                -0.0369675   -0.2906175   0.1668317
        4  White   [1,2)                NA                 0.0870221   -0.1949038   0.3024304
        5  White   [1,2)                NA                -0.0199848   -0.3054406   0.2030514


