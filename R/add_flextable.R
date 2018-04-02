#' Add a flextable or mytable object into a document object
#' @param mydoc A document object
#' @param ftable A flextable or mytable object
#' @param title An character string as a plot title
#' @param code R code for table
#' @param echo logical Whether or not show R code
#' @importFrom officer add_slide ph_with_text  body_add_par
#' @importFrom flextable body_add_flextable ph_with_flextable ph_with_flextable_at
#' @return a document object
#' @export
#' @examples
#' require(rrtable)
#' require(moonBook)
#' require(officer)
#' require(magrittr)
#' ftable=mytable(Dx~.,data=acs)
#' title="mytable Example"
#' ft=df2flextable(head(iris))
#' title2="df2flextable Example"
#' doc=read_docx()
#' doc %>% add_flextable(ftable,title,code="mytable(Dx~.,data=acs)",echo=TRUE) %>%
#'         add_flextable(ft,title2,code="df2flextable(head(iris))",echo=TRUE) %>%
#'         print(target="mytable.docx")
#' read_pptx() %>%
#'        add_flextable(ftable,title,code="mytable(Dx~.,data=acs)",echo=TRUE) %>%
#'        add_flextable(ftable,title,code="mytable(Dx~.,data=acs)") %>%
#'        add_flextable(ft,title2,code="df2flextable(head(iris))",echo=TRUE) %>%
#'        add_flextable(ft,title2,code="df2flextable(head(iris))") %>%
#'        print(target="mytable.pptx")
add_flextable=function(mydoc,ftable,title="",code="",echo=FALSE){
     if("mytable" %in% class(ftable)){
          ft<-mytable2flextable(ftable)
     } else {
          ft<-ftable
     }
     if(class(mydoc)=="rpptx"){
          mydoc <- mydoc %>% add_slide("Title and Content",master="Office Theme")
          mydoc <- mydoc %>% ph_with_text(type="title",str=title)
          if(echo) {
              codeft=Rcode2flextable(code,eval=FALSE,format="pptx")
              mydoc<-mydoc %>% ph_with_flextable_at(value=codeft,left=1,top=2)
              mydoc<-mydoc %>% ph_with_flextable_at(value=ft,left=1,top=2.5)
          } else{
              mydoc<-mydoc %>% ph_with_flextable_at(value=ft,left=1,top=2)
          }

     } else {
          mydoc <- mydoc %>% add_title(title)
          mydoc<-mydoc %>% body_add_par(value="",style="Normal")
          if(echo) {
              codeft=Rcode2flextable(code,eval=FALSE,format="docx")
              mydoc<-mydoc %>% body_add_flextable(codeft)
              mydoc<-mydoc %>% body_add_par(value="",style="Normal")
          }
          mydoc<-mydoc %>% body_add_flextable(ft)
     }
     mydoc
}


#
# library(rvg)
# read_pptx() %>%
#      add_slide(layout = "Title and Content", master = "Office Theme") %>%
#      ph_with_vg(code = print(gg), type = "body") %>%
#      add_slide(layout = "Title and Content", master = "Office Theme") %>%
#      ph_with_vg(code = plot(1:10,1:10,type="b"), type = "body") %>%
#      print(target = "demo_rvg.pptx")


#' Add plot into a document object
#' @param mydoc A document object
#' @param plotstring String of an R code encoding a plot
#' @param title An character string as a plot title
#' @param vector A logical. If TRUE, vector graphics are produced instead, PNG images if FALSE.
#' @param echo logical Whether or not show R code
#' @return a document object
#' @importFrom officer ph_with_text
#' @importFrom rvg ph_with_vg_at
#' @export
#' @examples
#' require(rrtable)
#' require(officer)
#' require(rvg)
#' require(magrittr)
#' read_pptx() %>% add_plot("plot(iris)") %>% add_plot("plot(iris)",echo=TRUE)
add_plot=function(mydoc,plotstring,title="",vector=TRUE,echo=FALSE){

     if(class(mydoc)=="rpptx"){

          mydoc<- mydoc %>%
               add_slide(layout = "Title and Content", master = "Office Theme") %>%
               ph_with_text(type="title",str=title)
          if(echo){
              codeft=Rcode2flextable(plotstring,eval=FALSE,format="pptx")
              mydoc<-mydoc %>% ph_with_flextable_at(value=codeft,left=1,top=2)
              temp=paste0("ph_with_vg_at(mydoc,code=",plotstring,",left=1,top=2.3,width=8,height=5)")
              mydoc=eval(parse(text=temp))
          } else{
              temp=paste0("ph_with_vg_at(mydoc,code=",plotstring,",left=1,top=2,width=8,height=5)")
              mydoc=eval(parse(text=temp))
          }
     } else{
          temp=paste0("body_add_vg(mydoc,code=",plotstring,")")
          mydoc <- mydoc %>%
               add_title(title)
          if(echo) {
              mydoc<-mydoc %>% body_add_par(value="",style="Normal")
              codeft=Rcode2flextable(plotstring,eval=FALSE,format="docx")
              mydoc<-mydoc %>% body_add_flextable(codeft)
          }
          mydoc=eval(parse(text=temp))
     }
     mydoc
}


