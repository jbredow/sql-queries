
USE [PriceMgmt];
GO
SET  ANSI_NULLS ON;
GO
SET  QUOTED_IDENTIFIER ON;
GO

CREATE VIEW [dbo].[vw_Matrix_Group_Stg]
AS
   SELECT pm.Branch,
          pm.DiscountGroup,
          pm.ItemNumber,
          pm.PriceColumn,
          pm.PMBasis,
          pm.PMOper,
          pm.PMMult,
          pm.LastUpdatedDate,
          pm.ODS_INSERT_TS,
          pm.DeletedOnDate
   FROM [Feibusdev1-db\feibus_dev1].CaptainSCR_Staging.dbo.PriceMatrix pm
        INNER JOIN dbo.vw_PromotionsDGs pdg
           ON     pm.DiscountGroup = pdg.DiscGroup
              AND pm.Branch = pdg.AcctNk
              AND pm.PriceColumn = pdg.PC
   WHERE pm.DeletedOnDate IS NULL
GO