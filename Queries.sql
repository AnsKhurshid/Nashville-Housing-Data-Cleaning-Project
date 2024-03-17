
Select * 
from NashvilleHousing

-- Populate Property Address data

Select na.ParcelID, na.PropertyAddress, nb.ParcelID, nb.PropertyAddress,
isnull(na.PropertyAddress,nb.PropertyAddress)
from NashvilleHousing na
join NashvilleHousing nb
	on na.ParcelID = nb.ParcelID
	and na.UniqueID <> nb.UniqueID
where na.PropertyAddress is null


Update na
set PropertyAddress = isnull(na.PropertyAddress,nb.PropertyAddress)
from NashvilleHousing na
join NashvilleHousing nb
	on na.ParcelID = nb.ParcelID
	and na.UniqueID <> nb.UniqueID
where na.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From NashvilleHousing


--

select OwnerAddress
from NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

Alter Table NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Change column data type and its data accordingly

select SoldAsVacant
from NashvilleHousing

Alter table NashvilleHousing
Alter column SoldAsVacant nvarchar(50)

Select SoldAsVacant , CASE When SoldAsVacant = 1 THEN 'Yes'
	   When SoldAsVacant = 0 THEN 'No'
	   ELSE SoldAsVacant
	   END
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 1 THEN 'Yes'
	   When SoldAsVacant = 0 THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

With RowNumCTE as(
Select *, 
		ROW_NUMBER() OVER (Partition By 
		ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
		order by uniqueID) row_num
from NashvilleHousing
)

Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


-- Del unsed columns


Select * 
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


















