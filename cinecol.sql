drop DATABASE if exists cinecol;
create database cinecol;
use cinecol;

create table Genero(
    id_genero int primary key,
    nombre_gen varchar(30)
);

create table Peliculas(
    id_pelicula int auto_increment primary key ,
    nombre_completo varchar(60),
    director varchar(60),
    duracion int,
    fecha_estreno date,
    id_genero int,
    foreign key (id_genero) REFERENCES Genero(id_genero)
);


DELIMITER //
create procedure GuardarGeneros(
p_id_genero int , 
p_nombre_gen varchar(30)) begin 
insert into Genero(id_genero, nombre_gen) 
values (p_id_genero, p_nombre_gen);
end;//

create procedure MostrarGeneros() 
begin 
select * from Genero g;
end;//

create procedure GuardarPeliculas(
p_nombre_completo varchar(60), 
p_director varchar(60), 
p_duracion int, 
p_fecha_estreno date, 
p_id_genero int) begin 
insert into Peliculas(nombre_completo, director, duracion, fecha_estreno, id_genero) 
values (p_nombre_completo, p_director, p_duracion, p_fecha_estreno, p_id_genero);
end;//

create procedure MostrarPeliculas()
begin select p.nombre_completo as 'Nombre Pelicula', g.nombre_gen as 'Genero', p.director as 'Director', p.duracion as 'Duracion (minutos)', p.fecha_estreno as 'Fecha Estreno' from Peliculas p inner join Genero g on p.id_genero=g.id_genero;
end;//

create procedure mostrarPeliGenero(
n_gen varchar(30)) begin
select 
p.nombre_completo as 'Nombre Pelicula', 
p.director as 'Director', 
p.duracion as 'Duracion (minutos)', 
p.fecha_estreno as 'Fecha Estreno' 
from Peliculas p 
inner join Genero g on p.id_genero=g.id_genero
where g.id_genero = n_gen;
end;//

create procedure BuscarPeliculasPorFecha(
in p_desde date, 
in p_hasta date) begin
SELECT 
p.nombre_completo as 'Nombre Pelicula',
g.nombre_gen as 'Genero',
p.director as 'Director',
p.duracion as 'Duracion (minutos)',
p.fecha_estreno as 'Fecha Estreno'
from Peliculas p
inner join Genero g on g.id_genero = p.id_genero
where p.fecha_estreno between p_desde and p_hasta
order by p.fecha_estreno;
end;//

call GuardarGeneros('1', 'Accion');
call GuardarGeneros('2', 'Animación');
call GuardarGeneros('3', 'Aventura');
call GuardarGeneros('4', 'Bélico');
call GuardarGeneros('5', 'Ciencia ficcion');
call GuardarGeneros('6', 'Comedia');
call GuardarGeneros('7', 'Comedia dramatica');
call GuardarGeneros('8', 'Crimen');
call GuardarGeneros('9', 'Docuficcion');
call GuardarGeneros('10', 'Documental');
call GuardarGeneros('11', 'Drama');
call GuardarGeneros('12', 'Fantasia');
call GuardarGeneros('13', 'Ficcion');
call GuardarGeneros('14', 'Misterio');
call GuardarGeneros('15', 'Musical');
call GuardarGeneros('16', 'Romance');
call GuardarGeneros('17', 'Suspenso');
call GuardarGeneros('18', 'Terror');
call GuardarGeneros('19', 'Western');