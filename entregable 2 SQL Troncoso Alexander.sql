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

-- Insertamos datos a las tablas
insert into asignaturas (id_asignatura, nombre, creditos, precio) values
(1,'Quimica',4,120), (2,'Lenguaje',3,90), (3,'Algebra',5,150), (4,'Aritmetica',4,120),
(5,'Fisica',5,150), (6,'Biologia',3,90), (7,'Economia',4,120), (8,'Historia',3,90),
(9,'Filosofia',2,60), (10,'Geometria',4,120);

insert into estudiantes (id_estudiante, nombre, procedencia, email) values
(1,'Alfredo','Lima','alfredo@gmail.pe'), (2,'Elizabeth','Cusco','elizabeth@gmail.com'),
(3,'Eduardo','Callao','eduardo@hotmail.com'), (4,'Alexander','Trujillo','alexander@outlook.com'),
(5,'Moises','Lima','Moi@gmail.pe'), (6,'Delia','Pisco','delicita@gmail.com'),
(7,'Pablo','Cusco','pablucha@hotmail.com'), (8,'Matias','Lima','elmati@outlook.com'),
(9,'Sandra','Puno','snadra@gmail.pe'), (10,'Elsa','Cusco','elsa@gmail.com'),
(11,'Jorge','Callao','jorgito@hotmail.com'), (12,'Camila','Trujillo','Cam@outlook.com');

insert into profesores (id_profesor, nombre_profes, id_asignatura, edad, telefono, email) values
(1,'Sandro',3,35,936564758,'sandro@gmail.pe'), (2,'Lucia',2,40,936545268,'lucid@gmail.pe'),
(3,'Miguel',5,38,966446809,'miky@gmail.pe'), (4,'Luis',8,42,973233553,'lucho@gmail.pe'),
(5,'Karen',1,46,999222555,'karen@gmail.pe'), (6,'Juan',10,38,946895124,'juanjo@gmail.pe'),
(7,'Katya',4,50,956458743,'katy@gmail.pe'), (8,'Agustin',9,39,936895478,'agustin@gmail.pe'),
(9,'Jose',6,25,923365457,'joses@gmail.pe'), (10,'Paco',7,40,999999991,'pacooo@gmail.pe');

insert into sucursales (id_sucursal, direccion, hora_de_apertura, hora_de_cierre) values
(1, 'Av.Los Incas 512', '08:15:00', '20:00:00'),
(2, 'Av.La cultura 685', '7:00:00', '21:00:00'),
(3, 'Calle Maruri L.c-1', '11:00:00', '17:00:00');

insert into tipo_de_empleados (id_empleado, funcion, horas_de_trabajo) values
(1, 'Docente', 6), (2, 'Administracion', 4), (3, 'Limpieza', 8),
(4, 'logistica', 6), (5, 'Seguridad', 8), (6, 'Marketing', 5);

insert into sueldos (id_empleado, sueldo_neto, id_sucursal) values
(1, 1800,2), (2, 1500,3), (3, 1000,null),
(4, 2300,3), (5, 1500,null), (6, 2000,1);

-- Creacion de vistas
-- Vista para ver que estudiantes de la academia provienen del deparatamento de Cusco
Create or replace view Cusqueños as
(select nombre, procedencia
from estudiantes
where procedencia = 'cusco');
select * from cusqueños;
-- Vista para ver que estudiantes tienen un correo con direccion gmail
Create view gmail as
(select nombre, email
from estudiantes
where email like '%gmail%');
select * from gmail;

-- Vista para ver las funcion del empleado, cuantas horas trabaja y su sueldo
create or replace view descr_empleo as 
(select funcion, horas_de_trabajo, sueldo_neto
from tipo_de_empleados t join sueldos s on (t.id_empleado=s.id_empleado));
select * from descr_empleo;

