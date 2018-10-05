
library(foreign)
library(MASS)
library(shiny)
library(dplyr)
library(ggplot2)

cdata <- read.dta("https://stats.idre.ucla.edu/stat/data/crime.dta")


shinyServer(  
  function(input, output) {    
    output$myPlot <- renderPlot({      
      
      SC <- filter(cdata, state == input$StateChoice)
      ggplot(data = cdata,aes(crime, get(input$CrimeChoice) )) + geom_point() + geom_point(data = SC,colour = "red", size=input$PointSize)
      
      
    })

    }
)