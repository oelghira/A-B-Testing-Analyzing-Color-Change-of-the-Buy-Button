# install.packages(c("dplyr","ggplot2","gridExtra"))
library(dplyr)
library(ggplot2)
library(gridExtra)
sales = read.csv("")
#update with link to saved sales.csv from repository
#pre ab test data
sales_ab = read.csv("")
#update with link to saved sales_ab.csv from repository
#ab test data

#sales (pre ab test) data contained independent (time, product reviews, rating) data & the response for each observation
#the ab test only contained the group information (experimental or control) and the response
#for the sake of making the analysis more interesting the sales data will be randomly sampled and have observations moved to the ab test
#so that the ab test data has the same independent variables (time, product reviews, rating) as the sales  
#Thus a purchase == "yes" observation in the sales ab test will have the same measurements as a random purchase == "yes" observation in the pre ab test data
#the same is true for a purchase == "no" observation in the sales ab test 

sales_purchase_yes = sales %>% filter(purchase == "yes")
sales_purchase_no = sales %>% filter(purchase == "no")

sales_ab_purchase_yes = sales_ab %>% filter(purchase == "yes")
sales_ab_purchase_no = sales_ab %>% filter(purchase == "no")

set.seed(1)
sales_purchase_yes_indexes = sample(1:nrow(sales_purchase_yes),nrow(sales_ab_purchase_yes), replace = FALSE)
sales_ab_purchase_yes = cbind(sales_ab_purchase_yes,sales_purchase_yes[sales_purchase_yes_indexes,])
#removing original purchase column so that there are not two columns titled purhcase
sales_ab_purchase_yes = sales_ab_purchase_yes[,-3]
sales_purchase_yes = sales_purchase_yes[-sales_purchase_yes_indexes,]

sales_purchase_no_indexes = sample(1:nrow(sales_purchase_no),nrow(sales_ab_purchase_no), replace = FALSE)
sales_ab_purchase_no = cbind(sales_ab_purchase_no,sales_purchase_no[sales_purchase_no_indexes,])
#removing original purchase column so that there are not two columns titled purhcase
sales_ab_purchase_no = sales_ab_purchase_no[,-3]
sales_purchase_no = sales_purchase_no[-sales_purchase_no_indexes,]

sales = rbind(sales_purchase_yes,sales_purchase_no)
sales_ab = rbind(sales_ab_purchase_yes,sales_ab_purchase_no)

rm(sales_purchase_yes_indexes)
rm(sales_ab_purchase_yes)
rm(sales_purchase_yes)

rm(sales_purchase_no_indexes)
rm(sales_ab_purchase_no)
rm(sales_purchase_no)

sales$purchase = as.factor(sales$purchase)
sales_ab$group = as.factor(sales_ab$group)
sales_ab$purchase = as.factor(sales_ab$purchase)

#changing sales scale from 0 to 4 to 1 to 5
sales$product_rating = sales$product_rating + 1
sales_ab$product_rating = sales_ab$product_rating + 1

sales = as.data.frame(sales)
#pre ab test data discussed in ReadME
sales_ab = as.data.frame(sales_ab)
#ab test data discssed in ReadMe

###################################################################################################################
#Pre AB Test EDA
###################################################################################################################
sales_prop = prop.table(table(sales$purchase))
sales_freq = table(sales$purchase)
sales_table = rbind(round(sales_freq,0),round(sales_prop,2))
row.names(sales_table) = c("count","frequency %")
sales_table
#53% purchase = yes, 47% purchase = no

s1 = ggplot(sales, aes(x = purchase, y = time_on_page_sec, fill = purchase))+geom_boxplot()+ggtitle("Time (seconds) Spent on Page")+theme(legend.position = "none")
s1 = s1 + scale_fill_manual(values=c("#F8766D", "#B79F00"))
s2 = ggplot(sales, aes(x = purchase, y = num_product_reviews, fill = purchase))+geom_boxplot()+ggtitle("Number of Product Reviews")+theme(legend.position = "none")
s2 = s2 + scale_fill_manual(values=c("#F8766D", "#B79F00"))
s3 = ggplot(sales, aes(x = purchase, y = product_rating, fill = purchase))+geom_boxplot()+ggtitle("Product Rating")+theme(legend.position = "none")
s3 = s3 + scale_fill_manual(values=c("#F8766D", "#B79F00"))
grid.arrange(s1,s2,s3, nrow = 1)

