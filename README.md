# Semiconductor Trade Policy Analysis

An analysis of the Joint Ministerial Statement on Addressing Structural Excess Capacity and Production, focused on how U.S. trade policy has responded to foreign excess capacity in semiconductors.

## Research Question

What U.S. trade policy responses to foreign excess capacity in semiconductors and other related electronic components have best protected investment, production, and exports, and at what cost to U.S. chip buyers?

This repository is a first step toward that question. It looks at how U.S. semiconductor capacity utilization changed before and after five major trade-policy actions.

## Scope

The Joint Ministerial Statement identifies five industries of concern:

1. Autos and Electric Vehicles (EVs)
2. Batteries
3. Chemicals
4. Foundational Semiconductors
5. Solar Panels

This project looks only at semiconductors and related electronic components.

## Policy Episodes

The analysis covers five U.S. trade actions, which together span the main types of response to foreign excess capacity:

1. 1986 U.S.-Japan Semiconductor Agreement (September 1986): a negotiated agreement on chip pricing and market access
2. 1993 anti-dumping duty on Korean memory chips (May 1993)
3. 2003 countervailing duty on Hynix (August 2003): a duty aimed at foreign subsidies
4. 2018 Section 301 tariffs on Chinese goods (July 2018)
5. 2025 Section 301 action on Chinese legacy chips (window starts January 2026)

## Data

All data comes from the Federal Reserve Bank of St. Louis (FRED), monthly:

- Capacity utilization, semiconductors and other electronic components (CAPUTLG3344S): https://fred.stlouisfed.org/series/CAPUTLG3344S
- Industrial production, semiconductors and other electronic components (IPG3344S): https://fred.stlouisfed.org/series/IPG3344S
- All employees, semiconductors and electronic components (CES3133440001): https://fred.stlouisfed.org/series/CES3133440001
- Federal funds effective rate (FEDFUNDS): https://fred.stlouisfed.org/series/fedfunds

Capacity utilization is the share of an industry's potential output that is actually being produced. A healthy rate is generally between 79% and 85%. Rates well below that range can signal excess capacity.

## Method

1. Load the four FRED series and rename their columns to a common format (date plus one value column each).
2. Join them into a single monthly dataset by date.
3. Create a log of industrial production. Fed output data is adjusted for chip quality, so it grows exponentially; changes in the log are roughly percent changes.
4. Build an event window around each policy: 3 years before and 3 years after, with each month labeled by its distance from the policy start and as "Before" or "After."
5. Plot capacity utilization for each episode in its own panel, with a dashed line at the policy start and separate trend lines fitted to the 12 months before and the 12 months after.

## How to Run

1. Install R and the tidyverse package.
2. Download each FRED series above as a CSV and save it in the project folder. The capacity utilization file is saved as SemiConductorCU.csv; the others keep their FRED series names (FEDFUNDS.csv, IPG3344S.csv, CES3133440001.csv).
3. Run the R script. It prints a summary of the cleaned data and draws the before-and-after graph.

## Limitations

- Small sample size: five policy episodes. The conclusions suggest likely mechanisms; they are not precise estimates.
- There is no comparison group yet, so changes around a policy date may reflect the semiconductor business cycle rather than the policy itself.
- The data covers a broad category (NAICS 3344), which includes circuit boards and other components, not just chips. Policies aimed at memory chips may be diluted in the aggregate.
- Capacity utilization alone can be read two ways. A drop can mean new capacity was built or that output fell, so it needs to be read alongside output and employment.
- The 2025 action has only a few months of "after" data, and its initial tariff rate was 0%.

## Next Steps

- Graph output and employment alongside capacity utilization.
- Add manufacturing-wide capacity utilization as a benchmark to separate policy effects from the business cycle.
- Add semiconductor price data to measure the cost to U.S. chip buyers.
- Add export data to measure effects on U.S. exports.
- Report numeric before-and-after changes for each episode, not just graphs.

## Status

In progress.
