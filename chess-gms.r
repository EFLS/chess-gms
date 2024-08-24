# Chess Grandmasters
# EFLS
#
# An analysis of all Chess Grandmaster titles as listed on Wikipedia

library("tidyverse")
library("rvest")    # To turn html into a table
library("forcats")  # To manage categorical variables

#############
#* READ DATA
#
# Fetch info from Wikipedia
wp_url <- "https://en.wikipedia.org/wiki/List_of_chess_grandmasters"
wp_tables <- wp_url %>%
  read_html() %>%        # Read HTML page
  html_table()          # Store all tables
#
# We need the first table, which contains the list of all GMs
gm_list <- wp_tables[[1]]

# Turn sex into a factor
gm_list$Sex <- factor(gm_list$Sex)

# Indicate which players are deceased
# They have (at least) a digit in the "Died" column
gm_list <- gm_list %>%
  mutate(Deceased = str_detect(Died, "\\d"))

glimpse(gm_list)

##########################
#* GM TITLES BY FEDERATION
#
# Note: Federation registered at time title was awarded

# Create a new table, with count grouped by federation
gm_federations <- gm_list %>%
  group_by(Federation) %>%
  summarize(count = n())

ggplot(gm_federations,
       aes(x = reorder(Federation, desc(count)),
           y = count, label = count)) +
  geom_col(fill = "slategrey") +
  geom_text(size = 2, vjust = -.5) +
  guides(x = guide_axis(angle = 90)) +
  labs(title = "Chess Grandmaster titles by federation",
       subtitle = "Federation membership at time title was awarded",
       x = "Federation",
       y = "Number of GM titles")

ggsave("graphs/federations.pdf")

####################
#* GM TITLES BY YEAR
#
# Create a new table with number of titles awarded grouped by year
gm_years <- gm_list %>%
  # Drop the current (i.e. highest) year, as it contains incomplete
  # data and thus is not relevant to compare with other years.
  filter(TitleYear < max(TitleYear)) %>%
  group_by(TitleYear) %>%
  summarize(count = n())

#** Plot: Number of GM titles awarded by year
ggplot(data = gm_years,
       aes(x = TitleYear, y = count,
           label = count)) +
  geom_col(width = .9,
           fill = "slategray") +
  # X axis: add mark every 5 years
  scale_x_continuous(breaks = seq(min(gm_years$TitleYear),
                                  max(gm_years$TitleYear),
                                  by = 5),
                     minor_breaks = NULL) +
  # Add labels to each year with value
  geom_text(size = 3, vjust = -.3) +
  # Chart labels
  labs(title = "FIDE Chess Grandmaster titles awarded each year",
       subtitle = "Data from Wikipedia",
       x = "Year",
       y = "Number of GM titles awarded")

ggsave("graphs/by-year.pdf")

#** Plot: Number of GM titles by year with highest year highlighted
# First store year with highest number of titles awarded
gm_year_highest <- filter(gm_years, count == max(gm_years$count))[[1,1]]
#
# Generate a vector of colours for the bars.
cust_bar_colours <- ifelse(gm_years$TitleYear == gm_year_highest,
                           "maroon",
                           "darkgray")
# The plot itself
ggplot(data = gm_years,
       aes(x = TitleYear, y = count, label = count,
           # Note: the fill needs to be set as a factor
           # so that it can  be overwritten later
           fill = factor(TitleYear))) +
  geom_col(width = .9) +
  # Overwriting the fill values with the custom colours
  scale_fill_manual(values = cust_bar_colours, guide = "none") +
  # Chart labels
  labs(title = "Chess Grandmaster titles by year",
       subtitle = "Data from Wikipedia",
       x = "Year",
       y = "Number of GM titles awarded")

ggsave("graphs/by-year-highlight.pdf")

#** Plot total number of GMs
ggplot(data = gm_years,
       aes(x = TitleYear, y = cumsum(count))) +
  geom_line(linewidth = 1.5, colour = "Maroon") +
  geom_point(size = .5, colour = "White") +
  labs(title = "Chess Grandmaster titles",
       subtitle = "Cummulative number of GM titles awarded",
       x = "Year",
       y = "Total number of GM titles")

ggsave("graphs/total-gms.pdf")


