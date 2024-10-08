# Load Packages ----
library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)
library(boastUtils)
library(ggplot2)


# Load additional dependencies and setup functions
# source("global.R")

# Define UI for App ----
ui <- list(
  ## Create the app page ----
  dashboardPage(
    skin = "blue",
    ### Create the app header ----
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
    ### Create the sidebar/left navigation menu ----
    dashboardSidebar(
      width = 250,
      sidebarMenu(
        id = "pages",
        menuItem("Overview", tabName = "overview", icon = icon("gauge-high")),
        menuItem("Prerequisites", tabName = "prerequisites", icon = icon("book")),
        menuItem("Explore Assumptions", tabName = "explore1", icon = icon("wpexplorer")),
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
        #### Set up the Overview Page ----
        tabItem(
          tabName = "overview",
          withMathJax(),
          h1("Two Period Differences-in-Differences Regression"),
          p("This app is designed to help students explore and understand the
            core concepts, assumptions of Two-Period Diff-in-Diff by experimenting
            with simulation."),
          h2("Instructions"),
          p("Explore the app based on the following instructions:"),
          tags$ol(
            tags$li("Review any prerequiste ideas using the Prerequistes tab."),
            tags$li("Explore the assumptions by the Explore Assumptions Tab.")
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
            "This version of the app was originally developed and coded by Xin(Michael) Yun(2024).",
            br(),
            br(),
            "Cite this app as:",
            br(),
            citeApp(),
            br(),
            br(),
            div(class = "updated", "Last Update: 10/07/2024 by XY.")
          )
        ),
        #### Set up the Prerequisites Page ----
        tabItem(
          tabName = "prerequisites",
          withMathJax(),
          h2("Prerequisites"),
          p("What is Two-Period Diff-in-Diff ? Two-Period Diff-in-Diff (",
            a(href = 'https://www.publichealth.columbia.edu/research/population-health-methods/difference-difference-estimation',
            "Two-Period Difference-in-Difference", class = 'bodylinks'),
            ") is a statistical method used to estimate causal effects by comparing
            changes in outcomes between a treatment group and a control group over
            two time periods: before and after the intervention. It accounts for
            time-invariant differences between the groups and isolates the impact
            of the intervention by assuming that, in the absence of treatment,
            both groups would follow parallel trends over time. This method is
            particularly useful when randomization is not feasible. Here we use
            linear regression as the estimation method to explore."),
          br(),
          # Box for Regression Model
          box(
            title = strong("Regression Model"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            p("The Diff-in-Diff regression model is used to estimate the causal effect of a treatment. The general form of the Diff-in-Diff regression is:"),
            HTML("<p>\\[
          {Y}_{it} = \\hat{\\beta}_0 + \\hat{\\beta}_1 t + \\hat{\\beta}_2 G_i + \\hat{\\beta}_3 (t \\times I_t \\times G_i)
          \\]</p>"),
            p("Where:"),
            HTML("
    <ul>
            <li><strong>\\(\\hat{Y}_{it}\\)</strong>: Estimated outcome for individual i at time t.</li>
            <li><strong>t</strong>: Continuous time variable.</li>
            <li><strong>\\(G_i\\)</strong>: Group indicator (1 for the treatment group, 0 for the control group).</li>
            <li><strong>\\(I_t\\)</strong>: Time indicator (1 for the post-treatment period, 0 for the pre-treatment period).</li>
            <li><strong>\\(\\hat{\\beta}_0\\)</strong>: Estimated intercept.</li>
            <li><strong>\\(\\hat{\\beta}_1\\)</strong>: Estimated coefficient for the time trend.</li>
            <li><strong>\\(\\hat{\\beta}_2\\)</strong>: Estimated coefficient for the treatment group.</li>
            <li><strong>\\(\\hat{\\beta}_3\\)</strong>: Estimated coefficient for the interaction term, which reflects the impact of the treatment on the treated group, controlling for time trends.</li>
          </ul>
  ")
          ),

          box(
            title = strong("Causal Inference Concepts"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            HTML("<strong>1. Correlation vs. Causation:</strong>
        <p>Correlation indicates a relationship between two variables, but it does not mean one causes the other. Causation, however, implies that one event leads directly to another. Causal inference aims to establish this cause-and-effect relationship.</p>

        <strong>2. Counterfactuals:</strong>
        <p>Counterfactuals ask what would have happened if the treatment had not occurred. In causal inference, we try to estimate the unobserved outcome for individuals who were treated.</p>

        <strong>3. Potential Outcomes Framework:</strong>
        <p>This framework models two potential outcomes: one if the individual is treated and one if not treated. The causal effect is the difference between these two outcomes, but only one is observed, so we estimate the average effect.</p>

        <strong>4. Confounding Variables:</strong>
        <p>Confounders influence both the treatment and the outcome, potentially biasing results. Accounting for confounders is critical for estimating the true causal effect.</p>

        <strong>5. Assumptions for Causal Inference:</strong>
        <p>Causal inference relies on assumptions like no unmeasured confounding, consistency (the observed outcome matches the potential outcome under treatment), and SUTVA (no interference between units).</p>

        <strong>6. Estimation of Causal Effects:</strong>
        <p>We estimate treatment effects such as the Average Treatment Effect (ATE) for the whole population or the Average Treatment Effect on the Treated (ATT) for those who actually received treatment. Heterogeneous effects capture variations across subgroups.
                 </p>")
          ),



          box(
            title = strong("Parallel Trends Assumption"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            p("The Parallel Trends Assumption ensures that, in the absence of treatment, the average difference between the treatment and control groups remains constant over time."),

            p("Testing the Assumption:"),
            p("Visual inspection is the most common method to test the assumption. If the treatment and control groups exhibit parallel trends in the pre-intervention period, this assumption holds."),

            p("Statistical tests can also be used to formally test for differences in pre-intervention trends."),

            p("If the assumption is violated:"),
            p("The Difference-in-Difference (Diff-in-Diff) model may yield biased estimates of the treatment effect.")

          ),



          box(
            title = strong("Exchangeability Assumption"),
            status = "primary",
            collapsible = TRUE,
            collapsed = TRUE,
            width = '100%',
            p("Exchangeability of the error terms refers to the assumption that
            there are no systematic differences
              between the treatment and control groups (beyond the parallel
              trends assumption), other than the treatment itself. For example,
              this says that there is no confounding, such as what would occur
              with factors that affect both treatment group assignment and the
              outcome in the absence of treatment."),

            p("Testing the Assumption:"),
            p("Exchangeability is assumed to be satisfied through the design of the study.While it cannot be directly tested,
            you can compare pre-treatment characteristics between the treatment and control groups to check for balance. "),

            p("If the assumption is violated:"),
            p("If exchangeability is violated, the estimated treatment effect may be biased, as there could be confounding
       factors that affect both treatment assignment and the outcome. ")
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
            p(HTML("In this app, we assume that these regression assumptions are held.
            However, if you'd like to further explore and check these assumptions,
            visit the <a href='https://psu-eberly.shinyapps.io/Assumptions/' class='
            bodylinks'>Regression Assumptions</a> app."))
          )
        ),


        #### Note: you must have at least one of the following pages. You might
        #### have more than one type and/or more than one of the same type. This
        #### will be up to you and the goals for your app.
        #### Set up an Explore 1 Page ----
        tabItem(
          tabName = "explore1",
          withMathJax(),

          h2("Explore Assumptions"),
          p("This page allows you to explore key assumptions of a Two-Period
            Difference-in-Difference model, specifically focusing on the Parallel
            Trends assumption and Exchangeability Assumption. You can use the sliders
            to adjust the parameters. The graphs will automatically update to show how
            these changes influence the model's results, helping you understand whether
            the assumptions hold or are violated in different scenarios. "),
          br(),

          # Main content for exploring assumptions
          fluidPage(
            tabsetPanel(
              id = "whichAssumption",
              type = "tabs",

              ##### Parallel Trends Assumption ----
              tabPanel(
                title = "Parallel Trends",
                br(),

                # Input column (left side) ----
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

                # Output column (right side) ----
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

                # Input column (left side) ----
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

                # Output column (right side) ----
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
        #### Set up the References Page ----
        tabItem(
          tabName = "references",
          withMathJax(),
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
            "Wickham, H. (2024). ggplot2: Elegant graphics for data analysis. Springer-Verlag New York. Available from https://CRAN.R-project.org/package=ggplot2"
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

# Define server logic
server <- function(input, output, session) {

  # Info button logic
  observeEvent(input$info, {
    sendSweetAlert(
      session = session,
      type = "info",
      title = "Information",
      text = "This App helps you explore different assumptions using the Diff-in-Diff model."
    )
  })

  ####button###
  observeEvent(
    eventExpr = input$go,
    handlerExpr = {
      updateTabItems(
        session = session,
        inputId = "pages",
        selected = "prerequisites")
    })

  # Generate data for Parallel Trends Assumption
  generate_data <- reactive({
    years <- 1959:1969  # Simulated years
    intervention_year <- 1964  # The year of intervention

    control_pre <- 8  # Baseline for control group
    treatment_pre <- 7  # Baseline for treatment group

    control_slope <- input$trend_control  # Control group trend slope
    treatment_slope <- input$trend_treatment  # Treatment group trend slope
    treatment_effect <- input$treatment_effect  # Treatment effect applied after intervention year

    # Post-intervention treatment slope
    if (treatment_effect == 0) {
      treatment_slope_post <- control_slope  # If treatment effect is 0, post-intervention slope is the same as control group
    } else {
      treatment_slope_post <- treatment_slope + treatment_effect  # If treatment effect is non-zero, slope changes
    }

    # Create data for control group (before and after intervention)
    control_values <- control_pre + control_slope * (years - min(years))

    # Create data for treatment group (before and after intervention)
    treatment_values_pre <- treatment_pre + treatment_slope * (years[years <= intervention_year] - min(years))
    treatment_values_post <- treatment_pre + treatment_slope * (intervention_year - min(years)) +
      treatment_slope_post * (years[years > intervention_year] - intervention_year)

    # Combine pre and post treatment values
    treatment_values <- c(treatment_values_pre, treatment_values_post)

    # Combine all data into a data frame
    data.frame(
      year = rep(years, 2),
      outcome = c(control_values, treatment_values),
      group = factor(rep(c("Control Group", "Treatment Group"), each = length(years)))
    )
  })

  # Render the DID plot ----
  output$didPlot <- renderPlot({
    data <- generate_data()
    intervention_year <- 1964  # The year of intervention

    # Plot using ggplot2
    ggplot(data, aes(x = year, y = outcome, color = group)) +
      geom_line(size = 1.2) +
      geom_vline(aes(xintercept = intervention_year, linetype = "Intervention"), color = "black", size = 1) +
      labs(title = "Parallel Trends Assumption", x = "Year", y = "Outcome", linetype = "") +
      theme_minimal() +

      # Customize the color for Control and Treatment groups
      scale_color_manual(values = c("Control Group" = "blue", "Treatment Group" = "red")) +

      # Include the intervention line in the legend
      scale_linetype_manual(values = c("Intervention" = "solid")) +

      # Make all text elements bold and increase size
      theme(
        axis.text.x = element_blank(),  # Hide x-axis numbers
        axis.ticks.x = element_blank(),  # Hide x-axis ticks
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_text(size = 20, face = "bold"),
        axis.title.y = element_text(size = 20, face = "bold"),
        axis.text = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 16, face = "bold"),
        plot.title = element_text(size = 22, face = "bold")
      )
  })

  # Assumption Check for Parallel Trends
  output$assumptionCheck <- renderUI({
    if (input$trend_control == input$trend_treatment) {
      HTML("<p style='font-size:18px; font-weight:bold;'>Assumption Satisfied: The control and treatment groups have parallel trends before the intervention, meaning the assumption holds.</p>")
    } else {
      HTML("<p style='font-size:18px; font-weight:bold;'>Assumption Violated: The control and treatment groups do not follow parallel trends before the intervention, meaning the assumption is violated.</p>")
    }
  })

  # Assumption Check for Exchangeability
  output$exchangeabilityCheck <- renderUI({
    if (input$confounder == 0) {
      HTML("<p style='font-size:18px; font-weight:bold;'>Exchangeability Assumption holds: No systematic differences between treatment and control groups.</p>")
    } else {
      HTML("<p style='font-size:18px; font-weight:bold;'>Exchangeability Assumption violated: Systematic differences between treatment and control groups exist.
           A confounding factor may explain the differences between outcomes, so Diff-in-Diff model has bias.</p>")
    }
  })

  # Generate data for Exchangeability Assumption
  generate_exchangeability_data <- reactive({
    years <- 1959:1969
    control_pre <- 8  # Baseline for control group

    # Apply user's input for initial difference and confounding effect
    treatment_pre <- control_pre + input$initial_diff
    confounder_effect <- input$confounder

    # Control group has constant slope
    control_slope <- 1

    # Treatment group has an adjusted slope due to the confounder
    treatment_slope <- 1 + confounder_effect

    # Create data for control group
    control_values <- control_pre + control_slope * (years - min(years))

    # Create data for treatment group with bias from confounder
    treatment_values <- treatment_pre + treatment_slope * (years - min(years))

    # Combine all data into a data frame
    data.frame(
      year = rep(years, 2),
      outcome = c(control_values, treatment_values),
      group = factor(rep(c("Control Group", "Treatment Group"), each = length(years)))
    )
  })

  # Plot for Exchangeability Assumption (Line Plot)
  output$plotExchangeability <- renderPlot({
    data <- generate_exchangeability_data()
    intervention_year <- max(data$year)  # The intervention year is set to the last year

    ggplot(data, aes(x = year, y = outcome, color = group)) +
      geom_line(size = 1.2) +  # Using line plot to show trends

      # Add the vertical line at the far right representing intervention, and give it a label in the legend
      geom_vline(aes(xintercept = intervention_year, linetype = "Intervention"), color = "black", size = 1) +

      # Set the labels for title, x, and y axes
      labs(title = "Exchangeability Assumption", x = "Year", y = "Outcome", linetype = "") +
      theme_minimal() +

      # Customize the color for Control and Treatment groups
      scale_color_manual(values = c("Control Group" = "blue", "Treatment Group" = "red")) +

      # Include the intervention line in the legend
      scale_linetype_manual(values = c("Intervention" = "solid")) +

      # Remove x-axis numeric labels and ticks
      theme(
        axis.text.x = element_blank(),  # Hide x-axis text (numbers)
        axis.ticks.x = element_blank(),  # Hide x-axis ticks
        legend.position = "bottom",
        legend.title = element_blank(),

        # Make all text elements bold and increase size
        axis.title.x = element_text(size = 20, face = "bold"),
        axis.title.y = element_text(size = 20, face = "bold"),
        axis.text = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 16, face = "bold"),
        plot.title = element_text(size = 22, face = "bold")
      )
  })


}


# Run the application using boastApp ----
boastUtils::boastApp(ui = ui, server = server)
