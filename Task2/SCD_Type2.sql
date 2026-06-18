-- ===================================
-- Task 2
-- SCD Type 2 Asset Register
-- SCD Type 2 Design:
-- Maintains full history of asset changes by versioning records
-- Only one active record per AssetID at any time (IsCurrent = 1)
-- ===================================

-- Recommended: Wrap this logic in a stored procedure with transaction control
-- to ensure atomic SCD processing

-- Create Dimension Table

CREATE TABLE dbo.DimAsset
(
    AssetSK INT IDENTITY(1,1) PRIMARY KEY,
    AssetID VARCHAR(50),
    AssetName VARCHAR(200),
    AssetCategory VARCHAR(100),
    Location VARCHAR(100),
    EffectiveFrom DATETIME2,
    EffectiveTo DATETIME2,
    IsCurrent BIT
);

CREATE TABLE dbo.StgAsset
(
    AssetID VARCHAR(50),
    AssetName VARCHAR(200),
    AssetCategory VARCHAR(100),
    Location VARCHAR(100)
);

-- Insert New Records

INSERT INTO dbo.DimAsset
(
    AssetID,
    AssetName,
    AssetCategory,
    Location,
    EffectiveFrom,
    EffectiveTo,
    IsCurrent
)
SELECT
    s.AssetID,
    s.AssetName,
    s.AssetCategory,
    s.Location,
    SYSUTCDATETIME(),
    '9999-12-31',
    1
FROM dbo.StgAsset s
LEFT JOIN dbo.DimAsset d
       ON s.AssetID = d.AssetID
      AND d.IsCurrent = 1
WHERE d.AssetID IS NULL;

-- Expire Existing Records
-- Expire current record if any attribute changes


UPDATE d
SET
    EffectiveTo = SYSUTCDATETIME(),
    IsCurrent = 0
FROM dbo.DimAsset d
INNER JOIN dbo.StgAsset s
    ON s.AssetID = d.AssetID
WHERE d.IsCurrent = 1
AND (
        ISNULL(d.AssetName,'') <>
        ISNULL(s.AssetName,'')
     OR
        ISNULL(d.AssetCategory,'') <>
        ISNULL(s.AssetCategory,'')
     OR
        ISNULL(d.Location,'') <>
        ISNULL(s.Location,'')
    );
-- Insert New Versions
-- Insert new version after expiry of changed records

INSERT INTO dbo.DimAsset
(
    AssetID,
    AssetName,
    AssetCategory,
    Location,
    EffectiveFrom,
    EffectiveTo,
    IsCurrent
)
SELECT
    s.AssetID,
    s.AssetName,
    s.AssetCategory,
    s.Location,
    SYSUTCDATETIME(),
    '9999-12-31',
    1
FROM dbo.StgAsset s
JOIN dbo.DimAsset d
    ON s.AssetID = d.AssetID
WHERE d.IsCurrent = 0
AND NOT EXISTS (
    SELECT 1
    FROM dbo.DimAsset x
    WHERE x.AssetID = s.AssetID
    AND x.IsCurrent = 1
);

## Data Quality Controls

/*Before loading data into the dimension table I would typically:

1. Validate business keys.
2. Remove duplicate records.
3. Check mandatory fields.
4. Audit row counts.
5. Log rejected records.
*/
