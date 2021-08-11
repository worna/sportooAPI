--DROP TABLE admin;
--DROP TABLE sport_hall_customer;
--DROP TABLE customer_course;
--DROP TABLE course;
--DROP TABLE room;
--DROP TABLE sport_hall;
--DROP TABLE customer;
--DROP TABLE city;

create table admin
(
    email    varchar not null
        constraint admin_pkey
            primary key,
    password varchar not null
);

alter table admin
    owner to john;

create table city
(
    city_name varchar not null,
    zip_code  integer not null,
    country   varchar not null,
    constraint city_pkey
        primary key (country, zip_code, city_name)
);

alter table city
    owner to john;

create table customer
(
    id               integer generated always as identity
        constraint customer_pkey
            primary key,
    first_name       varchar not null,
    last_name        varchar not null,
    birth_date       date    not null,
    gender           integer not null,
    phone_number     varchar not null,
    email            varchar not null,
    password         varchar not null,
    inscription_date date    not null,
    is_manager       integer not null,
    is_instructor    integer not null,
    language         varchar not null,
    address          varchar not null,
    city_name        varchar not null,
    zip_code         integer not null,
    country          varchar not null,
    constraint fk_city
        foreign key (city_name, zip_code, country) references city (city_name, zip_code, country)
);

alter table customer
    owner to john;

create unique index customer_email_uindex
    on customer (email);

create table sport_hall
(
    id           integer generated always as identity
        constraint sport_hall_pkey
            primary key,
    name         varchar not null,
    manager      varchar
        constraint sport_hall_customer_email_fk
            references customer (email)
            on delete set null,
    phone_number varchar not null,
    email        varchar not null,
    city_name    varchar not null,
    zip_code     integer not null,
    country      varchar not null,
    address      varchar not null,
    constraint fk_city
        foreign key (city_name, zip_code, country) references city (city_name, zip_code, country)
);

alter table sport_hall
    owner to john;

create unique index sport_hall_name_uindex
    on sport_hall (name);

create table sport_hall_customer
(
    id_sport_hall  integer not null
        constraint sport_hall_customer_id_sport_hall_fkey
            references sport_hall
            deferrable,
    email_customer varchar not null
        constraint sport_hall_customer_customer_email_fk
            references customer (email),
    constraint sport_hall_customer_pkey
        primary key (id_sport_hall, email_customer)
);

alter table sport_hall_customer
    owner to john;

create table room
(
    id_room       integer not null,
    id_sport_hall integer not null
        constraint room_id_sport_hall_fkey
            references sport_hall
            deferrable,
    max_capacity  integer,
    constraint room_pkey
        primary key (id_room, id_sport_hall)
);

alter table room
    owner to john;

create table course
(
    id                 integer generated always as identity
        constraint course_pkey
            primary key,
    id_sport_hall      integer   not null,
    id_room            integer   not null,
    starting_date_time timestamp not null,
    ending_date_time   timestamp not null,
    level              varchar   not null,
    activity           varchar   not null,
    instructor         varchar
        constraint "FK_instructor"
            references customer (email)
            on delete set null,
    constraint course_id_sport_hall_fkey
        foreign key (id_sport_hall, id_room) references room (id_sport_hall, id_room)
            on update cascade on delete cascade
            deferrable
);

alter table course
    owner to john;

create table customer_course
(
    email_customer varchar not null,
    id_course      integer not null
        constraint customercourse_id_course_fkey
            references course
            deferrable,
    constraint customercourse_pkey
        primary key (email_customer, id_course)
);

alter table customer_course
    owner to john;



INSERT INTO admin (email, password) values
    ('adminarnaud@jesuisadmin', '$2b$10$nrEYTYATjPsmlfIzkFl.Ke63t8i7u1FEgK9WJMkLoRpvCbSdKSDU.'),
    ('adminvicky@jesuisadmin', '$2b$10$UIVN8CI0Dqy9evA8Ceo4Iums1/09ZvtZF5JRGXsLKGSumQs1VwiD.');

INSERT INTO city (city_name, zip_code, country) values
    ('Namur', 5000, 'Belgique'),
    ('Fleurus', 5000, 'Belgique'),
    ('Thuin', 6530, 'Belgique'),
    ('Tamines', 5060, 'Belgique'),
    ('Charleroi', 6000, 'Belgique'),
    ('Gembloux', 5030, 'Belgique'),
    ('Namur', 5101, 'Belgique'),
    ('Namur', 5100, 'Belgique'),
    ('Namur', 5020, 'Belgique'),
    ('Namur', 5002, 'Belgique'),
    ('Namur', 5310, 'Belgique'),
    ('Namur', 5001, 'Belgique');


