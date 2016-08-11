library( shiny )
library( markdown )

source( "tabPanels.R", local=TRUE )

shinyUI( 
  navbarPage( "Harvesting Peregrine Falcon Populations", 
              theme = "bootstrap.css", 
              tabPanel( title = "Introduction", 
                        withMathJax(), 
                        includeHTML( "introduction.html" ), 
                        value = "tP0", 
                        icon = icon( name = "book", 
                                     lib = "font-awesome" ) ), 
              tabPanel( title = "Model", 
                        tP1, 
                        value = "tP1", 
                        icon = icon( name = "cog", 
                                     lib = "font-awesome" ) ), # end tabPanel "tP1" 
              tabPanel( title = "Questions", 
                        withMathJax(), 
                        includeHTML( "questions.html" ), 
                        value = "tP2", 
                        icon = icon( name = "question", 
                                     lib = "font-awesome" ) ), 
              id = "panels", 
              footer = div( br(), 
                            img( src="R-UN_L4c_tag_4c.png" ), 
                            tags$a( href = "http://snr.unl.edu/", "Brought to you by the School of Natural Resources" ) 
              ) 
  ) # end navbarPage
) # end shinyUI

