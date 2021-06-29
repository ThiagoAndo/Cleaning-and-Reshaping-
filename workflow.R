
suppressMessages(library(XLConnect))
suppressMessages(library(stringr))
suppressMessages(library(dplyr))
suppressMessages(library(janitor))
suppressMessages(library(tidyr))
suppressMessages(library(rebus))

files <- dir("Dirty_data", full = T)


if(length(files)==0 ){
   warning("FIRST YOU MUST CREATE A NEW R PROJEC THEN COPY THE FILES DOWNLOADED FROM GIT HUB 
        AND PASTE ALL INTO THE NEW PROJECT FOLDER") }

my_book <- loadWorkbook(files[1])

book <- loadWorkbook(files[2])

readingFiles <- function(sex, col_num, col_nam, sheet_num){
   colnames <- readWorksheet(my_book, sheet=5, endRow =16)
   colnames <- unlist( colnames[5,] )
   names(colnames)  <- NULL
   no      <-  readWorksheet(my_book, sheet=4, startRow =6 , startCol = 18, endCol = 18)
   gen     <-  readWorksheet(my_book, sheet=sheet_num, startRow =6)
   if(sex == "male"){gen <-  cbind(gen, no)}
   colnames[col_num] <- col_nam
   names(gen) <- colnames
   
   return(gen)
}

transfom <- function(bit, div){
   
}


firstStep <- function(bit, div, type){
   
   if(type == "suv"){
      bit <-  bit %>%
         select( - names(bit[,18, drop = F]))%>%
         filter(!is.na(label))%>%
         fill(state)%>%
         mutate(division = as.factor(div))
      
   }else if(type == "resp"){
      bit <-  bit %>%
         mutate(division = as.factor(div),
                region = str_remove(region, char_class("(")%R%WRD%R%char_class(")")))%>%
         select(division, everything() )}
   
   return(bit)
   
}


secondStep <- function(data, type, num, place){
   start <- str_which(data[,place], fixed("Divisions")) 
   Division <-  str_remove(data[start,place], " Divisions")
   New_South_Wales  <- firstStep( data[(start[1]+1) : (start[2]-num[1]),] , Division[1],type)
   Victoria         <- firstStep( data[(start[2]+1) : (start[3]-num[1]),] , Division[2],type)
   Queensland       <- firstStep( data[(start[3]+1) : (start[4]-num[1]),] , Division[3],type)
   South            <- firstStep( data[(start[4]+1) : (start[5]-num[1]),] , Division[4],type)
   Western          <- firstStep( data[(start[5]+1) : (start[6]-num[1]),] , Division[5],type)
   Tasmania         <- firstStep( data[(start[6]+1) : (start[7]-num[1]),] , Division[6],type)
   Northern         <- firstStep( data[(start[7]+1) : (start[8]-num[1]),] , Division[7],type)
   Capital          <- firstStep( data[(start[8]+1) : num[2],] , Division[8],type)
   
   full <- rbind(New_South_Wales, Victoria, Queensland, South, Western, Tasmania, Northern,
                 Capital)
   return(full)
}

thirdStep <- function(full,sex,fitu){
   
   full <- full %>%
      gather("years", "participants",- fitu)%>%
      select(c(fitu, division, years, participants))%>%
      mutate(years = as.factor(str_trim(str_remove(years, fixed("years")))),
             years = recode(years, "85  and over" = "85-over"),
             state = str_remove(state, char_class("(")%R%WRD%R%char_class(")")))%>%
      clean_names()
   
   if(sex == "male"){ 
      tidy <- full %>%
         select( - no_gender) %>%
         mutate(sex = factor(sex)) %>%
         rename(measure = label)%>%
         clean_names()
      
      
      no_gender <- full %>%
         select( - participants) %>% 
         filter(years == "18-19")%>%
         mutate(years = NA, sex = NA)%>%
         rename(measure = label,
                participants = no_gender)%>%
         clean_names()
      
      tidy <-  bind_rows(tidy,no_gender)
      
      
     
   }else{ 
      
      tidy <-full %>% 
         mutate(sex = factor(sex)) %>%
         rename(measure = label)%>%
         clean_names()
   } 
   
   tidy <- tidy %>%
      select(division, state, years, sex, measure,participants ) %>%
      arrange(years)
   
   return(tidy) 
}

   

data  <- readingFiles("male",c(1,2,19),c("state", "label","no_gender"),5)
full  <-  secondStep(data,"suv",c(6,636),"state")
tidy_male  <-  thirdStep(full,"male",c("state", "label", "no_gender", "division"))


data  <- readingFiles("female",c(1,2,18),c("state", "label","Total Females(b)"),6)
full  <-  secondStep(data,"suv",c(6,636),"state") 
tidy_female  <-  thirdStep(full,"female",c("state", "label", "division"))


Participation_final <- rbind(tidy_male,tidy_female)

# write.csv(joined,"participation_final.csv", row.names = FALSE)

#====================================RESPONSE 


bind <- function(sheet_num,col_num, col_name){
   response <- readWorksheet(book,sheet=3,startRow =7,startCol=sheet_num[1],endCol =sheet_num[2])
   response[,col_num]<- NULL
   names(response) <- col_name
   return(response)
}

response_clear <- bind(c(1,6),c(3,5,6),c("region", "yes", "no"))

response_not_clear <- bind(c(11,13),2 ,c("not_clear", "non_responding"))

all_data <-  cbind(response_clear,response_not_clear)

full <- secondStep(all_data,"resp",c(3,172),"region")

     

response_final <- full %>%
                  gather(vote, count,-division,-region)%>%
                  arrange(region)


# write.csv(response_final,"response_final.csv", row.names = FALSE)
     













