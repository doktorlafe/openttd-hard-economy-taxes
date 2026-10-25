class HardEconomyTaxes extends GSInfo {
  function GetAuthor()      { return "lafe"; }
  function GetName()        { return "Hard Economy Taxes"; }
  function GetDescription() { return "Makes money harder to earn: profit tax, wealth tax and overhead, charged every quarter."; }
  function GetVersion()     { return 1; }
  function GetDate()        { return "2026-10-25"; }
  function CreateInstance() { return "HardEconomyTaxes"; }
  function GetShortName()   { return "HECT"; }
  function GetAPIVersion()  { return "15"; }
  function GetURL()         { return ""; }

  function GetSettings() {
    AddSetting({name = "profit_tax", description = "Profit tax (% of quarterly profit)",
      easy_value = 10, medium_value = 25, hard_value = 40, custom_value = 25,
      flags = CONFIG_INGAME, min_value = 0, max_value = 90});
    AddSetting({name = "wealth_tax", description = "Wealth tax (0.1% of company value per quarter)",
      easy_value = 1, medium_value = 3, hard_value = 6, custom_value = 3,
      flags = CONFIG_INGAME, min_value = 0, max_value = 30});
    AddSetting({name = "overhead", description = "Overhead (% of quarterly income)",
      easy_value = 3, medium_value = 8, hard_value = 15, custom_value = 8,
      flags = CONFIG_INGAME, min_value = 0, max_value = 50});
    AddSetting({name = "vehicle_fee", description = "Fee per vehicle per quarter",
      easy_value = 20, medium_value = 60, hard_value = 120, custom_value = 60,
      flags = CONFIG_INGAME, min_value = 0, max_value = 2000});
    AddSetting({name = "station_fee", description = "Fee per station per quarter",
      easy_value = 50, medium_value = 150, hard_value = 300, custom_value = 150,
      flags = CONFIG_INGAME, min_value = 0, max_value = 5000});
    AddSetting({name = "cash_tax_threshold", description = "Cash tax: tax-free bank balance (in thousands)",
      easy_value = 20000, medium_value = 5000, hard_value = 2000, custom_value = 5000,
      flags = CONFIG_INGAME, min_value = 0, max_value = 1000000});
    AddSetting({name = "cash_tax_rate", description = "Cash tax: per mille of the balance above that, per quarter",
      easy_value = 5, medium_value = 10, hard_value = 20, custom_value = 10,
      flags = CONFIG_INGAME, min_value = 0, max_value = 100});
    AddSetting({name = "economy_news", description = "Show the quarterly bill as a news popup (off = only in the debug log)",
      easy_value = 1, medium_value = 1, hard_value = 1, custom_value = 1,
      flags = CONFIG_BOOLEAN | CONFIG_INGAME, min_value = 0, max_value = 1});
  }
}
RegisterGS(HardEconomyTaxes());
