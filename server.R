library(shiny)
library(ggplot2)
shinyServer(
        function(input, output){
                
                # this part get data from the file and store it in recordData.
                recordData <- reactive({
                        fileload <- input$file
                        if(is.null(fileload)){return()} # this if is very important
                        readLines(con = fileload$datapath) #con has to be a path, not file itself
                })
                #-------------------------------------------------------------------------------------------------------------------------------
                
                # this part seperate data to several variables. Most of function here should use eventReactive as we want it update after we upload the file.
                # otherwise it only return NA.
                
                # expDate store the experiment date.
                expDate <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        as.Date(recordData()[2], "%m-%d-%Y")
                })
                
                # extract baseline from recordData and store in baseline.
                baseline <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        as.numeric(strsplit(recordData()[4], ",")[[1]])
                })
                
                # extract treatment period neuron ongoing activity rate data from recordData and store in treat.
                treat <- eventReactive(input$submit, {
                        tmp <- as.numeric(strsplit(recordData()[6], ",")[[1]])
                        if(length(tmp)>9){tmp <- tmp[c(length(tmp)-8):length(tmp)]}
                        return(tmp)
                })
                
                # extract the stimulation response period neuron ongoing activity rate data from recordData and store in stimulate.
                stimulate <- eventReactive(input$submit, {
                        as.numeric(strsplit(recordData()[8], ",")[[1]])
                })
                
                # the response period's each time bin can be considered as activated ("Y") or not activated ("N") based on our standard.
                # only the continously 2 bins above our standard are considered activation.
                # We store the response period marks in actiTrial.
                actiTrial <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        # actiTrial is the vector to record each bin either activated or not
                        tmp <- vector(mode = "character", length = 0)
                        a <- append(stimulate(),0)
                        a <- append(a,0,after=0)
                        for(i in 1:length(a)){
                                if(a[i] >standard() && (a[i-1]>standard() || a[i+1]>standard())){
                                        tmp[i] <- "Y"
                                }else{
                                        tmp[i] <- "N"
                                }
                        }
                        return(tmp[-c(1,length(tmp))])
                })
                
                # the duration of activation in response period. 0 means no activation.
                actiDuration <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        5*sum(actiTrial()=="Y")
                })
                
                # whether this neuron get activated.
                actiWhe <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        if(actiDuration()>9){
                                return("Y")
                        }else{
                                return("N")
                        }
                })
                
                # the magnitude of neuron activation. 
                actiMag <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        mean(stimulate()[which(actiTrial()=="Y")])/mean(treat())
                })
                
                # neuron activation delay. if no activation, actiDelay should be NA
                actiDelay <- eventReactive(input$submit, {
                        if(is.null(recordData)){return()}
                        5*(which(actiTrial() == "Y")[1]-1)
                })
                
                # drug name
                drugName <- renderText({
                        if(input$drugName == ""){
                                return("drug")
                        }else{
                                return(input$drugName)
                        }
                })
                #----------------------------------------------------------------------------------------------------------------------------
                
                
                # this part set the different web variables
                standard <- renderText({
                        if(input$standard == 1){
                                return(t.test(treat())$conf.int[2])
                        }else if(input$standard == 2){
                                return(mean(treat())+2*sd(treat()))
                        }else if(input$standard == 3){
                                return(mean(treat())+sd(treat()))
                        }else{
                                return()
                        }
                })
                #-----------------------------------------------------------------------------------------------------------------------------
                
                # this part set the output.
                output$date <- renderText({
                        if(is.null(expDate())){return()}
                        paste("Experiment date:", expDate(), sep=" ")
                })
                output$baseline <- renderText({
                        if(is.null(baseline())){return()}
                        paste("Neuron ongoing activity baseline: ", round(mean(baseline()), 2), "Hz", sep = "")
                })
                output$treat <- renderText({
                        if(is.null(treat())){return()}
                        paste(sprintf("Neuron ongoing activity after %s %s %s administration: ",input$drugConcentration, drugName(), input$treatMeth), round(mean(treat()),2), "Hz", sep = "")
                })
                output$csdPlot <- renderPlot({
                        if(is.null(treat())||(is.null(stimulate()))){return()}
                        tmp <- data.frame("tp"=c(paste("T", 1:length(treat()), sep = ""), paste("R", 1:length(stimulate()), sep = "")), "rate" = c(treat(), stimulate()))
                        tmp$tp <- factor(tmp$tp, levels = tmp$tp)
                        ggplot(data=tmp, aes(x=tp, y=rate)) + 
                                geom_bar(stat = "identity") +
                                geom_bar(stat = "identity", data = tmp[1:length(treat()),], aes(x=tp, y=rate), fill="gray60") +
                                geom_bar(stat = "identity", data = tmp[length(treat())+which(actiTrial()=="Y"),], aes(x=tp, y=rate), fill="rosybrown") +
                                labs(x="time point (T = treatment, R = response, bin=5 min)", y="neuron ongoing activity rate (Hz)") +
                                ggtitle("Neuron ongoing activity changes by physiological stimulation") +
                                theme(plot.title = element_text(face="bold", size=24))
                })
                output$csdAna <- renderText({
                        if(is.null(recordData())){return()}
                        x <- vector(mode = "character", length = 0)
                         
                        x <- append(x, sprintf("After %s treatmend, the ongoing activity rate is %g%% of baseline.",drugName(), 100*mean(treat())/mean(baseline())))

                        
                        if(actiWhe() == "N"){ # ifduration less than 10, no activation, stop calculation.
                                x <- append(x, "There is no continously 2 bins above the activation standard. This neuron is not activated.")
                        }else if(actiWhe() == "Y"){
                                x <- append(x, sprintf("This neuron is activated for %g min with %g min delay. The average magnitude is %g%%.", 
                                                       actiDuration(), actiDelay(), 100*actiMag()))
                        }
                        

                        
                        return(x)
                })
                #----------------------------------------------------------------------------------------------------------------------------
                
                # this is a test outlet.
#                 output$standard <- renderText({
#                         actiWhe()
#                  })
        }
)