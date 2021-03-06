tabItem(tabName = "dmr",

        fluidRow(
            column(8,  bsAlert("dmrmessage"),
                   bsCollapse(id = "collapseDmr", open = "DMR plots",
                              bsCollapsePanel("Probes info", dataTableOutput('probesSE'), style = "default"))),
            column(4,
                   box(title = "DMR analysis",width = NULL,
                       status = "danger",
                       solidHeader = FALSE, collapsible = FALSE,
                       box(title = "Data",width = NULL,
                           solidHeader = TRUE, collapsible = TRUE,
                           bsTooltip("dmrfile", "A summarized Experiment", "left"),
                           shinyFilesButton('dmrfile', 'Select data (.rda)', 'Please select SummarizedExperiment object',
                                            multiple = FALSE)),
                       #fileInput('dmrfile', 'Select SummarizedExperiment object',
                       #         accept=c(".rda"))),
                       box(title = "Parameters control",width = NULL,
                           solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                           sliderInput("dmrcores", "Cores",step=1,
                                       min = 1, max = parallel::detectCores(), value = 1),
                           selectizeInput('dmrPvalues',
                                          "Probes to calculate p-values?",
                                          choices = c("differential","all"),  multiple = FALSE),
                           bsTooltip("dmrPvalues",
                                     "All: calculete p-values for all probes (slower). Differential: calculate p-values for probes with a difference of mean DNA methylation higher than the threshold (faster)",
                                     "left"),
                           numericInput("dmrthrsld", "DNA methylation threshold",
                                        min = 0, max = 1, value = 0.1, step = 0.05),
                           numericInput("dmrpvalue", "P-value adj cut-off",
                                        min = 0, max = 1, value = 0.05, step = 0.001),

                           selectizeInput('dmrgroupCol',
                                          "Group column",
                                          choices = NULL,  multiple = FALSE),
                           selectizeInput('dmrgroups',
                                          "Groups",
                                          choices = NULL,  multiple = TRUE)),
                       actionButton("dmrAnalysis",
                                    "DMR analysis",
                                    style = "background-color: #000080;
                                    color: #FFFFFF;
                                    margin-left: auto;
                                    margin-right: auto;
                                    width: 100%",
                                    icon = icon("flask")),
                       bsTooltip("dmrAnalysis", "This might take from hours up to days", "left"))
            )
        )
)
