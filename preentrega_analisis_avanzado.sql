-- Pre-entrega Módulo 5
-- Eliana Ordóñez
-- Requiere tablas de modulo 2 y 4

--====================================================================
-- 1. CTE: Ventas_mensuales
-- Agrupa las ventas por mes (normalizando con DATE_TRUNC) y categoría
--sumando el total vendido.
with ventas_mensuales as (
	select 
		date_trunc('month',v.fecha_venta) as mes,
		p.categoria as categoria,
		SUM(v.monto) as total_ventas
	from ventas v
	join productos p on v.id_producto = p.id_producto
	group by date_trunc ('month',v.fecha_venta), p.categoria 
),

-- 2. CTE: metricas_ventana
metricas_ventana as (
	select
		mes,
		categoria,
		total_ventas,
		RANK() OVER(partition by mes order by total_ventas desc) as ranking_mes,
		SUM(total_ventas) OVER(partition by categoria order by mes) as ventas_acumuladas
		from ventas_mensuales
)

-- Select final: compara la ventana del mes contra el promedio historico
-- de esa misma categorria y etiqueta el resultado.

select 
	mv.mes,
	mv.categoria,
	mv.total_ventas,
	mv.ranking_mes,
	mv.ventas_acumuladas,
	case 
		when mv.total_ventas > prom.promedio_categoria then 'Exitoso'
		else 'Bajo el promedio'
	end as comparativa
from metricas_ventana mv
join (
	select categoria, avg(total_ventas) as promedio_categoria
	from ventas_mensuales
	group by categoria
) as prom on mv.categoria=prom.categoria 
order by mv.mes, mv.ranking_mes;
	
	
	