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

create table Sala(
    id_sala int auto_increment primary key,
    nombre_sala varchar(30) not null,
    capacidad int
);
 
create table Silla(
    id_silla int auto_increment primary key,
    id_sala int not null,
    codigo varchar(5) not null,
    foreign key (id_sala) references Sala(id_sala)
);
 
create table Funcion(
    id_funcion int auto_increment primary key,
    id_pelicula int not null,
    id_sala int not null,
    fecha_hora datetime not null,
    precio decimal(10,2) not null,
    foreign key (id_pelicula) references Peliculas(id_pelicula),
    foreign key (id_sala) references Sala(id_sala)
);
 
create table VentaEntrada(
    id_venta int auto_increment primary key,
    id_funcion int not null,
    id_silla int not null,
    idUsuario int not null,
    fecha_venta datetime default current_timestamp,
    foreign key (id_funcion) references Funcion(id_funcion),
    foreign key (id_silla) references Silla(id_silla),
    foreign key (idUsuario) references usuario(idUsuario),
    unique (id_funcion, id_silla)
);

insert into Sala(nombre_sala, capacidad) values ('Sala 1', 20);
 
insert into Silla(id_sala, codigo) 
select 1, concat(l.letra, n.num) 
from (select 'A' letra union select 'B' union select 'C' union select 'D') l
cross join (select 1 num union select 2 union select 3
            union select 4 union select 5) n;


 
/* insert into Funcion(id_pelicula, id_sala, fecha_hora, precio)
values (1, 1, date_add(now(), interval 1 day), 12000),
       (1, 1, date_add(now(), interval 2 day), 12000);*/ 

create table AuditoriaVenta(
    id_auditoria int auto_increment primary key,
    id_venta int,
    id_funcion int,
    id_silla int,
    idUsuario int,
    accion varchar(20),
    fecha datetime default current_timestamp
);


-- CREACION DE TABLAS HASTA AQUI


DELIMITER //

drop procedure if exists login;//
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

drop procedure if exists GuardarGeneros;//
create procedure GuardarGeneros(
p_id_genero int , 
p_nombre_gen varchar(30)) begin 
insert into Genero(id_genero, nombre_gen) 
values (p_id_genero, p_nombre_gen);
end;//

drop procedure if exists MostrarGeneros;//
create procedure MostrarGeneros() 
begin 
select * from Genero g;
end;//

drop procedure if exists GuardarPeliculas;//
create procedure GuardarPeliculas(
p_nombre_completo varchar(60), 
p_director varchar(60), 
p_duracion int, 
p_fecha_estreno date, 
p_id_genero int) begin 
insert into Peliculas(nombre_completo, director, duracion, fecha_estreno, id_genero) 
values (p_nombre_completo, p_director, p_duracion, p_fecha_estreno, p_id_genero);
end;//

drop procedure if exists MostrarPeliculas;//
create procedure MostrarPeliculas()
begin select p.nombre_completo as 'Nombre Pelicula', g.nombre_gen as 'Genero', p.director as 'Director', p.duracion as 'Duracion (minutos)', p.fecha_estreno as 'Fecha Estreno' from Peliculas p inner join Genero g on p.id_genero=g.id_genero;
end;//

drop procedure if exists mostrarPeliGenero;//
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

drop procedure if exists BuscarPeliculasPorFecha;//
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

drop function if exists SillasLibres;//
create function SillasLibres(p_id_funcion int) returns int reads sql data
begin
    declare total int;
    declare vendidas int;
 
    select count(*) into total
    from Funcion f
    inner join Silla s on s.id_sala = f.id_sala
    where f.id_funcion = p_id_funcion;
 
    select count(*) into vendidas
    from VentaEntrada
    where id_funcion = p_id_funcion;
 
    return total - vendidas;
end;//
 
drop function if exists IngresosFuncion;//
create function IngresosFuncion(p_id_funcion int) returns decimal(12,2)
reads sql data
begin
    declare total decimal(12,2);
 
    select ifnull(f.precio * count(v.id_venta), 0) into total
    from Funcion f
    left join VentaEntrada v on v.id_funcion = f.id_funcion
    where f.id_funcion = p_id_funcion
    group by f.id_funcion, f.precio;
 
    return ifnull(total, 0);
end;//

drop procedure if exists MostrarFunciones;//
create procedure MostrarFunciones()
begin
    select f.id_funcion, p.nombre_completo as pelicula,
           s.nombre_sala as sala, f.fecha_hora, f.precio,
           SillasLibres(f.id_funcion) as libres
    from Funcion f
    inner join Peliculas p on f.id_pelicula = p.id_pelicula
    inner join Sala s on f.id_sala = s.id_sala
    where f.fecha_hora >= now()
    having libres > 0
    order by f.fecha_hora;
