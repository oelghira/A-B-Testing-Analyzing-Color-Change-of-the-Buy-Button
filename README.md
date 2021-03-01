# A-B-Testing-Analyzing-Color-Change-of-the-Buy-Button
In this analysis I determine if changing the color of the "buy" button for an online retailer had an impact on sales

## Introduction  
An online retailer is curious if there would be a bump in sales by changing the color of the "buy" button on thier site from red to yellow. The sales department believes that the red "buy" button blends in too much with the web page and deters some consumers from completing a purchase. The retailer has decied to perform an A/B test to determine if a shift from a red "buy" button to a yellow "buy" button will show an increase in the purchase rate. In this analysis I will perform the exploratory data analysis on 9,000 visits to the retailer as a baseline then conclude from the A/B test of 1,000 randomized visits to the site if the color change made an impact on purchases.  

The results of the A/B test failed to provide statistically significant evidence that change in color from red to yellow impacted the sales rate.  

## Data  
### Pre A/B Test  
The baseline data (pre A/B test) consisted of 9,000 visits to the site that result in a purchase or not. In the pre-test data there were 4,730 (53%) visits that resulted in a purchase and 4,270 (47%) that did not. With each observation the following data was collected:  
  
time_on_page_sec: The ammount of time in seconds an individual user spent on that page     
num_product_reviews: The number of product reviews for the product the customer viewed  
product_rating: The product rating of the product the customer viewed  
purchase: An indicator of whether or not the customer purchased the product  

### A/B Test  
In the A/B test 1,000 visits to the site were randomly assigned to either an experimental group who saw a yellow "buy" button or the control group who saw a red "buy" button. In the experimental group contained 504 visits and the control group contained 496 visits for an almost completely balanced experiment. The experimental group resulted in 172 (34%) purchases, while the control group resulted in 138 (28%) purchases. The same independent data was collected during the A/B test as in the pre A/B test. 

## Pre A/B Test Exploratory Data Analysis  
The first thing to note is that in the pre A/B test the number of purchases seems about evenly split.
  
![Sales Table](https://user-images.githubusercontent.com/46107551/109396416-6ca9e800-78ff-11eb-82f9-ce58b9991991.png)

When we take a closer look at the number of purchases and the independent variables it becomes apparent that there is a difference in the number of product ratings and product rating for the visits that resulted in a purchase and those that did not. We can infer from this that amount of time spent on the page does not indicate if the visit will result in a purchase. We can also infer that the actual product being viewd has a big impact in determining if the visit will result in a purchase. The more reviews a product has and a higher rating lead to a larger probablity of a purchase occuring. 
  
![sales box plots](https://user-images.githubusercontent.com/46107551/109395815-6403e280-78fc-11eb-9cff-a616d03d20b0.png)
  
Hypothesis tests confirmed that there is a statistically significant difference in the average number of product reviews and product rating for visits that resulted in a purchase and those that did not. Tests also confirmed there is no difference in the average amount of time spent on the page. All tests were conducted with an ** \alpha = 0.05. FIX THISS!!!!**

The scatter plots using time spent on page as the x-axis and number of reviews and product rating as the y-axis shows there are no signs of a high correlation with the exception of the negative correlation between time and product rating. We can infer from this that the higher a rated a product the less time it takes for a customer to decide to purchase. 
  
![sales scatter plots](https://user-images.githubusercontent.com/46107551/109395828-6ebe7780-78fc-11eb-8207-deeb06ec6bf4.png)

![Sales Prod Rev Cat](https://user-images.githubusercontent.com/46107551/109398189-3b361a00-7909-11eb-855c-1d7d741eb2ed.png)

![Sales Prod Rat Cat](https://user-images.githubusercontent.com/46107551/109398194-48530900-7909-11eb-938b-2c7908c154fd.png)