INSERT INTO customer (first_name, last_name, birth_date, gender, phone_number, email, password, inscription_date, is_manager, is_instructor, language, address, city_name, zip_code, country) values
    ('Arnaud', 'Lockman', '2001/02/07', 0, '0474025605', 'etu40153@henallux.be', '$2b$10$JpNfn2ZcVrJS.0PqurxZmuAq1KD7yKF9sHlsqe0Xi42ZvsiOro5YS', '2020/12/15', 1, 0, 'français', 'Rue Dave 331', 'Namur', 5000, 'Belgique'),
    ('Vicky', 'Zagorski', '2000/09/14', 1, '0496818836', 'etu41165@henallux.be', '$2b$10$979p27waEVjeGVitpOyqrua8h4YLAAxwhJH8NDf4AwDeap/sjtACO', '2020/12/15', 1, 1, 'français', 'Rue Brennet 102', 'Fleurus', 5000, 'Belgique'),
    ('Louis', 'Vanadenhoven', '1999/09/11', 0, '0475691236', 'etu20856@henallux.be', '$2b$10$p7ikVMeiYM2TpBxFu5RoGOmXj74ZrfzkOAtNmTtYdb2UhAFVHzFku', '2020/12/15', 0, 1, 'français', 'Place du marché 33', 'Thuin', 6530, 'Belgique'),
    ('Alizée', 'Verschoren', '2001/08/18', 1, '0497542263', 'alizou@hotmail.com', '$2b$10$ufsTzozI6OxVv5LEJ.RdseL8/g34hFxCu3KAqx2qqox/jr2FY.vZW', '2020/12/15', 0, 1, 'spanish', 'Rue Barthélemy Molet 20', 'Tamines', 5060, 'Belgique'),
    ('Emma', 'Di Mola', '2003/06/11', 1, '0498154632', 'emmadimola@gmail.be', '$2b$10$y8e2knp3rJoB7tnBJr2UE.8NjDGHN1L3y6pSmgnvMwSB9RxdqBUf2', '2020/12/15', 0, 1, 'english', 'Rue de Montigny', 'Charleroi', 6000, 'Belgique'),
    ('Hugo', 'Gebbia', '2004/07/05', 0, '0474754986', 'huggies@hotmail.be', '$2b$10$j5FSVPaRe7qq8sAZjcCU2urMIecBNELykYYLp7yqrOIt4d9ETkTXK', '2020/12/15', 0, 0, 'français', 'Grand Rue 143', 'Charleroi', 6000, 'Belgique'),
    ('Antonella', 'Robin', '1980/07/4', 1, '0471459632', 'anto@hotmail.be', '$2b$10$W7BytOiURKFdvOlSvTSfMesie41lLdFCXbHvpArd7cr4i2DteDYq.', '2020/12/15', 0, 0, 'français', 'Avenue Albert 1er 32', 'Gembloux', 5030, 'Belgique'),
    ('Florine', 'Zagorski', '2004/07/05', 1, '0474754986', 'flo@hotmail.be', '$2b$10$/IZLRDkiK3.DZawNp1rFke9fejT5qU/rKGhI22Ayc1UID31qzJm.q', '2020/12/15', 0, 0, 'français', 'Rue Brennet 102', 'Fleurus', 5000, 'Belgique'),
    ('Brigitte', 'Hody', '1967/09/06', 1, '0474754986', 'bri@hotmail.be', '$2b$10$sYcyRhhvFbABLh.UbdWgHu.un5N.lK9kp/xU0k8h.80jMiKfFyy4q', '2020/12/15', 0, 1, 'français', 'Rue Brennet 102', 'Fleurus', 5000, 'Belgique'),
    ('Walter', 'Zagorski', '2004/07/05', 0, '0474754986', 'wal@hotmail.be', '$2b$10$sW9TIZLAGefwaXENqvCt/e9irbZVBM0gEMSZiScZMopXG6gNajC4i', '2020/12/15', 1, 0, 'français', 'Rue Brennet 102', 'Fleurus', 5000, 'Belgique'),
    ('Benjamin', 'Vanadenhoven', '1995/04/02', 0, '0412563982', 'benjivana@outlook.com', '$2b$10$uPHqil/SvqMD7XmUygx3dO/QMHIWrK7wu9C8PUD1MGpa.ARGwfdRa', '2020/12/15', 1, 0, 'français', 'Rue Brennet 102', 'Fleurus', 5000, 'Belgique');



