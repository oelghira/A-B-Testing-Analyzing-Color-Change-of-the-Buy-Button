# A-B-Testing-Analyzing-Color-Change-of-the-Buy-Button
In this analysis I determine if changing the color of the "buy" button for an online retailer had an impact on sales

## Introduction  
An online retailer is curious if there would be a bump in sales by changing the color of the "buy" button on thier site from red to yellow. The sales department believes that the red "buy" button blends in too much with the web page and deters some consumers from completing a purchase. The retailer has decied to perform an A/B test to determine if a shift from a red "buy" button to a yellow "buy" button will show an increase in the purchase rate. In this analysis I will perform the exploratory data analysis on 9,000 visits to the retailer as a baseline then conclude from the A/B test of 1,000 randomized visits to the site if the color change made an impact on the number ofpurchases.  

(Spoiler Alert!: The results of the A/B test failed to provide statistically significant evidence that change in color from red to yellow impacted the sales rate.) 

## Data  
### Pre A/B Test  
The baseline data (pre A/B test) consisted of 9,000 visits to the site that result in a purchase or not. In the pre-test data there were 4,730 (53%) visits that resulted in a purchase and 4,270 (47%) that did not. With each observation the following data was collected:  
  
**time_on_page_sec:** The ammount of time in seconds an individual user spent on that page     
**num_product_reviews:** The number of product reviews for the product the customer viewed  
**product_rating:** The product rating of the product the customer viewed  
**purchase:** An indicator of whether or not the customer purchased the product  

### A/B Test  
In the A/B test 1,000 visits to the site were randomly assigned to either an experimental group who saw a yellow "buy" button or the control group who saw a red "buy" button. The experimental group contained 504 visits and the control group contained 496 visits for an almost completely balanced experiment. The experimental group resulted in 172 (34%) purchases, while the control group resulted in 138 (28%) purchases. The same independent data was collected during the A/B test as in the pre A/B test. 

## Pre A/B Test Exploratory Data Analysis  
The first thing to note is that in the pre A/B test the number of purchases seems about evenly split.
  
