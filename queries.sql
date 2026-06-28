select
case 
	when age between 16 and 25 then '16-25'
	when age between 26 and 40 then '26-40'
	when age >40 then '40+'
end as age_category,
count(*) as age_count
from customers
group by age_category
order by age_category;  --количество покупателей в разных возрастных группах--


select 
count(distinct customers.customer_id) as total_customers,
to_char(sale_date, 'yyyy-mm') as selling_month,
ROUND(SUM(price*quantity)) as income
from sales 
inner join products
on sales.product_id = products.product_id 
inner join customers
on sales.customer_id = customers.customer_id
group by selling_month
order by selling_month; --данные по количеству уникальных покупателей и выручке, которую они принесли--


select 
concat(customers.first_name,' ', customers.last_name) as customer,
sale_date,
concat(employees.first_name,' ', employees.last_name) as seller
from sales
inner join customers
on sales.customer_id = customers.customer_id
inner join employees 
on sales.sales_person_id = employees.employee_id
inner join products
on sales.product_id = products.product_id
where price = 0
and sale_date = (
select min(sale_date)
from sales
where sales.customer_id = customers.customer_id)
group by customers.customer_id, sales.sale_date, customer, seller
order by customers.customer_id;  --покупатели первая покупка которых пришлась на время проведения специальных акций-- 

select 
concat(first_name,' ', last_name) as seller,
SUM(price*quantity) as income,
count(sales_id) as operation
FROM sales 
inner join products
on sales.product_id = products.product_id 
inner join employees 
on sales.sales_person_id = employees.employee_id
group by employee_id
order by income DEsc
limit 10;    --отчет с продавцами у которых наибольшая выручка--

select
    concat(first_name, ' ',last_name) as seller,
    floor(avg(price * quantity)) as average_income
from sales
join employees
    on sales.sales_person_id = employees.employee_id
join products
    on sales.product_id = products.product_id
group by seller
having avg(price *quantity) < (
    select avg(price * quantity)
    from sales 
    join products
        on sales.product_id = products.product_id
)
order by average_income, seller;  --отчет с продавцами, чья выручка ниже средней выручки всех продавцов--


select 
concat(first_name,' ', last_name) as seller,
lower(to_char(sale_date, 'FMDay')) as day_of_week,
FLOOR (SUM(price*quantity)) as income
FROM sales 
inner join products
on sales.product_id = products.product_id 
inner join employees 
on sales.sales_person_id = employees.employee_id
group by to_char(sale_date, 'FMDay'), seller, extract(dow from sale_date)
order by 
case extract (dow from sale_date) when 0 then 7
else extract(dow from sale_date) end, seller; --отчет с данными по выручке по каждому продавцу и дню недели--
