DROP TABLE IF EXISTS Portfolio2;

CREATE TABLE Portfolio2 (
    Date DATE,
    GOOG_Adjusted_Close DECIMAL(10, 2),
    GOOG_Cumulative_Return DECIMAL(10, 8),
    GOOG_Value DECIMAL(10, 5),
    CELG_Adjusted_Close DECIMAL(10, 2),
    CELG_Cumulative_Return DECIMAL(10, 8),
    CELG_Value DECIMAL(10, 5),
    NVDA_Adjusted_Close DECIMAL(10, 2),
    NVDA_Cumulative_Return DECIMAL(10, 8),
    NVDA_Value DECIMAL(10, 5),
    FB_Adjusted_Close DECIMAL(10, 2),
    FB_Cumulative_Return DECIMAL(10, 8),
    FB_Value DECIMAL(10, 5),
    SPY_Adjusted_Close DECIMAL(10, 2),
    SPY_Cumulative_Return DECIMAL(10, 8),
    SPY_Value DECIMAL(10, 5),
    Portfolio_Cumulative_Return DECIMAL(10, 8),
    Portfolio_Value DECIMAL(10, 8)
);

INSERT INTO Portfolio2 (Date, 
                      GOOG_Adjusted_Close, GOOG_Cumulative_Return, GOOG_Value,
                      CELG_Adjusted_Close, CELG_Cumulative_Return, CELG_Value,
                      NVDA_Adjusted_Close, NVDA_Cumulative_Return, NVDA_Value,
                      FB_Adjusted_Close, FB_Cumulative_Return, FB_Value,
                      SPY_Adjusted_Close, SPY_Cumulative_Return, SPY_Value,
                      Portfolio_Cumulative_Return, Portfolio_Value)
SELECT 
    t1.Date,
    t1.close AS GOOG_Adjusted_Close, 
    t1.close / FIRST_VALUE(t1.close) OVER (ORDER BY t1.Date) AS GOOG_Cumulative_Return, 
    NULL AS GOOG_Value,
    t2.close AS CELG_Adjusted_Close, 
    t2.close / FIRST_VALUE(t2.close) OVER (ORDER BY t2.Date) AS CELG_Cumulative_Return, 
    NULL AS CELG_Value,
    t3.close AS NVDA_Adjusted_Close, 
    t3.close / FIRST_VALUE(t3.close) OVER (ORDER BY t3.Date) AS NVDA_Cumulative_Return, 
    NULL AS NVDA_Value,
    t4.close AS FB_Adjusted_Close, 
    t4.close / FIRST_VALUE(t4.close) OVER (ORDER BY t4.Date) AS FB_Cumulative_Return, 
    NULL AS FB_Value,
    t5.close AS SPY_Adjusted_Close, 
    t5.close / FIRST_VALUE(t5.close) OVER (ORDER BY t5.Date) AS SPY_Cumulative_Return, 
    NULL AS SPY_Value,
    NULL AS Portfolio_Cumulative_Return, 
    NULL AS Portfolio_Value
FROM 
    GOOG t1
INNER JOIN 
    CELG t2 ON t1.Date = t2.Date
INNER JOIN 
    NVDA t3 ON t1.Date = t3.Date
INNER JOIN 
    FB t4 ON t1.Date = t4.Date
INNER JOIN 
    SPY t5 ON t1.Date = t5.Date
ORDER BY 
    t1.Date;