round(cor(sales[,1:3],sales[1:3]),2)
round(cor(sales[which(sales$purchase == "no"),1:3],sales[which(sales$purchase == "no"),1:3]),2)
round(cor(sales[which(sales$purchase == "yes"),1:3],sales[which(sales$purchase == "yes"),1:3]),2)

r3 = ggplot(sales %>% filter(purchase == "no"), aes(x = time_on_page_sec, y = num_product_reviews)) + geom_point(color =  "#F8766D")
r3 = r3 + annotate("text", x = 45, y = 80, label ="Cor = -0.16", fontface = 2)
r3 = r3 + annotate("rect", xmin = 40, xmax = 50, ymin = 75, ymax = 85, alpha = .2)

r4 = ggplot(sales %>% filter(purchase == "no"), aes(x = time_on_page_sec, y = product_rating)) + geom_point(color =  "#F8766D") +ylim(0,5)
r4 = r4 + annotate("text", x = 45, y = 4.5, label ="Cor = -0.48", fontface = 2)
r4 = r4 + annotate("rect", xmin = 40, xmax = 50, ymin = 4.2, ymax = 4.7, alpha = .2)

r5 = ggplot(sales %>% filter(purchase == "yes"), aes(x = time_on_page_sec, y = num_product_reviews)) + geom_point(color =  "#B79F00")
r5 = r5 + annotate("text", x = 45, y = 80, label ="Cor = -0.59", fontface = 2)
r5 = r5 + annotate("rect", xmin = 40, xmax = 50, ymin = 75, ymax = 85, alpha = .2)

r6 = ggplot(sales %>% filter(purchase == "yes"), aes(x = time_on_page_sec, y = product_rating)) + geom_point(color =  "#B79F00")
r6 = r6 + annotate("text", x = 45, y = 4.5, label ="Cor = -0.78", fontface = 2)
r6 = r6 + annotate("rect", xmin = 40, xmax = 50, ymin = 4.2, ymax = 4.7, alpha = .2)
# gridExtra::grid.arrange(r1,r3,r5,r2,r4,r6, ncol = 3)
gridExtra::grid.arrange(r3,r5,r4,r6, ncol = 2)

#only correlation that stands out is the correlation between time on page and product rating
#i.e. the higher the product rating the less time spent on page

#ftest of equal variances shows that none of the variances for the independent variables are equal between a purchase and no purchase group
var.test(
  sales$time_on_page_sec[sales$purchase == "yes"],
  sales$time_on_page_sec[sales$purchase == "no"],
  alternative = "two.sided"
)

var.test(
  sales$num_product_reviews[sales$purchase == "no"],
  sales$num_product_reviews[sales$purchase == "yes"],
  alternative = "two.sided"
)

var.test(
  sales$product_rating[sales$purchase == "yes"],
  sales$product_rating[sales$purchase == "no"],
  alternative = "two.sided"
)
#all Ftests revealed unequal varainces of independent variables in pre ab test data 
#this result lead to the following hypothesis tests:
(mean(sales$num_product_reviews[sales$purchase == "yes"]) - mean(sales$num_product_reviews[sales$purchase == "no"]))/sqrt(((1/length(sales$num_product_reviews[sales$purchase == "yes"]))*var(sales$num_product_reviews[sales$purchase == "yes"]))+((1/length(sales$num_product_reviews[sales$purchase == "no"]))*var(sales$num_product_reviews[sales$purchase == "no"])))

#is there a difference in pre ab test data of the average product rating between purchase == "yes" and purchase == "no" groups
(mean(sales$product_rating[sales$purchase == "yes"]) - mean(sales$product_rating[sales$purchase == "no"]))/sqrt(((1/length(sales$product_rating[sales$purchase == "yes"]))*var(sales$product_rating[sales$purchase == "yes"]))+((1/length(sales$product_rating[sales$purchase == "no"]))*var(sales$product_rating[sales$purchase == "no"])))

