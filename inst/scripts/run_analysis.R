#load longbowtools
library(longbowtools)
library(devtools)
library(jsonlite)

# template file
rmd_filename <- package_file("inst","templates","longbow_RiskFactors.Rmd")

# generate inputs file (can also use an existing one)
# params <- params_from_rmd(rmd_filename, sample_json)
sample_json <- package_file("inst","sample_data","sample_inputs.json")
params <- fromJSON(sample_json)

# to run on your machine
run_locally(rmd_filename, sample_json, open_result = TRUE)

# to run on ghap rcluster
# provide your ghap credentials
configure_cluster("~/cluster_credentials.json")

# provide inputs (these reference Andrew's dataset)
# inputs_json <- "~/Dropbox/gates/tlapp-demo/templates/birthweight_inputs.json"
run_on_longbow(rmd_filename, sample_json, open_result = TRUE)

ghap_test_json <- package_file("inst","sample_data","ghap_test.json")
job_url <- run_on_longbow(rmd_filename, ghap_test_json, open_result = TRUE)

# publish your template for other users to use
publish_template(rmd_filename, open_result = TRUE)

# ghap_ip: 52.90.130.177
