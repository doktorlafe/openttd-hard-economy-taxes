# Hard Economy Taxes – Game Script for OpenTTD

A lightweight version of Hard Economy with only the economy part (OpenTTD 15.x, API 15). Every quarter it charges
each company a profit tax, a wealth tax, overhead, fees for vehicles and stations, and a cash tax.

## Settings
| Setting | Easy / Medium / Hard | Range | Meaning |
|---|---|---|---|
| Profit tax | 10 / 25 / 40 | 0–90 | % of quarterly profit (0 when at a loss) |
| Wealth tax | 1 / 3 / 6 | 0–30 | tenths of a percent of company value per quarter |
| Overhead | 3 / 8 / 15 | 0–50 | % of quarterly income |
| Fee per vehicle | 20 / 60 / 120 | 0–2000 | fee per vehicle per quarter |
| Fee per station | 50 / 150 / 300 | 0–5000 | fee per station per quarter |
| Cash tax: tax-free balance | 20000 / 5000 / 2000 | 0–1,000,000 | in thousands; the balance above this is taxed |
| Cash tax: rate | 5 / 10 / 20 | 0–100 | per mille of the balance above the threshold per quarter |
| Economy news | on | 0/1 | show the bill breakdown as an in-game news message |

## Calculation
```
profit   = income + expenses
tax      = profit > 0 ? profit × profit_tax / 100 : 0
wealth   = company value × wealth_tax / 1000
overhead = income × overhead / 100
fixed    = vehicles × vehicle_fee + stations × station_fee
cash     = ((balance − threshold) / 1000) × cash_tax_rate
total    = tax + wealth + overhead + fixed + cash
```
The amount is charged to the **Other** row in the finances window. AI companies are taxed too.
