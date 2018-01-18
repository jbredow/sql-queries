SELECT "YEARMONTH",
       "CHANNEL",
       "MM",
       "REGION",
       "ACCOUNT_NUMBER",
       "ACCOUNT_NAME",
       "WRITER_INIT",
       "GPTRACK_KEY",
       "Total Sales",
       "Total Cost",
       "Total GP$",
       CASE WHEN "Total Sales">0 THEN "Total GP$"/"Total Sales" ELSE 0 END "Total GP%",
       "Total # Lines",
       "Price Matrix Sales",
       "Price Matrix Cost",
       "Price Matrix GP$",
       CASE WHEN "Price Matrix Sales">0 THEN "Price Matrix GP$"/"Price Matrix Sales" ELSE 0 END "Price Matrix GP%",
       CASE WHEN "Outbound Sales">0 THEN "Price Matrix Sales"/"Outbound Sales" ELSE 0 END "Price Matrix Use%$",
       CASE WHEN "Total # Lines">0 THEN "Price Matrix # Lines"/"Total # Lines" ELSE 0 END "Price Matrix Use%#",
       CASE WHEN "Total GP$">0 THEN "Price Matrix GP$"/"Total GP$" ELSE 0 END "Price Matrix Profit%$",
       "Price Matrix # Lines",
       "Contract Sales",
       "Contract Cost",
       "Contract GP$",
       CASE WHEN "Contract Sales">0 THEN "Contract GP$"/"Contract Sales" ELSE 0 END "Contract GP%",
       CASE WHEN "Outbound Sales" >0 THEN "Contract Sales"/"Outbound Sales" ELSE 0 END "Contract Use%$",
       CASE WHEN "Total # Lines">0 THEN "Contract # Lines"/"Total # Lines" ELSE 0 END "Contract Use%#",
       CASE WHEN "Total GP$">0 THEN "Contract GP$"/"Total GP$" ELSE 0 END "Contract Profit%$",
       "Contract # Lines",
       "Manual Sales",
       "Manual Cost",
       "Manual GP$",
       CASE WHEN "Manual Sales">0 THEN "Manual GP$"/"Manual Sales"ELSE 0 END "Manual GP%",
       CASE WHEN "Outbound Sales">0 THEN "Manual Sales"/"Outbound Sales" ELSE 0 END "Manual Use%$",
       CASE WHEN "Total # Lines">0 THEN "Manual # Invoices"/"Total # Lines" ELSE 0 END "Manual Use%#",
       CASE WHEN "Total GP$">0 THEN "Manual GP$"/"Total GP$" ELSE 0 END "Manual Profit%$",
       "Manual # Invoices" "Manual # Lines",
       "Other Sales",
       "Other Cost",
       "Other GP$",
       CASE WHEN "Other Sales">0 THEN "Other GP$"/"Other Sales" ELSE 0 END "Other GP%",
       CASE WHEN "Outbound Sales">0 THEN "Other Sales"/"Outbound Sales" ELSE 0 END "Other Use%$",
       CASE WHEN "Total # Lines">0 THEN "Other # Lines"/"Total # Lines" ELSE 0 END "Other Use%#",
       CASE WHEN "Total GP$">0 THEN "Other GP$"/"Total GP$" ELSE 0 END "Other Profit%$",
       "Other # Lines",
       CASE WHEN "Outbound Sales">0 THEN "Credits $"/"Outbound Sales" ELSE 0 END "Credits Use%$",
       CASE WHEN "Total # Lines">0 THEN "Credits Lines"/"Total # Lines"ELSE 0 END "Credits Use%#",
       "Freight Profit (Loss)",
       "Total # Invoices"
  FROM AAE0376.GP_TRACKER_WRITER_SUMS