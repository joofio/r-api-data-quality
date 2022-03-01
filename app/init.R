my.packages<-c("plumber","bnlearn","yaml")
install_if_missing<- function(p){
    if (p %in% rownames(installed.packages())==FALSE){
        install.packages(p,dependencies=TRUE)
    }
    else{
        cat(paste("skipping already installed package:",p,"\n"))
    }
}
invisible(sapply(my.packages,install_if_missing))