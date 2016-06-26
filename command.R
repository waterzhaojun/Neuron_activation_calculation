setwd("data-science-class/C9W4A_Neuron_activation_calculation/")

x <- readLines("example.txt")
xa <- as.numeric(strsplit(x[2], ",")[[1]])

stimulate <- c(0,2,0,6,4,3,0,0,4,7,8,0)
standard <- 9

actiTrial <- vector(mode = "numeric", length = 0)
magTrial <- vector(mode = "numeric", length = 0)
thisTrial <- 0

for(i in 1:length(stimulate)){
        if(stimulate[i]>=standard){
                thisTrial <- thisTrial + 1
                magTrial
                if(i == length(stimulate)){
                        actiTrial <- append(actiTrial, thisTrial)
                }
        }else if(stimulate[i]<standard){
                actiTrial <- append(actiTrial, thisTrial)
                thisTrial <- 0
        }
}


actiTrial
actiTrial>1

sum(actiTrial[(which(actiTrial>1))])

actiDelay <- NULL

for(i in 1:length(stimulate)-1){
        if(stimulate[i]>standard && stimulate[i+1]>standard){
                actiDelay <- 5*(i-1)
                break
        }
}

a <- c(5,0,5,5,5,0,5,0,0,5,5,0,5)
b <- vector(mode = "character", length = 0L)


a <- append(a,0)
a <- append(a,0,after=0)
for(i in 1:length(a)){
        if(a[i] >3 && (a[i-1]>3 || a[i+1]>3)){
                b[i] <- "Y"
        }else{
                b[i] <- "X"
        }
}

a[-c(1,length(a))]
b[-c(1,length(b))]


library(slidify)

author("neuron_activation_calculator")
