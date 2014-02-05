################################
#creates simple graph of populations
#scraped with file get-data.py


library("ggplot2") 

data <- read.csv("citypop.csv")
x <- ggplot(data, aes(year,rank,colour= city))
x <- x + geom_line()
x <- x + scale_y_reverse()

print(x)
