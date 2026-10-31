# Movie Rental Analytics

A capstone project that analyses a DVD rental business using the **Sakila** database. It combines SQL exploratory analysis (EDA) with an interactive **Power BI** dashboard to understand customer behaviour, film inventory, staff performance and store operations.

> Data covers **May 2005 to February 2006**, with most activity in July and August.

---

## Contents

| File | What it is |
|---|---|
| `Movie_Rental_analysis.pbix` | Power BI report (5 pages, 15 report questions) |
| `Movie_rental_analysis_EDA.xlsx` | 15 EDA questions: SQL query, result tables and insights per sheet |
| `movie_rental_analysis_MECE_framework.pdf` | MECE framework: 6 analysis areas, findings, recommendations, limitations |
| `Movie_Rental_Analytics.pptx` | Presentation covering the full workflow, data model, EDA and report |
| `images/` | Screenshots of the data model and the 5 report pages (add your own) |

## Dataset at a glance

| Measure | Value |
|---|---|
| Rentals | 16,044 |
| Customers | 599 (108 countries) |
| Films / copies | 1,000 / 4,581 |
| Stores | 2 (Woodridge, Australia and Lethbridge, Canada) |
| Staff | 2 |
| Total revenue | $67,406.56 (average payment $4.20) |

Source tables (16 in Sakila) used: `customer`, `address`, `city`, `country`, `payment`, `rental`, `inventory`, `film`, `category`, `film_category`, `language`, `staff`, `store`.

## Tools

- **PostgreSQL** for the EDA queries (run against a `v_rental_fact` view that joins rental, payment, customer, film, category and store data)
- **Power BI Desktop** for the model, DAX measures and report
- **Excel** for the EDA results workbook
- **PowerPoint** for the final presentation

## Workflow

1. **Understand** the Sakila schema and group the tables into six MECE areas: Customers, Sales, Films, Inventory, Staff, Stores.
2. **Clean** the data (see below).
3. **Transform**: add calculated columns and DAX measures.
4. **Model**: connect the tables in Power BI with Rental at the centre.
5. **EDA with SQL**: answer 15 questions and record query, finding and meaning.
6. **Report in Power BI**: build 5 pages answering 15 report questions.

### Data cleaning

- 183 rentals have no return date, so they are labelled *Not Returned*; late-return rates use returned rentals only.
- 42 films have no inventory copy; they are kept and flagged as not rentable.
- There is no customer rating or age data, so average rentals per customer is used as an engagement proxy.
- All films are English and all customers share one `create_date`, so language and tenure comparisons are marked as not possible.
- A one-day batch of 182 rentals on 14 Feb 2006 is excluded from the hourly analysis.
- Key and ID columns (`customer_id`, `rental_id`, `inventory_id` and similar) are hidden in report view.

### Transformations

- **Customer:** Customer Name, Customer Type (new or existing), Lifetime Spend, Spend Tier (High, Mid, Low)
- **Payment:** Payment Band with Band Order (Under $2, $2-4.99, $5-7.99, $8+), Year-Month
- **Rental:** Rental Days, Return Status (On Time, Late, Not Returned)
- **Film and store:** Rental Rate Label, Rental Duration (days), Store Location
- **Staff:** Days Active, First and Last Rental Handled, Staff Status
- **Measures:** Avg Rental Days, Avg Payment, Payments, Inventory Copies

## Data model

`Rental` is the central table. All relationships are one-to-many with single-direction filters, so there are no ambiguous paths.

| Relationship | Key |
|---|---|
| Customer to Rental | `customer_id` |
| Staff to Rental | `staff_id` |
| Inventory to Rental | `inventory_id` |
| Rental to Payment | `rental_id` |
| Store to Inventory | `store_id` |
| Film to Inventory | `film_id` |

## Power BI report

| Page | Questions answered |
|---|---|
| Overview | Q1 revenue by month, Q2 sales by payment band, Q3 customer segments, Q8 store performance |
| Customers & Regions | Q10 customers by city, Q11 revenue by country, Q12 highest and lowest locations |
| Films & Inventory | Q4 rental duration, Q5 inventory by rating, Q6 categories, Q13 language, Q14 rental rate, Q15 rental duration by category |
| Staff & Stores | Q7 staff employment duration, Q8 store comparison, Q9 average rental duration by staff |
| Animated Trends | Bonus: countries by month bubble chart, monthly revenue by store, top 10 countries |

Slicers on every page: Store Location, Category, Country, Rating.

**Notes**
- Sakila has no payment method, so Q2 uses payment amount bands.
- Sakila has no customer ratings, so Q12 uses average rentals per customer.
- The report shows a late-return rate of 51.1% (8,106 rentals), while the SQL analysis shows about 46%. The two use different late-return calculations.

## EDA questions and key findings

| # | Question | Key finding |
|---|---|---|
| 1 | New vs repeat customers | Repeat rentals bring 96.3% of revenue |
| 2 | Highest rental rates and demand | $4.99 films bring 48.9% of revenue; price does not change demand |
| 3 | Staff performance | Both staff perform almost equally (8,040 vs 8,004 rentals) |
| 4 | Seasonal trends by location | Rentals per day rise from 72 to 289 (May to Aug) in both stores |
| 5 | Language and segments | All rentals are English |
| 6 | Loyalty and revenue | Most loyal quartile earns 31% of revenue vs 19% for the least loyal |
| 7 | Categories by location | Small differences: Action leads Store 1, Sports leads Store 2 |
| 8 | Staff availability and ratings | Availability is constant; effect cannot be measured |
| 9 | Store proximity | Correlation between distance and rentals is 0.05 |
| 10 | Categories by age group | Cannot be answered; no age data |
| 11 | Highest-spending customers | Top 10% bring 14.3% of revenue; frequency sets them apart |
| 12 | Inventory and repeat business | About 3.5 rentals per copy at 2, 3 or 4 copies |
| 13 | Busiest hours and days | Demand is flat; weekends slightly busier |
| 14 | Cultural and demographic factors | Country barely changes preferences |
| 15 | Language availability | All 1,000 films are English |

## Key insights and recommendations

- **Marketing:** focus on India, China and the USA, reward high-frequency customers, contact inactive customers and run offers on quiet days.
- **Film collection:** add copies in Sports, Sci-Fi and Animation, keep $4.99 films, and buy copies for (or remove) the 42 films with none.
- **Staff and planning:** both staff perform equally, so train on following up late and unreturned rentals and add cover at weekends.
- **Stores:** keep stock balanced across both stores, because customers use both.

## Limitations

- No customer rating or feedback data, so satisfaction cannot be measured directly.
- Only 41 days of rental activity, so a full-year seasonal pattern cannot be established.
- Only two stores and two staff members, so comparisons are limited.
- No age, gender or other demographics beyond country, city and district.

## How to use

1. Open `Movie_Rental_analysis.pbix` in Power BI Desktop and use the page tabs and slicers.
2. Open `Movie_rental_analysis_EDA.xlsx` and start from the *Summary* sheet; each question has its own sheet with the SQL query and results.
3. To rerun the SQL, load the Sakila database into PostgreSQL and create the `v_rental_fact` view first.
