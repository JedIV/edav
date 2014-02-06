################################
#Creates simple graph of populations
#And more advanced ranking graphs
#Scraped with file get-data.py
#Jed Dougherty
#Started: 2014-02-04

library(ggplot2)
library(plyr)
data <- read.csv("citypop.csv")
total_pop <- read.csv("us_total_pop.csv")

total_pop$totalpop <- total_pop$totalpop*1000

data <- merge(data,total_pop, by = "year")

data$prop_pop <- data$pop/data$totalpop

y <- ggplot(data, aes(x = year,y = prop_pop,
                      colour= city, alpha=(21-rank)/20))
y <- y + geom_line()
y <- y + guides(col = guide_legend(ncol = 3, byrow= TRUE))
print(y)

x <- ggplot(data, aes(x = year,y = rank,colour= city))
x <- x + geom_line()
x <- x + scale_y_reverse()
x <- x + guides(col = guide_legend(ncol = 3, byrow= TRUE))
print(x)

#finds the highest and lowest ranking for each city
min_rank <- aggregate(rank ~ city, data, min)
max_rank <- aggregate(rank ~ city, data, max)

#finds all the dates at which cities have these rankings
city_high_rank <- merge(data,min_rank, by = c("city","rank"))
city_low_rank <- merge(data,max_rank, by = c("city","rank"))

#combines cities and dates
city_high_lows <- rbind(city_high_rank,city_low_rank)

#grabs the min and max dates to find displacement
min_date <- aggregate(year ~ city, city_high_lows, min)
max_date <- aggregate(year ~ city, city_high_lows, max)
city_first_last <- rbind(min_date,max_date)

#put into one dataset
limited <- merge(city_high_lows,city_first_last, by = c("city","year"))

#limit to uniques
limited <- unique(limited)
limited <- limited[with(limited, order(city,year)),]
limited_rank <- ddply(limited, .(city),summarize,-diff(rank))

names(limited_rank) <- c("city","rank_change")

limited_rank <- limited_rank[with(limited_rank, order(rank_change)),]
limited_rank$city <- factor(limited_rank$city, levels=unique(as.character(limited_rank$city)) )

#Rankings over time
ranking <- ggplot(limited_rank,aes(city,rank_change))
ranking <- ranking + geom_bar(stat="identity")
ranking <- ranking + coord_flip()
ranking <- ranking + ggtitle("Cities are Always Rising and Falling In America")
ranking <- ranking + ylab("Max Change over Time") + xlab("City")
print(ranking)

#Shows Year At Which Cities First Hit Their Peak Rank

