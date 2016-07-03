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

library(ggplot2)

expData <- readLines(con="https://raw.githubusercontent.com/waterzhaojun/Neuron_activation_calculation/master/example.txt")

treat <- as.numeric(strsplit(expData[6], ",")[[1]])
if(length(treat)>9){
        treat <- treat[c(length(treat)-8):length(treat)]
}

stimulate <- as.numeric(strsplit(expData[8], ",")[[1]])

standard <- t.test(treat)$conf.int[2]

tmp <- vector(mode = "character", length = 0)
a <- append(stimulate,0)
a <- append(a,0,after=0)
for(i in 1:length(a)){
        if(a[i] >standard && (a[i-1]>standard || a[i+1]>standard)){
                tmp[i] <- "Y"
        }else{
                tmp[i] <- "N"
        }
}
tmp <- tmp[-c(1,length(tmp))]

df <- data.frame("tp"=c(paste("T", 1:length(treat), sep = ""), paste("R", 1:length(stimulate), sep = "")), "rate" = c(treat, stimulate))
df$tp <- factor(df$tp, levels = df$tp)
ggplot(data=df, aes(x=tp, y=rate)) + 
        geom_bar(stat = "identity") +
        geom_bar(stat = "identity", data = df[1:length(treat),], aes(x=tp, y=rate), fill="gray60") +
        geom_bar(stat = "identity", data = df[length(treat)+which(tmp=="Y"),], aes(x=tp, y=rate), fill="rosybrown") +
        labs(x="time point (T = treatment, R = response, bin=5 min)", y="neuron ongoing activity rate (Hz)") +
        ggtitle("Neuron ongoing activity changes by physiological stimulation") +
        theme(plot.title = element_text(face="bold", size=24))