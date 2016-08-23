## Create tabpanel objects here
## they should be named tP<i> where <i> is the
## index of the order they are created.

tP1 <- fluidPage( # start "Model" fluidpage
  sidebarLayout(
    sidebarPanel(
      sliderInput( inputId = "b", 
                   label = "Indicate the proportion of 2-year-old birds that breed:", 
                   min = 0, 
                   max = 1, 
                   value = 1, 
                   sep = "" ), 
      sliderInput( inputId = "h", 
                   label = "Indicate the proportion of nestling harvest:", 
                   min = 0, 
                   max = 20, 
                   value = 5, 
                   step = 0.01, 
                   sep = "", 
                   post = "%" ), 
      sliderInput( inputId = "yrProj", 
                   label = "Indicate the year to which you would like to project the population:", 
                   min = 1980, 
                   max = as.numeric( format( Sys.Date(), "%Y" ) ), 
                   value = 2002, 
                   step = 1, 
                   sep = "" ), 
      fluidRow(
        column( width = 7,
                numericInput( inputId = "n0", 
                              label = "Enter the number of falcon pairs in 1980:", 
                              value = 20, 
                              min = 1, 
                              max = 50, 
                              step = 1 ) ) )
    ),
    mainPanel( 
      h4( textOutput( outputId = "l" ) ), 
      plotOutput( outputId = "popPlot" ), 
      plotOutput( outputId = "hPlot" )
    )
  )
) # end "Model" fluidpage
