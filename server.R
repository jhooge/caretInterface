library(shiny)
library(caret)
library(doMC)

load("RData/modelMapping.RData")

testOutput <- function(input, output) {
  
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header = input$header,
             sep = input$sep, quote = input$quote)
  })
  

  output$modelName <- renderText({
    model <- getModelInfo(input$model)
    name <- modelMapping$model[modelMapping$metArgName == input$model]
    return(name[1])
  })
  
  output$chooseParams <- renderUI({
    
    model <- getModelInfo(modelMapping$metArgName[1])
    model <- getModelInfo(input$model)
    parameters <- model[[input$model]]$parameters
    
    isNumeric  <- parameters$class == "numeric"
    numParams  <- subset(parameters, isNumeric)
    textParams <- subset(parameters, !isNumeric)
    
    inputs <- list()
    if(nrow(numParams) != 0) {
      for (i in 1:nrow(numParams)) {
        inputs <- list(inputs, numericInput(inputId = as.character(numParams$parameter)[i],
                                            label = as.character(numParams$label)[i],
                                            value = 0))
      }
    }
    if(nrow(textParams) != 0) {
      for (i in 1:nrow(textParams)) {
        inputs <- list(inputs, textInput(inputId = as.character(textParams$parameter)[i],
                                         label = as.character(textParams$label)[i],
                                         value = ""))
      }
    }
    return(inputs)
  })
}
  
shinyServer(function(input, output) {
  output <- testOutput(input, output)
#     output <- classificationOutput(input, output)
})