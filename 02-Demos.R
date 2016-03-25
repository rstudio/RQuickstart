# R

log10(100)

library(ggplot2)

View(mpg)
View(iris)
View(mtcars)

?mpg
?ggplot
?geom_point

# Visualizations with ggplot2

## plot

plot(iris$Sepal.Width, iris$Sepal.Length)

## ggplot2

ggplot(iris, aes(Sepal.Width, Sepal.Length)) + 
  geom_point()

ggplot(iris, aes(Sepal.Width, Sepal.Length)) + 
  geom_point(aes(shape = Species, color = Species))

ggplot(iris, aes(Sepal.Width, Sepal.Length)) + 
  geom_point(aes(shape = Species, color = Species)) +
  theme_bw()

ggplot(iris, aes(Sepal.Width, Sepal.Length)) + 
  geom_point(aes(shape = Species, color = Species)) +
  theme_bw() + 
  geom_smooth(aes(shape = Species, color = Species), method = lm, se = FALSE) 

ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  geom_rug(aes(color = Species), position = "jitter") + 
  stat_density2d(aes(alpha = ..level.., fill = Species), geom = "polygon") +
  theme_bw() +
  scale_alpha(range = c(0.05, 0.5))

ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  geom_rug(aes(color = Species), position = "jitter") + 
  stat_density2d(aes(alpha = ..level.., fill = Species), geom = "polygon") +
  theme_bw() +
  scale_alpha(range = c(0.05, 0.5)) +
  facet_wrap( ~ Species)

## ggplot

ggplot(mpg, aes(displ, hwy))
ggplot(mpg, aes(displ, hwy)) + geom_point()

# Aesthetics

ggplot(mpg) + geom_point(aes(x = displ, y = hwy, color = class))
ggplot(mpg) + geom_point(aes(x = displ, y = hwy, size = class))
ggplot(mpg) + geom_point(aes(x = displ, y = hwy, shape = class))
ggplot(mpg) + geom_point(aes(x = displ, y = hwy, alpha = class))

## Mapping vs. setting

ggplot(mpg, aes(displ, hwy)) + geom_point(mapping = aes(color = class))
ggplot(mpg, aes(displ, hwy)) + geom_point(color = "green")
ggplot(mpg, aes(displ, hwy)) + geom_point(size = 5)
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 3)
ggplot(mpg, aes(displ, hwy)) + geom_point(alpha = 0.5)

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(color = class))
ggplot(mpg, aes(displ, hwy)) + geom_point(color = "green")

# Geoms

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_smooth(aes(x = displ, y = hwy))
ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  geom_smooth(aes(x = displ, y = hwy))

ggplot(mpg) + geom_point(aes(class, hwy))

## Global vs. Local

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(method = lm) +
  geom_point(aes(color = cyl), data = mpg[1:10, ])

ggplot(mpg, aes(displ, hwy, color = class)) + 
  geom_smooth(method = lm) +
  geom_point()

ggplot(mpg, aes(displ, hwy)) + 
  geom_smooth(method = lm) +
  geom_point(aes(color = class))

ggplot(mpg, aes(displ, hwy)) + 
  geom_point()

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +
  geom_point(data = mpg[1:50,], color = "green")

# Grammar of Graphics

# Data Wrnagling with dplyr

library(babynames)
View(babynames)

my_name <- filter(bnames, name == "Garrett", sex == "M")
my_name <- select(my_name, name, year, prop)
ggplot(my_name) + 
  geom_line(aes(x = year, y = prop))

## dplyr

library(dplyr)
?tbl
?select
?filter
?left_join
?mutate
?summarise
?group_by
?`%>%`

## tbl's

babynames
tbl_df(babynames)

bnames <- tbl_df(babynames)

## Verbs

arrange(storms, wind)
arrange(storms, desc(wind))

select(storms, storm, pressure)

filter(storms, wind == 50)
filter(storms, wind >= 50)
filter(storms, wind > 60, wind == 40)

View(births)

left_join(songs, artists, by = "name")

mutate(storms, ratio = pressure / wind)

summarise(pollution, median = median(amount))
summarise(pollution, mean = mean(amount), sum = sum(amount), n = n())
p <- group_by(pollution, city)
summarise(p, mean = mean(amount), sum = sum(amount), n = n())

# %>%

p <- group_by(pollution, city)
summarise(p, mean = mean(amount), sum=sum(amount), n=n())
my_name <- filter(bnames, name == "Garrett", sex == "M")
my_name <- select(my_name, name, year, prop)
my_name <- left_join(my_name, boys, by = "year")
my_name <- mutate(my_name, n = round(prop * births))

summarize(pollution, median = median(amount))
pollution %>% summarize(median = median(amount))

bnames %>%
  left_join(births, by = c("year", "sex")) %>%
  mutate(n = round(prop * births)) %>%
  select(name, sex, year, n) %>%
  filter(!is.na(n)) %>%
  group_by(name, sex) %>%
  summarise(total = sum(n)) %>%
  arrange(desc(total))

tmp1 <- left_join(bnames, births, by = c("year", "sex"))
tmp2 <- mutate(tmp1, n = round(prop * births))
tmp3 <- select(tmp2, name, sex, year, n) 
tmp4 <- filter(tmp3, !is.na(n)) 
tmp5 <- group_by(tmp4, name, sex)
tmp6 <- summarise(tmp5, total = sum(n))
tmp7 <- arrange(tmp6, desc(total))

arrange(
  summarise(
    group_by(
      filter(
        select(
          mutate(
            left_join(bnames, births, by = c("year", "sex")), 
            n = round(prop * births)
          ), name, sex, year, n
        ), !is.na(n)
      ), name, sex
    ), total = sum(n)
  ), desc(total)
)








