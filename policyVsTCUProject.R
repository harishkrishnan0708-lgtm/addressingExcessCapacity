library(tidyverse)

#semiconductor Capacity Utilization
semiConductorCU <- read_csv("SemiConductorCU.csv")
#View(semiConductorCU)
#federal reserve monetary policy
fedFunds <- read_csv("FEDFUNDS.csv")
#View(fedFunds)
#semiconductor industrial production
semiIP   <- read_csv("IPG3344S.csv")
#View(semiIP)
#semiconductor employment
semiEmp  <- read_csv("CES3133440001.csv")
#View(semiEmp)

#now we must standardize the columns to date and then the unit we are looking for
semiCU   <- semiConductorCU   |> rename(date = 1, semiCUR  = 2)
fedFunds <- fedFunds |> rename(date = 1, fedRate  = 2)
semiIP   <- semiIP   |> rename(date = 1, semiOutput  = 2)
semiEmp  <- semiEmp  |> rename(date = 1, semiJobs = 2)

#combining everything into one dataframe
combinedDataFrame <- semiCU |> 
  left_join(semiIP,   by = "date") |>
  left_join(semiEmp,  by = "date") |>
  left_join(fedFunds, by = "date")

#making a logOut variable out of the semiOut variable, because Fed semiconductor output
#is adjusted for chip quality, so it grows exponentially as chips get stronger in later years
#changes in logOut ≈ percent changes in output.
combinedDataFrame <- combinedDataFrame |> mutate(logOut = log(semiOutput))
cleanUSData <- combinedDataFrame |> drop_na(semiCUR, fedRate, semiOutput, semiJobs)
#View(cleanUSData)
summary(cleanUSData)
nrow(cleanUSData)

# Policy timeline
policies <- tibble(
  policyDate = as.Date(c("1986-09-01", "1993-05-01", "2003-08-01",
                         "2018-07-01", "2026-01-01")),
  episode    = c("1986 U.S. - Japan Agreement", "1993 AD Duty on Korea",
                 "2003 CVD on Hynix", "2018 Sec. 301 Tariffs",
                 "2025 Sec. 301 Legacy Chips")
)

# Keep 3 years before and after each policy
window <- 3

episodeData <- policies |>
  cross_join(combinedDataFrame) |>
  filter(date >= policyDate - years(window),
         date <= policyDate + years(window)) |>
  mutate(monthsFromPolicy = interval(policyDate, date) %/% months(1),
         period  = if_else(date < policyDate, "Before", "After"),
         period  = factor(period, levels = c("Before", "After")),
         episode = factor(episode, levels = policies$episode)) |>
  drop_na(semiCUR)

# Graph
ggplot(data = episodeData, aes(x = monthsFromPolicy,
                               y = semiCUR,
                               color = period)) +
  geom_point() +
  geom_vline(xintercept = 0, linetype = "dashed") +
  scale_color_brewer(palette = "Set2") +
  facet_wrap(~episode, scales = "free_x") +
  labs(x = "Months From Policy Start",
       y = "Capacity Utilization (%)") +
  ggtitle("U.S. Semiconductor Capacity Utilization Before and After Trade-Policy Actions") +
  geom_smooth(data = ~ filter(.x, abs(monthsFromPolicy) <= 12),
              aes(group = period), method = "lm", se = FALSE, linewidth = 0.8) +
  theme_minimal() +
  theme(legend.position = "none",
        panel.grid = element_blank())