#' Add ggplot into a document object
#' @param mydoc A document object
#' @param title An character string as a plot title
#' @param code R code for table
#' @param echo logical Whether or not show R code
#' @return a document object
#' @importFrom rvg ph_with_vg body_add_vg
#' @export
#' @examples
#' require(rrtable)
#' require(ggplot2)
#' require(officer)
#' require(magrittr)
#' code <- "ggplot(mtcars, aes(x = mpg , y = wt)) + geom_point()"
#' read_pptx() %>% add_ggplot(code=code,echo=TRUE)
add_ggplot=function(mydoc,title="",code="",echo=FALSE){
     if(class(mydoc)=="rpptx"){
     mydoc<- mydoc %>%
          add_slide(layout = "Title and Content", master = "Office Theme") %>%
          ph_with_text(type="title",str=title)

     if(echo){
         codeft=Rcode2flextable(code,eval=FALSE,format="pptx")
         mydoc<-mydoc %>% ph_with_flextable_at(value=codeft,left=1,top=2)
         temp=paste0("ph_with_vg_at(mydoc,code=print(",code,"),left=1,top=2.3,width=8,height=5)")
         mydoc=eval(parse(text=temp))
     } else{
         temp=paste0("ph_with_vg_at(mydoc,code=print(",code,"),left=1,top=2,width=8,height=5)")
         mydoc=eval(parse(text=temp))
     }

     } else{
          mydoc <- mydoc %>%
               add_title(title)
          temp=paste0("body_add_vg(mydoc,code=print(",code,"))")
          if(echo) {
              mydoc<-mydoc %>% body_add_par(value="",style="Normal")
              codeft=Rcode2flextable(code,eval=FALSE,format="docx")
              mydoc<-mydoc %>% body_add_flextable(codeft)
          }
          mydoc=eval(parse(text=temp))
     }
     mydoc
}

#' Add plot into a document object
#' @param mydoc A document object
#' @param plotstring An string of R code encoding plot
#' @param title An character string as a plot title
#' @param width the width of the device.
#' @param height the height of the device.
#' @param units The units in which height and width are given. Can be px (pixels, the default), in (inches), cm or mm.
#' @param res The nominal resolution in ppi which will be recorded in the bitmap file, if a positive integer. Also used for units other than the default, and to convert points to pixels.
#' @param format plot format
#' @param echo logical Whether or not show R code
#' @param ... additional arguments passed to png()
#' @return a document object
#' @importFrom devEMF emf
#' @importFrom officer ph_with_img body_add_img ph_with_img_at
#' @export
#' @examples
#' require(officer)
#' require(rrtable)
#' require(magrittr)
#' require(flextable)
#' read_pptx() %>% add_img("plot(mtcars)",format="png",res=300)
add_img=function(mydoc,plotstring,title="",width=7,height=5,units="in",
                 res=300,format="emf",echo=FALSE,...) {
     # produce an emf file containing the ggplot
     filename <- tempfile(fileext = paste0(".",format))
     if(format=="emf"){
     emf(file = filename, width = width, height = height)
     } else if(format %in% c("png","PNG")){
          png(filename = filename, width = width, height = height,units=units,res=res,...)
     }
     eval(parse(text=plotstring))
     dev.off()
     if(class(mydoc)=="rpptx"){
          mydoc<- mydoc %>%
               add_slide(layout = "Title and Content", master = "Office Theme") %>%
               ph_with_text(type="title",str=title)
          if(echo){
          codeft=Rcode2flextable(plotstring,eval=FALSE,format="pptx")
          mydoc<-mydoc %>% ph_with_flextable_at(value=codeft,left=1,top=2)
          temp=paste0("ph_with_img_at(mydoc,src=filename,left=1,top=2.3,width=8,height=5)")
          mydoc=eval(parse(text=temp))
     } else{
         temp=paste0("ph_with_img_at(mydoc,src=filename,left=1,top=2,width=8,height=5)")
         mydoc=eval(parse(text=temp))
     }
     } else{
          mydoc <- mydoc %>% add_title(title)
          if(echo){
              codeft=Rcode2flextable(plotstring,eval=FALSE,format="docx")
              mydoc<-mydoc %>% body_add_flextable(codeft)
          }
          mydoc <- body_add_img(mydoc,src=filename,
                              width=width,height=height)
     }
     mydoc
}

