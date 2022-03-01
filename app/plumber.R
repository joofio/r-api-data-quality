library(plumber)
library(bnlearn)

#load net

model <- load("obs-hc.rda")

cors<-function(req,res){
  res$setHeader("Acess-Control-Allow-Origin","*")
  if (req$REQUEST_METHOD=="OPTIONS"){
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers",req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status<-200
    return(list())
  } else {
    plumber::forward()
  }
}

#* @post /predict
function(req,res){
  data <-tryCatch(jsonlite::parse_json(req$postBody,simplifyVector=TRUE), error=function(e) NULL  )
  if (is.null(data)){
    res$status<-400
    list(error="No data")
  } 
  data <-data.frame(data)
  ret <- predict(model,data)
  ret
}