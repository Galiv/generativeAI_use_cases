SELECT TOP 10
    D.[Stock Item] as ProductName, 
    SUM(F.Quantity) as SalesQuantity, 
    SUM(F.Profit) as SalesRevenue,
    DATEPART(QUARTER, F.[Invoice Date Key]) as [Quarter],
    DATEPART(YEAR, F.[Invoice Date Key]) as [Year]
FROM 
    Dimension."Stock Item" D 
INNER JOIN 
    Fact.Sale F 
ON 
    D.[Stock Item Key] = F.[Stock Item Key]
GROUP BY 
    D."Stock Item", 
    DATEPART(QUARTER, F.[Invoice Date Key]),
    DATEPART(YEAR, F.[Invoice Date Key])
ORDER BY 
    SalesRevenue DESC
