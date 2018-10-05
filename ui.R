
library(foreign)
library(MASS)
library(shiny)
library(dplyr)
library(ggplot2)

cdata <- read.dta("https://stats.idre.ucla.edu/stat/data/crime.dta")


shinyUI(pageWithSidebar(  
  headerPanel("Crime analysis"),  
  sidebarPanel(    
    selectInput(inputId = 'StateChoice', label="Choose a state", choices = cdata$state, multiple=FALSE) ,
    selectInput(inputId = 'CrimeChoice', label="Choose an indicator", choices = names(cdata)[4:9], multiple=FALSE) ,
    sliderInput(inputId = 'PointSize', label = 'Select size in plot', value = 5, min = 1, max = 10, step = 1)), 
  
  mainPanel(    
    plotOutput('myPlot')
  )
))