#is there a difference in pre ab test data of the average time spent on page between purchase == "yes" and purchase == "no" groups
(mean(sales$time_on_page_sec[sales$purchase == "yes"]) - mean(sales$time_on_page_sec[sales$purchase == "no"]))/sqrt(((1/length(sales$time_on_page_sec[sales$purchase == "yes"]))*var(sales$time_on_page_sec[sales$purchase == "yes"]))+((1/length(sales$time_on_page_sec[sales$purchase == "no"]))*var(sales$time_on_page_sec[sales$purchase == "no"])))

#hypothesis tests confirm what box plots show:
#the number of product ratings and product rating for purchases are significantly higher than than non purchases
#there is no difference in the amount of time spend on pages for each

#summary of number of prodcut reviews
summary(sales$num_product_reviews[sales$purchase == "yes"])
summary(sales$num_product_reviews[sales$purchase == "no"])

#creating number of product review categorical variable
sales$num_product_reviews_cat = ifelse(sales$num_product_reviews <= 30, 1, ifelse(sales$num_product_reviews <= 60,2,3))

s4 = ggplot(sales, aes(x = purchase, y = num_product_reviews, fill = purchase))+geom_boxplot() + scale_fill_manual(values=c("#F8766D", "#B79F00"))
labs <- c("30 or Fewer Reviews", "31 to 60 Reviews", "61 or More Reviews")
names(labs) <- c( "1", "2", "3")
s4 = s4 + facet_grid(~num_product_reviews_cat, labeller = labeller(num_product_reviews_cat = labs ))
s4 = s4 + theme(legend.position = "none")
s4 = s4 + ggtitle("Pre A/B Test")
s4

#summary of product ratings
summary(sales$product_rating[sales$purchase == "yes"])
summary(sales$product_rating[sales$purchase == "no"])

#creating product rating categorical variable
sales$product_rating_cat = ifelse(sales$product_rating <=2, 1,ifelse(sales$product_rating <= 3,2,3))

s5 = ggplot(sales, aes(x = purchase, y = product_rating, fill = purchase))+geom_boxplot() + scale_fill_manual(values=c("#F8766D", "#B79F00"))
labs <- c("Product Rating <= 2", "Product Rating Between 2 & 3", "Product Rating > 3")
names(labs) <- c( "1", "2", "3")
s5 = s5 + facet_grid(~product_rating_cat, labeller = labeller(product_rating_cat = labs ))
s5 = s5 + theme(legend.position = "none")
s5 = s5 + ggtitle("Pre A/B Test")
s5

#summary of time on page
summary(sales$time_on_page_sec)
summary(sales$time_on_page_sec[sales$purchase == "yes"])
summary(sales$time_on_page_sec[sales$purchase == "no"])





#to do a hypothesis test of ab test data, we will assume a binomial distribution where each visit has 2 outcomes possible and purchase = yes has a fixed probability

#to get the an estimate of the probability of a sale will randomly subset the sales data in groups of 500 and count purchases
#will repeat 30 times

i = 1
purchase_rate = c()
while(i <=30){
  set.seed(i)
  temp_indexes = sample(1:nrow(sales),500,replace = TRUE)
  temp = sales[temp_indexes,]
  purchase_rate[i] = nrow(temp[which(temp$purchase == "yes"),])/500
  i = i + 1
}


purchase_rate = as.data.frame(matrix(c(purchase_rate,1:30), ncol = 2))
colnames(purchase_rate) = c("purchase_rate","Subset")

ggplot(purchase_rate, aes(x = Subset, y = purchase_rate))+geom_point()+
  ggtitle("Purchase Rate in 30 Randomly Sampled Subsets")+
  geom_hline(yintercept = mean(purchase_rate$purchase_rate))+
  annotate("text",x = 4 ,y = mean(purchase_rate$purchase_rate)+0.0015, label ="Average Purchase Rate ~ 0.52", size = 4)+
  annotate("rect", xmin = -1 , xmax = 31, ymin = mean(purchase_rate$purchase_rate)-0.001, ymax =mean(purchase_rate$purchase_rate)+0.001, alpha = 0.2 )