# read_docx() %>% add_img(plot(mtcars),title="plot(mtcars)",format="png",res=300) %>%
#      print(target="png.docx")



####################


#' Make a data.frame with character strings encoding R code
#' @param result character strings encoding R code
#' @param preprocessing character strings encoding R code as a preprocessing
#' @param eval logical. Whether or not evaluate the code
#' @importFrom utils capture.output
Rcode2df=function(result,preprocessing,eval=TRUE){
     if(preprocessing!="") eval(parse(text=preprocessing))
     res=c()
     codes=unlist(strsplit(result,"\n",fixed=TRUE))
     for(i in 1:length(codes)){
          #if(codes[i]=="") next
          if(length(grep("cat",codes[i]))==1) {
               if(grep("cat",codes[i])==1) next
          }
          res=c(res,codes[i])
          if(eval){
          temp=capture.output(eval(parse(text=codes[i])))
          if(length(temp)==0) temp1=""
          else  {
               temp1=Reduce(pastelf,temp)
               temp1=paste0(temp1,"\n ")
          }
          res=c(res,temp1)
          }

     }
     data.frame(result=res,stringsAsFactors = FALSE)

}

pastelf=function(...){
     paste(...,sep="\n")
}

#' Split strings with desired length with exdent
#' @param string String
#' @param size desired length
#' @param exdent exdent
#' @importFrom stringr str_extract_all str_flatten str_pad
#' @return splitted character vector
tensiSplit <- function(string,size=82,exdent=3) {
    result=c()
    if(nchar(string)<=size) {
        result=string
    } else{
        temp=substr(string,1,size)
        result=unlist(str_extract_all(substr(string,size+1,nchar(string)), paste0('.{1,',size-exdent,'}')))
        result=paste0(str_flatten(rep(" ",exdent)),result)
        result=c(temp,result)
    }
    str_pad(result,size,"right")
}


#' Make a FlexTable with a data.frame
#' @param df A data.frame
#' @param bordercolor A border color name
#' @param format desired format. choices are "pptx" or "docx"
#' @importFrom flextable delete_part flextable height_all void
#' @importFrom stringr str_split str_wrap
#' @return A FlexTable object
df2RcodeTable=function(df,bordercolor="gray",format="pptx"){
    # df
    #bordercolor="gray";maxlen=80
    maxlen=ifelse(format=="pptx",92,82)
    font_size=ifelse(format=="pptx",11,10)
    no<-code<-c()
     for(i in 1:nrow(df)){
          temp=df[i,]
          result=unlist(strsplit(temp,"\n",fixed=TRUE))
          if(length(result)>0){
               for(j in 1:length(result)){

                    splitedResult=tensiSplit(result[j],size=maxlen)
                    code=c(code,splitedResult)
                    no=c(no,rep(i,length(splitedResult)))
               }
          }
     }
     df2=data.frame(no,code,stringsAsFactors = FALSE)
     flextable(df2) %>%
          align(align="left",part="all") %>% border_remove() %>%
          bg(i=~no%%2==1,bg="#EFEFEF") %>%
          padding(padding=0) %>%
          #padding(i=~no%%2==0,padding.left=10) %>%
          font(fontname="Monaco",part="all") %>%
          fontsize(size=font_size) %>%
          delete_part(part="header") %>%
          void(j=1) %>%
          autofit() %>% height_all(height=0.2,part="all")
}

