## app.R ##

# ******************************************************************************
# Shiny es un paquete de R que facilita la creación de aplicaciones web (web Apps) 
# interactivas directamente desde R. 
# En esta sección conversaremos las bases para crear aplicaciones Shiny.
# ******************************************************************************
# 
# ******************************************************************************
# ESTRUCTURA DE UNA SHINY APP
#
# Las Shiny App, regularmente, deben estar contenidas en un único script 
# llamado "app.R"
# El script app.R se debe ubicar en un directorio (por ejemplo, newdir/)
# 
# Un app.R tiene tres componentes:
# 1. Un objeto de interfaz de usuario: "ui" -- controla el diseño y la apariencia
# 2. Una función de servidor: "server" -- contiene el código y funciones
# 3. Una llamada a la función shinyApp crea objetos de aplicación Shiny
# ******************************************************************************

# Definimos una App que consulte y grafique precios de acciones

# ******************************************************************************

#install.packages("shiny")
#install.packages("ggplot2")
#install.packages("quantmod")

library(shiny)
library(ggplot2)
library(quantmod)

# UI
ui <- fluidPage(
  
  # App title
  titlePanel("Precios de acciones de Oracle, AMD, IBM y Nvidia"),
  
  # Otros elementos
  
)

#

# SERVER
server <- function(input, output) {
  #
  # Código, llamadas a APIs y otras operaciones
}

#

shinyApp(ui = ui, server = server)
