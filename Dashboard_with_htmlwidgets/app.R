library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dygraphs)

### ~~~~~ui~~~~~ #####
ui <- dashboardPage(
  dashboardHeader(title = 'htmlwidgets'),
  
  ### +++Sidebar--- #####
  dashboardSidebar(
    sidebarMenu(
      menuItem('DataTables', tabName = 'DataTables'),
      menuItem('Plotly', tabName = 'Plotly'),
      menuItem('Dygraph', tabName = 'Dygraph')
    )
  ),
  
  ### +++Body--- #####
  dashboardBody(
    tabItems(
      ### DataTables #####
      tabItem(tabName = 'DataTables', 
        fluidRow(
          box(title = 'Table CSS Classes', status = 'primary', solidHeader = T,
            radioButtons('DT_css_class', NULL,
              choices = list('display' = 'display',
                             'stripe' = 'stripe',
                             'hover' = 'hover',
                             'row-border' = 'row-border',
                             'order-column' = 'order-column')
            )
          ),
          box(title = 'options', status = 'primary', solidHeader = T,
            checkboxInput('DT_caption', 'caption'),
            checkboxInput('DT_filter', 'filter'),
            textOutput('DT_selected_row')
          )
        ),
        dataTableOutput('DT')
      ),
      ### Plotly #####
      tabItem(tabName = 'Plotly',
        tabsetPanel(
          tabPanel(title = 'base',
            plotlyOutput('plotly_base')
          ),
          tabPanel(title = 'with_ggplot',
                   plotlyOutput('plotly_with_ggplot')
          )
        )
      ),
      ### Dygraph #####
      tabItem(tabName = 'Dygraph',
        dygraphOutput('Dygraph')
      )
    )
  )
)

### ~~~~~server~~~~~ #####
server <- function(input, output) {
  ### tab_DataTables #####
  output$DT <- renderDataTable(
    datatable(iris, 
              class = input$DT_css_class, 
              caption = 'This is caption'[input$DT_caption], 
              filter = if(input$DT_filter) 'top' else 'none')
  )
  
  output$DT_selected_row <- renderText(
    paste('selected :', paste(input$DT_rows_selected, collapse = ' '))
  )
  ### tab_Plotly #####
  output$plotly_base <- renderPlotly({
    iris %>% plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species)
  })
  
  output$plotly_with_ggplot <- renderPlotly({
    p <- iris %>% ggplot(aes(Sepal.Length, Sepal.Width, color = Species)) +
      geom_point() 
    ggplotly(p)
  })
  ### Dygraph #####
  output$Dygraph <- renderDygraph({
    dygraph(AirPassengers) %>% dyRangeSelector()
  })
}

shinyApp(ui, server)