#' Make a flextable object with character strings encoding R code
#' @param result character strings encoding R code
#' @param preprocessing character strings encoding R code as a preprocessing
#' @param format desired format. choices are "pptx" or "docx"
#' @param eval logical. Whether or not evaluate the code
#' @export
Rcode2flextable=function(result,preprocessing="",format="pptx",eval=TRUE){
     df=Rcode2df(result,preprocessing=preprocessing,eval=eval)
     df2RcodeTable(df,format=format)

}



#' Make a R code slide into a document object
#' @param mydoc A document object
#' @param code  A character string encoding R codes
#' @param title An character string as a plot title
#' @param preprocessing A character string of R code as a preprocessing
#' @param format desired format. choices are "pptx" or "docx"
#' @return a document object
#' @export
#' @examples
#' #library(rrtable)
#' #library(magrittr)
#' #library(officer)
#' #code="fit=lm(mpg~hp+wt,data=mtcars)\nsummary(fit)"
#' #read_pptx() %>% add_Rcode(code,title="Regression Analysis") %>% print(target="Rcode.pptx")
add_Rcode=function(mydoc,code,title="",preprocessing="",format="pptx"){

     ft <- Rcode2flextable(code,preprocessing=preprocessing,format=format)
     mydoc <- mydoc %>% add_flextable(ft,title=title)
     mydoc
}


#' Add title slide
#' @param mydoc A document object
#' @param title An character string as a title
#' @param subtitle An character string as a subtitle
#' @export
#' @examples
#' #read_pptx() %>% add_title_slide(title="Web-based analysis with R" %>% print(target="title.pptx")
add_title_slide=function(mydoc,title="",subtitle=""){
     mydoc <- mydoc %>%
          add_slide(layout="Title Slide",master="Office Theme") %>%
          ph_with_text(type="ctrTitle",str=title) %>%
          ph_with_text(type="subTitle",str=subtitle)
     mydoc
}


#' convert data to pptx file
#' @param data A document object
#' @param preprocessing A string
#' @param filename File name
#' @param format desired format. choices are "pptx" or "docx"
#' @param width the width of the device.
#' @param height the height of the device.
#' @param units The units in which height and width are given. Can be px (pixels, the default), in (inches), cm or mm.
#' @param res The nominal resolution in ppi which will be recorded in the bitmap file, if a positive integer. Also used for units other than the default, and to convert points to pixels.
#' @param rawDataName raw Data Name
#' @param rawDataFile raw Data File
#' @param vanilla logical. WHether or not make vanilla table
#' @param echo logical Whether or not show R code
#' @importFrom officer read_docx read_pptx
#' @export
data2office=function(data,
                   preprocessing="",
                   filename="Report",format="pptx",width=7,height=5,units="in",
                   res=300,rawDataName=NULL,rawDataFile="rawData.RDS",vanilla=FALSE,echo=FALSE){

     if(!is.null(rawDataName)){
          rawData=readRDS(rawDataFile)
          assign(rawDataName,rawData)
     }
    if(preprocessing!="") eval(parse(text=preprocessing))

    data$type=tolower(data$type)
    if("title" %in% data$type) {
        mytitle=data[data$type=="title",]$code[1]
        data=data[data$type!="title",]
    } else{
        mytitle="Web-based Analysis with R"
    }
    if("author" %in% data$type) {
        myauthor=data[data$type=="author",]$code[1]
        data=data[data$type!="author",]
    } else{
        myauthor="prepared by web-r.org"
    }

     if(format=="pptx"){
          mydoc <- read_pptx() %>%
                   add_title_slide(title=mytitle,subtitle=myauthor)
     } else {
          mydoc <- read_docx()
     }
     #str(data)
     for(i in 1:nrow(data)){
          #cat("data$code[",i,"]=",data$code[i],"\n")

          if(data$type[i]=="Rcode") eval(parse(text=data$code[i]))
          if(data$type[i]=="data"){
              ft=df2flextable(eval(parse(text=data$code[i])),vanilla=vanilla)
              mydoc=add_flextable(mydoc,ft,data$title[i],data$code[i],echo=echo)
          } else if(data$type[i]=="table"){
               tempcode=set_argument(data$code[i],argument="vanilla",value=vanilla)
               ft=eval(parse(text=tempcode))
               mydoc=add_flextable(mydoc,ft,data$title[i],data$code[i],echo=echo)
          } else if(data$type[i]=="mytable"){
               res=eval(parse(text=data$code[i]))
               ft=mytable2flextable(res,vanilla=vanilla)
               mydoc=add_flextable(mydoc,ft,data$title[i],data$code[i],echo=echo)
          } else if(data$type[i]=="ggplot"){
               mydoc=add_ggplot(mydoc,title=data$title[i],code=data$code[i],echo=echo)
          }else if(data$type[i]=="2ggplots"){

              codes=unlist(strsplit(data$code[i],"\n"))
              # codes=unlist(strsplit(sampleData2$code[8],"\n"))
              gg1=codes[1]
              gg2=codes[2]
              mydoc=add_2ggplots(mydoc,title=data$title[i],plot1=gg1,plot2=gg2,
                                 echo=echo)
          } else if(data$type[i]=="plot"){
               mydoc<-add_plot(mydoc,data$code[i],title=data$title[i],echo=echo)

          } else if(data$type[i]=="2plots"){

              codes=unlist(strsplit(data$code[i],"\n"))
              mydoc=add_2plots(mydoc,plotstring1=codes[1],plotstring2=codes[2],title=data$title[i],echo=echo)

          } else if(data$type[i]=="rcode"){

               mydoc=add_Rcode(mydoc,code=data$code[i],title=data$title[i],
                               preprocessing=preprocessing,format=format)

          } else if(data$type[i]=="text"){

              mydoc=add_text(mydoc,title=data$title[i],text=data$code[i])

          } else if(data$type[i] %in% c("PNG","png")){

               mydoc<-add_img(mydoc,data$code[i],title=data$title[i],format="png",echo=echo)

          } else if(data$type[i] %in% c("emf","EMF")){

               mydoc<-add_img(mydoc,data$code[i],title=data$title[i],echo=echo)

          }


     }
     if(length(grep(".",filename,fixed=TRUE))>0) {
         target=filename
     } else{
        target=paste0(filename,".",format)
     }
    #cat("target=",target,"\n")
     mydoc %>% print(target=target)
}