end;//
 
drop procedure if exists MostrarSillasDisponibles;//
create procedure MostrarSillasDisponibles(in p_id_funcion int)
begin
    select si.id_silla, si.codigo
    from Funcion f
    inner join Silla si on si.id_sala = f.id_sala
    where f.id_funcion = p_id_funcion
      and si.id_silla not in (
          select v.id_silla from VentaEntrada v
          where v.id_funcion = p_id_funcion)
    order by si.codigo;
end;//
 
drop procedure if exists GuardarVenta;//
create procedure GuardarVenta(in p_id_funcion int, in p_id_silla int,
                              in p_idUsuario int)
begin
    insert into VentaEntrada(id_funcion, id_silla, idUsuario)
    values (p_id_funcion, p_id_silla, p_idUsuario);
end;//
 
drop procedure if exists ReporteVentas;//
create procedure ReporteVentas(in p_desde date, in p_hasta date)
begin
    select
        p.nombre_completo as 'Pelicula',
        s.nombre_sala     as 'Sala',
        f.fecha_hora      as 'Funcion',
        si.codigo         as 'Silla',
        u.usr             as 'Cajero',
        f.precio          as 'Valor',
        v.fecha_venta     as 'Fecha Venta'
    from VentaEntrada v
    inner join Funcion f   on v.id_funcion = f.id_funcion
    inner join Peliculas p on f.id_pelicula = p.id_pelicula
    inner join Sala s      on f.id_sala = s.id_sala
    inner join Silla si    on v.id_silla = si.id_silla
    inner join usuario u   on v.idUsuario = u.idUsuario
    where date(v.fecha_venta) between p_desde and p_hasta
    order by v.fecha_venta;
end;//

drop trigger if exists ValidarVenta;//
create trigger ValidarVenta before insert on VentaEntrada for each row
begin
    declare sala_funcion int;
    declare sala_silla int;
    declare fecha_funcion datetime;
 
    select id_sala, fecha_hora into sala_funcion, fecha_funcion
    from Funcion where id_funcion = new.id_funcion;
 
    select id_sala into sala_silla
    from Silla where id_silla = new.id_silla;
 
    if sala_funcion <> sala_silla then
        signal sqlstate '45000'
        set message_text = 'La silla no pertenece a la sala de esta función';
    end if;
 
    if fecha_funcion < now() then
        signal sqlstate '45000'
        set message_text = 'La función ya se realizó';
    end if;
end;//

drop trigger if exists AuditarVenta;//
create trigger AuditarVenta after insert on VentaEntrada for each row
begin
    insert into AuditoriaVenta(id_venta, id_funcion, id_silla,
                               idUsuario, accion)
    values (new.id_venta, new.id_funcion, new.id_silla,
            new.idUsuario, 'VENTA');
end;//

drop trigger if exists BloquearModificacionVenta//
create trigger BloquearModificacionVenta before update on VentaEntrada for each row
begin
    signal sqlstate '45000'
    set message_text = 'Las ventas registradas no se pueden modificar';
end//


call GuardarGeneros('1', 'Accion');//
call GuardarGeneros('2', 'Animación');//
call GuardarGeneros('3', 'Aventura');//
call GuardarGeneros('4', 'Bélico');//
call GuardarGeneros('5', 'Ciencia ficcion');//
call GuardarGeneros('6', 'Comedia');//
call GuardarGeneros('7', 'Comedia dramatica');//
call GuardarGeneros('8', 'Crimen');//
call GuardarGeneros('9', 'Docuficcion');//
call GuardarGeneros('10', 'Documental');//
call GuardarGeneros('11', 'Drama');//
call GuardarGeneros('12', 'Fantasia');//
call GuardarGeneros('13', 'Ficcion');//
call GuardarGeneros('14', 'Misterio');//
call GuardarGeneros('15', 'Musical');//
call GuardarGeneros('16', 'Romance');//
call GuardarGeneros('17', 'Suspenso');//
call GuardarGeneros('18', 'Terror');//
call GuardarGeneros('19', 'Western');//

insert into Peliculas(nombre_completo, director, duracion, fecha_estreno, id_genero)
values ('Los Pollitos Dicen', 'Mike Milfort', 67,
        str_to_date('06-07-2007', '%d-%m-%Y'), 15);

insert into Funcion(id_pelicula, id_sala, fecha_hora, precio)
select min(id_pelicula), 1, date_add(now(), interval 1 day), 12000
from peliculas;

insert into Funcion(id_pelicula, id_sala, fecha_hora, precio)
select min(id_pelicula), 1, date_add(now(), interval 2 day), 12000
from peliculas;
