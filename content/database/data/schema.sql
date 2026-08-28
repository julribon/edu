
-----------------------------------------
-- Delete tables
-----------------------------------------

drop table if exists command_product;
drop table if exists command;
drop table if exists product;
drop table if exists client;


-----------------------------------------
-- Create tables
-----------------------------------------
create table client (
    id          integer,
    email       varchar(50) not null, 
    password    varchar(50) not null,
    firstname   varchar(50) not null,
    lastname    varchar(50) not null,
    constraint pk_client        primary key (id),
    constraint uq_client_email  unique      (email)
);

create table product (
    id integer,
    reference char(10) not null,
    name varchar(50) not null, 
    description varchar(1000),
    price decimal not null,
    --category varchar(255) not null,
    constraint pk_product primary key (id),
    constraint uq_product_reference unique (reference)
);

create table command (
    id integer,
    client_id integer not null,
    reference char(10) not null,
    command_date date default current_date,
    constraint pk_command primary key (id),
    constraint uq_command_reference unique (reference),
    constraint fk_command_client_id foreign key (client_id) references client(id)
);

create table command_product (
    command_id integer,
    product_id integer,
    quantity integer not null,
    buy_price decimal not null,
    constraint pk_command_product primary key (command_id, product_id),
    constraint fk_command_product_command_id foreign key (command_id) references command(id),
    constraint fk_command_product_product_id foreign key (product_id) references product(id)
);

/*
create table category (
    id integer primary key,
    name varchar(255) not null
);
*/

/*
insert into client values
(1, 'a@s.ch', '1234', 'Alice', 'Smith'),
(2, 'b@s.ch', '1234', 'Bob', 'Smith');

insert into product values
(1, 'PROD_12345', 'Pomme', 'Pomme Gala', 1.0);

insert into product (id, price, reference, name)
values (2, 1.5, 'PROD_56789', 'Poire');

update product
set description = 'Poire  fraiche'
where id = 2
;

select *
from client
where id = 2;

delete from client
where email = 'a@s.ch'
;

select * from product
;
*/





-- Insertion des clients avec emails professionnels
INSERT INTO client (id, email, password, firstname, lastname) VALUES (1, 'antoinette.costa@techcorp.com', '$wFLOiUkU0', 'Antoinette', 'Costa');
INSERT INTO client (id, email, password, firstname, lastname) VALUES (2, 'auguste.costa@smartshop.io', '7(kW#eIy_^', 'Auguste', 'Costa');
INSERT INTO client (id, email, password, firstname, lastname) VALUES (3, 'benjamin.dias@gadgethub.org', 'T^_5EJBwsi', 'Benjamin', 'Dias');
INSERT INTO client (id, email, password, firstname, lastname) VALUES (4, 'claire.bourgeois@digitalzone.net', 'aAS^eZai%6', 'Claire', 'Bourgeois');
INSERT INTO client (id, email, password, firstname, lastname) VALUES (5, 'émile.pons@cloudify.co', 'IjnY7lS8+%', 'Émile', 'Pons');
INSERT INTO client (id, email, password, firstname, lastname) VALUES (6, 'alice.smith@hotmal.com', '7Hkuf(7678)', 'Alice', 'Smith');

-- Insertion des produits réalistes
INSERT INTO product (id, reference, name, description, price) VALUES (1, 'REF0000001', 'Echo Dot 5', 'Enceinte connectée avec Alexa, Wi-Fi et Bluetooth intégrés, design compact', 59.99);
INSERT INTO product (id, reference, name, description, price) VALUES (2, 'REF0000002', 'Logitech MX Master 3S', 'Souris sans fil haut de gamme avec capteurs de précision et défilement MagSpeed', 99.9);
INSERT INTO product (id, reference, name, description, price) VALUES (3, 'REF0000003', 'Kindle Paperwhite', 'Liseuse étanche avec éclairage réglable et autonomie longue durée', 129.95);
INSERT INTO product (id, reference, name, description, price) VALUES (4, 'REF0000004', 'Anker PowerCore 20K', 'Batterie externe 20 000 mAh avec charge rapide PowerIQ', 49.99);
INSERT INTO product (id, reference, name, description, price) VALUES (5, 'REF0000005', 'Samsung SSD 980 1TB', 'Disque SSD interne NVMe M.2 PCIe Gen3 pour ordinateurs portables et PC', 89.99);
INSERT INTO product (id, reference, name, description, price) VALUES (6, 'REF0000006', 'Lenovo Laptop i7', 'Ordinateur portables Lenovo nouvelle génération', 574.95);


-- Insertion des commandes
INSERT INTO command (id, client_id, reference, command_date) VALUES (1, 2, 'CMD0000001', '2024-11-21');
INSERT INTO command (id, client_id, reference, command_date) VALUES (2, 1, 'CMD0000002', '2025-02-27');
INSERT INTO command (id, client_id, reference, command_date) VALUES (3, 5, 'CMD0000003', '2024-11-30');
INSERT INTO command (id, client_id, reference, command_date) VALUES (4, 3, 'CMD0000004', '2024-11-17');
INSERT INTO command (id, client_id, reference, command_date) VALUES (5, 5, 'CMD0000005', '2024-12-25');
INSERT INTO command (id, client_id, reference, command_date) VALUES (6, 2, 'CMD0000006', '2025-02-01');
INSERT INTO command (id, client_id, reference, command_date) VALUES (7, 1, 'CMD0000007', '2025-01-13');
INSERT INTO command (id, client_id, reference, command_date) VALUES (8, 3, 'CMD0000008', '2025-01-23');
INSERT INTO command (id, client_id, reference, command_date) VALUES (9, 3, 'CMD0000009', '2025-03-28');
INSERT INTO command (id, client_id, reference, command_date) VALUES (10, 5, 'CMD0000010', '2025-01-26');

-- Insertion des lignes de commande avec prix d'achat ajustés
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (4, 3, 3, 126.3);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (5, 4, 3, 52.48);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (9, 2, 1, 100.0);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (2, 2, 2, 95.81);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (10, 3, 2, 124.06);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (7, 1, 3, 61.8);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (8, 5, 1, 92.6);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (1, 2, 3, 101.36);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (6, 2, 1, 104.56);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (3, 3, 1, 124.07);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (6, 5, 2, 89.25);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (9, 3, 3, 132.57);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (4, 5, 1, 92.07);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (7, 4, 2, 49.85);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (5, 1, 4, 58.59);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (1, 1, 3, 59.79);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (3, 2, 1, 104.76);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (10, 5, 2, 94.44);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (2, 4, 3, 50.67);
INSERT INTO command_product (command_id, product_id, quantity, buy_price) VALUES (8, 3, 1, 132.03);

--COMMIT;

