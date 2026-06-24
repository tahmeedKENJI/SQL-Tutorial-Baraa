USE JoinPractice_1;
GO

SELECT
	pei.id,
	pei.first_name,
	pei.last_name,
	pei.email,
	pei.phone,
	oi.customer_id,
	oi.first_name,
	oi.last_name,
	oi.email,
	oi.order_id,
	oi.order_date,
	oi.mailing_address
FROM OrderInfo as oi
LEFT JOIN PersonalInfo as pei
ON pei.id = oi.customer_id
WHERE pei.id IS NOT NULL;

--Alternatively...
--SELECT
--	pei.id,
--	pei.first_name,
--	pei.last_name,
--	pei.email,
--	pei.phone,
--	oi.customer_id,
--	oi.first_name,
--	oi.last_name,
--	oi.email,
--	oi.order_id,
--	oi.order_date,
--	oi.mailing_address
--FROM OrderInfo as oi
--FULL JOIN PersonalInfo as pei
--ON pei.id = oi.customer_id
--WHERE pei.id IS NOT NULL AND oi.customer_id IS NOT NULL;