library(tidyverse)
x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")
sort(x1)
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
y1 <- factor(x1, levels = month_levels)
sort(y1)

y2 <- parse_factor(x2, levels = month_levels)

f1 <- factor (x1, levels = unique (x1))
f1

f2 <- x1 %>% factor() %>% fct_inorder()

levels(f1)
levels(f2)

gss_cat %>% count(race)

ggplot(gss_cat, aes(race)) + geom_bar() +scale_x_discrete(drop = FALSE) 

ggplot(gss_cat, aes(rincome)) + geom_bar() +scale_x_discrete(drop = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust =1))

ggplot(gss_cat, aes(rincome)) + geom_bar() +scale_x_discrete(drop = FALSE) +
  theme(axis.text.x = element_text(angle = 45, hjust =1))

ggplot(gss_cat, aes(rincome)) + geom_bar() +scale_x_discrete(drop = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust =1)) + coord_flip()
ggplot(gss_cat, aes(relig)) + geom_bar()

ggplot(gss_cat, aes(partyid)) + geom_bar()

gss_cat %>%
  count(relig, denom) %>%
  ggplot(aes(x = relig, y = denom, size = n)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90))


relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

relig_summary
ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

#Factor reorder
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()


rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()

ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")


gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

gss_cat %>% count(partyid)
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(relig = relig) %>%
  count(relig)

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)
