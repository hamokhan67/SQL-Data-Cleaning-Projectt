-- Data Cleaning SQL Project 

SELECT * 
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

SELECT SaleDate, CONVERT(DATE,SaleDate)
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

UPDATE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
SET SaleDate = CONVERT(DATE,SaleDate)

-- Populate property Adress Data

SELECT *
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
WHERE PropertyAddress IS NULL


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM   Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning] a
JOIN  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning] b 
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning] a
JOIN  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning] b 
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- Breaking out Address into indivisual Colums(Address, City, State)

SELECT PropertyAddress
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

ALTER TABLE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
ADD PropertySplitAddress NVARCHAR(255);

UPDATE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

ALTER TABLE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
ADD PropertySplitCity  NVARCHAR(255);

UPDATE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]


--Now for the Owner Address

SELECT OwnerAddress
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

SELECT 
PARSENAME (REPLACE(OwnerAddress, ',', '.') ,3),
PARSENAME (REPLACE(OwnerAddress, ',', '.') ,2),
PARSENAME (REPLACE(OwnerAddress, ',', '.') ,1)
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

ALTER TABLE Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
ADD OwnersplitAddress NVARCHAR(255);

UPDATE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
SET OwnersplitAddress = PARSENAME (REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitCity  NVARCHAR(255);

UPDATE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
SET  OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
ADD OwnerSplitstate  NVARCHAR(10);

UPDATE  Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
SET  OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',', '.') ,1)


SELECT *
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]


--Removing Duplicates

SELECT *
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

WITH RemovDupli AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) AS rownum
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
)
SELECT *
FROM RemovDupli
WHERE rownum >1

WITH RemovDupli AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) AS rownum
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
)
DELETE
FROM RemovDupli
WHERE rownum >1

WITH RemovDupli AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID) AS rownum
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
)
SELECT *
FROM RemovDupli
WHERE rownum >1

-- Deleting Unused Columns

SELECT *
FROM Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]

ALTER TABLE Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Data_Cleaning_Project..[Nashville Housing Data for Data Cleaning]
DROP COLUMN SaleDate

