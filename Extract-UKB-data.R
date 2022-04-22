#### Prepare environment

rm(list = ls())

# Load required packages
library('reshape2')
library('ukbtools')
library('tidyverse')
library('tibble')
library('readr')
library('data.table')
library('ggplot2')

# Load UKB raw dataset
load("/data/teaglewl/ukbiobank/raw_data/my_ukb_data.rda")

# Use ukb_df_field to create a field code-to-descriptive name key, as dataframe or named lookup vector.
my_ukb_key <- ukb_df_field("ukb45856", path = "/data/teaglewl/ukbiobank/raw_data")

# Function to extract data
extract_ukb <- function(data_showcase, output_filepath, my_ukb_key, my_ukb_data) {
    
    # Create dataframe with field.showcase and col.name values
    data_key <- dplyr::filter(my_ukb_key, my_ukb_key$field.showcase %in% data_showcase)
    
    # Remove duplicate data
    data_key <- data_key[!duplicated(data_key$col.name), ]
    data_key <- data_key[,c("field.showcase", "col.name")]
    
    # Create UKB datasets
    ukb_data <- select(my_ukb_data, matches(data_key$col.name))
    
    # Save dataset as .txt file
    write.table(ukb_data, 
            file = output_filepath, 
            sep = "\t", 
            quote = FALSE, 
            row.names = FALSE)
    
    # Print completion message
    print(paste0("Data extraction complete. Data saved at ", output_filepath))
}

#### Extract data

# Set function inputs
data_showcase <- c(
    "eid",
    ## I20-25 Ischemic heart disease
    "131296", # Date I20 first reported (angina pectoris)
    "131298", # Date I21 first reported (acute myocardial infarction)
    "131300", # Date I22 first reported (subsequent myocardial infarction)
    "131302", # Date I23 first reported (certain current complications following acute myocardial infarction)
    "131304", # Date I24 first reported (other acute ischaemic heart diseases)
    "131306", # Date I25 first reported (chronic ischaemic heart disease)
    ## I60-69 Cerebrovascular disease
    "131360", # Date I60 first reported (subarachnoid haemorrhage)
    "131362", # Date I61 first reported (intracerebral haemorrhage)
    "131364", # Date I62 first reported (other nontraumatic intracranial haemorrhage)
    "131366", # Date I63 first reported (cerebral infarction)
    "131368", # Date I64 first reported (stroke, not specified as haemorrhage or infarction)
    "131370", # Date I65 first reported (occlusion and stenosis of precerebral arteries, not resulting in cerebral infarction)
    "131372", # Date I66 first reported (occlusion and stenosis of cerebral arteries, not resulting in cerebral infarction)
    "131374", # Date I67 first reported (other cerebrovascular diseases)
    "131376", # Date I68 first reported (cerebrovascular disorders in diseases classified elsewhere)
    "131378" # Date I69 first reported (sequelae of cerebrovascular disease)
) 
output_filepath <- "/data/teaglewl/ukbiobank/outputs_data/dr-tamura-collab-raw-data_CVD-outcomes.txt"

# Extract and save data
extract_ukb(data_showcase, output_filepath, my_ukb_key, my_ukb_data)
