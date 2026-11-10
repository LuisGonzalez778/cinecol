drop DATABASE if exists cinecol;
create database cinecol;
use cinecol;

create table perfil(
idPerfil int NOT NULL AUTO_INCREMENT primary key,
nombrePerfil varchar(45) NOT NULL
);

INSERT INTO perfil VALUES (1,'ADMINISTRADOR'),(2,'CAJERO');

CREATE TABLE usuario (
  idUsuario int NOT NULL AUTO_INCREMENT primary key,
  usr varchar(45) NOT NULL,
  pass varchar(45) NOT NULL,
  idPerfil int NOT NULL,
  FOREIGN KEY (idPerfil) REFERENCES perfil(idPerfil)
  );
  
INSERT INTO usuario VALUES (1,'ADMIN','1234',1),(2,'LGONZA','5678',2),(3,'ICASAD','9012',2);

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

CREATE PROCEDURE login(p_usuario VARCHAR(45), p_pass VARCHAR(45))
BEGIN
DECLARE v_idUsuario INT;
    DECLARE v_usuario VARCHAR(45);
    DECLARE v_idPerfil INT;
    
    SELECT idUsuario, idPerfil INTO v_idUsuario, v_idPerfil
    FROM usuario 
    WHERE usr = p_usuario AND pass = p_pass
    LIMIT 1;
    
    IF v_idUsuario IS NOT NULL THEN
        SELECT v_idUsuario AS idUsuario, v_idPerfil AS idPerfil;
    ELSE
        SELECT 0 AS idUsuario,  0 AS idPerfil;
    END IF;
END;//

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