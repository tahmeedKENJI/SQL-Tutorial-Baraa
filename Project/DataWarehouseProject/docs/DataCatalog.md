# Data Catalog

This file contains information about the data stored in the data warehouse.
- Schema level: GOLD
- Dimension Tables
  1. dim_customers
  2. dim_products
- Fact tables
  1. fact_sales

# gold.dim_customers

- Purpose: Stores customer information enriched with demographics and geographic data
- Columns
  
| Column Name     | Data Type    | Description                                          |
| --------------- | ------------ | ---------------------------------------------------- |
| customer_key    | INT          | Unique identifier for each customer (surrogate key)  |
| customer_id     | NVARCHAR(50) | Unique ID assigned to the customer                   |
| customer_number | NVARCHAR(50) | Customer number                                      |
| first_name      | NVARCHAR(50) | Customer's first name                                |
| last_name       | NVARCHAR(50) | Customer's last name                                 |
| birth_date      | DATE         | Customer's date of birth (yyyy-mm-dd)                |
| country         | NVARCHAR(50) | Country of the customer                              |
| marital_status  | NVARCHAR(50) | Marital status of the customer ('Single', 'Married') |
| gender          | NVARCHAR(50) | Gender of the customer ('Male', 'Female', 'N/A')     |
| creation_date   | DATE         | Date the customer record was created (yyyy-mm-dd)    |

# gold.dim_products

- Purpose: Provide information about the products and their attributes
- Columns:
  
| Column Name          | Data Type    | Description                                        |
| -------------------- | ------------ | -------------------------------------------------- |
| product_key          | INT          | Unique identifier for each product (surrogate key) |
| product_id           | NVARCHAR(50) | Unique ID assigned to the product                  |
| product_number       | NVARCHAR(50) | Product number                                     |
| product_name         | NVARCHAR(50) | Name of the product                                |
| category_id          | NVARCHAR(50) | Unique ID for the product category                 |
| category_name        | NVARCHAR(50) | Name of the product category                       |
| subcategory_name     | NVARCHAR(50) | Name of the product subcategory                    |
| maintainenace_status | NVARCHAR(50) | Maintenance status of the product ('Yes', 'No')    |
| product_cost         | NVARCHAR(50) | Cost of the product                                |
| product_line         | NVARCHAR(50) | Product line classification                        |
| product_start_date   | NVARCHAR(50) | Start date of the product (yyyy-mm-dd)             |

# gold.fact_sales

- Purpose: Contains the raw transactional records with proper relation to dimensional tables  
- Columns:
  
| Column Name   | Data Type    | Description                                         |
| ------------- | ------------ | --------------------------------------------------- |
| order_number  | NVARCHAR(50) | Unique identifier for each order                    |
| product_key   | INT          | Foreign key referencing the product dimension       |
| customer_key  | INT          | Foreign key referencing the customer dimension      |
| order_date    | DATE         | Date when the order was placed                      |
| shipping_date | DATE         | Date when the order was shipped                     |
| due_date      | DATE         | Date when the payment is due                        |
| sales_amount  | NVARCHAR(50) | Total sales amount for the order (quantity * price) |
| quantity      | NVARCHAR(50) | Quantity of products ordered                        |
| price         | NVARCHAR(50) | Price of the product                                |
