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
concat(first_name,' ', last_name) as seller,
ROUND(AVG(price*quantity)) as average_income
FROM sales 
inner join employees 
on sales.sales_person_id = employees.employee_id
inner join products
on sales.product_id = products.product_id
where price*quantity< (
select AVG(price*quantity)
FROM sales 
inner join products
on sales.product_id = products.product_id)
group by seller
order by average_income desc;  --отчет с продавцами, чья выручка ниже средней выручки всех продавцов--


select 
concat(first_name,' ', last_name) as seller,
to_char(sale_date, 'Dy') as day_of_week,
ROUND(SUM(price*quantity)) as income
FROM sales 
inner join products
on sales.product_id = products.product_id 
inner join employees 
on sales.sales_person_id = employees.employee_id
group by to_char(sale_date, 'Dy'), seller
order by seller; --отчет с данными по выручке по каждому продавцу и дню недели--
