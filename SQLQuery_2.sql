

WITH QuarterlySales AS (
SELECT 
    DI.[Stock Item] AS ProductName,
    SUM(FS.Profit) AS Revenue,
    SUM(FS.Quantity) AS Quantity,
    DATEPART(QUARTER, FS.[Invoice Date Key]) AS Quarter,
    DATEPART(YEAR, FS.[Invoice Date Key]) AS Year
FROM 
    Fact.Sale FS
    INNER JOIN Dimension.[Stock Item] DI 
        ON FS.[Stock Item Key] = DI.[Stock Item Key]
GROUP BY 
    DI.[Stock Item],
    DATEPART(QUARTER, FS.[Invoice Date Key]),
    DATEPART(YEAR, FS.[Invoice Date Key])
),
GrowthRates AS (
SELECT 
    QS.ProductName,
    QS.Revenue,
    QS.Quantity,
    QS.Quarter AS CurrentQuarter,
    QS.Year AS CurrentYear,
    LAG(QS.Revenue, 1) OVER (PARTITION BY QS.ProductName ORDER BY QS.Year, QS.Quarter) AS PreviousRevenue,
    LAG(QS.Quantity, 1) OVER (PARTITION BY QS.ProductName ORDER BY QS.Year, QS.Quarter) AS PreviousQuantity,
    LAG(QS.Quarter, 1) OVER (PARTITION BY QS.ProductName ORDER BY QS.Year, QS.Quarter) AS PreviousQuarter,
    LAG(QS.Year, 1) OVER (PARTITION BY QS.ProductName ORDER BY QS.Year, QS.Quarter) AS PreviousYear
FROM 
    QuarterlySales QS
)
SELECT top 10
    GR.ProductName,
    ((GR.Revenue - GR.PreviousRevenue) / NULLIF(GR.PreviousRevenue, 0)) * 100 AS GrowthRevenueRate,
    ((GR.Quantity - GR.PreviousQuantity) / NULLIF(GR.PreviousQuantity, 0)) * 100 AS GrowthQuantityRate,
    GR.CurrentQuarter,
    GR.CurrentYear,
    GR.PreviousQuarter,
    GR.PreviousYear
FROM 
    GrowthRates GR
ORDER BY 
    GR.ProductName, 
    GR.CurrentYear, 
    GR.CurrentQuarter;

