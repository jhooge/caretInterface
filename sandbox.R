modelLookupTable <- modelLookup()
models <- unique(modelLookupTable$model)
subset(availModels, model == "ada")