#' convert data to pptx file
#' @param ... arguments to be passed to data2office()
#' @export
#' @examples
#' #library(rrtable)
#' #data2pptx(sampleData2)
data2pptx=function(...){
     data2office(...)
}

#' convert data to docx file
#' @param ... arguments to be passed to data2office()
#' @export
#' @examples
#' #library(rrtable)
#' #data2docx(sampleData2)
data2docx=function(...){
     data2office(...,format="docx")
}


#' Convert html5 code to latex
#' @param df A data.frame
html2latex=function(df){
    temp=colnames(df)
    temp=stringr::str_replace(temp,"<i>p</i>","\\\\textit{p}")
    temp=stringr::str_replace(temp,"&#946;","$\\\\beta$")
    temp=stringr::str_replace(temp,"Beta","$\\\\beta$")
    temp=stringr::str_replace(temp,"&#967;<sup>2</sup>","$\\\\chi^{2}$")
    colnames(df)=temp
    df
}



#
# data=rrtable::sampleData2
# data[2,3]="df2flextable(iris[1:10,])"
# data<-rbind(data,data[3,])
# data<-rbind(data,data[3,])
# data$type[6]="png"
# data$type[7]="emf"
# data
# library(magrittr)
# library(officer)
# library(flextable)
# library(moonBook)
# library(rvg)
# library(ggplot2)
#
# data2pptx(data[5:7,])
# data[6,]
# data2pptx(data)
# data1=data[3,]
# data1
# data=data1
# filename="Report.pptx"
# data2office(data)
# data2office(data,format="docx")
# data2pptx(data)
# data2docx(data)
# # data=data[3,]
# # data
#
# str(data)
#
# mydoc=read_pptx()
#
# for(i in 1:nrow(data)){
#      eval(parse(text=data$code[i]))
# mydoc=add_plot(mydoc,data$code[i],title=data$title[i])
# }
# mydoc %>% print(target="plot.pptx")
#
#
# require(editData)
# result=editData(sampleData2)
# result
# sampleData2=result
# devtools::use_data(sampleData2,overwrite=TRUE)
# sampleData2