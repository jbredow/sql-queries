SELECT "CHANNEL",
       "MM",
       "REGION",
       "ACCOUNT_NUMBER",
       "BU_NAME",
       "ROLLING_QTR",
       "MM",
       "GPTRACK_KEY",
       "Total Sales",
       "Total Cost",
       "Total GP$",
       ROUND((CASE WHEN "Total Sales">0 THEN "Total GP$"/"Total Sales" ELSE 0 END),3) "Total GP%",
       "Total # Lines",
       "Outbound Sales",
       "Price Matrix Sales",
       "Price Matrix Cost",
       "Price Matrix GP$",
       ROUND((CASE WHEN "Price Matrix Sales">0 THEN "Price Matrix GP$"/"Price Matrix Sales" ELSE 0 END),3) "Price Matrix GP%",
       ROUND((CASE WHEN "Outbound Sales">0 THEN "Price Matrix Sales"/"Outbound Sales" ELSE 0 END),3) "Price Matrix Use%$",
       ROUND((CASE WHEN "Total # Lines">0 THEN "Price Matrix # Lines"/"Total # Lines" ELSE 0 END),3) "Price Matrix Use%#",
       ROUND((CASE WHEN "Total GP$">0 THEN "Price Matrix GP$"/"Total GP$" ELSE 0 END),3) "Price Matrix Profit%$",
       "Price Matrix # Lines",
       "Contract Sales",
       "Contract Cost",
       "Contract GP$",
       ROUND((CASE WHEN "Contract Sales">0 THEN "Contract GP$"/"Contract Sales" ELSE 0 END),3) "Contract GP%",
       ROUND((CASE WHEN "Outbound Sales" >0 THEN "Contract Sales"/"Outbound Sales" ELSE 0 END),3) "Contract Use%$",
       ROUND((CASE WHEN "Total # Lines">0 THEN "Contract # Lines"/"Total # Lines" ELSE 0 END),3) "Contract Use%#",
       ROUND((CASE WHEN "Total GP$">0 THEN "Contract GP$"/"Total GP$" ELSE 0 END),3) "Contract Profit%$",
       "Contract # Lines",
       "Manual Sales",
       "Manual Cost",
       "Manual GP$",
       ROUND((CASE WHEN "Manual Sales">0 THEN "Manual GP$"/"Manual Sales"ELSE 0 END),3) "Manual GP%",
       ROUND((CASE WHEN "Outbound Sales">0 THEN "Manual Sales"/"Outbound Sales" ELSE 0 END), 3) "Manual Use%$",
       ROUND((CASE WHEN "Total # Lines">0 THEN "Manual # Lines"/"Total # Lines" ELSE 0 END),3) "Manual Use%#",
       ROUND((CASE WHEN "Total GP$">0 THEN "Manual GP$"/"Total GP$" ELSE 0 END),3) "Manual Profit%$",
       "Manual # Lines",
       "Other Sales",
       "Other Cost",
       "Other GP$",
       ROUND((CASE WHEN "Other Sales">0 THEN "Other GP$"/"Other Sales" ELSE 0 END),3) "Other GP%",
       ROUND((CASE WHEN "Outbound Sales">0 THEN "Other Sales"/"Outbound Sales" ELSE 0 END),3) "Other Use%$",
       ROUND((CASE WHEN "Total # Lines">0 THEN "Other # Lines"/"Total # Lines" ELSE 0 END),3) "Other Use%#",
       ROUND((CASE WHEN "Total GP$">0 THEN "Other GP$"/"Total GP$" ELSE 0 END),3) "Other Profit%$",
       "Other # Lines",
       "Credits $" "Credit Sales",
       ROUND((CASE WHEN "Outbound Sales">0 THEN "Credits $"/"Outbound Sales" ELSE 0 END),3) "Credits Use%$",
       ROUND((CASE WHEN "Total # Lines">0 THEN "Credits Lines"/"Total # Lines"ELSE 0 END),3) "Credits Use%#"
  FROM AAD9606.GP_TRACKER_SUMS