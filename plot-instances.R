#install.packages(c("ggplot2", "tidyverse", "plyr", "stringr", "scales", "duckdb"))

library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)
library(scales)
library(duckdb)

con <- dbConnect(duckdb())
dbExecute(con, "CREATE TABLE result AS FROM '*.csv'")
dbExecute(con, "CREATE TABLE aggregated AS SELECT instance, query, median(time) AS time FROM results GROUP BY ALL");
aggregated <- dbGetQuery(con, "FROM aggregated")

ggplot(aggregated, aes(x=query, fill=instance, col=instance)) +
  geom_col(aes(y=time, col=instance), position="dodge", width=0.75) +
  scale_x_continuous(breaks=seq(1, 22)) +
  xlab("Query") +
  ylab("Execution time [s]") +
  theme_bw()

ggsave("tpc-sf100-instances.pdf", width=10, height=6)
