## app.R ##

library(shiny)
library(ggplot2)
library(quantmod)

# UI
ui <- fluidPage(
  
  # App title
  titlePanel("Precios de acciones de Oracle, AMD, IBM y Nvidia"),
  
  # Diseño de barra lateral con definiciones de entrada y salida
  sidebarLayout(
    
    # Panel de inputs
    sidebarPanel(
      
      # Agrega un campo de entrada para seleccionar la fecha
      dateInput( "fecha_inicial", 
                 label = "Selecciona una fecha de inicio:", 
                 value = Sys.Date() - 365 ),
      
      dateInput( "fecha_final", 
                 label = "Selecciona una fecha de fin:", 
                 value = Sys.Date() - 1 ),
      
      downloadButton('download_Data',"Descarga Datos")
      
    ),
    
    # Main panel, donde se mostrarán los resultdos
    mainPanel(
      
      # Output: Gráfica de precios
      plotOutput( outputId = "grafico" )
      
    )
  )
)

#

# SERVER
server <- function(input, output) {
  #
  tickers <- c("ORCL","AMD","IBM","NVDA")
  #
  observe({
    #
    getSymbols(tickers, src = "yahoo", from = input$fecha_inicial, 
               to = input$fecha_final, periodicity = "daily")
    #
    ORCL_DF <- as.data.frame( ORCL ) # Convertimos a Data Frame
    ORCL_DF$Date <- as.Date( rownames(ORCL_DF) ) # Generamos la fecha
    ORCL_DF <- ORCL_DF[ , c('Date', 'ORCL.Adjusted')] # Seleccionamos 2 variables
    #
    AMD_DF <- as.data.frame( AMD ) # Convertimos a Data Frame
    AMD_DF$Date <- as.Date( rownames(AMD_DF) ) # Generamos la fecha
    AMD_DF <- AMD_DF[ , c('Date', 'AMD.Adjusted')] # Seleccionamos 2 variables
    #
    IBM_DF <- as.data.frame( IBM ) # Convertimos a Data Frame
    IBM_DF$Date <- as.Date( rownames(IBM_DF) ) # Generamos la fecha
    IBM_DF <- IBM_DF[ , c('Date', 'IBM.Adjusted')] # Seleccionamos 2 variables
    #
    NVDA_DF <- as.data.frame( NVDA ) # Convertimos a Data Frame
    NVDA_DF$Date <- as.Date( rownames(NVDA_DF) ) # Generamos la fecha
    NVDA_DF <- NVDA_DF[ , c('Date', 'NVDA.Adjusted')] # Seleccionamos 2 variables
    # 
    # Combina y conserva todas las filas de ambos DataFrames
    DF_FINAL <- merge(ORCL_DF, AMD_DF, by = "Date", all = TRUE) 
    DF_FINAL <- merge(DF_FINAL, IBM_DF, by = "Date", all = TRUE) 
    DF_FINAL <- merge(DF_FINAL, NVDA_DF, by = "Date", all = TRUE) 
    # Creamos índices
    DF_FINAL_Index <- data.frame( DF_FINAL$Date,
                                  ORCL = ( DF_FINAL$ORCL.Adjusted / DF_FINAL$ORCL.Adjusted[1] ) * 100,
                                  AMD = ( DF_FINAL$AMD.Adjusted / DF_FINAL$AMD.Adjusted[1] ) * 100,
                                  IBM = ( DF_FINAL$IBM.Adjusted / DF_FINAL$IBM.Adjusted[1] ) * 100,
                                  NVDA = ( DF_FINAL$NVDA.Adjusted / DF_FINAL$NVDA.Adjusted[1] ) * 100 )
    #
    names(DF_FINAL_Index) <- c("Date","ORCL","AMD","IBM","NVDA") # Nombres nuevos
    #
    # Descarga
    Data <- reactive(DF_FINAL_Index)
    
    output$download_Data <- downloadHandler(
      filename = function(){"Data.csv"}, 
      content = function(fname){ write.csv(Data(), fname) } )
    #
    output$grafico <- renderPlot({
      # Gráfico de líneas para las series ORCL, AMD, IBM y NVDA
      ggplot( DF_FINAL_Index, aes( x = Date ) ) +
        geom_line(aes(y = ORCL, color = "ORCL"), linewidth = 1) +
        geom_line(aes(y = AMD, color = "AMD"), linewidth = 1) +
        geom_line(aes(y = IBM, color = "IBM"), linewidth = 1) +
        geom_line(aes(y = NVDA, color = "NVDA"), linewidth = 1) +
        labs( title = "Gráfico de los indices de Oracle, AMD, IBM y Nvidia",
              x = "Fecha", y = "Índice (Valor inicial = 100)") +
        scale_color_manual(name = "Series", 
                           values = c(ORCL = "blue", AMD = "green", IBM = "red", NVDA = "purple")) +
        theme_minimal()
    })
  })
}

#

shinyApp(ui = ui, server = server)
