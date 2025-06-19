use FURNITURE;
-- Create cleaned table with proper conversion handling
DROP TABLE FURNITURE.dbo.furniture_cleaned;

SELECT 
    productTitle,

    -- Sanitize and convert originalPrice
    TRY_CAST(REPLACE(REPLACE(LTRIM(RTRIM(originalPrice)), '$', ''), ',', '') AS FLOAT) AS originalPrice,

    -- Sanitize and convert price
    TRY_CAST(REPLACE(REPLACE(LTRIM(RTRIM(price)), '$', ''), ',', '') AS FLOAT) AS price,

    sold,

    -- Simplify tagText categories
    CASE
        WHEN tagText = 'Free shipping' THEN 'Free shipping'
        WHEN tagText = '+Shipping: $5.09' THEN '+Shipping: $5.09'
        ELSE 'others'
    END AS tagText,

    -- Calculate discount percentage with null-safe conversion
    ROUND(
        ((TRY_CAST(REPLACE(REPLACE(LTRIM(RTRIM(originalPrice)), '$', ''), ',', '') AS FLOAT) - 
          TRY_CAST(REPLACE(REPLACE(LTRIM(RTRIM(price)), '$', ''), ',', '') AS FLOAT)) /
          NULLIF(TRY_CAST(REPLACE(REPLACE(LTRIM(RTRIM(originalPrice)), '$', ''), ',', '') AS FLOAT), 0)) * 100.0, 2
    ) AS discount_percentage

INTO FURNITURE.dbo.furniture_cleaned
FROM FURNITURE.dbo.ecommerce_furniture_dataset_2024
WHERE originalPrice IS NOT NULL
  AND ISNUMERIC(REPLACE(REPLACE(LTRIM(RTRIM(originalPrice)), '$', ''), ',', '')) = 1
  AND ISNUMERIC(REPLACE(REPLACE(LTRIM(RTRIM(price)), '$', ''), ',', '')) = 1;
---
SELECT 
    tagText,
    COUNT(*) AS item_count,
    ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM FURNITURE.dbo.furniture_cleaned
GROUP BY tagText
ORDER BY avg_discount DESC;

SELECT * FROM FURNITURE.dbo.furniture_cleaned;

