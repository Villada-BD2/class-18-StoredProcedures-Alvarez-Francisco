-- Clase 18, EJ 1: 100% HECHO POR MI : --
delimiter // 
create procedure cantCopias(in f_film_id int, in f_film_name varchar(150), in st_store_id int, out cant_copias int)
begin 
	select count(i.film_id) into cant_copias from inventory i 
	join film f on f.film_id = i.film_id
	where ((f_film_id = f.film_id and f_film_name = f.title) or (f_film_id != f.film_id and f_film_name = f.title) 
	or (f_film_id = f.film_id and (f_film_name != f.title or f_film_name = ''))) and st_store_id = i.store_id;
END //
delimiter ;

call cantCopias(0, 'ADAPTATION HOLES', 2, @resultado);
select @resultado;

-- Clase 18 EJ 2: 100% hecho por mi: --
delimiter //
create procedure peoplePerCountry(in co_country varchar(200), out lista_personas varchar(6000)) 
begin 
	declare customer_name varchar(200);
	declare lista varchar(6000) default '';
	declare terminar int default 0;
	declare bucle_customer cursor for
	select concat(c.first_name, ' ', c.last_name) from customer c 
	join address a on a.address_id = c.address_id 
	join city ci on ci.city_id = a.city_id 
	join country co on co.country_id = ci.country_id
	where co_country = co.country;
	declare continue handler for not found
	set terminar = 1;
	open bucle_customer; 
	bucle: loop
		fetch bucle_customer into customer_name;
		if terminar = 1 then 
		leave bucle; 
		end if; 
		if lista = '' then 
		set lista = customer_name; 
		else
		set lista = concat(lista, '; ', customer_name);
		end if;
	end loop;
	close bucle_customer;
	set lista_personas = lista;
end //

delimiter ;

select * from customer


call peoplePerCountry('Argentina', @resultado);
select @resultado;

-- Clase 18, EJ 3: --

-- La función inventory_in_stock y el procedimiento almacenado film_in_stock se usan para gestionar la disponibilidad de películas en la base de datos.

-- La función inventory_in_stock recibe el identificador de una copia física y devuelve un valor booleano (TRUE o FALSE) para indicar si está disponible para alquilar. Lo que hace basicamente es, comprueba si existen alquileres sin una fecha de devolución registrada. --

-- Por su parte, el procedimiento film_in_stock recibe el identificador de una película y el de una tienda. Utiliza la función anterior para encontrar todas las copias disponibles de esa película en la tienda seleccionada y devuelve sus identificadores, además de la cantidad total de copias disponibles mediante un parámetro de salida (OUT). --

-- Ejemplo de uso: --
-- Para comprobar si una copia está disponible: --
-- SELECT inventory_in_stock(8); -- 

-- Buscar las copias disponibles de una película en una tienda: --
-- CALL film_in_stock(1, 1, @cantidad); --

-- Consultar la cantidad de copias disponibles --
-- SELECT @cantidad; -- 