![Sales Table](https://user-images.githubusercontent.com/46107551/109396416-6ca9e800-78ff-11eb-82f9-ce58b9991991.png)

When we take a closer look at the number of purchases and the independent variables it becomes apparent that there is a difference in the number of product reviews and product rating for the visits that resulted in a purchase and those that did not. We can infer from this that the amount of time spent on the page does not indicate if the visit will result in a purchase. We can also infer that the actual product being viewed has a big impact in determining if the visit will result in a purchase. The more reviews a product has and a higher rating lead to a larger probablity of a purchase occuring. 
  
![sales box plots](https://user-images.githubusercontent.com/46107551/109395815-6403e280-78fc-11eb-9cff-a616d03d20b0.png)
  
Hypothesis tests confirmed that there is a statistically significant difference in the average number of product reviews and product rating for visits that resulted in a purchase and those that did not. Tests also confirmed there is no difference in the average amount of time spent on the page. All tests were conducted with an α = 0.05.

The scatter plots using time spent on page as the x-axis and number of reviews and product rating as the y-axis shows there are no signs of a high correlation with the exception of the negative correlation between time and product rating. We can infer from this that the higher a product is rated, the less time it takes for a customer to decide to purchase. 
  
![sales scatter plots](https://user-images.githubusercontent.com/46107551/109395828-6ebe7780-78fc-11eb-8207-deeb06ec6bf4.png)

The analysis thus far has shown that a purchase is heavily influenced by the number of reviews and rating of the product. 

When categorizing the number of reviews into groups, we see less separation between the visits that resulted in a purchase and those that did not. It is only in the middle category where products have 31 to 60 reviews that there is noticeable difference. 
![Sales Prod Rev Cat](https://user-images.githubusercontent.com/46107551/109398189-3b361a00-7909-11eb-855c-1d7d741eb2ed.png)

When categorizing the product ratings, we see the same trend as we did with the number of reveiws. There appears to only be a separation between the visits that resulted in a purchase or not in the middle category. 
![Sales Prod Rat Cat](https://user-images.githubusercontent.com/46107551/109398194-48530900-7909-11eb-938b-2c7908c154fd.png)

## A/B Test Analysis
The first thing to note when conducting this analysis is that we are working with a binomial distribution. A visit can have 1 of 2 outcomes, purchase or not, with an assumed fixed probability of a purchase. We will use this distribution to perform the hypothesis test needed to provide a decisive answer to the retailer. From this test we want to know if the purchase rate from the visits in the experimental yellow "buy" button group was higher than those in the control group with the original red "buy" button. Statistically speaking we will test the following null hypothesis against the alternative hypothesis:  
  
![null](https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cbold%7BH_0%3A%20%5Ctext%7BExperimental%20Purchase%20Rate%7D%20%3D%20%5Ctext%7BControl%20Purchase%20Rate%7D%7D)  
![alt](https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cbold%7BH_1%3A%20%5Ctext%7BExperimental%20Purchase%20Rate%7D%20%3E%20%5Ctext%7BControl%20Purchase%20Rate%7D%7D)

To do this we will first need a baseline probability of purchase from our Pre A/B test data. To do this, I've taken 30 random samples of 500 data points with replacement of our pre A/B test data. 500 data points were used in each subset as that is the approximate size of our experimental and control group. The scatter plot below shows the purchase rate from these samples. An average purchase rate of approximately 0.52. This will provide our probability of a purchase and help determine the variance needed to conduct our hypothesis tests. 
![Sales purchase rate](https://user-images.githubusercontent.com/46107551/109451693-fbac2280-7a1b-11eb-87e4-60ccfa7e0046.png)

For our hypothesis test we will assume that the experimental and control groups had equal variances that are known from our pre A/B test data. Using the binomial distribution our variance takes the form of np(1-p). From our resampling of the pre A/B test data we have p = 0.52 (probability of purchase) and (1-p) = 0.48 (probability of no purchase). From our experimental group we had 504 visits to the site with 172 that resulted in a purchase. In the control group there were 496 visits and 138 resulted in a purchase. Thus to get our test statistic we will have the following:

![test](https://latex.codecogs.com/gif.latex?%5Csmall%20%5Cfrac%7B%5Cbar%7By_1%7D-%5Cbar%7By_2%7D%7D%7B%5Csqrt%7B%5Cfrac%7B%5Csigma_1%5E2%7D%7Bn_1%7D&plus;%5Cfrac%7B%5Csigma_2%5E2%7D%7Bn_2%7D%7D%7D%20%3D%20%5Cfrac%7B%5Cfrac%7B172%7D%7B504%7D-%5Cfrac%7B138%7D%7B496%7D%7D%7B%5Csqrt%7B%5Cfrac%7Bn_1p%281-p%29%7D%7Bn_1%7D&plus;%5Cfrac%7Bn_2p%281-p%29%7D%7Bn_2%7D%7D%7D%20%3D%20%5Cfrac%7B%5Cfrac%7B172%7D%7B504%7D-%5Cfrac%7B138%7D%7B496%7D%7D%7B%5Csqrt%7B2p%281-p%29%7D%7D%20%3D%20%5Cfrac%7B%5Cfrac%7B172%7D%7B504%7D-%5Cfrac%7B138%7D%7B496%7D%7D%7B%5Csqrt%7B2*0.52*0.48%29%7D%7D%20%5Capprox%200.09)

The test statistic of 0.09 which gives a pvalue of 1 - 0.5359 = 0.4641 which does not provide evidence to reject the null. **Hence we do NOT have evidence to reject the null hypothesis & can conclude that there is not a statistically significant difference in the purchase rate between the experimental and control groups.**

To control the effects of the product under consideration during the visit, the same method was conducted with the same number of product review categories ("30 or Fewer Reviews", "31 to 60 Reviews", and "61 or More Reviews") and product rating categories ("Product Rating <= 2", "Product Rating Between 2 & 3", "Product Rating > 3"). These tests resulted the same as our overall test. There were no significant differences found in the purchase rates between the experimental and control groups. These tests have been omitted for brevity's sake, but can be found in the R-code within this repository. 

## Conclusion
The results of the A/B test did not show statistically significant evidence to support the sales department's hunch that a yellow "buy" button would lead to more sales than the current red "buy" button. It is unlikely that making this change would lead to any additional sales, but it is possible that a color change could lead to a better customer experience. From the analysis we saw that higher rated products and products with more reviews did have an impact on the number of purchases. The online retailer can take the learnings from this test and commit to another test on different methods to incentivize its customers to leave more reviews. The retailer could also test in the future if different suppliers can provide products for their site that lead to higher reviews. Increasing the number of product reviews and higher rated products should be the objectives of future A/B tests to improve sales. 
