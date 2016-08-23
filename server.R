library( shiny )
library( popbio )
library( ggplot2 )

shinyServer( 
  function( input, output, session){
    
    bioParams <- list( f = 1.66059, # nestlings fledged per pair
                       r = 0.5, # proportion of female nestlings
                       s0 = 0.5439949, # survival of nestlings to age 1
                       s1 = 0.6697616, # survival of 1-year-old birds
                       s2 = 0.8002913 ) # survival of birds ≥2 years old
    
    popProj <- reactive( {
      
      bioParams$b <- input$b # proportion of 2-year-old birds that breed
      bioParams$h <- input$h / 100 # proportion of nestlings permitted to be taken
      
      ppm <- matrix( data = 0, 
                     nrow = 3, 
                     ncol = 3 )
      
      ppm[ 1, 2 ] <- bioParams$b * bioParams$s1 * bioParams$r * bioParams$f * ( 1 - bioParams$h ) # harvest-adjusted fecundity of 2-year-old birds
      ppm[ 1, 3 ] <- bioParams$s2 * bioParams$r * bioParams$f * ( 1 - bioParams$h ) # harvest-adjusted fecundity of ≥3-year-old birds
      
      ppm[ 2, 1 ] <- bioParams$s0 # survival of age class 1 birds
      ppm[ 3, 2 ] <- bioParams$s1 # survival of age class 2 birds
      ppm[ 3, 3 ] <- bioParams$s2 # survival of age class 3+ birds
      
      popParams <- list( l = lambda( ppm ) )
      popParams$N <- matrix( data = 0, nrow = 3, ncol = input$yrProj - 1979 )
      popParams$N[ , 1 ] <- c( 0, input$n0, input$n0 ) # initial population vector assumes the adult birds are evenly distributed between 2nd and 3rd age classes
      
      popParams$Htot <- data.frame( Year = 1980:input$yrProj, 
                                    Harvest = 0 )
      
      for( i in 2:ncol( popParams$N ) ){
        popParams$N[ , i ] <- ppm %*% popParams$N[ , i - 1 ]
        popParams$Htot$Harvest[ i ] <- ( ( ( ppm[ 1, 2 ] * popParams$N[ 2, i - 1 ] ) + ( ppm[ 1, 3 ] * popParams$N[ 3, i - 1 ] ) ) * bioParams$h ) / ( 1 - bioParams$h )
      }

      popParams$Ntot <- data.frame( Year = 1980:input$yrProj, 
                                    Population = colSums( popParams$N ) )
      
      popParams
      
      }
    )
    
    output$l <- renderText( {
      paste( "The predicted rate of population growth (λ) is ",
             round( popProj()$l, digits = 3 ),
             ".",
             sep = "" )
    })
    
    output$popPlot <- renderPlot( {
      ggplot( data = popProj()$Ntot, 
              aes( x = Year, 
                   y = Population ) ) + 
        geom_line( size = 1.5, 
                   colour = "mediumseagreen", 
                   lineend = "round" ) + 
        theme_classic() + 
        theme( axis.title = element_text( size = 16 ), 
               axis.text = element_text( size = 14 ) ) + 
        scale_x_continuous( name = "Year" ) + 
        scale_y_continuous( name = "Population size", 
                            limits = c( 0, 1.2 * max( popProj()$Ntot$Population ) ) )
    })
    
    output$hPlot <- renderPlot( { 
      ggplot( data = popProj()$Htot, 
              aes( x = Year, 
                   y = Harvest ) ) + 
        geom_line( size = 1.5, 
                   colour = "tomato2", 
                   lineend = "round" ) + 
        theme_classic() + 
        theme( axis.title = element_text( size = 16 ), 
               axis.text = element_text( size = 14 ) ) + 
        scale_x_continuous( name = "Year" ) + 
        scale_y_continuous( name = "Number of fledglings harvested", 
                            limits = c( 0, 1.2 * max( popProj()$Htot$Harvest ) ) )
        
      })
    
  }
)
