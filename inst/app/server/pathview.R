
#----------------------------------------------
#                 DEA Pathview
pathway.data <- function(){
    inFile <- input$pathewayexpfile
    if (is.null(inFile)) return(NULL)
    file  <- as.character(parseFilePaths(get.volumes(isolate({input$workingDir})), input$pathewayexpfile)$datapath)
    if(tools::file_ext(file)=="csv"){
        se <- read_csv(file)
    } else if(tools::file_ext(file)=="rda"){
        se <- get(load(file))
    }

    return(se)
}
output$deaSE <- renderDataTable({
    data <- pathway.data()
    if(!is.null(data)) as.data.frame(data)
},
options = list(pageLength = 10,
               scrollX = TRUE,
               jQueryUI = TRUE,
               pagingType = "full",
               lengthMenu = list(c(10, 20, -1), c('10', '20', 'All')),
               language.emptyTable = "No results found",
               "dom" = 'T<"clear">lfrtip',
               "oTableTools" = list(
                   "sSelectedClass" = "selected",
                   "sRowSelect" = "os",
                   "sSwfPath" = paste0("//cdn.datatables.net/tabletools/2.2.4/swf/copy_csv_xls.swf"),
                   "aButtons" = list(
                       list("sExtends" = "collection",
                            "sButtonText" = "Save",
                            "aButtons" = c("csv","xls")
                       )
                   )
               )
), callback = "function(table) {table.on('click.dt', 'tr', function() {Shiny.onInputChange('allRows',table.rows('.selected').data().toArray());});}"
)

observe({
    shinyFileChoose(input, 'pathewayexpfile',
                    roots=get.volumes(input$workingDir),
                    session=session,
                    restrictions=system.file(package='base'))
})
observeEvent(input$pathwaygraphBt , {
    closeAlert(session,"deaAlert")
    data <- pathway.data()
    if(is.null(data)) {
        createAlert(session, "deamessage", "deaAlert", title = "Data error", style =  "danger",
                    content = "Please upload results", append = FALSE)
        return(NULL)
    }
    pathway.id <- isolate({input$pathway.id})
    kegg.native <- isolate({input$kegg.native.checkbt})

    if("mRNA" %in% colnames(data)) {
        gene <- strsplit(data$mRNA,"\\|")
    } else {
        gene <- rownames(data)
    }
    data$SYMBOL <- unlist(lapply(gene,function(x) x[1]))

    # Converting Gene symbol to geneID
    library(clusterProfiler)
    eg = as.data.frame(bitr(data$SYMBOL,
                            fromType="SYMBOL",
                            toType="ENTREZID",
                            OrgDb="org.Hs.eg.db"))
    eg <- eg[!duplicated(eg$SYMBOL),]

    data <- merge(data,eg,by="SYMBOL")

    data <- subset(data, select = c("ENTREZID", "logFC"))
    genelistDEGs <- as.numeric(data$logFC)
    names(genelistDEGs) <- data$ENTREZID

    withProgress(message = 'Creating pathway graph',
                 detail = 'This may take a while...', value = 0, {
                     # pathway.id: hsa05214 is the glioma pathway
                     # limit: sets the limit for gene expression legend and color
                     hsa05214 <- pathview(gene.data  = genelistDEGs,
                                          pathway.id = pathway.id,
                                          species    = "hsa",
                                          kegg.native = kegg.native,
                                          limit      = list(gene=as.integer(max(abs(genelistDEGs)))))
                     incProgress(1, detail = paste("Done"))
                 })
    getPath <- parseDirPath(get.volumes(isolate({input$workingDir})), input$workingDir)
    if (length(getPath) == 0) getPath <- paste0(Sys.getenv("HOME"),"/TCGAbiolinksGUI")

    if(kegg.native) {
        extension <- ".pathview.png"
    } else {
        extension <- ".pathview.pdf"
    }
    fname <- paste0(pathway.id,extension)
    TCGAbiolinks:::move(fname,file.path(getPath,fname))

    createAlert(session, "deamessage", "deaAlert", title = "Pathway graph created", style =  "success",
                content = paste0("Results saved in: ", file.path(getPath,fname)), append = FALSE)
})

observeEvent(input$pathwaygraphBt , {
    updateCollapse(session, "collapsedea", open = "Pathview plot")
    output$pathviewPlot <- renderUI({
        plotOutput("pathviewImage", height = input$pathwaygraphheigth)
    })})

observeEvent(input$pathwaygraphBt , {
    output$pathviewImage <- renderImage({
        getPath <- parseDirPath(get.volumes(isolate({input$workingDir})), input$workingDir)
        if (length(getPath) == 0) getPath <- paste0(Sys.getenv("HOME"),"/TCGAbiolinksGUI")
        pathway.id <- isolate({input$pathway.id})
        extension <- ".pathview.png"
        outfile <- file.path(getPath, paste0(pathway.id,extension))

        if(!isolate({input$kegg.native.checkbt})){
            x <- tryCatch({
                conv.extension <- ".pathview.pdf"
                extension <- "aux.pathview.png"
                outfile <- file.path(getPath, paste0(pathway.id,extension))
                animation::ani.options('autobrowse'=FALSE)
                animation::im.convert(file.path(getPath, paste0(pathway.id,conv.extension)), output = outfile, extra.opts="-density 150")
            },  error = function(e) {
                createAlert(session, "deamessage", "deaAlert", title = "Error", style =  "warning",
                            content = "I couldn't convert the pdf to png.", append = FALSE)
                print(e)
            })
        }
        # Return a list containing the filename
        list(src = outfile,
             contentType = 'image/png',
             width =  input$pathwaygraphwidth,
             height = input$pathwaygraphheight,
             alt = "File not found")
    }, deleteFile = FALSE)

})
