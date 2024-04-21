-- zad 1
select avg(unitprice) avgprice
from products p;

select avg(unitprice) over () as avgprice
from products p;

select categoryid, avg(unitprice) avgprice
from products p
group by categoryid;

select avg(unitprice) over (partition by categoryid) as avgprice
from products p;

-- zad 2
select p.productid,
       p.ProductName,
       p.unitprice,
       (select avg(unitprice) from products) as avgprice
from products p
where productid < 10;

select p.productid,
       p.ProductName,
       p.unitprice,
       avg(unitprice) over () as avgprice
from products p
where productid < 10;

select p.productid,
       p.ProductName,
       p.unitprice,
       (select avg(unitprice) over () from products limit 1) as avgprice
from products p
where productid < 10;

select p.productid,
       p.ProductName,
       p.unitprice,
       (select avg(unitprice) from products pr where pr.productid < 10) as avgprice
from products p
where productid < 10;

-- zad 3
select productid,
       productname,
       unitprice,
       (select avg(p.unitprice) from products p) as avg_price
from products;

select p.productid, p.productname, p.unitprice, avg(p2.unitprice) as avg_price
from products p
         cross join products p2
group by p.productid, p.productname, p.unitprice;

select productid, productname, unitprice, avg(unitprice) over () as avg_price
from products;

-- zad 4
select p1.productid,
       p1.productname,
       p1.unitprice,
       (select avg(p2.unitprice) from products p2 where p1.categoryid = p2.categoryid) as avg_category_price
from products p1
where p1.unitprice > (select avg(p2.unitprice) from products p2 where p1.categoryid = p2.categoryid);

with products1 as (select productid,
                          productname,
                          unitprice,
                          avg(unitprice) over (partition by categoryid) as avg_category_price
                   from products)

select productid, productname, unitprice, avg_category_price
from products1
where unitprice > avg_category_price;

with products1 as (select p.productid, p.productname, p.unitprice, avg(p1.unitprice) as avg_category_price
                   from products p
                            cross join products p1
                   where p.categoryid = p1.categoryid
                   group by p.productid, p.productname, p.unitprice)

select productid, productname, unitprice, avg_category_price
from products1
where unitprice > avg_category_price;

-- zad 5
select count(*)
from product_history;

-- zad 6
-- SUBQUERY
select id,
       productid,
       productname,
       unitprice,
       (select avg(p.unitprice) from product_history p) as avg_price
from product_history;

-- JOIN
select p.id, p.productid, p.productname, p.unitprice, avg(p2.unitprice) as avg_price
from product_history p
         cross join product_history p2
group by p.id, p.productid, p.productname, p.unitprice;

-- WINDOW FUNCTION
select id, productid, productname, unitprice, avg(unitprice) over () as avg_price
from product_history;

-- zad 7 -- ALL QUERIES ARE VERY SLOW
-- SUBQUERY
select p.id,
       p.productid,
       p.productname,
       p.unitprice,
       (select avg(p1.unitprice) from product_history p1 where p.categoryid = p1.categoryid) as avg_category_price,
       (select sum(p1.value) from product_history p1 where p.categoryid = p1.categoryid)     as sum_category_value,
       (select avg(p1.unitprice)
        from product_history p1
        where p.productid = p1.productid
          and strftime('%Y', p.date) = strftime('%Y', p1.date))                              as avg_year_price
from product_history p;

-- WINDOW FUNCTION
select p.id,
       p.productid,
       p.productname,
       p.unitprice,
       avg(unitprice) over category_window                              as avg_category_price,
       sum(value) over category_window                                  as sum_category_value,
       avg(unitprice) over (partition by productid, strftime('%Y', date)) as avg_year_price
from product_history p
window category_window as (
        partition by categoryid
        );

-- JOIN
select p.id,
       p.productid,
       p.productname,
       p.unitprice,
       avg(p1.unitprice) as avg_category_price,
       sum(p1.value)     as sum_category_value,
       avg(p2.unitprice) as avg_year_price
from product_history p
         cross join product_history p1
         cross join product_history p2
where p.categoryid = p1.categoryid
  and p.productid = p2.productid
  and strftime('%Y', p.date) = strftime('%Y', p2.date)
group by p.id, p.productid, p.productname, p.unitprice;

