DROP TABLE IF EXISTS pet CASCADE;
DROP TABLE IF EXISTS owner CASCADE;
DROP TABLE IF EXISTS visit CASCADE;
DROP TABLE IF EXISTS vet CASCADE;


CREATE TABLE owner (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL
);

CREATE TABLE pet (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  species TEXT NOT NULL,
  breed TEXT,
  age INTEGER,
  owner_id INTEGER,
  CONSTRAINT pet_owner_id FOREIGN KEY (owner_id) REFERENCES owner (id)
);

CREATE TABLE vet (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  license TEXT NOT NULL
);

CREATE TABLE visit (
  id INTEGER PRIMARY KEY,
  pet_id INTEGER NOT NULL,
  vet_id INTEGER NOT NULL,
  visit_date DATE NOT NULL,
  diagnosis TEXT NOT NULL,
  CONSTRAINT visit_pet_id FOREIGN KEY (pet_id) REFERENCES pet (id),
  CONSTRAINT visit_vet_id FOREIGN KEY (vet_id) REFERENCES vet (id)
);


INSERT INTO owner (id, name, phone) VALUES (1, 'Amal', '800-555-0100');
INSERT INTO owner (id, name, phone) VALUES (2, 'Cruz', '800-555-0123');
INSERT INTO owner (id, name, phone) VALUES (3, 'Jie', '800-555-0150');

INSERT INTO pet (id, name, species, breed, age, owner_id) VALUES (1, 'Mewmew', 'cat', 'Tabby', 10, 1);
INSERT INTO pet (id, name, species, breed, age, owner_id) VALUES (2, 'Whiskers', 'cat', 'Calico', 1, 2);
INSERT INTO pet (id, name, species, breed, age, owner_id) VALUES (3, 'Lil'' Bub', 'cat', 'American Shorthair', 5, 2);
INSERT INTO pet (id, name, species, breed, age, owner_id) VALUES (4, 'Snuggles', 'dog', 'Bichon', 5, 3);
INSERT INTO pet (id, name, species, breed, age, owner_id) VALUES (5, 'Honey', 'dog', 'Pug', 1, 3);

INSERT INTO vet (id, name, license) VALUES (1, 'Dr. Furry', 'OH1234');
INSERT INTO vet (id, name, license) VALUES (2, 'Dr. Bones', 'NY9999');

INSERT INTO visit (id, pet_id, vet_id, visit_date, diagnosis) VALUES (1, 1, 2, '2022-01-20', 'fleas');
INSERT INTO visit (id, pet_id, vet_id, visit_date, diagnosis) VALUES (2, 1, 2, '2022-03-18', 'hairball');
INSERT INTO visit (id, pet_id, vet_id, visit_date, diagnosis) VALUES (3, 4, 1, '2022-01-28', 'ear infection');
INSERT INTO visit (id, pet_id, vet_id, visit_date, diagnosis) VALUES (4, 3, 2, '2022-09-01', 'sore paw');
