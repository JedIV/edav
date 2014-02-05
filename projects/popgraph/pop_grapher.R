################################
#creates simple graph of populations
#scraped with file get-data.py


library("ggplot2") 
data <- read.csv("citypop.csv")
total_pop <- read.csv("us_total_pop.csv")

total_pop$totalpop <- total_pop$totalpop*1000

data <- merge(data,total_pop, by = "year")

data$prop_pop <- data$pop/data$totalpop

y <- ggplot(data, aes(x = year,y = prop_pop,colour= city, alpha=(21-rank)/20))
y <- y + geom_line()
y <- y + guides(col = guide_legend(ncol = 3, byrow= TRUE))
print(y)

x <- ggplot(data, aes(x = year,y = rank,colour= city))
x <- x + geom_line()
x <- x + scale_y_reverse()
x <- x + guides(col = guide_legend(ncol = 3, byrow= TRUE))

print(x)
