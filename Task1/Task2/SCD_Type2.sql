-- ===================================
-- Task 2
-- SCD Type 2 Asset Register
-- ===================================

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
AND d.EffectiveTo >= DATEADD(MINUTE,-1,SYSUTCDATETIME());