INSERT INTO sport_hall (name, manager, phone_number, email, city_name, zip_code, country, address) values
    ('Jims', 'etu40153@henallux.be', '081302807', 'namur@jimsfitness.com', 'Namur', 5000, 'Belgique', 'Rue de la Gare Fleurie 16'),
    ('CrossFit Namur', 'etu40153@henallux.be', '0471132890', 'namur@crossfit.com', 'Namur', 5000, 'Belgique', 'Avenue Albert 1er 3'),
    ('Kineo Fitness & Wellness', 'etu40153@henallux.be', '081300802', 'erpent@kineo.be', 'Namur', 5101, 'Belgique', 'Place Notre Dame de la Paix 1'),
    ('Basic Fit', 'etu41165@henallux.be', '025887710', 'namur@jimsfitness.com', 'Namur', 5000, 'Belgique', 'Boulevard l Herbatte 249'),
    ('First Class Gym', 'etu41165@henallux.be', '081309100', 'firstclass@gym.com', 'Namur', 5100, 'Belgique', 'Chaussée de Liège 147'),
    ('Gym senio Flawinne Gymsana', 'etu41165@henallux.be', '0471403999', 'gymsana@gym.com', 'Namur', 5020, 'Belgique', 'Rue Emile Vanderverlde 8'),
    ('Swiss Ball Namur', 'etu41165@henallux.be', '0473472851', 'vanespen@live.be', 'Namur', 5000, 'Belgique', 'Place André Ryckmans 18'),
    ('Freerun', 'wal@hotmail.be', '0473472851', 'namur@freeruncompany.com', 'Namur', 5002, 'Belgique', 'Rue de l Escaille 262'),
    ('Garuda Muay-Thaï', 'wal@hotmail.be', '0478715649', 'garudamt@hotmail.com', 'Namur', 5100, 'Belgique', 'Rue de Dave 331'),
    ('DJ Elizabeth - Salsabam ASBL', 'wal@hotmail.be', '0474720176', 'info@djeli.be', 'Namur', 5100, 'Belgique', 'Rue Ablert Michiels 8'),
    ('Top Gym', 'benjivana@outlook.com', '081435652', 'info@topgym.be', 'Namur', 5310, 'Belgique', 'Chaussée de Namur 291'),
    ('Enjoy Sport ASBL', 'benjivana@outlook.com', '081313219', 'enjoysportasbl@gmail.com', 'Namur', 5100, 'Belgique', 'Rue du Corso Fleuri 15'),
    ('Namur Fit', 'benjivana@outlook.com', '081456379', 'fit@namur.be', 'Namur', 5001, 'Belgique', 'Place du Bia Bouquet 2'),
    ('Sportoo Center', 'etu40153@henallux.be', '0814596230', 'sportoo@center.be', 'Namur', 5000, 'Belgique', 'Rue de la Gare Fleurie 16'),
    ('Sportoo Center Kids', 'etu40153@henallux.be', '0814596230', 'sportoo@center.be', 'Namur', 5000, 'Belgique', 'Rue de la Gare Fleurie 17');


INSERT INTO room (id_room, id_sport_hall, max_capacity) values
    (1, 1, 25),
    (2, 1, 10),

    (1, 2, 15),
    (2, 2, 30),

    (1, 3, 40),

    (1, 4, 30),
    (2, 4, 18),

    (1, 5, 10),
    (2, 5, 20),
    (3, 5, 30),

    (1, 6, 15),

    (1, 7, 12),
    (2, 7, 20),

    (1, 8, 50),
    (2, 8, 35),
    (3, 8, 20),

    (1, 9, 16),

    (1, 10, 23),
    (2, 10, 39),

    (1, 11, 30),

    (1, 12, 100),

    (1, 13, 21),
    (2, 13, 10),

    (1, 14, 15),
    (2, 14, 32),

    (1, 15, 10),
    (2, 15, 20),
    (3, 15, 20);