-- Vista para ver que profesor enseña cada curso y su edad ordenandolos de menor a mayor
create or replace view profes as 
(select nombre, edad, nombre_profes
from profesores p join asignaturas a on (p.id_asignatura=a.id_asignatura) order by edad);
select * from profes;

-- Vista para ver que cursos son los mas caros (valen mas de 100 soles) y cuanto cuestan
Create or replace view Cursos_caros as
(select nombre, precio
from asignaturas
where precio > 100);
select * from cursos_caros;

-- Creacion de funciones
-- funcion para ver el nombre de un curso por su id 

delimiter //
create function f_curso (identificacion int) returns varchar (100) deterministic
begin
     declare curso varchar(100);
     select nombre into curso from asignaturas 
     where id_asignatura = identificacion;
     return curso;
end //
delimiter ;
select f_curso(2);

-- funcion para ver el correo de un estudiante, teniendo su id de estudiante y su nombre 
delimiter //
create function fcorreo (ide int, nom char(50)) returns varchar (100) deterministic
begin
     declare correo varchar(100);
     select email into correo from estudiantes
     where id_estudiante = ide and nombre = nom;
     return correo;
end //
delimiter ;
select fcorreo (1,'Alfredo') as correo;

-- Creacion de Stored Procedures
-- Stored procedure para ordenar los estudiantes de la academia de acuerdo al campo establecido

DELIMITER //
CREATE PROCEDURE `sp_estudiante_order` (IN field CHAR(20))
BEGIN
    DECLARE orden_alum VARCHAR(100);
    DECLARE clausula VARCHAR(200);
    IF field <> '' THEN
        SET orden_alum = CONCAT('ORDER BY ', field);
    ELSE
        SET orden_alum = '';
    END IF;
    SET @clausula = CONCAT('SELECT * FROM estudiantes ', orden_alum);
    PREPARE runSQL FROM @clausula;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END //
DELIMITER ;

CALL sp_estudiante_order('Procedencia');

-- Stored procedure para registrar a los nuevos alumnos en un periodo de academia nuevo
-- y ver al ultimo alumno registrado

create table Nuevos_alumnos(
id int PRIMARY KEY auto_increment,
alumno char(20));

DELIMITER $$
CREATE PROCEDURE nuevos (in Nuevoalumno char(20))
begin
    IF Nuevoalumno = "" then 
    select "ERROR NO SE PUEDE CARGAR EL REGISTRO";
    Else 
		insert into Nuevos_alumnos (alumno) values (Nuevoalumno);
	end if;
     select * from Nuevos_alumnos order by id desc;
END $$
DELIMITER ;
call nuevos("Efrain");
call nuevos("Eliazar");

-- Creacion de Triggers
/*Trigger Before Insert en la tabla sueldos: Para asegurarse de que el empleado
y la sucursal en la que trabaja existen antes de insertar un nuevo sueldo.*/
SET foreign_key_checks = 0;
DELIMITER $$
CREATE TRIGGER insert_sueldo_neto
BEFORE INSERT ON sueldos
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tipo_de_empleados WHERE id_empleado = NEW.id_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de empleado no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM sucursales WHERE id_sucursal = NEW.id_sucursal) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sucursal especificada no existe';
    END IF;
END $$
DELIMITER ;
INSERT INTO sueldos (id_empleado, sueldo_neto, id_sucursal)
VALUES (2, 1500, 5);

/*Trigger after Delete en la tabla estudiantes: Para observar la fecha de eliminacion de un estudiante 
y poner sus datos mas importantes en otra tabla.*/

CREATE TABLE ex_estudiantes(
id_estudiante int,
nombre varchar(25),
procedencia varchar(25),
fecha timestamp
);

delimiter $$

create trigger registro_exs
after delete on estudiantes
for each row 
begin
    insert into ex_estudiantes(id_estudiante,nombre,procedencia,fecha)
    value (old.id_estudiante, old.nombre,old.procedencia ,now());
end $$
delimiter ;

delete from estudiantes where id_estudiante = 4;




