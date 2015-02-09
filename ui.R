library(doMC)
library(caret)

## Takes caret's model lookup table
## Returns mapping of model and method argument name
# getModelMapping <- function(modelLookupTable) {
#   modelsInfo <- sapply(unique(modelLookupTable$model), getModelInfo)
#   metArgName  <- c()
#   model <- c()
#   for (name in names(modelsInfo)) {
#     subnames <- names(modelsInfo[[name]])
#     for (subname in subnames){
#       metArgName <- c(names, subname)
#       model <- c(labels, modelsInfo[[name]][[subname]]$label)
#     }
#   }
#   models <- data.frame(model=model, metArgName=metArgName)
#   models$model <- as.character(models$model)
#   models$metArgName <- as.character(models$metArgName)
#   modls <- unique(models)
#   return(models)
# }
# modelMapping <- getModelMapping(modelLookup()

load("RData/modelMapping.RData")

shinyUI(fluidPage(
  titlePanel("Shiny Caret Interface"),
  sidebarLayout(
    sidebarPanel(
      selectInput("model", label="Model", 
                  choices=c(modelMapping$metArgName),
                  selected=modelMapping$metArgName[1]),
      h3(textOutput("modelName")),
      hr(),
      sliderInput("cores", "Number of Cores", 1, detectCores(), 1, step = 1),
      hr(),
      uiOutput("chooseParams")
      ),
    mainPanel(
      tableOutput("parameters")
      )
    )
  )
)