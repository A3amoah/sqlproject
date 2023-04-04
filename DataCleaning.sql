/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]


  /*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.dbo.NashvilleHousing


--standardise Date Format
Select SaleDateConverted,CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--populate Property Address data
Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
  on a.ParcelID =b.ParcelID
  AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
  on a.ParcelID =b.ParcelID
  AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into individual columns(Address,City,State)
Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing 


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add  PropertySplitCity Nvarchar(255);

update NashvilleHousing
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing 




select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing 

select
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing 


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
Add  OwnerSplitCity Nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvilleHousing
Add  OwnerSplitState Nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


--change Y and N to Yes and No in "Sold as Vacant" field
select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing 
Group by SoldAsVacant
order by 2


Select SoldAsVacant,
   CASE when SoldAsVacant = 'Y' THEN 'Yes'
        when SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
   END
 from PortfolioProject.dbo.NashvilleHousing 

 Update NashvilleHousing
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
   END


---Remove Duplicates
WITH RowNumCTE AS(
select *,
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate, 
					LegalReference
					ORDER BY 
					     UniqueID
						 ) row_num
from PortfolioProject.dbo.NashvilleHousing 
--order by ParcelID
)
DELETE
From RowNumCTE
where row_num > 1
--order by PropertyAddress


--delete unused columns
Alter Table PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate