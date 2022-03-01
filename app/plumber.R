library(plumber)
library(bnlearn)

#* @apiTitle Gapminder API
#* @apiDescription API for exploring Gapminder dataset
load("/Users/joaoalmeida/obs-hc.rda")
model <- osa.hc.fit
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
#* @post /eval_quality/<target>
#* @param target:string
#* @parser json
#* @serializer json

function(req,res,target){
  data <-tryCatch(jsonlite::parse_json(req$postBody,simplifyVector=TRUE), error=function(e) NULL  )
  #data <- req$postBody
  if (is.null(data)){
    res$status<-400
    list(error="No data")
  } 
  data<-data.frame(data)
  data <- as.data.frame(lapply(data,as.numeric))

  predicted <- predict(model, node = target, data = data, method = "bayes-lw")
  
  real.val<-data[,target]
  if ((real.val - predicted)>predicted*1.5){
    ret=list(result="weak outlier",predicted=predicted,real=real.val)
  }  else if ((real.val - predicted)>predicted*3){
    ret=list(result="strong outlier",predicted=predicted,real=real.val)
  }else{
    ret=list(result="ok",predicted=predicted,real=real.val)
    
  }
ret
}
#* @plumber
function(pr) {
  pr %>%
    pr_set_api_spec("api-spec.yaml")
}