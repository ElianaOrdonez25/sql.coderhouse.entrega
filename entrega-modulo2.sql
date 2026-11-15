-- Pre entrega Módulo 2: Tablas principales con restricciones y datos iniciales
-- Autor: Eliana Ordóñez

--0.Crear Base de Dato del proyecto

create database retail_project;

-- 1. DDL - Estructura de tablas

-- Tabla Clientes
create table clientes (
	id_cliente serial primary key,
	nombre varchar (50) not null,
	email varchar (100) not null unique
);

-- Tabla Producto
create table productos (
	id_producto serial primary key,
	nombre varchar (100) not null,
	categoria varchar (50) not null,
	precio decimal (10,2) not null check (precio >0),
	stock integer not null default 0 check (stock >=0)
);

-- Tabla Ventas
create table ventas (
	id_venta serial primary key,
	id_cliente integer not null references clientes(id_cliente),
	id_producto integer not null references productos(id_producto),
	cantidad integer not null check (cantidad >0),
	fecha_venta date not null default current_date,
	monto decimal (10,2) not null check (monto>0)
);


-- 2. DML - Carga inicial de datos

BEGIN;

INSERT INTO clientes (nombre, email) VALUES
    ('Laura Gómez',    'laura.gomez@example.com'),
    ('Martín Sosa',    'martin.sosa@example.com'),
    ('Carla Díaz',     'carla.diaz@example.com'),
    ('Bruno Ferreyra', 'bruno.ferreyra@example.com'),
    ('Nadia Romero',   'nadia.romero@example.com');

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
    ('Auriculares Bluetooth', 'Electrónica', 25999.00, 40),
    ('Mouse Inalámbrico',     'Electrónica', 8999.00,  75),
    ('Zapatillas Running',    'Indumentaria', 45000.00, 30),
    ('Campera Impermeable',   'Indumentaria', 62000.00, 15),
    ('Termo 1L Acero',        'Hogar',        18500.00, 60);

INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta, monto) VALUES
    (1, 1, 1, '2026-08-02', 25999.00),
    (2, 3, 2, '2026-08-05', 90000.00),
    (3, 5, 1, '2026-08-07', 18500.00),
    (4, 2, 3, '2026-08-10', 26997.00),
    (5, 4, 1, '2026-08-12', 62000.00);

COMMIT;

-- 3- DML - Mantenimiento 

-- Verificación previa antes del update
select id_producto, nombre, precio
from productos
where categoria = 'Indumentaria';

-- Rebajar el precio de los productos de la categoria indumentaria un 5%
update productos
set precio = round (precio*0.95,2)
where categoria = 'Indumentaria';

-- Verificarción antes del delete
select * 
from ventas
where id_venta = 1;

-- Elimincación de un registro de venta
delete from ventas
where id_venta=1;