-- zad 8
select productid,
       productname,
       unitprice,
       categoryid,
       row_number() over (partition by categoryid order by unitprice desc) as rowno,
       rank() over (partition by categoryid order by unitprice desc)       as rankprice,
       dense_rank() over (partition by categoryid order by unitprice desc) as denserankprice
from products;

select productid,
       productname,
       unitprice,
       categoryid,
       (select count(*) + 1
        from products p2
        where p2.categoryid = p.categoryid
          and (p2.unitprice > p.unitprice or (p2.unitprice = p.unitprice and p2.productid < p.productid))) as rowno,
       (select count(*) + 1
        from products p2
        where p2.categoryid = p.categoryid
          and p2.unitprice > p.unitprice)                                                                  as rankprice,
       (select count(distinct p2.unitprice) + 1
        from products p2
        where p2.categoryid = p.categoryid
          and p2.unitprice > p.unitprice)                                                                  as denserankprice
from products p
order by p.unitprice desc;

-- zad 9
with ranking as (select strftime('%Y', date)                                                                     as year,
                        productid,
                        productname,
                        unitprice,
                        date,
                        dense_rank() over (partition by productid, strftime('%Y', date) order by unitprice desc) as rank
                 from product_history)
select *
from ranking
where rank < 5
order by year, productid, rank;

with ranking as (select strftime('%Y', date)               as year,
                        productid,
                        productname,
                        unitprice,
                        date,
                        (select count(distinct p2.unitprice) + 1
                         from product_history p2
                         where p2.productid = p.productid
                           and strftime('%Y', p2.date) = strftime('%Y', p.date)
                           and p2.unitprice > p.unitprice) as rank
                 from product_history p)
select *
from ranking
where rank < 5
order by year, productid, rank;

-- zad 10
select productid,
       productname,
       categoryid,
       date,
       unitprice,
       lag(unitprice) over (partition by productid order by date)
           as previousprodprice,
       lead(unitprice) over (partition by productid order by date)
           as nextprodprice
from product_history
where productid = 1
  and strftime('%Y', date) = '2022'
order by date;

with t as (select productid,
                  productname,
                  categoryid,
                  date,
                  unitprice,
                  lag(unitprice) over (partition by productid
                      order by date) as previousprodprice,
                  lead(unitprice) over (partition by productid
                      order by date) as nextprodprice
           from product_history)
select *
from t
where productid = 1
  and strftime('%Y', date) = '2022'
order by date;

select p.productid,
       p.productname,
       p.categoryid,
       p.date,
       p.unitprice,
       (select p1.unitprice
        from product_history p1
        where p1.productid = 1
          and strftime('%Y', p1.date) = '2022'
          and p1.date < p.date
        order by p1.date desc
        limit 1)
           as previousprodprice,
       (select p1.unitprice
        from product_history p1
        where p1.productid = 1
          and strftime('%Y', p1.date) = '2022'
          and p1.date > p.date
        order by p1.date
        limit 1)
           as nextprodprice
from product_history p
where p.productid = 1
  and strftime('%Y', p.date) = '2022'
order by p.date;

-- zad 11
with order_values as (select c.companyname,
                             o.customerid,
                             o.orderid,
                             o.orderdate,
                             round(sum((od.unitprice * od.quantity) * (1 - od.discount)) + o.freight, 2) as order_total
                      from orders o
                               inner join orderdetails od on o.orderid = od.orderid
                               inner join customers c on o.customerid = c.customerid
                      group by o.orderid, c.customerid)

select companyname,
       orderid,
       orderdate,
       order_total,
       lag(orderid) over other_customer_orders     as prev_order_id,
       lag(orderdate) over other_customer_orders   as prev_order_date,
       lag(order_total) over other_customer_orders as prev_order_value
from order_values
window other_customer_orders as (partition by customerid order by orderdate);

-- zad 12
select productid,
       productname,
       unitprice,
       categoryid,
       first_value(productname) over (partition by categoryid
           order by unitprice desc) first,
       last_value(productname) over (partition by categoryid
           order by unitprice desc) last
from products
order by categoryid, unitprice desc;

select productid,
       productname,
       unitprice,
       categoryid,
       first_value(productname) over (partition by categoryid order by unitprice desc)                                            first,
       last_value(productname)
                  over (partition by categoryid order by unitprice desc rows between unbounded preceding and unbounded following) last
from products
order by categoryid, unitprice desc;

