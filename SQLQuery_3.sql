WITH TotalRevenueAndQuantity AS
(
    SELECT 
        DATEPART(QUARTER, [Invoice Date Key]) AS Quarter,
        DATEPART(YEAR, [Invoice Date Key]) AS Year,
        SUM(Profit) AS TotalRevenue,
        SUM(Quantity) AS TotalQuantity
    FROM 
        [Fact].[Sale]
    GROUP BY 
        DATEPART(QUARTER, [Invoice Date Key]),
        DATEPART(YEAR, [Invoice Date Key])
),
CustomerRevenueAndQuantity AS
(
    SELECT 
        C.Customer AS CustomerName,
        DATEPART(QUARTER, S.[Invoice Date Key]) AS Quarter,
        DATEPART(YEAR, S.[Invoice Date Key]) AS Year,
        SUM(S.Profit) AS CustomerRevenue,
        SUM(S.Quantity) AS CustomerQuantity
    FROM 
        [Fact].[Sale] AS S
        INNER JOIN [Dimension].[Customer] AS C ON S.[Customer Key] = C.[Customer Key]
    GROUP BY 
        C.Customer,
        DATEPART(QUARTER, S.[Invoice Date Key]),
        DATEPART(YEAR, S.[Invoice Date Key])
)
SELECT 
    CR.CustomerName,
    CR.CustomerRevenue / TR.TotalRevenue * 100 AS TotalRevenuePercentage,
    CR.CustomerQuantity / TR.TotalQuantity * 100 AS TotalQuantityPercentage,
    CR.Quarter,
    CR.Year
FROM 
    CustomerRevenueAndQuantity AS CR
    INNER JOIN TotalRevenueAndQuantity AS TR ON CR.Quarter = TR.Quarter AND CR.Year = TR.Year
ORDER BY 
    CR.Year,
    CR.Quarter,
    CR.CustomerName
