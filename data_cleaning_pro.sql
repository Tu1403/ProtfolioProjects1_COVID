-- Cleaning Data in SQL Queries

select *
from PortfolioProject1.dbo.NashvilleHousing
---------------------------------------------------

--Standardize Date Format

select SaleDateConverted, CONVERT (date, SaleDate) 
from PortfolioProject1.dbo.NashvilleHousing

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate);

alter table PortfolioProject1.dbo.NashvilleHousing
add SaleDateConverted1 Date;

update PortfolioProject1.dbo.NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

--------------------
-- Populare Property Address data
select *
from PortfolioProject1.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1.dbo.NashvilleHousing a
join PortfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1.dbo.NashvilleHousing a
join PortfolioProject1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out address into individual columns (address, cyti, state)
select PropertyAddress
from PortfolioProject1.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject1.dbo.NashvilleHousing

alter table PortfolioProject1.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update PortfolioProject1.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table PortfolioProject1.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

update PortfolioProject1.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



 select *

from PortfolioProject1.dbo.NashvilleHousing



 select OwnerAddress

from PortfolioProject1.dbo.NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.') ,3),
PARSENAME(Replace(OwnerAddress,',','.') ,2),
PARSENAME(Replace(OwnerAddress,',','.') ,1)
from PortfolioProject1.dbo.NashvilleHousing


alter table PortfolioProject1.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update PortfolioProject1.dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.') ,3)

alter table PortfolioProject1.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update PortfolioProject1.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.') ,2)


alter table PortfolioProject1.dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255);

update PortfolioProject1.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.') ,1)

 select *

from PortfolioProject1.dbo.NashvilleHousing


--Change Y and N to yes and no in "Sold as Vacant" field

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject1.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,
case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	end
from PortfolioProject1.dbo.NashvilleHousing

update PortfolioProject1.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	end

-- Remove duplicates
with RowNumCTE AS(
select *,
	ROW_NUMBER() over(
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate, 
				LegalReference
				order by
					UniqueID
					) row_num
	
from PortfolioProject1.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num >1
order by ParcelID


select *

from PortfolioProject1.dbo.NashvilleHousing

--Delete Unused Colums
select *

from PortfolioProject1.dbo.NashvilleHousing

alter table PortfolioProject1.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject1.dbo.NashvilleHousing
drop column SaleDate