select productid,
       productname,
       unitprice,
       categoryid,
       (select productname
        from products p1
        where p.categoryid = p1.categoryid
        order by p1.unitprice desc
        limit 1) first,
       (select productname
        from products p1
        where p.categoryid = p1.categoryid
          and p.unitprice = p1.unitprice
        order by p1.unitprice
        limit 1) last
from products p
order by categoryid, unitprice desc;

-- zad 13
with order_values as (select o.customerid,
                             o.orderid,
                             o.orderdate,
                             round(sum((od.unitprice * od.quantity) * (1 - od.discount)) + o.freight,
                                   2) as order_total
                      from orders o
                               inner join orderdetails od on o.orderid = od.orderid
                      group by o.orderid)

select customerid,
       orderid,
       orderdate,
       order_total,
       first_value(orderid) over asc_monthly_orders      as lowest_total_monthly_id,
       first_value(orderdate) over asc_monthly_orders    as lowest_total_monthly_date,
       first_value(order_total) over asc_monthly_orders  as lowest_total_monthly_value,
       first_value(orderid) over desc_monthly_orders     as highest_total_monthly_id,
       first_value(orderdate) over desc_monthly_orders   as highest_total_monthly_date,
       first_value(order_total) over desc_monthly_orders as highest_total_monthly_value
from order_values
window asc_monthly_orders as ( partition by customerid, strftime('%Y', orderdate), strftime('%m', orderdate)
        order by order_total ),
       desc_monthly_orders as ( partition by customerid, strftime('%Y', orderdate), strftime('%m', orderdate)
               order by order_total desc );

-- zad 14
select id,
       productid,
       date,
       sum(value) over (partition by productid, date)                                                                        as daily_value,
       sum(value)
           over (partition by productid, strftime('%Y', date), strftime('%m', date) order by date RANGE UNBOUNDED PRECEDING) as monthly_value_to_date
from product_history
order by productid, date;

select id,
       productid,
       date,
       (select sum(ph1.value)
        from product_history ph1
        where ph.productid = ph1.productid
          and ph.date = ph1.date)  as daily_value,
       (select sum(ph1.value)
        from product_history ph1
        where ph.productid = ph1.productid
          and strftime('%Y', ph1.date) = strftime('%Y', ph.date)
          and strftime('%m', ph1.date) = strftime('%m', ph.date)
          and ph1.date <= ph.date) as monthly_value_to_date
from product_history ph
order by productid, date;

-- zad 15
with p as (select productid,
                  productname,
                  lag(date) over (partition by productid order by date) + 1 as date_from,
                  date                                                      as date_to,
                  unitprice,
                  max(unitprice) over (partition by productid)              as maxprice
           from product_history
           order by productid)
select productid, productname, date_from, date_to, unitprice
from p
where p.unitprice = p.maxprice;

with order_values as (select o.customerid,
                             o.orderid,
                             o.orderdate,
                             round(sum((od.unitprice * od.quantity) * (1 - od.discount)) + o.freight,
                                   2) as order_total
                      from orders o
                               inner join orderdetails od on o.orderid = od.orderid
                      group by o.orderid)

select customerid,
       orderid,
       orderdate,
       order_total,
       first_value(orderid) over desc_monthly_orders      as highest_total_monthly_id,
       first_value(orderdate) over desc_monthly_orders    as highest_total_monthly_date,
       first_value(order_total) over desc_monthly_orders  as highest_total_monthly_value,
       nth_value(orderid, 2) over desc_monthly_orders     as second_highest_total_monthly_id,
       nth_value(orderdate, 2) over desc_monthly_orders   as second_highest_total_monthly_date,
       nth_value(order_total, 2) over desc_monthly_orders as second_highest_total_monthly_value
from order_values
window desc_monthly_orders as ( partition by customerid, strftime('%Y', orderdate), strftime('%m', orderdate)
        order by order_total desc );

select productid,
       productname,
       unitprice,
       categoryid,
       row_number() over desc_price_by_category   as rowno,
       rank() over desc_price_by_category         as rankprice,
       dense_rank() over desc_price_by_category   as denserankprice,
       percent_rank() over desc_price_by_category as percentrankprice,
       cume_dist() over desc_price_by_category    as cumedistprice
from products
window desc_price_by_category as (partition by categoryid order by unitprice desc);

select companyname, country, ntile(2) over (partition by country)
from customers;