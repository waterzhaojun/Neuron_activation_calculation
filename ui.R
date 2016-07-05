
shinyUI(fluidPage(
        
        title = "Neuron Activation Calculator",
        fluidRow(
                column(12,
                       style = "vertical-align:middle; height:50px; color: #ffffff; font-size:30px; background-color: DarkSlateGray;",
                       "Neuron activation calculator"
                ),
                column(12,
                       style = "margin-top: 10px;",
                       "This calculator is a small tool developed based on our research project of measuring the trigeminal neuron responses to CSD
                       stimulation. In each experiment neuron ongoing activity rate of 3 periods are saved in a txt file. The periods baseline (B), 
                        treatment (T), response (R) represent neuron's natual activity level, neuron's activity level after drug treatment, neuron's 
                        activity level after cortical spreading depression stimulation respectively. Each period has a series of time bins (bin=5min).
                        We use mean() function to measure B and T period neuron level, then compare R to T to check whether it is activated or not 
                        basing on 95% confidence interval. Only 2 continuous bins higher than standard is considered as activation. More technical details can be found at ",
                       tags$a(href="http://jn.physiology.org/content/113/7/2778.abstract", "here."),
                       tags$br(),
                       tags$br(),
                       "A txt file example can be download at ", 
                       tags$a(href="https://raw.githubusercontent.com/waterzhaojun/Neuron_activation_calculation/master/example.txt", "here."),
                        "You need to upload the txt file then click \"Calculate\" to get the result. Drug's name, concentration and administration method are not necessary
                       but recommended. The standard for measuring neuron activation is default to confidence interval with two times and one time 
                       standard deviation as options."
                        
                )
                
        ),
        
        fluidRow(
                column(4,
                       h4("Experiment information"),
                       hr(),
                       fileInput(inputId = 'file', label = "input your file"),
                       actionButton("submit", "Calculate")
                ),
                column(4, 
                       h4("Analyze parameter"),
                       hr(),
                       radioButtons("standard", label = "Standard measure method", choices = c("95% confidence interval"=1,"2 times standard deviation"=2, "1 times standard deviation"=3), selected = 1)
                ),
                column(4, 
                       h4("Drug information"),
                       hr(),
                       textInput(inputId="drugName", label = "drug name: "),
                       textInput(inputId="drugConcentration", label = "drug concentration: "),
                       textInput(inputId="treatMeth", label = "administration method: ")
                )
        ),
        
        fluidRow(
                column(12,
                       hr()
                )
        ),
        
        fluidRow(
                column(12,
                       style = "background-color: Gainsboro;",
                       plotOutput("csdPlot"),
                       textOutput("date"),
                       textOutput("baseline"),
                       textOutput("treat"),
                       textOutput("csdAna"),
                       textOutput("standard")
                )
        ),
        
        fluidRow(
                column(12,
                       hr()
                )
        ),
        
        fluidRow(
                column(12,
                       style = "text-align: center;",
                       "Created by Jun Zhao, Jun.2016"
                )
        )
        
        

))

