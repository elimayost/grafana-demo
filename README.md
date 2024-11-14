# Grafana demo

## Tools needed

1. Docker
2. docker-compose
3. [Task](https://taskfile.dev/)

## Installation

1. Create a "grafana_data" directory
2. Launch the required containers:

``` bash
docker-compose up
```

3. Change the elastic user's password:

``` bash
docker exec -it elasticsearch elasticsearch-reset-password -u elastic
```

4. Copy the password into .env
5. Create the elasticesearch gtd index:

``` bash
task create-index:run
```

6. Add the processors for that index:

``` bash
task add-processaors:run
```

7. Ingest the data:

``` bash
task ingest:run
```

8. Verify the total docs count (shoul be ~ 180K):

``` bash
task count-docs:run
```

9. Copy the sqlite database file to grafana container:

``` bash
docker copy data/gtd.sqlite grafana:/
```

## Grafana UI

In your browser open [UI](http://localhost:3000)

Username: admin
Password: admin

You can skip updating the password.

## Data sources

Once inside the UI, we need to declare two data sources, elasticsearch, and sqlite.

On the left hand side, click on the burger menu icon to expand the menu.

Under "Connections" click to "Add new connection".

### SQLite

Search for slite and click install. Once the plugin is installed, click on "Add new data source", and set the following:

Name: sqlite
Path: /gtq.sqlite

### Elasticsearch

Search for elasticsearch. No need to install the plugin as it is there by default. Add a new data source and set the fields:

Name: elasticsearch
URL: https://elasticsearch:9200
Authentication: Basic authentication
User: elastic
Password: The password from installation step 2
Skip TLS certificate validation: clicked
Index name: gtd
Time field name: timestamp

## Visualisations

### Quick glance

1. Total events (stat)

``` sql
select count(*) as total from gtd
```

Options to discuss:

- Title
- Value options
- Stat styles
- Standard options

2. Total killed

``` sql
select sum(nkill) as total from gtd
```

Options to discuss:

- Colour to emphasize a point

3. Year with maximum killed

``` sql
select
  cast(iyear as decimal),
  sum(nkill) as total_killed
from gtd
group by iyear
order by total_killed desc
limit 1;
```

Options to discuss:

- Value options (one field or all fields)
- Stat styles orientation

4. Total regions (stat)

``` sql
select count(distinct region_txt) as total from gtd
```

Or:

``` sql
select region_txt as region, count(region_txt) as total from gtd group by region
```

Options to discuss:

- The difference between the two in Value options with Distinct Count on region field
as opposed to First/Last in the first query.

5. Total countries (stat)

``` sql
select count(distinct country_txt) as total from gtd
```

6. Total groups (stat)

``` sql
select count(distinct(gname)) as total from gtd
```

7. Total weapon types (stat)

``` sql
select count(distinct(weaptype1_txt)) as total from gtd
```

8. Total attack types (stat)

``` sql
select count(distinct(attacktype1_txt)) as total from gtd
```

9. Success rate (stat)

``` sql
with success as (
  select cast(count(*) as float) as total from gtd where success=1
)

select 100 * success.total / count(*) as rate from success, gtd
```

To discuss:

- Cast on rate to get a more accurate result with decimal.
- Standard options unit - only adds the percent sign (i.e needs to be multiplied by 100 in query)

10. Suicide rate (stat)
``` sql
with suicide as (
  select cast(count(*) as float) as total from gtd where suicide=1
)

select 100 * suicide.total / count(*) as rate from suicide, gtd
```

11. Individual rate (stat)
``` sql
with individual as (
  select cast(count(*) as float) as total from gtd where individual=1
)

select 100 * individual.total / count(*) as rate from individual, gtd
```

To discuss adding a row for grouping multiple panels

### Total events - by time

1. By year (bar)
``` sql
select iyear as year, count(*) as total from gtd group by iyear
```

Options to discuss:

- X Axis label rotation
- Tooltip
- Legend
- Overrides

2. By month (bar)
``` sql
select cast(imonth as decimal) as month, count(*) as total from gtd where imonth!=0 group by month
```

Or:

``` sql
select
  case imonth
    when 1 then 'Jan'
    when 2 then 'Feb'
    when 3 then 'Mar'
    when 4 then 'Apr'
    when 5 then 'May'
    when 6 then 'Jun'
    when 7 then 'Jul'
    when 8 then 'Aug'
    when 9 then 'Sep'
    when 10 then 'Oct'
    when 11 then 'Nov'
    when 12 then 'Dec'
  end as month,
  count(*) as total
from gtd
where imonth!=0
group by month
order by cast(imonth as decimal)
```

To discuss:

- The difference between filtering in the query and Transform Data (transform happening BEFORE visualisation)
- Value mappings as an easier way tha case/then in sql query
- The difference between the types of imonth and month and the need for casting for ordering correctly.

### Total events - by weapon

``` sql
select
    iyear as year,
    weaptype1_txt as weapon,
    count(*) as total
from gtd
where weapon='$weapon'
group by year, weapon
order by year, weapon
```

Things to discuss:

- Panel options - Repeat options and max per row.
- Thresholds and Standard options color Scheme, BAR chart color by field option.
- Talk about theresholds with repeat and the need for single panels if the thresholds are different from panel to panel.

### Total events - by location

1. By region (Pie)
``` sql
select
    region_txt as region,
    count(*) as total
from gtd
where region_txt in (${region:sqlstring})
group by region
order by total desc
```

To discuss:

- Variables
- sqlstring resulting in 'region1, region 2'
- Donut
- Legend placement - not repeating what is already in the chart

2. By country (map)

``` sql
select
    country_txt as country,
    count(*) as total
from gtd
where
    region_txt in (${region:sqlstring}) and
    country_txt in (${country:sqlstring})
group by country_txt
```

To discuss:

- Variables
- Linking Variables

3. By city

``` sql
select city , count(*) as total from gtd group by city order by city
```

To discuss:

- Lagging result on long lists
- Lagging on filter with long lists
- The efficiency of such a graph

4. Top 10 cities

``` sql
select city , count(*) as total from gtd group by city order by total desc limit 10
```

- To discuss the efficiency of the data
- Column alignment choice that make it easy to read

### Total events - by attack type

To discuss:

- Time series vs terms grouping
- Timestamp interval in query
- Ability to zoom/select with the mouse
- Legend filtering
- Readability of the graph compared to the repeat option

### Total events - by weapon type

To discuss:

- The repeat option
- Thresholds
- Filtering with the filter hides all other repeated panels
- Can only edit the first panel as the rest are dependant on it

### Raw data

To discuss:

- Organize/Hide/Rename fields (boolean with ?)
- Value mapping for booleans
- Overrides created automatically by resizing column width