###################################################################################################################
#Sales AB
###################################################################################################################
ab1 = ggplot(sales_ab, aes(x = purchase, y = time_on_page_sec, fill = purchase))+geom_boxplot()+ggtitle("Time (seconds) Spent on Page")+theme(legend.position = "none")+geom_boxplot()+facet_grid(~group)
ab1 = ab1 + scale_fill_manual(values=c("#F8766D", "#B79F00"))
ab2 = ggplot(sales_ab, aes(x = purchase, y = num_product_reviews, fill = purchase))+geom_boxplot()+ggtitle("Number of Product Reviews")+theme(legend.position = "none")+geom_boxplot()+facet_grid(~group)
ab2 = ab2 + scale_fill_manual(values=c("#F8766D", "#B79F00"))
ab3 = ggplot(sales_ab, aes(x = purchase, y = product_rating, fill = purchase))+geom_boxplot()+ggtitle("Product Rating")+theme(legend.position = "none")+geom_boxplot()+facet_grid(~group)
ab3 = ab3 + scale_fill_manual(values=c("#F8766D", "#B79F00"))
grid.arrange(ab1,ab2,ab3, nrow = 1)


table(sales_ab$group, sales_ab$purchase)

# 172/504 purchases in experimental group
# 138/496 purchases in control group

#hypothesis test statistic
#see ReadMe for details on calculation
# ((172/504)-(138/496))/sqrt(2*0.52*0.48)
# 0.08922914

# the test statistic or z score of 0.09  gives a pvalue of 1 - 0.5359 = 0.4641 which does not provide evidence to reject the null 
#i.e. overall the experimental group and control group performed nearly the same overall
#however both severly underperformed expectations given the sales data prior to our AB test


#creating same number of product reviews categorical variable in ab test data as in pre ab test data
sales_ab$num_product_reviews_cat = ifelse(sales_ab$num_product_reviews <= 30, 1, ifelse(sales_ab$num_product_reviews <= 60,2,3))

#creating same product rating categorical variable in ab test data as in pre ab test data
sales_ab$product_rating_cat = ifelse(sales_ab$product_rating <=2, 1,ifelse(sales_ab$product_rating <= 3,2,3))

nrow(sales[which(sales$num_product_reviews_cat == 1),])
nrow(sales[which(sales$num_product_reviews_cat == 1 & sales$purchase == "yes"),])
59/1081
nrow(sales[which(sales$num_product_reviews_cat == 2),])
nrow(sales[which(sales$num_product_reviews_cat == 2 & sales$purchase == "yes"),])
3666/6757
nrow(sales[which(sales$num_product_reviews_cat == 3),])
nrow(sales[which(sales$num_product_reviews_cat == 3 & sales$purchase == "yes"),])
1005/1162

#repeating same procedure for num prod reviews categories 2 & 3
#there were hardly any sales in group 1 so no need to conduct this test
i = 1
purchase_rate = c()
while(i <=30){
  set.seed(i)
  temp = sales[which(sales$num_product_reviews_cat == 2),]
  temp_indexes = sample(1:nrow(temp),400,replace = TRUE)
  temp = temp[temp_indexes,]
  purchase_rate[i] = nrow(temp[which(temp$purchase == "yes"),])/400
  i = i + 1
}
#mean purchase rate in num prod cat 2 = 0.54
#both exp and control grp severly underperformed
#test statistic for comparing purchase rate in experimental and control groups within num prod reviews categories 2
#found no difference in purchase rate between experimental and control group
((131/390)-(103/373))/sqrt(2*0.54*0.46)

i = 1
purchase_rate = c()
while(i <=30){
  set.seed(i)
  temp = sales[which(sales$num_product_reviews_cat == 3),]
  temp_indexes = sample(1:nrow(temp),50,replace = TRUE)
  temp = temp[temp_indexes,]
  purchase_rate[i] = nrow(temp[which(temp$purchase == "yes"),])/50
  i = i + 1
}
#mean purchase rate in num prod cat 3 = 0.87
#both exp and control grp severly underperformed
#test statistic for comparing purchase rate in experimental and control groups within num prod reviews categories 3
#found no difference in purchase rate between experimental and control group
((41/48)-(34/50))/sqrt(2*0.87*0.13)

nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 1 & sales_ab$group == "experimental"),])
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 1 & sales_ab$group == "experimental" & sales_ab$purchase == "yes"),])
0/66
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 1 & sales_ab$group == "control"),])
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 1 & sales_ab$group == "control" & sales_ab$purchase == "yes"),])
1/73
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 2 & sales_ab$group == "experimental"),])
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 2 & sales_ab$group == "experimental" & sales_ab$purchase == "yes"),])
131/390
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 2 & sales_ab$group == "control"),])
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 2 & sales_ab$group == "control" & sales_ab$purchase == "yes"),])
103/373
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 3 & sales_ab$group == "experimental"),])
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 3 & sales_ab$group == "experimental" & sales_ab$purchase == "yes"),])
41/48
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 3 & sales_ab$group == "control"),])
nrow(sales_ab[which(sales_ab$num_product_reviews_cat == 3 & sales_ab$group == "control" & sales_ab$purchase == "yes"),])
34/50


nrow(sales[which(sales$product_rating_cat == 1),])
nrow(sales[which(sales$product_rating_cat == 1 & sales$purchase == "yes"),])
137/1603
nrow(sales[which(sales$product_rating_cat == 2),])
nrow(sales[which(sales$product_rating_cat == 2 & sales$purchase == "yes"),])
1935/4686
nrow(sales[which(sales$product_rating_cat == 3),])
nrow(sales[which(sales$product_rating_cat == 3 & sales$purchase == "yes"),])
2658/2711

#repeating same procedure for prod rev cats 2 & 3
#hardly any purchases in cat 1 so no need to test
i = 1
purchase_rate = c()
while(i <=30){
  set.seed(i)
  temp = sales[which(sales$product_rating_cat == 2),]
  temp_indexes = sample(1:nrow(temp),300,replace = TRUE)
  temp = temp[temp_indexes,]
  purchase_rate[i] = nrow(temp[which(temp$purchase == "yes"),])/300
  i = i + 1
}
#mean(purchase_rate)
#mean purchase rate in num prod cat 2 = 0.42
#both exp and control grp severly underperformed
#test statistic for comparing purchase rate in experimental and control groups within product rating categories 2
#found no difference in purchase rate between experimental and control group
((64/276)-(61/298))/sqrt(2*0.42*0.58)

i = 1
purchase_rate = c()
while(i <=30){
  set.seed(i)
  temp = sales[which(sales$product_rating_cat == 3),]
  temp_indexes = sample(1:nrow(temp),100,replace = TRUE)
  temp = temp[temp_indexes,]
  purchase_rate[i] = nrow(temp[which(temp$purchase == "yes"),])/100
  i = i + 1
}
#mean(purchase_rate)
#mean purchase rate in num prod cat 3 = 0.97
#both exp and control grp severly underperformed
#test statistic for comparing purchase rate in experimental and control groups within product rating categories 3
#found no difference in purchase rate between experimental and control group
((105/110)-(77/79))/sqrt(2*0.97*0.03)


nrow(sales_ab[which(sales_ab$product_rating_cat == 1 & sales_ab$group == "experimental"),])
nrow(sales_ab[which(sales_ab$product_rating_cat == 1 & sales_ab$group == "experimental" & sales_ab$purchase == "yes"),])
3/118
nrow(sales_ab[which(sales_ab$product_rating_cat == 1 & sales_ab$group == "control"),])
nrow(sales_ab[which(sales_ab$product_rating_cat == 1 & sales_ab$group == "control" & sales_ab$purchase == "yes"),])
0/119
nrow(sales_ab[which(sales_ab$product_rating_cat == 2 & sales_ab$group == "experimental"),])
nrow(sales_ab[which(sales_ab$product_rating_cat == 2 & sales_ab$group == "experimental" & sales_ab$purchase == "yes"),])
64/276
nrow(sales_ab[which(sales_ab$product_rating_cat == 2 & sales_ab$group == "control"),])
nrow(sales_ab[which(sales_ab$product_rating_cat == 2 & sales_ab$group == "control" & sales_ab$purchase == "yes"),])
61/298
nrow(sales_ab[which(sales_ab$product_rating_cat == 3 & sales_ab$group == "experimental"),])
nrow(sales_ab[which(sales_ab$product_rating_cat == 3 & sales_ab$group == "experimental" & sales_ab$purchase == "yes"),])
105/110
nrow(sales_ab[which(sales_ab$product_rating_cat == 3 & sales_ab$group == "control"),])
nrow(sales_ab[which(sales_ab$product_rating_cat == 3 & sales_ab$group == "control" & sales_ab$purchase == "yes"),])
77/79

#no statistical difference anywhere i.e button color did not make an impact in sales
