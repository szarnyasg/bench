#install.packages(c("ggplot2", "tidyverse", "plyr", "stringr", "scales", "duckdb"))

library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)
library(scales)
library(duckdb)

con <- dbConnect(duckdb("results.db"))
dbExecute(con, "CREATE OR REPLACE TABLE results AS FROM 'results/*.csv'")
dbExecute(con, "CREATE OR REPLACE TABLE aggregated AS
  SELECT
    replace(instance, 'large', 'l') AS instance,
    CASE instance[3] WHEN 'i' THEN 'intel' WHEN 'a' THEN 'amd' WHEN 'g' THEN 'graviton' END AS architecture,
    query,
    median(time) AS time FROM results GROUP BY ALL");
aggregated <- dbGetQuery(con, "FROM aggregated")

aggregated$instance <-
  factor(aggregated$instance, levels =
            c("c7a.8xl", "m7a.4xl", "r7a.2xl",
              "c7g.8xl", "m7g.4xl", "r7g.2xl",
              "c6i.8xl", "m6i.4xl", "r6i.2xl"
              ), ordered=TRUE)

ggplot(aggregated, aes(x=instance, y=time, fill=architecture, col=architecture)) +
  geom_col(position="dodge", width=0.75) +
  facet_wrap(~query, ncol=3, scales="free") +
  ylab("Execution time [s]") +
  theme_bw() +
  theme(legend.position="top")
  #theme(axis.text.x = element_text(angle = 50, vjust = 0.5))

ggsave("tpc-sf100-instances.pdf", width=18, height=14)