INSERT INTO course (id_sport_hall, id_room, starting_date_time, ending_date_time, level, activity, instructor) values
    (1, 1, '2020/12/17 17:30:00', '2020/12/17 18:30:00', 'Enfants', 'Yoga', 'etu20856@henallux.be'),
    (1, 1, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Adultes', 'BodyPump', 'alizou@hotmail.com'),
    (1, 1, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Adultes', 'BodyAttack', 'alizou@hotmail.com'),
    (1, 2, '2020/12/17 20:00:00', '2020/12/17 21:00:00', 'Senior', 'Yoga', 'etu20856@henallux.be'),

    (2, 1, '2020/12/17 17:30:00', '2020/12/17 18:30:00', 'Adultes niveau 1', 'Crossfit', 'emmadimola@gmail.be'),
    (2, 1, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Adultes niveau 2', 'Crossfit', 'emmadimola@gmail.be'),
    (2, 1, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Adultes', 'Stretching', 'emmadimola@gmail.be'),
    (2, 2, '2020/12/17 17:30:00', '2020/12/17 18:30:00', 'Adultes niveau 1', 'Cardio', 'bri@hotmail.be'),
    (2, 2, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Adultes niveau 2', 'Cardio', 'bri@hotmail.be'),
    (2, 2, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Adultes niveau 3', 'Cardio', 'bri@hotmail.be'),

    (3, 1, '2020/12/17 19:00:00', '2020/12/17 20:00:00', 'Senior', 'Yoga', 'bri@hotmail.be'),
    (3, 1, '2020/12/17 20:30:00', '2020/12/17 21:30:00', 'Senior', 'Relaxation', 'bri@hotmail.be'),

    (4, 1, '2020/12/17 16:30:00', '2020/12/17 18:30:00', 'Enfants niveau 1', 'Gym', 'etu20856@henallux.be'),
    (4, 2, '2020/12/17 18:30:00', '2020/12/17 20:30:00', 'Enfants niveau 2', 'Gym', 'alizou@hotmail.com'),

    (5, 1, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Adultes niveau 1', 'Zumba', 'emmadimola@gmail.be'),
    (5, 1, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Adultes niveau 2', 'Zumba', 'emmadimola@gmail.be'),
    (5, 2, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Adultes niveau 1', 'Cardio', 'bri@hotmail.be'),
    (5, 2, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Adultes niveau 2', 'Cardio', 'bri@hotmail.be'),
    (5, 3, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Adultes niveau 3', 'BodyCombat', 'bri@hotmail.be'),

    (6, 1, '2020/12/17 16:00:00', '2020/12/17 18:00:00', 'Enfants', 'Circuit training', 'alizou@hotmail.com'),
    (6, 1, '2020/12/17 18:00:00', '2020/12/17 20:00:00', 'Ados', 'Circuit training', 'alizou@hotmail.com'),
    (6, 1, '2020/12/17 20:00:00', '2020/12/17 22:00:00', 'Adultes', 'Circuit training', 'alizou@hotmail.com'),

    (7, 1, '2020/12/17 17:30:00', '2020/12/17 18:30:00', 'Adultes niveau 1', 'Crossfit', 'emmadimola@gmail.be'),
    (7, 2, '2020/12/17 17:30:00', '2020/12/17 18:30:00', 'Adultes niveau 2', 'Crossfit', 'emmadimola@gmail.be'),

    (8, 1, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Ados', 'Cardio', 'emmadimola@gmail.be'),
    (8, 1, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Ados', 'Course', 'emmadimola@gmail.be'),
    (8, 2, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Ados', 'Zumba', 'bri@hotmail.be'),
    (8, 2, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Ados', 'Fitness', 'bri@hotmail.be'),
    (8, 3, '2020/12/17 18:30:00', '2020/12/17 19:30:00', 'Ados', 'Stretching', 'bri@hotmail.be'),
    (8, 3, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Ados', 'Yoga', 'bri@hotmail.be'),

    (9, 1, '2020/12/17 14:00:00', '2020/12/17 15:00:00', 'Kids', 'Fun Dance', 'emmadimola@gmail.be'),
    (9, 1, '2020/12/17 15:00:00', '2020/12/17 16:00:00', 'Kids', 'Gymnastique', 'emmadimola@gmail.be'),

    (10, 1, '2020/12/17 16:00:00', '2020/12/17 18:00:00', 'Enfants', 'Psychomotricité', 'alizou@hotmail.com'),
    (10, 1, '2020/12/17 18:00:00', '2020/12/17 20:00:00', 'Ados', 'Circuit training', 'alizou@hotmail.com'),
    (10, 2, '2020/12/17 16:00:00', '2020/12/17 18:00:00', 'Enfants', 'Psychomotricité', 'bri@hotmail.be'),
    (10, 2, '2020/12/17 18:00:00', '2020/12/17 20:00:00', 'Ados', 'Circuit training', 'bri@hotmail.be'),

    (11, 1, '2020/12/17 15:30:00', '2020/12/17 16:30:00', 'Adultes niveau 1', 'Bodybalance', 'etu20856@henallux.be'),
    (11, 1, '2020/12/17 16:30:00', '2020/12/17 17:30:00', 'Adultes niveau 2', 'Bodybalance', 'etu20856@henallux.be'),

    (12, 1, '2020/12/17 15:30:00', '2020/12/17 17:30:00', 'Enfants niveau 1', 'Yoga', 'etu41165@henallux.be'),
    (12, 1, '2020/12/17 17:30:00', '2020/12/17 19:30:00', 'Enfants niveau 2', 'Yoga', 'etu41165@henallux.be'),

    (13, 1, '2020/12/17 14:00:00', '2020/12/17 15:00:00', 'Enfants niveau 1', 'Zumba', 'etu41165@henallux.be'),
    (13, 2, '2020/12/17 14:00:00', '2020/12/17 15:00:00', 'Enfants niveau 2', 'Zumba', 'bri@hotmail.be'),

    (14, 1, '2020/12/17 15:30:00', '2020/12/17 17:30:00', 'Senior', 'Yoga', 'alizou@hotmail.com'),
    (14, 2, '2020/12/17 17:30:00', '2020/12/17 19:30:00', 'Senior', 'Yoga', 'emmadimola@gmail.be'),

    (15, 1, '2020/12/17 15:30:00', '2020/12/17 17:30:00', 'Ados niveau 1', 'Circuit training', 'etu41165@henallux.be'),
    (15, 2, '2020/12/17 17:30:00', '2020/12/17 19:30:00', 'Ados niveau 2', 'Circuit training', 'etu41165@henallux.be'),
    (15, 3, '2020/12/17 19:30:00', '2020/12/17 20:30:00', 'Ados niveau 1', 'Circuit training', 'etu41165@henallux.be');


INSERT INTO sport_hall_customer (id_sport_hall, email_customer) values
    (1, 'etu41165@henallux.be'),
    (15, 'etu41165@henallux.be'),

    (1, 'emmadimola@gmail.be'),

    (1, 'alizou@hotmail.com'),

    (4, 'etu40153@henallux.be'),
    (6, 'etu40153@henallux.be'),
    (8, 'etu40153@henallux.be'),
    (10, 'etu40153@henallux.be'),

    (8, 'bri@hotmail.be'),
    (10, 'bri@hotmail.be'),

    (1, 'huggies@hotmail.be'),
    (3, 'huggies@hotmail.be'),

    (1, 'anto@hotmail.be'),
    (3, 'anto@hotmail.be'),

    (4, 'flo@hotmail.be');


INSERT INTO customer_course (email_customer, id_course) values
    ('etu41165@henallux.be', 1),
    ('etu41165@henallux.be', 3),
    ('etu41165@henallux.be', 45),
    ('etu41165@henallux.be', 47),

    ('emmadimola@gmail.be', 1),
    ('emmadimola@gmail.be', 3),

    ('alizou@hotmail.com', 1),
    ('alizou@hotmail.com', 3),

    ('etu40153@henallux.be', 13),
    ('etu40153@henallux.be', 14),
    ('etu40153@henallux.be', 20),
    ('etu40153@henallux.be', 21),
    ('etu40153@henallux.be', 22),
    ('etu40153@henallux.be', 26),
    ('etu40153@henallux.be', 35),

    ('bri@hotmail.be', 26),
    ('bri@hotmail.be', 35),

    ('huggies@hotmail.be', 1),
    ('huggies@hotmail.be', 3),
    ('huggies@hotmail.be', 11),
    ('huggies@hotmail.be', 12),

    ('anto@hotmail.be', 1),
    ('anto@hotmail.be', 3),
    ('anto@hotmail.be', 11),
    ('anto@hotmail.be', 12),

    ('flo@hotmail.com', 13),
    ('flo@hotmail.com', 14);