#  How would you replace this scatterplot with one that draws 
#  boxplots? Try out your best guess.
#  ggplot(mpg) + geom_point(aes(class, hwy))
ggplot(data = mpg) + geom_boxplot(aes(x = displ, y = hwy))


#  How would you create this plot? 
#  Hint: histograms do not require a y aesthetic.
ggplot(data = mpg) + geom_histogram(aes(x = hwy))


#  Make these plots:
#    
#  Plot 1
#  Data = diamonds
#  geom = count
#  x = cut
#  y = color
ggplot(diamonds, aes(x = cut, y = color)) +
  geom_count()

#  Plot 2
#  Data = diamonds
#  geom = point
#  x = carat
#  y = price
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()


#  Create a data set that contains only rows with your name and sex, 
#  and only the columns name, year, and prop.
#  Then plot the data with 
#  ggplot(<data name here>) + 
#    geom_line(aes(x = year, y = prop))
library(dplyr)
my_name <- filter(bnames, name == "Garrett", sex == "M")
my_name <- select(my_name, name, year, prop)
ggplot(my_name) + 
  geom_line(aes(x = year, y = prop))


#  1. filter() births to just rows with your sex.
boys <- filter(births, sex == "M")

#  2. Join the result to my_name by year.
my_name <- left_join(my_name, boys, by = "year")

#  3. Add a new variable to the data: n = round(prop * births)
my_name <- mutate(my_name, n = round(prop * births))

#  4. Save the new data. Then plot n over time.
ggplot(my_name) + geom_line(aes(x = year, y = n))


#  Work with a neighbor to determine what each line of the 
#  code below does.
# Take bnames and 
bnames %>% 
  # join to it births by year and sex.
  left_join(births, by = c("year", "sex")) %>%
  # Then use the result to calculate a new variable, n 
  mutate(n = round(prop * births)) %>%
  # Select from that four columns: name, sex, year, and n
  select(name, sex, year, n) %>% 
  # Filter out rows where n = NA
  filter(!is.na(n)) %>% 
  # Then group by the combination of name and gender
  group_by(name, sex) %>%
  # Calculate the total number of children for each group
  summarise(total = sum(n)) %>% 
  # Then order the groups from the largest total to the smallest
  arrange(desc(total))



