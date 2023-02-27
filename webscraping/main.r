# -*- coding: utf-8 -*-

# -- Sheet --

# # Intro to web scraping in R


# **First, Need to load library (rvest)**


# # **Step 1: Install rvest**


library(tidyverse)
library(rvest)

# # **Step 2: Retrieve the HTML Page**


# retrieving the target web page 
document <- read_html("https://scrapeme.live/shop")

# The **read_html()** function retrieves the HTML downloaded using the URL passed as a parameter, then parses it and assigns the resulting data structure to the document variable.


# print out document contents
print(document)

# # **Step 3: Identify and Select the Most Important HTML elements**


# selecting the list of product HTML elements 
html_products <- document %>% html_elements("li.product")

# Notice from the HTML code that a li.product HTML element includes:
# - An **a** that stores the product URL.
# - An **img** that contains the product image.
# - A **h2** that keeps the product name.
# - A **span** that stores the product price.


print(html_products)

# This executes the html_elements() rvest function on document by using the **R %>% pipe operator**. Specifically, html_elements() returns the list of HTML elements found applying a CSS selector or XPath expression.


# selecting the "a" HTML element storing the product URL 
a_element <- html_products %>% html_element("a") 
# selecting the "img" HTML element storing the product image 
img_element <- html_products %>% html_element("img") 
# selecting the "h2" HTML element storing the product name 
h2_element <- html_products %>% html_element("h2") 
# selecting the "span" HTML element storing the product price 
span_element <- html_products %>% html_element("span")

print(a_element)

# # **Step 4: Extract the Data from the HTML Elements**
# rvest applies the last function of the queue statement to each HTML element selected with html_element() from html_products. html_attr() returns the string stored in a single attribute. Similarly, html_text2() returns the text in an HTML element as it looks in a browser.


# extracting data from the list of products and storing the scraped data into 4 lists 
product_urls <- html_products %>% 
	html_element("a") %>% 
	html_attr("href") 
product_images <- html_products %>% 
	html_element("img") %>% 
	html_attr("src") 
product_names <- html_products %>% 
	html_element("h2") %>% 
	html_text2() 
product_prices <- html_products %>% 
	html_element("span") %>% 
	html_text2()

# converting the lists containg the scraped data into a dataframe 
products <- data.frame( 
	product_urls, 
	product_images, 
	product_names, 
	product_prices 
)

# # **Step 5: Export the Scraped Data to CSV**
# Before converting the products variable into CSV format, change its column names using names(). It allows you to change the names associated with every dataframe component so that the exported CSV file will be easier to read.


# changing the column names of the data frame before exporting it into CSV 
names(products) <- c("url", "image", "name", "price")

# Export the dataframe object to a CSV file using the **write.csv()** method, which instructs your R web crawler to produce a **products.csv** file containing the scraped data.


# export the data frame containing the scraped data to a CSV file 
write.csv(products, file = "./products.csv", fileEncoding = "UTF-8")



