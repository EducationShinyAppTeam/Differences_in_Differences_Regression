# Load Packages ----
library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)
library(ggplot2)
library(boastUtils)
library(openxlsx)
library(shinyjs)
library(DT)
library(broom)
library(dplyr)
# Load additional dependencies and setup functions
# source("global.R")

# Define UI for App ----
ui <- list(
  ## Create the app page ----
  dashboardPage(
    skin = "blue",
    ### App header ----
    dashboardHeader(
      title = "Two-Period Diff-in-Diff",
      titleWidth = 250,
      tags$li(class = "dropdown", actionLink("info", icon("info"))),
      tags$li(
        class = "dropdown",
        boastUtils::surveyLink(name = "Differences_in_Differences_Regression")
      ),
      tags$li(
        class = "dropdown",
        tags$a(
          id = "home",
          href = 'https://shinyapps.science.psu.edu/',
          icon("house")
        )
      )
    ),
    ### Sidebar/left navigation menu ----
    dashboardSidebar(
      width = 250,
      sidebarMenu(
        id = "pages",
        menuItem("Overview", tabName = "overview", icon = icon("gauge-high")),
        menuItem("Prerequisites", tabName = "prerequisites", icon = icon("book")),
        menuItem("Explore Assumptions", tabName = "explore1", icon = icon("wpexplorer")),
        menuItem("Explore Interpretations", tabName = "explore2", icon = icon("wpexplorer")),
        menuItem("Challenge", tabName = "challenge", icon = icon("gears")),
        menuItem("References", tabName = "references", icon = icon("leanpub"))
      ),
      tags$div(
        class = "sidebar-logo",
        boastUtils::sidebarFooter()
      )
    ),
    ### Create the content ----
    dashboardBody(
      tabItems(
        ####Overview Page ----
        tabItem(
          tabName = "overview",
          h1("Two Period Difference-in-Difference Regression"),
          p("This app is designed to help students explore and understand 
          the core concepts, assumptions and interpretations of Two-Period Diff-in-Diff by experimenting
            with simulation and real life data."),
          h2("Instructions"),
          p("Explore the app based on the following instructions:"),
          tags$ol(
            tags$li("Review any prerequiste ideas using the Prerequistes tab."),
            tags$li("Explore the assumptions of the model using the Explore Assumptions Tab."),
            tags$li("Explore interpreting the model using the Explore Interpretations Tab."),
            tags$li("Test your understanding using the Challenge Tab.")
          ),
          ##### Go Button--location will depend on your goals
          div(
            style = "text-align: center;",
            bsButton(
              inputId = "go",
              label = "Prerequisites",
              icon = icon("book"),
              style = "default",
              size = "large"
            )
          ),
          ##### Create two lines of space
          br(),
          br(),
          h2("Acknowledgements"),
          p(
            "This version of the app was originally developed and 
            coded by Xin(Michael) Yun(2024), special thank you to Prof. Neil Hatfield, Prof. Dennis Pearl and Muzhi Liu. ",
            br(),
            br(),
            "Cite this app as:",
            br(),
            citeApp(),
            br(),
            br(),
            div(class = "updated", "Last Update: 12/09/2024 by XY.")
          )
        ),
        ####Prerequisites Page ----
        tabItem(
          tabName = "prerequisites",
          withMathJax(),
          h2("Prerequisites"),
          p("What is Two-Period Diff-in-Diff? ", 
            tags$a(
              href = "https://www.publichealth.columbia.edu/research/population-health-methods/difference-difference-estimation", 
              "Two-Period Difference-in-Difference", 
              class = "bodylinks"
            ), 
            " is a statistical method used to estimate causal effects by comparing changes in outcomes between a treatment group and a control group over two time periods: before and after the intervention. It accounts for time-invariant differences between the groups and isolates the impact of the intervention by assuming that, in the absence of treatment, both groups would follow parallel trends over time. This method is particularly useful when randomization is not feasible. Here we use linear regression as the estimation method to explore."
          ),
          
          # Box for Regression Model
          box(
            title = strong("Regression Model"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            
            # Wrap the entire content in withMathJax() to enable LaTeX rendering
            
            # Description of the Diff-in-Diff regression model
            p("The Diff-in-Diff regression model is used to estimate the causal effect of a treatment. The general form of the Diff-in-Diff regression is:"),
            
            # LaTeX equation rendered with \[ \] for block display
            p("\\[
Y_{it} = \\beta_0 + \\beta_1 t + \\beta_2 G_i + \\beta_3 (t \\times I_t \\times G_i) + \\epsilon_{it}
\\]"),
            
            # Explanation of the terms used in the regression equation
            p("Where:"),
            
            tags$ol(
              tags$li("\\(Y_{it}\\): Outcome for individual i at time t."),
              tags$li("\\(t\\): Continuous time variable."),
              tags$li("\\(G_i\\): Group indicator (1 for the treatment group, 0 for the control group)."),
              tags$li("\\(I_t\\): Time indicator (1 for the post-treatment period, 0 for the pre-treatment period)."),
              tags$li("\\(\\beta_0\\): Intercept."),
              tags$li("\\(\\beta_1\\): Coefficient for the time trend."),
              tags$li("\\(\\beta_2\\): Coefficient for the treatment group."),
              tags$li("\\(\\beta_3\\): Coefficient for the interaction term, which reflects the impact of the treatment on the treated group, controlling for time trends."),
              tags$li("\\(\\epsilon_{it}\\) represents the error term, capturing unobserved factors that may affect the outcome but are not included in the model.")
            ),
            p("\\(\\text{Estimator}\\): If the regression is true, the causal effect of the treatment
              is given by \\(\\beta_3\\), which is estimated by \\(\\hat{\\beta}_3\\) using an analysis appropriate for the sampling design.")
            
          ),
          
          
          
          box(
            title = strong("Causal Inference Concepts"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            tags$ol(
              tags$li(
                tags$strong("Correlation vs. Causation:"),
                p("Correlation indicates a relationship between two variables, but it does not mean one causes the other. Causation, however, implies that one event leads directly to another. Causal inference aims to establish this cause-and-effect relationship.")
              ),
              tags$li(
                tags$strong("Counterfactuals:"),
                p("Counterfactuals ask what would have happened if the treatment had not occurred. In causal inference, we try to estimate this unobserved outcome for individuals who were treated.")
              ),
              tags$li(
                tags$strong("Potential Outcomes Framework:"),
                p("This framework models two potential outcomes: one if the individual is treated and one if not treated. The causal effect is the difference between these two outcomes, but only one is observed, so we estimate the average effect under our model.")
              ),
              tags$li(
                tags$strong("Confounding Variables:"),
                p("Confounders influence both the treatment and the outcome, potentially biasing results. Accounting for confounders is critical for estimating the true causal effect.")
              ),
              tags$li(
                tags$strong("Assumptions for Causal Inference:"),
                p("Causal inference relies on assumptions like no unmeasured confounding, consistency (the observed outcome matches the potential outcome under treatment), and SUTVA (no interference between units).")
              ),
              tags$li(
                tags$strong("Estimation of Causal Effects:"),
                p("We estimate treatment effects such as the Average Treatment Effect (ATE) for the whole population or the Average Treatment Effect on the Treated (ATT) for those who actually received treatment. Heterogeneous effects capture variations across subgroups.")
              )
            )
          ),
          
          box(
            title = strong("Parallel Trends Assumption"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            tags$ol(
              tags$li("The Parallel Trends Assumption ensures that, 
                      in the absence of treatment, the average difference 
                      between the treatment and control groups remains constant over time."),
              
              tags$li(tags$strong("Testing the Assumption:"),
                      p("Visual inspection of a scatterplot of observations versus 
                      time color-coded by group is the most common method to test this 
                      assumption. If the treatment and control groups exhibit 
                        parallel trends in the pre-intervention period, this assumption
                        holds.Statistical tests can also be used to formally test for 
                        differences in pre-intervention trends.")),
              tags$li(tags$strong("If the assumption is violated:"),
                      p("The Difference-in-Difference (Diff-in-Diff) model may 
                        yield biased estimates of the treatment effect.")
              )
            )
            
          ),
          
          box(
            title = strong("Exchangeability Assumption"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            tags$ol(
              tags$li("Exchangeability of the error terms refers to the assumption that
            there are no systematic differences
              between the treatment and control groups (beyond the parallel
              trends assumption), other than the treatment itself. For example,
              this says that there is no confounding, such as what would occur
              with factors that affect both treatment group assignment and the
              outcome in the absence of treatment."),
              
              tags$li(tags$strong("Testing the Assumption:"),
                      p("Exchangeability is assumed to be satisfied 
                    through the design of the study.While it cannot be directly tested,
                    you can compare pre-treatment characteristics between 
                    the treatment and control groups to check for balance.")),
              tags$li(tags$strong("If the assumption is violated:"),
                      p("If exchangeability is violated, the estimated treatment 
                    effect may be biased, as there could be confounding
                    factors that affect both treatment assignment and the outcome.")
              )
            )
          ),
          
          box(
            title = strong("Additional Assumptions"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            p("In addition to the specific assumptions of the
              Two-Period Difference-in-Difference (Diff-in-Diff) model,
              other regression assumptions will also apply to Diff-in-Diff models
              as appropriate for the study design and the analysis method used
              for the linear regression."),
            p("These assumptions may include things like linearity, independence
              of errors, homoscedasticity, no multicollinearity, and normality of
              residuals. Ensuring these assumptions hold is crucial for the accuracy
              of your regression results."),
            p("In this app, we assume that these regression assumptions are held. 
   However, if you'd like to further explore and check these assumptions, 
   visit the", tags$a(
     href = "https://psu-eberly.shinyapps.io/Assumptions/", 
     "Regression Assumptions", 
     class = "bodylinks"
   ), "app.")
          )
        ),

   ####Explore Assumptions Page ----
   tabItem(
     tabName = "explore1",
     h2("Explore Assumptions"),
     p("This page allows you to explore key assumptions of a Two-Period
            Difference-in-Difference model, specifically focusing on the Parallel
            Trends assumption and Exchangeability Assumption. You can use the sliders
            to adjust the parameters. The graphs will automatically update to show how
            these changes influence the model's results, helping you understand whether
            the assumptions hold or are violated in different scenarios."),
     p(strong("Note:"), " The vertical black line represents the intervention time point. 
   The left part is pre-intervention, and the right part is post-intervention. 
   The red dashed line represents the Treatment Group, 
   while the blue solid line represents the Control Group."),
     
     # Main content for exploring assumptions
     fluidPage(
       tabsetPanel(
         id = "whichAssumption",
         type = "tabs",
         
         ##### Parallel Trends Assumption ----
         tabPanel(
           title = "Parallel Trends",
           br(),
           
           #Input column (left side)
           column(
             width = 4,
             wellPanel(
               tags$strong("Parallel Trends Assumption"),
               
               # Sliders for trend adjustment
               sliderInput(
                 inputId = "trend_control",
                 label = "Control Group Trend Slope (Pre Intervention):",
                 min = 0.5,
                 max = 3,
                 value = 1.5,
                 step = 0.1
               ),
               sliderInput(
                 inputId = "trend_treatment",
                 label = "Treatment Group Trend Slope (Pre Intervention):",
                 min = 0.5,
                 max = 3,
                 value = 1.5,
                 step = 0.1
               ),
               sliderInput(
                 inputId = "treatment_effect",
                 label = "Treatment Effect (Post Intervention):",
                 min = 0,
                 max = 5,
                 value = 2,
                 step = 0.5
               )
             )
           ),
           
           # Output column (right side)
           column(
             width = 8,
             plotOutput("didPlot", height = "400px"),
             br(),
             uiOutput('assumptionCheck')
           )
         ),
         ##### Exchangeability Assumption ----
         tabPanel(
           title = "Exchangeability",
           br(),
           
           # Input column (left side)
           column(
             width = 4,
             wellPanel(
               tags$strong("Exchangeability Assumption"),
               
               # Slider for initial outcome differences (baseline difference)
               sliderInput(
                 inputId = "initial_diff",
                 label = "Initial Outcome Difference Between Groups (Pre Intervention):",
                 min = -5,
                 max = 5,
                 value = 0,
                 step = 0.5
               ),
               
               # Slider for confounder effect (simulating trend difference)
               sliderInput(
                 inputId = "confounder",
                 label = "Impact of Confounding Variable on Treatment Group:",
                 min = 0,
                 max = 5,
                 value = 0,
                 step = 0.5
               )
             )
           ),
           
           # Output column (right side)
           column(
             width = 8,
             plotOutput("plotExchangeability", height = "400px"),
             br(),
             uiOutput("exchangeabilityCheck")
           )
         )
       )
     )
   ),
   
   ####Explore Interpretation Page ----
   tabItem(
     tabName = "explore2",
     h2("Explore Interpretations"),
     p("To start your Diff-in-Diff exploration, we will use data from 
    the paper \"If not now, when? Climate disaster and the Green vote 
    following the 2021 Germany floods\" by Susanna Garside and Haoyu Zhai. 
    This study examines the short-term electoral effects of the 2021 floods in Germany 
    on voter support for the Green Party, using a difference-in-difference (DID) design. 
    The treatment group here refers to areas affected by the floods or severe weather."),
     p("The interactive components in this page will help you understand how to 
    interpret the Diff-in-Diff model results. You can manipulate various aspects of 
    the model to see how different parameters impact the interpretation of the results."),
     p(strong("Note:"), " All numbers in this page are rounded to four decimal 
       places. If some values appear as 0, it indicates that their original values were 
       very close to zero but rounded to 0 after formatting."),
     sidebarLayout(
       sidebarPanel(
         p(strong("Variable Selections")),
         p("This Difference-in-Difference model estimates the effect 
           of flood exposure or severe weather on Green Party voting share."),
         selectInput(
           "treatment", 
           p(strong("Select Treatment Variable:")),
           choices = list("Flooded" = "flooded", "Severe Weather" = "severe"),
           selected = "flooded"
         ),
         checkboxGroupInput(
           "covariates", 
           p(strong("Select Covariates:")),
           choices = list(
             "Average Income" = "income_mean",
             "Unemployment Rate" = "unemployed_rate",
             "Population Density" = "pop_per_sqkm",
             "Proportion of Elderly Population" = "old_share",
             "Land Set Aside (%)" = "land_set_pct",
             "Agricultural Land (%)" = "land_agri_pct",
             "Distance to Environmental Feature" = "distance"
           ),
           selected = character(0)
         )
       ),
       mainPanel(
         p(strong("Interpretation of ATT:")),
         uiOutput("att_value"),
         br(),
         p(strong("Interpretation of p-value:")),
         uiOutput("interpretationText"),
         br(),
         DTOutput("model_summary_table")
       )
     )
   ),
   
       
   ####Challenge Page ----
   tabItem(
     tabName = "challenge",
     h2("Challenge"),
     p("Welcome to the Diff-in-Diff Challenge! This page allows you to test your knowledge of Diff-in-Diff models with multiple-choice questions."),
     p("Use these quizzes to deepen your understanding of the assumptions and interpretations in Diff-in-Diff analysis."),
     
     # Main content for Diff-in-Diff Challenge
     tabsetPanel(
       id = "challenge_tabs",
       type = "tabs",
       
       ###### Assumption Quiz -----
       tabPanel(
         title = "Assumptions",
         br(),
         # Question and choices for Assumption Quiz
         htmlOutput("assumption_questionText"),
         br(),
         uiOutput("assumption_choices"),
         br(),
         
         # Action buttons for Assumption Quiz
         
             bsButton(inputId = 'submitA', label = 'Check Answer', style = "default",
                      size = "large", disabled = FALSE),
             bsButton(inputId = 'nextA', label = 'Next', style = "default",
                      size = "large", disabled = FALSE),
             bsButton(inputId = 'clearA', label = 'Clear', style = "default",
                      size = "large", disabled = FALSE),
         
         
         # Feedback section with icons and text feedback for Assumption Quiz
         div(id = "assumption_feedbackSection",
             htmlOutput("assumption_challengeFeedback"),
             uiOutput("assumption_textFeedback")
         )
       ),
       
       #####Interpretation Quiz -----
       tabPanel(
         title = "Interpretations",
         br(),
         p("Scenario: A school district implemented a new reading program in 2021 aimed at improving students' reading scores. 
        The program was introduced in one city (treatment group) while a neighboring city, with similar demographics and 
        school funding, did not adopt the program (control group). Researchers gathered reading scores from 2019 to 2023 
        to evaluate the program's impact."),
         br(),
         # Question and choices for Interpretation Quiz
         htmlOutput("interpretation_questionText"),
         br(),
         uiOutput("interpretation_choices"),
         br(),
         
         # Action buttons for Interpretation Quiz
         
             bsButton(inputId = 'submitX', label = 'Check Answer', style = "default",
                      size = "large", disabled = FALSE),
             bsButton(inputId = 'nextX', label = 'Next', style = "default",
                      size = "large", disabled = FALSE),
             bsButton(inputId = 'clearX', label = 'Clear Answer', style = "default",
                      size = "large", disabled = FALSE),
         
         
         # Feedback section with icons and text feedback for Interpretation Quiz
         div(id = "interpretation_feedbackSection",
             htmlOutput("interpretation_challengeFeedback"),
             uiOutput("interpretation_textFeedback")
         )
       )
     )
   ),
   
   #### References Page ----
   tabItem(
     tabName = "references",
     h2("References"),
     
     p(
       class = "hangingindent",
       "Attali, D., & Edwards, T. (2024). shinyWidgets: Custom inputs widgets for shiny. (v0.8.7). [R package]. Available from https://CRAN.R-project.org/package=shinyWidgets"
     ),
     
     p(
       class = "hangingindent",
       "Bailey, E. (2022). shinyBS: Twitter bootstrap components for shiny. (v0.61.1). [R package]. Available from https://CRAN.R-project.org/package=shinyBS"
     ),
     
     p(
       class = "hangingindent",
       "Barrowman, N. (2014). Correlation, causation, and confusion. The New Atlantis, 43, 23–44. http://www.jstor.org/stable/43551404"
     ),
     
     p(
       class = "hangingindent",
       "Chang, W., & Borges Ribeiro, B. (2021). shinydashboard: Create dashboards with 'Shiny'. (v0.7.2). [R package]. Available from https://CRAN.R-project.org/package=shinydashboard"
     ),
     
     p(
       class = "hangingindent",
       "Chang, W., Cheng, J., Allaire, J., Xie, Y., & McPherson, J. (2024). shiny: Web application framework for R. (v1.9.1). [R package]. Available from https://CRAN.R-project.org/package=shiny"
     ),
     
     p(
       class = "hangingindent",
       "Columbia University Mailman School of Public Health. (n.d.). Difference-in-difference estimation. Columbia University. https://www.publichealth.columbia.edu/research/population-health-methods/difference-difference-estimation"
     ),
     
     p(
       class = "hangingindent",
       "Egami, N. (2024). Difference-in-Differences Design. POLS-GU4722: Statistical Theory and Causal Inference, Columbia University, Spring 2024."
     ),
     
     p(
       class = "hangingindent",
       "Garside, S., & Zhai, H. (2022). If not now, when? Climate disaster and the Green vote following the 2021 Germany floods. Research & Politics, 9(4). https://doi.org/10.1177/20531680221141523"
     ),
     
     p(
       class = "hangingindent",
       "Robinson, D., Hayes, A., & Couch, S. (2023). broom: Convert statistical analysis objects into tidy tibbles. (v1.0.5). [R package]. Available from https://CRAN.R-project.org/package=broom"
     ),
     
     p(
       class = "hangingindent",
       "Walker, A. (2023). openxlsx: Read, write and edit xlsx files. (v4.2.5). [R package]. Available from https://CRAN.R-project.org/package=openxlsx"
     ),
     
     p(
       class = "hangingindent",
       "Wickham, H. (2024). ggplot2: Elegant graphics for data analysis. Springer-Verlag New York. Available from https://CRAN.R-project.org/package=ggplot2"
     ),
     
     p(
       class = "hangingindent",
       "Wickham, H., François, R., Henry, L., & Müller, K. (2023). dplyr: A grammar of data manipulation. (v1.1.2). [R package]. Available from https://CRAN.R-project.org/package=dplyr"
     ),
     
     br(),
     br(),
     br(),
     boastUtils::copyrightInfo()
   )
      )
    )
  )
)

# Server code  ----
server <- function(input, output, session) {
  
  #### Info button ----
  observeEvent(input$info, {
    sendSweetAlert(
      session = session,
      type = "info",
      title = "Information",
      text = "This App helps you explore the assumptions and interpretations of the Diff-in-Diff model."
    )
  })
  
  #### Button to navigate to prerequisites page ----
  observeEvent(
    eventExpr = input$go,
    handlerExpr = {
      updateTabItems(
        session = session,
        inputId = "pages",
        selected = "prerequisites")
    })
  #### Parallel Trends Assumption ----
  # Generate data for Parallel Trends Assumption
  generate_data <- reactive({
    years <- 1959:1969
    intervention_year <- 1964
    
    control_pre <- 8
    treatment_pre <- 7
    
    control_slope <- input$trend_control
    treatment_slope <- input$trend_treatment
    treatment_effect <- input$treatment_effect
    
    treatment_slope_post <- ifelse(treatment_effect == 0, control_slope, treatment_slope + treatment_effect)
    
    control_values <- control_pre + control_slope * (years - min(years))
    treatment_values_pre <- treatment_pre + treatment_slope * (years[years <= intervention_year] - min(years))
    treatment_values_post <- treatment_pre + treatment_slope * (intervention_year - min(years)) +
      treatment_slope_post * (years[years > intervention_year] - intervention_year)
    
    treatment_values <- c(treatment_values_pre, treatment_values_post)
    
    data.frame(
      year = rep(years, 2),
      outcome = c(control_values, treatment_values),
      group = factor(rep(c("Control Group", "Treatment Group"), each = length(years)))
    )
  })
  
  # Render the DID plot
  output$didPlot <- renderPlot({
    data <- generate_data()
    intervention_year <- 1964
    
    ggplot(data, aes(x = year, y = outcome, color = group, linetype = group)) +
      geom_line(linewidth = 1.2) +
      geom_vline(aes(xintercept = intervention_year), color = "black", linetype = "solid", linewidth = 1.2) +
      labs(title = "Parallel Trends Assumption", x = "Year", y = "Outcome") +
      theme_minimal() +
      scale_color_manual(values = c("Control Group" = "blue", "Treatment Group" = "red")) +
      scale_linetype_manual(values = c("Control Group" = "solid", "Treatment Group" = "dashed")) +
      theme(
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 20, face = "bold"),
        axis.text = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 16, face = "bold"),
        plot.title = element_text(size = 22, face = "bold")
      )
  })
  
  # Assumption Check for Parallel Trends
  output$assumptionCheck <- renderUI({
    if (input$trend_control == input$trend_treatment) {
      p(
        "Assumption Satisfied: The control and treatment groups have parallel trends before the intervention, meaning the assumption holds.",
        style = "font-size:18px; font-weight:bold;"
      )
    } else {
      p(
        "Assumption Violated: The control and treatment groups do not follow parallel trends before the intervention, meaning the assumption is violated.",
        style = "font-size:18px; font-weight:bold;"
      )
    }
  })
  
  #### Exchangeability Assumption ----
  # Assumption Check for Exchangeability
  output$exchangeabilityCheck <- renderUI({
    if (input$confounder == 0) {
      p("Exchangeability Assumption holds: No systematic differences between treatment and control groups.",
        style = "font-size:18px; font-weight:bold;")
    } else {
      p("Exchangeability Assumption violated: Systematic differences between treatment and control groups exist. A confounding factor may explain the differences between outcomes, so Diff-in-Diff model has bias.",
        style = "font-size:18px; font-weight:bold;")
    }
  })
  
  # Generate data for Exchangeability Assumption
  generate_exchangeability_data <- reactive({
    years <- 1959:1969
    control_pre <- 8
    
    treatment_pre <- control_pre + input$initial_diff
    confounder_effect <- input$confounder
    
    control_slope <- 1
    treatment_slope <- 1 + confounder_effect
    
    control_values <- control_pre + control_slope * (years - min(years))
    treatment_values <- treatment_pre + treatment_slope * (years - min(years))
    
    data.frame(
      year = rep(years, 2),
      outcome = c(control_values, treatment_values),
      group = factor(rep(c("Control Group", "Treatment Group"), each = length(years)))
    )
  })
  
  output$plotExchangeability <- renderPlot({
  data <- generate_exchangeability_data()
  intervention_year <- max(data$year)
  
  # Add a slight offset to one group's outcome
  data <- data %>%
    mutate(outcome = if_else(group == "Treatment Group", outcome + 0.1, outcome))  # Add 0.01 to the treatment group
  
  ggplot(data, aes(x = year, y = outcome, color = group, linetype = group)) +
    geom_line(linewidth = 1.2) +
    geom_vline(aes(xintercept = intervention_year), color = "black", linetype = "solid", linewidth = 1.2) +
    labs(title = "Exchangeability Assumption", x = "Year", y = "Outcome") +
    theme_minimal() +
    scale_color_manual(values = c("Control Group" = "blue", "Treatment Group" = "red")) +
    scale_linetype_manual(values = c("Control Group" = "solid", "Treatment Group" = "dashed")) +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      legend.position = "bottom",
      legend.title = element_blank(),
      axis.title.x = element_text(size = 20, face = "bold"),
      axis.title.y = element_text(size = 20, face = "bold"),
      axis.text = element_text(size = 16, face = "bold"),
      legend.text = element_text(size = 16, face = "bold"),
      plot.title = element_text(size = 22, face = "bold")
    )
  })
  
  #### Chanllenge ----
  # Load the question banks
  assumption_questions <- read.csv("questionbank1.csv", stringsAsFactors = FALSE)
  interpretation_questions <- read.csv("questionbank2.csv", stringsAsFactors = FALSE)
  
  # Reactive values to track current questions and shuffled choices
  values_assumption <- reactiveValues(
    num = sample(1:nrow(assumption_questions), 1),
    shuffled_choices = NULL
  )
  values_interpretation <- reactiveValues(
    num = sample(1:nrow(interpretation_questions), 1),
    shuffled_choices = NULL
  )
  
  ##### Assumption Quiz -----
  
  # Reactive values to track current question and shuffled choices
  values_assumption <- reactiveValues(
    num = 1, # Start from the first question
    shuffled_choices = NULL
  )
  
  # Shuffle choices for the current question
  observeEvent(values_assumption$num, {
    current_question <- assumption_questions[values_assumption$num, ]
    choices <- c(
      current_question$choice_1,
      current_question$choice_2,
      current_question$choice_3
    )
    values_assumption$shuffled_choices <- sample(choices)  # Randomize the order
  })
  
  # Render question text
  output$assumption_questionText <- renderUI({
    req(values_assumption$num)
    p(assumption_questions$question_text[values_assumption$num])
  })
  
  # Render randomized choices
  output$assumption_choices <- renderUI({
    req(values_assumption$shuffled_choices)
    radioButtons(
      inputId = "assumption_choice",
      label = "Choose an answer:",
      choices = values_assumption$shuffled_choices,
      selected = character(0), # Ensure no selection initially
      width = "100%"
    )
  })
  
  # Handle "Check Answer" button
  observeEvent(input$submitA, {
    req(input$assumption_choice)
    
    # Clear existing feedback
    output$assumption_challengeFeedback <- renderUI({ NULL })
    output$assumption_textFeedback <- renderUI({ NULL })
    shinyjs::hide("assumption_feedbackSection")  # Hide feedback first
    
    # Show new feedback
    current_question <- assumption_questions[values_assumption$num, ]
    correct_choice <- current_question[[current_question$correct_answer]]
    
    if (input$assumption_choice == correct_choice) {
      output$assumption_challengeFeedback <- boastUtils::renderIcon(
        icon = "correct", width = 36
      )
      output$assumption_textFeedback <- renderUI({
        div(current_question$correct_feedback)
      })
    } else {
      output$assumption_challengeFeedback <- boastUtils::renderIcon(
        icon = "incorrect", width = 36
      )
      output$assumption_textFeedback <- renderUI({
        div(current_question$incorrect_feedback)
      })
    }
    shinyjs::show("assumption_feedbackSection")  # Show feedback
  })
  
  # Handle "Next" button
  observeEvent(input$nextA, {
    # Clear the feedback explicitly
    output$assumption_challengeFeedback <- renderUI({ NULL })
    output$assumption_textFeedback <- renderUI({ NULL })
    
    shinyjs::hide("assumption_feedbackSection")  # Hide feedback
    
    # Cycle through questions sequentially
    if (values_assumption$num < nrow(assumption_questions)) {
      values_assumption$num <- values_assumption$num + 1  # Move to next question
    } else {
      values_assumption$num <- 1  # Reset to first question after the last one
    }
    
    updateRadioButtons(session, "assumption_choice", selected = character(0))  # Reset selection
  })
  
  # Handle "Clear Answer" button
  observeEvent(input$clearA, {
    # Clear the feedback explicitly
    output$assumption_challengeFeedback <- renderUI({ NULL })
    output$assumption_textFeedback <- renderUI({ NULL })
    
    shinyjs::hide("assumption_feedbackSection")  # Hide feedback
    updateRadioButtons(session, "assumption_choice", selected = character(0))  # Reset selection
  })
  
  ##### Interpretation Quiz -----
  
  # Reactive values to track current question and shuffled choices
  values_interpretation <- reactiveValues(
    num = 1, # Start from the first question
    shuffled_choices = NULL
  )
  
  # Shuffle choices for the current question
  observeEvent(values_interpretation$num, {
    current_question <- interpretation_questions[values_interpretation$num, ]
    choices <- c(
      current_question$choice_1,
      current_question$choice_2,
      current_question$choice_3
    )
    values_interpretation$shuffled_choices <- sample(choices)  # Randomize the order
  })
  
  # Render question text
  output$interpretation_questionText <- renderUI({
    req(values_interpretation$num)
    p(interpretation_questions$question_text[values_interpretation$num])
  })
  
  # Render randomized choices
  output$interpretation_choices <- renderUI({
    req(values_interpretation$shuffled_choices)
    radioButtons(
      inputId = "interpretation_choice",
      label = "Choose an answer:",
      choices = values_interpretation$shuffled_choices,
      selected = character(0), # Ensure no selection initially
      width = "100%"
    )
  })
  
  # Handle "Check Answer" button
  observeEvent(input$submitX, {
    req(input$interpretation_choice)  # Ensure a choice is selected
    
    # Clear existing feedback
    output$interpretation_challengeFeedback <- renderUI({ NULL })
    output$interpretation_textFeedback <- renderUI({ NULL })
    
    shinyjs::delay(50, {  # Slight delay to visually ensure feedback clearing
      current_question <- interpretation_questions[values_interpretation$num, ]
      correct_choice <- current_question[[current_question$correct_answer]]
      
      if (input$interpretation_choice == correct_choice) {
        output$interpretation_challengeFeedback <- boastUtils::renderIcon(
          icon = "correct", width = 36
        )
        output$interpretation_textFeedback <- renderUI({
          div(current_question$correct_feedback)
        })
      } else {
        output$interpretation_challengeFeedback <- boastUtils::renderIcon(
          icon = "incorrect", width = 36
        )
        output$interpretation_textFeedback <- renderUI({
          div(current_question$incorrect_feedback)
        })
      }
      shinyjs::show("interpretation_feedbackSection")  # Show feedback
    })
  })
  
  # Handle "Next" button
  observeEvent(input$nextX, {
    # Clear the feedback explicitly
    output$interpretation_challengeFeedback <- renderUI({ NULL })
    output$interpretation_textFeedback <- renderUI({ NULL })
    
    shinyjs::hide("interpretation_feedbackSection")  # Hide feedback
    
    # Cycle through questions sequentially
    if (values_interpretation$num < nrow(interpretation_questions)) {
      values_interpretation$num <- values_interpretation$num + 1  # Move to next question
    } else {
      values_interpretation$num <- 1  # Reset to first question after the last one
    }
    
    updateRadioButtons(session, "interpretation_choice", selected = character(0))  # Reset selection
  })
  
  # Handle "Clear Answer" button
  observeEvent(input$clearX, {
    # Clear the feedback explicitly
    output$interpretation_challengeFeedback <- renderUI({ NULL })
    output$interpretation_textFeedback <- renderUI({ NULL })
    
    shinyjs::hide("interpretation_feedbackSection")  # Hide feedback
    updateRadioButtons(session, "interpretation_choice", selected = character(0))  # Reset selection
  })
  
#### Interpretation ----
  # Load the dataset
  data_vote_main <- read.csv("cleaned_data.csv")
  
  # Observe changes in treatment and covariates to calculate ATT
  observeEvent(c(input$treatment, input$covariates), {
    treatment_var <- input$treatment
    
    # Prepare formula for the regression model
    base_formula <- as.formula(paste(
      "v_green_pct ~", treatment_var, "* time"
    ))
    
    # Add selected covariates to the model formula
    if (!is.null(input$covariates) && length(input$covariates) > 0) {
      covariate_formula <- paste(input$covariates, collapse = " + ")
      full_formula <- as.formula(paste(deparse(base_formula), "+", covariate_formula))
    } else {
      full_formula <- base_formula
    }
    
    # Fit the DiD model with the selected treatment and covariates
    model <- lm(full_formula, data = data_vote_main)
    
    # Extract the ATT estimate (interaction term of treatment and time)
    model_summary <- tidy(model)
    interaction_term <- paste(treatment_var, "time", sep = ":")
    
    # Check if the interaction term exists in the model summary
    if (interaction_term %in% model_summary$term) {
      att <- model_summary %>%
        filter(term == interaction_term) %>%
        pull(estimate)
      
      # Extract p-value for the ATT
      p_value <- model_summary %>%
        filter(term == interaction_term) %>%
        pull(p.value)
    } else {
      att <- NA
      p_value <- NA
    }
    
    # Interpretation of ATT
    output$att_value <- renderText({
      if (!is.na(att)) {
        att_percentage <- round(att * 100, 2)
        paste(
          "ATT (Average Treatment Effect on the Treated):", att_percentage, 
          "%. This means that areas exposed to the treatment (e.g., being flooded or severe weather) experienced an average increase",
          "of", att_percentage, "percentage points in Green Party vote share compared to areas not exposed to the treatment,",
          "after accounting for pre-treatment differences, time trends and the selected covariates."
        )
      } else {
        "ATT not available due to missing interaction term."
      }
    })
    
    # interpretation of p value
    output$interpretationText <- renderUI({
      if (!is.na(p_value) && p_value < 0.05) {
        interpretation <- paste("The ATT is statistically significant (p-value:", round(p_value, 4) ,  " ) after adjusting for the selected covariates.",
                                "This indicates that the selected treatment (", treatment_var, ") is associated with an increase in Green Party vote share.",
                                "An ATT of", round(att * 100, 2), "% suggests that municipalities exposed to", treatment_var,
                                "experienced a", round(att * 100, 2), "percentage point increase in vote share for the Green Party compared to those that were not exposed.")
      } else if (!is.na(p_value)) {
        interpretation <- paste("The ATT is not statistically significant (p-value:", round(p_value, 4), "),",
                                "indicating that the null model of no effect on Green Party vote share is a reasonable explanation of the data.")
      } else {
        interpretation <- "ATT and p-value not available due to missing interaction term."
      }
      div(interpretation)
    })
    
    # Render the model summary table
    output$model_summary_table <- renderDT({
      if (!exists("model_summary") || is.null(model_summary)) {
        return(NULL)
      }
      
      # Round numeric columns to 4 decimal places
      model_summary_rounded <- model_summary %>%
        mutate(across(where(is.numeric), ~ round(.x, 4)))
      
      # Rename terms for display
      model_summary_displayed <- model_summary_rounded %>%
        mutate(term = case_when(
          term == "(Intercept)" ~ "Intercept",
          term == "flooded" ~ "Flooded (Treatment)",
          term == "severe" ~ "Severe Weather (Treatment)",
          term == "time" ~ "Time (Post-Treatment Period)",
          term == "income_mean" ~ "Average Income",
          term == "unemployed_rate" ~ "Unemployment Rate",
          term == "pop_per_sqkm" ~ "Population Density",
          term == "old_share" ~ "Proportion of Elderly Population",
          term == "land_set_pct" ~ "Land Set Aside (%)",
          term == "land_agri_pct" ~ "Agricultural Land (%)",
          term == "distance" ~ "Distance to Environmental Feature",
          term == "flooded:time" ~ "Flooded x Time (Interaction)",
          term == "severe:time" ~ "Severe Weather x Time (Interaction)",
          TRUE ~ term # Default: leave unchanged
        ))
      
      # Render the datatable
      datatable(
        model_summary_displayed,
        caption = "Model Summary Table",
        style = "bootstrap4",
        rownames = FALSE,
        options = list(
          responsive = TRUE,
          scrollX = TRUE,
          columnDefs = list(
            list(className = 'dt-center', targets = 0:(ncol(model_summary_rounded) - 1))
          )
        )
      )
    })
  })
  
  # Display the dataset in a table format
  output$data_table <- renderDT({
    datatable(
      data_vote_main,
      caption = "Dataset Preview",
      style = "bootstrap4",
      rownames = FALSE,
      options = list(
        responsive = TRUE,
        scrollX = TRUE,
        columnDefs = list(
          list(className = 'dt-center', targets = 0:(ncol(data_vote_main) - 1))
        )
      )
    )
  })
}


# Run the application using boastApp ----
boastUtils::boastApp(ui = ui, server = server)