# The R-package allows geocoding of 100 rows of data at a time
# It will import this information into list format
# This code allows you to geocode many more rows of data and converts them
# into a convenient dataframe

# df is the table to convert
# `Postal Code` is the variable within the df containing the postcode


for(x in 1:ceiling(nrow(df)/100)){
  
  i = ((x-1)*100)+1
  j = i + 99
  
  sample <- slice(df, i:j)
  sample_list <- list(postcodes = c(sample$`Postal Code`))
  sample_listings <- bulk_postcode_lookup(sample_list)
  
  
  # First use the first example to build a blank table of names
  pc_result <- sample_listings[[1]]$result
  
  take_names <- setdiff(names(pc_result), 'codes')
  pc_result[sapply(pc_result, is.null)] = list(NA)
  pc_df <- cbind(as.data.frame(pc_result[take_names]),
                 as.data.frame(pc_result$codes))
  pc_df <- pc_df[0,]
  
  pc_result <- NULL
  
  
  ##########
  # Then run loop over all rows in this sample
  for(i in 1:100){
    pc_result <- sample_listings[[i]]$result
    
    # If there is no address found then skip to the next iteration
    if(length(pc_result) == 0) next
    
    take_names <- setdiff(names(pc_result), 'codes')
    pc_result[sapply(pc_result, is.null)] = list(NA)
    pc_df1 <- cbind(as.data.frame(pc_result[take_names]),
                    as.data.frame(pc_result$codes))
    
    pc_df <- rbind(pc_df,pc_df1) }
  
  name = paste0("pc_sample",x)
  assign(name,pc_df)
  newest = assign(name,pc_df) 
  
  ########
  # Then bind all the sample information together
  
  if(name == "pc_sample1"){
    
    postcodes = pc_sample1} else
    { postcodes <- rbind(postcodes, newest) }
  
}




