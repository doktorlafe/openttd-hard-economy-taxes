/* Quarterly taxes and fees. Called once per company from the main loop. */
function Economy_Settle(c)
{
  if (GSCompany.ResolveCompanyID(c) == GSCompany.COMPANY_INVALID) return;

  local q = GSCompany.CURRENT_QUARTER + 1; // last full quarter
  local income = GSCompany.GetQuarterlyIncome(c, q);
  local expenses = GSCompany.GetQuarterlyExpenses(c, q);
  local value = GSCompany.GetQuarterlyCompanyValue(c, q);

  local profit = income + expenses; // expenses are stored as negative
  local tax = profit > 0 ? profit * GSController.GetSetting("profit_tax") / 100 : 0;
  local wealth = value > 0 ? value * GSController.GetSetting("wealth_tax") / 1000 : 0;
  local over = income > 0 ? income * GSController.GetSetting("overhead") / 100 : 0;

  local fixed = 0;
  {
    local mode = GSCompanyMode(c);
    local vehicles = GSVehicleList().Count();
    local stations = GSStationList(GSStation.STATION_ANY).Count();
    fixed = vehicles * GSController.GetSetting("vehicle_fee") + stations * GSController.GetSetting("station_fee");
  }

  // cash tax: a share of the balance above the tax-free amount (divided first, so no overflow)
  local bank = GSCompany.GetBankBalance(c);
  local free = GSController.GetSetting("cash_tax_threshold") * 1000;
  local cash = bank > free ? ((bank - free) / 1000) * GSController.GetSetting("cash_tax_rate") : 0;

  local total = tax + wealth + over + fixed + cash;
  GSLog.Info("company " + c + ": income=" + income + " expenses=" + expenses + " value=" + value + " bank=" + bank +
    " | tax=" + tax + " wealth=" + wealth + " overhead=" + over + " fixed=" + fixed + " cash=" + cash + " total=" + total);
  if (total <= 0) return;

  GSCompany.ChangeBankBalance(c, -total, GSCompany.EXPENSES_OTHER, GSMap.TILE_INVALID);
  // Plain string: does not depend on the language file being loaded.
  if (!GSController.GetSetting("economy_news")) return;
  local text = "Quarterly bill - profit tax: " + tax + ", wealth tax: " + wealth + ", overhead: " + over +
    ", fleet and station fees: " + fixed + ", cash tax: " + cash + ". Total: " + total;
  try {
    GSNews.Create(GSNews.NT_GENERAL, text, c, GSNews.NR_NONE, 0);
  } catch (e) {
    GSLog.Warning("Could not send news: " + e);
  }
}
