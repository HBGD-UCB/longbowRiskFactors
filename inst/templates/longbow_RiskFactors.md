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
      uri: 'https://raw.githubusercontent.com/HBGD-UCB/longbowRiskFactors/master/inst/sample_data/birthwt_data.csv'
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
        1  White   [0,1)                NA                0.8600000   0.7636385   0.9563615
        1  White   [1,2)                NA                0.6206897   0.4955785   0.7458008
        1  White   [2,3)                NA                0.5714286   0.4415690   0.7012881
        1  White   [3,13]               NA                0.6262626   0.5307811   0.7217441
        2  White   [0,1)                NA                0.6666667   0.5238188   0.8095145
        2  White   [1,2)                NA                0.5522388   0.4329351   0.6715425
        2  White   [2,3)                NA                0.4222222   0.2776285   0.5668159
        2  White   [3,13]               NA                0.3800000   0.2846782   0.4753218
        3  White   [0,1)                NA                0.6862745   0.5586907   0.8138583
        3  White   [1,2)                NA                0.5820896   0.4637702   0.7004089
        3  White   [2,3)                NA                0.5208333   0.3792445   0.6624221
        3  White   [3,13]               NA                0.5048544   0.4081185   0.6015903
        4  White   [0,1)                NA                0.6382979   0.5006792   0.7759166
        4  White   [1,2)                NA                0.4714286   0.3542765   0.5885806
        4  White   [2,3)                NA                0.6129032   0.4914388   0.7343676
        4  White   [3,13]               NA                0.4270833   0.3279532   0.5262134
        5  White   [0,1)                NA                0.5434783   0.3992487   0.6877079
        5  White   [1,2)                NA                0.5423729   0.4149961   0.6697497
        5  White   [2,3)                NA                0.5869565   0.4443848   0.7295283
        5  White   [3,13]               NA                0.4950495   0.3973484   0.5927506


### Parameter: E(Y)


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   NA                   NA                0.6577947   0.6456622   0.6699272
        2  White   NA                   NA                0.4803150   0.4670056   0.4936244
        3  White   NA                   NA                0.5613383   0.5532350   0.5694415
        4  White   NA                   NA                0.5163636   0.5058137   0.5269136
        5  White   NA                   NA                0.5317460   0.5275549   0.5359371


### Parameter: RR


 study_id  mrace   intervention_level   baseline_level    estimate   ci_lower   ci_upper
---------  ------  -------------------  ---------------  ---------  ---------  ---------
        1  White   [0,1)                [1,2)             3.997046   3.173827   5.033790
        1  White   [2,3)                [1,2)             2.510884   1.853116   3.402129
        1  White   [3,13]               [1,2)             2.742798   2.130262   3.531464
        2  White   [0,1)                [1,2)             3.344132   2.466822   4.533452
        2  White   [2,3)                [1,2)             2.148059   1.432838   3.220291
        2  White   [3,13]               [1,2)             1.989947   1.429115   2.770869
        3  White   [0,1)                [1,2)             3.251071   2.468283   4.282110
        3  White   [2,3)                [1,2)             2.446761   1.742506   3.435649
        3  White   [3,13]               [1,2)             2.380508   1.800332   3.147651
        4  White   [0,1)                [1,2)             3.872751   2.787007   5.381472
        4  White   [2,3)                [1,2)             3.669655   2.670449   5.042736
        4  White   [3,13]               [1,2)             2.474243   1.761017   3.476331
        5  White   [0,1)                [1,2)             2.723828   1.911066   3.882249
        5  White   [2,3)                [1,2)             2.951168   2.105035   4.137410
        5  White   [3,13]               [1,2)             2.491158   1.833053   3.385535


### Parameter: PAR


 study_id  mrace   intervention_level   baseline_level      estimate     ci_lower    ci_upper
---------  ------  -------------------  ---------------  -----------  -----------  ----------
        1  White   [1,2)                NA                 0.0371050   -0.0885930   0.1628030
        2  White   [1,2)                NA                -0.0719238   -0.1919677   0.0481200
        3  White   [1,2)                NA                -0.0207513   -0.1393478   0.0978453
        4  White   [1,2)                NA                 0.0449351   -0.0726911   0.1625612
        5  White   [1,2)                NA                -0.0106269   -0.1380726   0.1168189


### Parameter: PAF


 study_id  mrace   intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  ------  -------------------  ---------------  ----------  ----------  ----------
        1  White   [1,2)                NA                0.6534681   0.5757237   0.7169666
        2  White   [1,2)                NA                0.5809477   0.4789729   0.6629641
        3  White   [1,2)                NA                0.6187692   0.5326009   0.6890518
        4  White   [1,2)                NA                0.6655664   0.5708608   0.7393716
        5  White   [1,2)                NA                0.6248415   0.5254667   0.7034057


