create database Academia;
use Academia;
-- Tabla Estudiantes
create table Estudiantes (
id_estudiante int primary key not null unique,
nombre varchar (50) not null,
procedencia text (30),
email varchar (50));
-- Tabla Profesores
create table Profesores (
id_profesor int primary key not null unique,
nombre varchar(50) not null,
edad int,
telefono int,
email varchar(50));
-- Tabla Asignaturas
create table Asignaturas (
id_asignatura varchar(10) primary key not null unique,
nombre varchar (20) not null,
creditos int not null,
precio int not null);
-- Tabla Sucursales
create table sucursales(
id_sucursal int primary key not null unique,
direccion varchar (50) not null,
hora_de_apertura time not null,
hora_de_cierre time not null);
-- Tabla empleados
create table tipo_de_empleados(
id_empleado int primary key not null unique,
funcion text (20) not null,
horas_de_trabajo int);
-- Tablas sueldos
create table Sueldos(
id_sueldo int primary key not null unique,
sueldo_neto int not null,
id_empleado int not null,
foreign key (id_empleado)
references tipo_de_empleados (id_empleado),
id_sucursal int not null,
foreign key (id_sucursal)
references sucursales (id_sucursal));