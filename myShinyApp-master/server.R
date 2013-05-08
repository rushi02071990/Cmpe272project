library(shiny)
library(ggplot2)
library(RSQLite)


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  #connect to the Database
  db=dbConnect(SQLite(),dbname="./MyTest.sqlite");
  
  predictY=function(x,y,trend_years)
  {
    fit=lm(y~x) 
    
    N=length(y);
    M=length(x);
    
    if(input$trendYears <= 0) {
      return (list(data.frame(x,y),fit))
    }
    
    for(i in 1:trend_years) {
      x[M+i] = x[M+i-1]+1;
      m = fit$coefficients[2];
      c = fit$coefficients[1];
      y[N+i]=m*x[M+i]+c;
    }
    
    new_df=data.frame(x,y)
    return(list(new_df,fit))    
  }
  
  predictY2=function(x,y,trend_years)
  {
    fit=lm(y~I(x^2+x)) 
    
    N=length(y);
    M=length(x);
    
    for(i in 1:trend_years) {
      x[M+i] = x[M+i-1]+1;
      m = fit$coefficients[2];
      c = fit$coefficients[1];
      y[N+i]=m*x[M+i]+c;
    }
    
    new_df=data.frame(x,y)
    
    return(new_df)    
  }
  
  # Query builder
  myQueryBuilder= function(t,p1,p2)
  {
    paste("select ", p1, " from ",t, " where Occupation  like ", paste("'",p2,"%'",sep=""));      
  }
  
  #get Y variable
  getYData=function(db,p1,p2)
  {
    y=vector();
    
    tbList=dbListTables(db);
    for(i in 1:length(tbList)){ 
      q=myQueryBuilder(tbList[i],p1,p2);
      
      rs=dbSendQuery(db,q);
      
      df=fetch(rs,n=-1);
      
      y[i]=df[,p1];
    }
    
    return(y);
  }
  
  
  
  # Return the requested Job occupation type
  occ_type <- reactive({
    input$job
  })
  
  # Return the parameter based on which you want to predict 
  job_param <- reactive({
    input$jf
  })
  
#   output$summary <-renderPrint({ 
#     
#     #get x and y
#     x=c(2002:2012)
# 
#     y=do.call(getYData,args=list(db,input$jf,input$job))
#     
#     #make a data frame
#     df = data.frame(x,y)
# 
#     print(str(df));
#     
#   })
  
#   # Generate a Plot 
#   output$main_plot <- renderPlot({
#     
#       if(input$plotButton != 0) {
#          isolate({
#             #connect to the Database
#             db=dbConnect(SQLite(),dbname="./MyTest.sqlite");
#     
#             x=c(2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012)
#             y=do.call(getYData,args=list(db,input$jf,input$job))
#          
#             aes_mapping <- aes_string(x = x, y = y)
#     
#             points <- geom_point(shape = 22, alpha = 1,size=5)
#             
#             p = ggplot(data.frame(x,y),aes(x=x,y=y))
#             p = p+xlab("years")+ylab(input$jf)+ggtitle(input$job)
#             p = p + points;
#             p = p + geom_line();
#             p = p + theme_bw();
#             p = p + scale_x_continuous(breaks=x) +  scale_y_continuous(range(y)) 
#         })
#     
#         print(p)
#         dbDisconnect(db)  
#       }
#  }) 

  # Generate a Plot 
  output$main_plot <- renderPlot({
    
    
    
        #connect to the Database
        #db=dbConnect(SQLite(),dbname="./MyTest.sqlite");
        
        x=c(2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012)
        y=do.call(getYData,args=list(db,input$jf,input$job))
    

        #new_df = predictY(x,y,input$trendYears)
        
        returnVal = predictY(x,y,input$trendYears)
        
        new_df = returnVal[1];
        
        
        
        x= as.vector(new_df[[1]]$x)
        y= as.vector(new_df$y)

        points <- geom_point(shape = 22, alpha = 1,size=5)
        
        p = ggplot(data=as.data.frame(new_df),aes(x=x,y=y))
        
        
        p = p + points
        
        p = p + scale_colour_hue(l = 40) + scale_shape(solid = FALSE)
        
        p = p + geom_line() + geom_vline(xintercept=2012,line_type="dashed")
        
        p = p + theme_bw()
       
        p = p + xlab("years") + ylab(input$jf) + ggtitle(input$job) #+ geom_smooth(se=FALSE,line_type="dashed")
        
        p = p + scale_x_continuous(breaks=x) +  scale_y_continuous(y) 
        
        
        print(p)
        
       # dbDisconnect(db)
  }) 
  
  # Show the plot
  output$view <- renderTable({
    x=c(2002:2012)
    y <- getYData(db,input$jf,input$job)    
    head(data.frame(x,y),n=length(x))
   })
})