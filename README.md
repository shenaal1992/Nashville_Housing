# Cleaning Data in SQL Queries

## Overview
This project focuses on cleaning and restructuring data using SQL queries, particularly from the `Nashville_Housing` dataset. The aim is to prepare the data for further analysis by standardizing formats, splitting and organizing addresses, converting values, and removing duplicates and unnecessary columns.

## SQL Queries Description

1. **Converting Sale Date**
   - Updates the `SaleDate` column to date format.

2. **Populating Missing Property Address Data**
   - Identifies and populates missing property address data by matching parcel IDs.

3. **Breaking Out Address into Individual Columns**
   - Splits the property address into separate columns for address and city.

4. **Using PARSENAME to Split Owner Address**
   - Utilizes PARSENAME function to split values for owner address, city, and state.

5. **Changing 'Y' and 'N' to 'Yes' and 'No'**
   - Converts 'Y' and 'N' values in the `SoldAsVacant` field to 'Yes' and 'No' respectively.

6. **Removing Duplicates**
   - Identifies and removes duplicate records based on specified criteria.

7. **Deleting Unused Columns**
   - Drops unused columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`).

## Usage
These SQL queries are designed to be executed in a SQL environment connected to the `Nashville_Housing` database. Ensure that the necessary tables are present and backed up before running these queries as they involve data modifications.

## Disclaimer
When handling real data in a production environment, ensure to thoroughly review and test data cleaning processes to prevent data loss or corruption.
