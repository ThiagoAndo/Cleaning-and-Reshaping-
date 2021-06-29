# Tidying & Reshaping


![](images/03.01_junior_tame_v_tidy.png)



# Data describe all columns
The data was taken from  [Australian Marriage](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1800.02017?OpenDocument)
 Law Postal Survey, 2017. 

Australian Marriage Law Postal Survey, 2017 was conducted by the Australian Bureau of Statistics. This survey tries to find out people’s views on legalizing same-sex marriage in Australia.

Two excel sheets are being used in the coming tasks:


### 1. Australian Marriage Law Postal Survey 2017 - Participation

Australian Marriage Law Postal Survey 2017 - Participation contains information on participants, Distributed over different age bands. A further division by (State/federal division) and gender(male/female)are provided in different sheets.

In this particular script sheet 5 and sheet 6 are going to be used: 

* sheet 5 contains male participants distributed over different age bands (RHS) and federal division(LHS).

* sheet 6 contains female participants distributed over different age bands and federal divisions.



<center>
   ![](images/first.png)
</center>

The image is the screenshot of sheet 5. Sheet 5 and 6 are identical in the arrangement.
</br>

### 2. Australian Marriage Law Postal Survey 2017 - Response

Australian Marriage Law Postal Survey 2017 - Response contains information on responses of various participants of the study.

In this analysis sheet, 3 of the data will be used from the Australian Marriage Law Postal Survey 2017 - Response the sheet contains responses of eligible participants and also contains info on non-responding participant and unclear responses over different federal divisions

<center>
   ![](images/second.png)
</center>
 </br> </br>

# Tidying Data

The data is not in tidy format. Reason: In Australian Marriage Law Postal Survey 2017 - Participation,
the clumms age brackets are distributed over columns that directly violate tidy data rules. To make data a tidy df, a gather operation is to be performed to create a column with age brackets as different levels of columns.

You can understand better about tidy data rules [here.](https://vita.had.co.nz/papers/tidy-data.pdf) 

To tidy these data a good portion of the gamut of tidyverse techniques will be used.

 * Read Excel files using `XLConnect`
 * Dropping rows and reshaping data with `tidyr` 
 * Filtering,and mutating with `dplyr`
 * Cleaning column names with `janitor`
 * Manipulating strings with `stringr` and `rebus`
 </br> </br>
 
 
 
# Tidied DataSets


### Australian Marriage Law Postal Survey 2017 - Participation
<center>
   ![](images/first_01.png)
</center>
 </br> </br>


### Australian Marriage Law Postal Survey 2017 - Response
<center>
   ![](images/second_02.png)
</center>



You can find the detailed script in markdown format in the [RPubs](https://rpubs.com/AndoFreitas)
