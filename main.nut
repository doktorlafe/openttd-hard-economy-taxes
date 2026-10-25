require("economy.nut");

class HardEconomyTaxes extends GSController {
  last_quarter_key = -1;
  pending = [];            // companies waiting to be taxed

  function Start();
  function Save();
  function Load(version, data);
  function WorkEconomy();
}

function HardEconomyTaxes::Save()
{
  return { last_quarter_key = this.last_quarter_key };
}

function HardEconomyTaxes::Load(version, data)
{
  if (data.rawin("last_quarter_key")) this.last_quarter_key = data.rawget("last_quarter_key");
}

function HardEconomyTaxes::Start()
{
  GSLog.Info("Hard Economy Taxes started: profit_tax=" + GSController.GetSetting("profit_tax") +
    " wealth_tax=" + GSController.GetSetting("wealth_tax") +
    " overhead=" + GSController.GetSetting("overhead"));

  while (true) {
    try {
      this.WorkEconomy();
    } catch (e) {
      GSLog.Error("economy failed: " + e);
    }
    // Work through one company per wake-up so there is never a spike.
    this.Sleep(this.pending.len() > 0 ? 74 : 74 * 10);
  }
}

function HardEconomyTaxes::WorkEconomy()
{
  if (this.pending.len() > 0) {
    Economy_Settle(this.pending.pop());
    return;
  }

  local date = GSDate.GetCurrentDate();
  local month = GSDate.GetMonth(date);
  if ((month - 1) % 3 != 0) return;
  local key = GSDate.GetYear(date) * 4 + (month - 1) / 3;
  if (key == this.last_quarter_key) return;

  // First month of a new quarter: queue the previous one for settling.
  if (this.last_quarter_key != -1) {
    for (local i = 0; i < 15; i++) {
      local c = GSCompany.ResolveCompanyID(i);
      if (c != GSCompany.COMPANY_INVALID) this.pending.append(c);
    }
  }
  this.last_quarter_key = key;
}
