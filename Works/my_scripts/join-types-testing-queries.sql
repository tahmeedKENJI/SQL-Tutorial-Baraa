USE JoinPractice_1
GO

select 
	pei.id, 
	pei.first_name,
	pei.last_name,
	oi.customer_id,
	oi.first_name,
	oi.last_name,
	oi.order_id,
	oi.order_date,
	oi.mailing_address,
	pei.email,
	pei.phone,
	oi.email
FROM PersonalInfo as pei
--LEFT JOIN OrderInfo as oi
--RIGHT JOIN OrderInfo as oi
--INNER JOIN OrderInfo as oi
FULL JOIN OrderInfo as oi
ON pei.id = oi.customer_id
--WHERE oi.customer_id IS NULL
--WHERE pei.id IS NULL
--WHERE oi.customer_id IS NULL OR pei.id IS NULL
