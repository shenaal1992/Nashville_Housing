/*
Cleaning data in SQL Queries
*/

SELECT	*
FROM	Nashville_Housing

UPDATE	Nashville_Housing
SET		SaleDate = CONVERT(DATE, SaleDate)
WHERE	Nashville_Housing.[UniqueID] IS NOT NULL  -- Didn't update rows as Expected

ALTER	TABLE	Nashville_Housing
ADD		SaleDateConverted Date;

UPDATE	Nashville_Housing
SET		Nashville_Housing.SaleDateConverted = CONVERT(DATE, SaleDate)

-- Populate Property Address Data
SELECT	*
FROM	Nashville_Housing
WHERE	PropertyAddress IS NULL;

SELECT	a.ParcelID,
		a.PropertyAddress,
		b.ParcelID,
		b.PropertyAddress
FROM	Nashville_Housing AS a
JOIN	Nashville_Housing AS b
	ON	a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]	
WHERE	a.PropertyAddress IS NULL;
	
SELECT	a.ParcelID,
		a.PropertyAddress,
		b.ParcelID,
		b.PropertyAddress, 
		ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM	Nashville_Housing AS a
JOIN	Nashville_Housing AS b
		ON	a.ParcelID = b.ParcelID
			AND a.[UniqueID ] <> b.[UniqueID ]	
WHERE	a.PropertyAddress IS NULL;

UPDATE	a
SET		PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM	Nashville_Housing AS a
JOIN	Nashville_Housing AS b
		ON	a.ParcelID = b.ParcelID
			AND a.[UniqueID ] <> b.[UniqueID ]	
WHERE	a.PropertyAddress IS NULL;

-- Breaking out Address in to Individual Columns

SELECT	PropertyAddress
FROM	Nashville_Housing
SELECT	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Add_,
		SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Street_
FROM	Nashville_Housing

-- Create two new coulmns for address and city

ALTER	TABLE	Nashville_Housing
ADD		PropertySplitAddress NVARCHAR(255)

UPDATE	Nashville_Housing
SET		PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER	TABLE	Nashville_Housing
ADD		PropertySplitCity NVARCHAR(255)

UPDATE	Nashville_Housing
SET		PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

/*
Using PARSENAME to split values for OwnerAddress. But it is counting backward
*/

SELECT	PARSENAME(REPLACE(OwnerAddress,',','.'),3),
		PARSENAME(REPLACE(OwnerAddress,',','.'),2),
		PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM	Nashville_Housing

ALTER	TABLE	Nashville_Housing
ADD		OwnerSplitAddress NVARCHAR(255)

ALTER	TABLE	Nashville_Housing
ADD		OwnerSplitCity NVARCHAR(255)

ALTER	TABLE	Nashville_Housing
ADD		OwnerSplitState NVARCHAR(255)

UPDATE	Nashville_Housing
SET		OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE	Nashville_Housing
SET		OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE	Nashville_Housing
SET		OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT	*
FROM	Nashville_Housing

/*
	Change Y and N to Yes and No in 'SoldAsVacant' Field
*/

SELECT		DISTINCT(SoldAsVacant),
			COUNT(SoldAsVacant)
FROM		Nashville_Housing
GROUP BY	SoldAsVacant
ORDER BY	COUNT(SoldAsVacant)


SELECT		SoldAsVacant,
			CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END 
FROM		Nashville_Housing

UPDATE		Nashville_Housing
SET			SoldAsVacant = CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
						   WHEN SoldAsVacant = 'N' THEN 'No'
					       ELSE SoldAsVacant
					       END
						   

/*
	Remove Duplicates (Normally don't delete data in the database )
*/

SELECT	*
FROM	Nashville_Housing


WITH RowNumCTE AS (
SELECT	*,
		ROW_NUMBER() 
		OVER(PARTITION BY	
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID) AS row_num
FROM		Nashville_Housing
--ORDER BY	ParcelID
)
SELECT	*
FROM	RowNumCTE
WHERE	RowNumCTE.row_num>1

WITH RowNumCTE AS (
SELECT	*,
		ROW_NUMBER() 
		OVER(PARTITION BY	
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID) AS row_num
FROM		Nashville_Housing
--ORDER BY	ParcelID
)
DELETE
FROM	RowNumCTE
WHERE	RowNumCTE.row_num>1


/*
	Delete unused columns
*/

SELECT	*
FROM	Nashville_Housing

ALTER	TABLE	Nashville_Housing
DROP	COLUMN	OwnerAddress,
				TaxDistrict,
				PropertyAddress,
				SaleDate
