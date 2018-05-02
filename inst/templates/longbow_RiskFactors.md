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
      strata: ['study_id']
      W: ['apgar1', 'apgar5', 'gagebrth', 'mage', 'meducyrs', 'sexn']
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


The following strata were considered:

* study_id: 1
* study_id: 2
* study_id: 3
* study_id: 4
* study_id: 5

### Dropped Strata

Some strata were dropped due to rare outcomes:

* study_id: 1

## Methods Detail

**todo**




# Results Detail

## Results Plots
![](longbow_RiskFactors_files/figure-html/plot_tsm-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_rr-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_paf-1.png)<!-- -->

![](longbow_RiskFactors_files/figure-html/plot_par-1.png)<!-- -->

## Data Summary

 study_id  A           n    nA   nAY0   nAY1
---------  -------  ----  ----  -----  -----
        1  [0,1)     289    54      9     45
        1  [1,2)     289    66     26     40
        1  [2,3)     289    62     29     33
        1  [3,13]    289   107     39     68
        2  [0,1)     276    45     14     31
        2  [1,2)     276    70     31     39
        2  [2,3)     276    49     29     20
        2  [3,13]    276   112     63     49
        3  [0,1)     296    53     17     36
        3  [1,2)     296    77     34     43
        3  [2,3)     296    50     24     26
        3  [3,13]    296   116     56     60
        4  [0,1)     294    48     17     31
        4  [1,2)     294    77     40     37
        4  [2,3)     294    66     28     38
        4  [3,13]    294   103     57     46
        5  [0,1)     273    48     21     27
        5  [1,2)     273    62     27     35
        5  [2,3)     273    54     22     32
        5  [3,13]    273   109     52     57

## Results Table

### Parameter: TSM


 study_id  intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  -------------------  ---------------  ----------  ----------  ----------
        2  [0,1)                NA                0.6874909   0.5495184   0.8254635
        2  [1,2)                NA                0.5778056   0.4631834   0.6924277
        2  [2,3)                NA                0.4485297   0.3102410   0.5868185
        2  [3,13]               NA                0.4100636   0.3214471   0.4986802
        3  [0,1)                NA                0.6735057   0.5483488   0.7986627
        3  [1,2)                NA                0.5539737   0.4432528   0.6646946
        3  [2,3)                NA                0.5219428   0.3871419   0.6567437
        3  [3,13]               NA                0.5224364   0.4311015   0.6137714
        4  [0,1)                NA                0.6290488   0.4955895   0.7625082
        4  [1,2)                NA                0.5182550   0.4086035   0.6279065
        4  [2,3)                NA                0.5367560   0.4214652   0.6520467
        4  [3,13]               NA                0.4505214   0.3574965   0.5435463
        5  [0,1)                NA                0.6404349   0.5084910   0.7723788
        5  [1,2)                NA                0.6242985   0.5060390   0.7425580
        5  [2,3)                NA                0.5543629   0.4270206   0.6817052
        5  [3,13]               NA                0.4703604   0.3757618   0.5649589


### Parameter: E(Y)


 study_id  intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  -------------------  ---------------  ----------  ----------  ----------
        2  NA                   NA                0.5036232   0.4857765   0.5214699
        3  NA                   NA                0.5574324   0.5480636   0.5668013
        4  NA                   NA                0.5170068   0.4992551   0.5347585
        5  NA                   NA                0.5531136   0.5378457   0.5683815


### Parameter: RR


 study_id  intervention_level   baseline_level    estimate   ci_lower   ci_upper
---------  -------------------  ---------------  ---------  ---------  ---------
        2  [0,1)                [1,2)             3.286526   2.477741   4.359313
        2  [2,3)                [1,2)             2.173338   1.508032   3.132159
        2  [3,13]               [1,2)             2.033364   1.523047   2.714668
        3  [0,1)                [1,2)             3.372897   2.568278   4.429597
        3  [2,3)                [1,2)             2.565568   1.853122   3.551919
        3  [3,13]               [1,2)             2.567855   1.969192   3.348520
        4  [0,1)                [1,2)             3.366193   2.498951   4.534404
        4  [2,3)                [1,2)             2.817073   2.089813   3.797422
        4  [3,13]               [1,2)             2.385251   1.780277   3.195808
        5  [0,1)                [1,2)             2.789458   2.117269   3.675052
        5  [2,3)                [1,2)             2.430209   1.810729   3.261623
        5  [3,13]               [1,2)             2.124257   1.616617   2.791303


### Parameter: PAR


 study_id  intervention_level   baseline_level      estimate     ci_lower    ci_upper
---------  -------------------  ---------------  -----------  -----------  ----------
        2  [1,2)                NA                -0.0741824   -0.1887109   0.0403462
        3  [1,2)                NA                 0.0034588   -0.1072879   0.1142054
        4  [1,2)                NA                -0.0012482   -0.1105317   0.1080353
        5  [1,2)                NA                -0.0711849   -0.1879610   0.0455911


### Parameter: PAF


 study_id  intervention_level   baseline_level     estimate    ci_lower    ci_upper
---------  -------------------  ---------------  ----------  ----------  ----------
        2  [1,2)                NA                0.5817239   0.4898335   0.6570632
        3  [1,2)                NA                0.6344103   0.5535086   0.7006530
        4  [1,2)                NA                0.6312335   0.5446634   0.7013445
        5  [1,2)                NA                0.5876885   0.5029179   0.6580026


