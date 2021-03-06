tabItem(tabName = "elmeranalysis",
        fluidRow(
            column(8,  bsAlert("elmermessage"),
                   bsCollapse(id = "collapelmer", open = "Enhancer Linking by Methylation/Expression Relationship (ELMER) ",
                              bsCollapsePanel("Enhancer Linking by Methylation/Expression Relationship (ELMER) ",  includeHTML("elmer.html"), style = "default"))
            ),
            column(4,
                   box(title = "Analysis", width = NULL,
                       status = "danger",
                       solidHeader = FALSE, collapsible = TRUE,collapsed = FALSE,
                       box(title = "Data", width = NULL,
                           solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                           box(title = "Create mee object", width = NULL,
                               solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                               shinyFilesButton('elmermetfile', 'Select DNA methylation object', 'Please select DNA methylation object',
                                                multiple = FALSE),
                               bsTooltip("elmermetfile", "An R object (.rda) with a summarized experiment of DNA methylation from HM450K platform for multiple samples",
                                         "left"),
                               tags$br(),
                               tags$br(),
                               shinyFilesButton('elmerexpfile', 'Select expression object', 'Please select gene expression object',
                                                multiple = FALSE),
                               bsTooltip("elmermetfile", "An R object (.rda) with a gene expression object for multiple samples",
                                         "left"),
                               tags$hr(),
                               selectizeInput('elmermeetype',
                                              "Group column",
                                              choices=NULL,
                                              multiple = FALSE),
                               selectizeInput('elmermeesubtype',
                                              "Experiment group",
                                              choices=NULL,
                                              multiple = FALSE),
                               selectizeInput('elmermeesubtype2',
                                              "Control group",
                                              choices=NULL,
                                              multiple = FALSE),
                               tags$hr(),
                               bsTooltip("elmermetnacut", " By default, for the DNA methylation data
                                         will remove probes with NA values in more than 20% samples and
                                         remove the anottation data.",
                                         "left"),
                               numericInput("elmermetnacut", "DNA methylation: Cut-off NA samples (%)",
                                            min = 0, max = 1, value = 0.2, step = 0.1),
                               textInput("meesavefilename", "Save as:", value = "mee.rda", width = NULL, placeholder = NULL),
                               actionButton("elmerpreparemee",
                                            "Create mee object",
                                            style = "background-color: #000080;
                                            color: #FFFFFF;
                                            margin-left: auto;
                                            margin-right: auto;
                                            width: 100%",
                                            icon = icon("floppy-o"))
                           ),
                           box(title = "Select mee object", width = NULL,
                               solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                               shinyFilesButton('elmermeefile', 'Select mee', 'Please select mee object',
                                                multiple = FALSE)
                           )),
                       box(title = "Analysis parameters", width = NULL,
                           solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                           box(title = "Differently methylated probes", width = NULL,
                               solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                               checkboxInput("elmerhyperdir", "Hypermethylation direction ?", value = TRUE, width = NULL),
                               bsTooltip("elmerhyperdir", "Select hypermethylated probes in experiment vs control",
                                         "left"),
                               checkboxInput("elmerhypodir", "Hypomethylation direction ?", value = TRUE, width = NULL),
                               bsTooltip("elmerhypodir", "Select hypomethylataded probes in experiment vs control",
                                         "left"),
                               numericInput("elmermetdiff", " DNA methylation difference cutoff",
                                            min = 0, max = 1, value = 0.3, step = 0.05),
                               numericInput("elmermetpercentage", " percentage",
                                            min = 0, max = 1, value = 0.2, step = 0.01),
                               numericInput("elmermetpvalue", " pvalue",
                                            min = 0, max = 1, value = 0.01, step = 0.01)
                           ),
                           box(title = "Predict enhancer-gene linkages", width = NULL,
                               solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                               numericInput("elmergetpairNumGenes", " Nearby genes",
                                            min = 1, max = 100, value = 20, step = 1),
                               numericInput("elmergetpairpercentage", " percentage",
                                            min = 0, max = 1, value = 0.2, step = 0.01),
                               numericInput("elmergetpairpermu", " Number of permutations",
                                            min = 0, max = 10000, value = 10000, step = 1000),
                               numericInput("elmergetpairpvalue", "Pvalue",
                                            min = 0, max = 1, value = 0.01, step = 0.01),
                               numericInput("elmergetpairportion", "Portion",
                                            min = 0, max = 1, value = 0.3, step = 0.1),
                               checkboxInput("elmergetpairdiffExp", "Apply t-test", value = FALSE, width = NULL)
                           ),
                           box(title = "Get enriched motif", width = NULL,
                               solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                               numericInput("elmergetenrichedmotifMinIncidence", "Minimum incidence",
                                            min = 0, max = 100, value = 10, step = 1),
                               numericInput("elmergetenrichedmotifLoweOR", "Lower boundary",
                                            min = 0, max = 5, value = 1.1, step = 0.1)
                           ),
                           box(title = "Identify regulatory TFs", width = NULL,
                               solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                               numericInput("elmergetTFpercentage", "Percentage",
                                            min = 0, max = 1, value = 0.2, step = 0.01)
                           )),
                       box(title = "Other options", width = NULL,
                           solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                           sliderInput("elmercores", "Cores", step=1,
                                       min = 1, max = parallel::detectCores(), value = 1),
                           textInput("elmerresultssavefolder", "Name of the results folder:", value = "results_elmer", width = NULL, placeholder = NULL)
                       ),
                       actionButton("elmerAnalysisBt",
                                    "Run analysis",
                                    style = "background-color: #000080;
                                    color: #FFFFFF;
                                    margin-left: auto;
                                    margin-right: auto;
                                    width: 100%",
                                    icon = icon("flask")))
            )
        )
)
