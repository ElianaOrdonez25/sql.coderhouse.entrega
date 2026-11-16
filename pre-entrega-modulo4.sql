-- Pre entrega Módulo 4: Consultas multicapa para análisis de negocio
-- Proyecto Retail
-- Eliana Ordóñez
-- Requiere las tablas del módulo 2 y una tabla adicional "categorias".
--=======================================================================

-- Tabla auxiliar usada en este módulo (no formaba parte del esquema original)
-- Se agrega para poder resolver la consulta de rentabilidad por categoria.

create table if not exists categorias (
	id_categoria serial primary key,
	nombre varchar (50) not null unique
);

insert into categorias (nombre) values
('Electrónica'),
('Indumentaria'),
('Hogar')
on conflict (nombre) do nothing;

--========================================================================
-- 1. Rentabilidad por categoría
-- Mostrar las categorías de producto que generan más ingresos, para priorizar
-- stock e inversión publicitaria en la próxima campaña.

select
	cat.nombre as categoria,
	SUM(v.cantidad) as unidades_vendidas,
	SUM (v.monto) as ingreso_total
from ventas v
join productos p on v.id_producto = p.id_producto 
join categorias cat on p.categoria = cat.nombre 
group by cat.nombre 
having SUM (v.monto) >30000 --umbral de ventas
order by ingreso_total desc;

--=========================================================================
-- 2. Clientes sin compras
-- Hallar clientes registrados sin coincidencia en la tabla ventas, para 
-- realizar campaña de reactivación con descuentos.

select 
	c.id_cliente,
	c.nombre,
	c.email,
	coalesce( COUNT(v.id_venta),0) as cantidad_compras
from clientes c
left join ventas v on c.id_cliente = v.id_cliente
group by c.id_cliente, c.nombre, c.email
having COUNT(v.id_venta)=0;

--==========================================================================
-- 3. Top de compras por cliente
-- Saber que producto compra más cada cliente y cuando fue la ultima compra, 
--para hacer seguimient personalizado.

select 
	c.nombre as cliente,
	p.nombre as producto_mas_comprado,
	SUM (v.cantidad) as veces_comprado,
	MAX(v.fecha_venta) as ultima_compra
from clientes c
join ventas v on c.id_cliente = v.id_cliente 
join productos p on v.id_producto = p.id_producto 
group by c.nombre, p.nombre
order  by c.nombre, veces_comprado desc;