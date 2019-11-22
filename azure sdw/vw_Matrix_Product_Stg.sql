USE [PriceMgmt];
GO
SET  ANSI_NULLS ON;
GO
SET  QUOTED_IDENTIFIER ON;
GO

CREATE VIEW [dbo].[vw_Matrix_Product_Stg]
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
        INNER JOIN dbo.vw_PromotionsProducts pp
           ON     pm.ItemNumber = pp.mpid
              AND pm.Branch = pp.AcctNk
              AND pm.PriceColumn = pp.PC
   WHERE pm.DeletedOnDate IS NULL
GO