DROP DATABASE IF EXISTS yourplacedb;

CREATE DATABASE IF NOT EXISTS yourplacedb;

USE yourplacedb;

CREATE TABLE USERS
(
  id VARCHAR(36) NOT NULL,
  fullname VARCHAR(200),
  dni VARCHAR(9),
  borndate DATE,
  password VARCHAR(250) NOT NULL,
  email VARCHAR(100) NOT NULL,
  verified BOOLEAN NOT NULL DEFAULT FALSE,
  picture VARCHAR(250),
  bio VARCHAR(180),
  telephone VARCHAR(12),
  PRIMARY KEY (id),
  UNIQUE (email),
  UNIQUE (telephone)
);

CREATE TABLE MESSAGES
(
  id VARCHAR(36) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  message VARCHAR(200) NOT NULL,
  id_user_sender VARCHAR(50) NOT NULL,
  id_user_receiver VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_user_sender) REFERENCES USERS(id),
  FOREIGN KEY (id_user_receiver) REFERENCES USERS(id)
);

CREATE TABLE USER_RATING
(
  rating INT NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  comment VARCHAR(200) NOT NULL,
  id_user_voter VARCHAR(50) NOT NULL,
  id_user_voted VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_user_voter, id_user_voted),
  FOREIGN KEY (id_user_voter) REFERENCES USERS(id),
  FOREIGN KEY (id_user_voted) REFERENCES USERS(id)
);

CREATE TABLE USER_ADDRESSES
(
  id VARCHAR(36) NOT NULL,
  street VARCHAR(250) NOT NULL,
  city VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  zipcode INT NOT NULL,
  id_user VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_user) REFERENCES USERS(id),
  UNIQUE (id_user)
);

CREATE TABLE PUBLICATION_ADDRESSES
(
  id VARCHAR(36) NOT NULL,
  street VARCHAR(200) NOT NULL,
  door VARCHAR(5) NOT NULL,
  floor VARCHAR(5) NOT NULL,
  city VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  zipcode INT NOT NULL,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE USER_BILLING_ADDRESSES
(
  id VARCHAR(36) NOT NULL,
  card_number INT NOT NULL,
  card_expiry DATE NOT NULL,
  id_user VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_user) REFERENCES USERS(id),
  UNIQUE (id_user)
);

CREATE TABLE NOTIFICATIONS
(
  id VARCHAR(36) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  notification_type ENUM('MESSAGE', 'VISIT', 'BOOKING', 'PAYMENT', 'RATING') NOT NULL,
  seen BOOLEAN NOT NULL DEFAULT FALSE,
  id_user VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_user) REFERENCES USERS(id)
);

CREATE TABLE PUBLICATION
(
  id VARCHAR(36) NOT NULL,
  area INT NOT NULL,
  rooms INT NOT NULL,
  bathrooms INT NOT NULL,
  garage BOOLEAN DEFAULT FALSE,
  elevator BOOLEAN DEFAULT FALSE,
  furnished BOOLEAN DEFAULT FALSE,
  pets BOOLEAN DEFAULT FALSE,
  parking BOOLEAN DEFAULT FALSE,
  garden BOOLEAN DEFAULT FALSE,
  pool BOOLEAN DEFAULT FALSE,
  terrace BOOLEAN DEFAULT FALSE,
  storage_room BOOLEAN DEFAULT FALSE,
  heating ENUM('GAS','ELECTRICA') DEFAULT 'ELECTRICA',
  publication_type ENUM('ALQUILER', 'VENTA') NOT NULL,
  deposit FLOAT DEFAULT 0,
  price FLOAT NOT NULL,
  availability_date DATE NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  disabled BOOLEAN NOT NULL DEFAULT FALSE,
  id_user VARCHAR(50) NOT NULL,
  id_publication_address VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_user) REFERENCES USERS(id),
  FOREIGN KEY (id_publication_address) REFERENCES PUBLICATION_ADDRESSES(id)
);

CREATE TABLE PUBLICATION_RATINGS
(
  rating INT NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  comment VARCHAR(180) NOT NULL,
  id_publication VARCHAR(50) NOT NULL,
  id_user_voter VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_publication, id_user_voter),
  FOREIGN KEY (id_publication) REFERENCES PUBLICATION(id),
  FOREIGN KEY (id_user_voter) REFERENCES USERS(id)
);

CREATE TABLE VISIT
(
  id VARCHAR(36) NOT NULL,
  visit_date DATE NOT NULL,
  visit_hour TIME NOT NULL,
  acepted BOOLEAN NOT NULL DEFAULT FALSE,
  id_publication VARCHAR(50) NOT NULL,
  id_user_visitant VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_publication) REFERENCES PUBLICATION(id),
  FOREIGN KEY (id_user_visitant) REFERENCES USERS(id)
);

CREATE TABLE PUBLICATION_PICTURES
(
  id VARCHAR(36) NOT NULL,
  url VARCHAR(200) NOT NULL,
  id_publication VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_publication) REFERENCES PUBLICATION(id)
);

CREATE TABLE BOOKING
(
  id VARCHAR(36) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  start_date DATE NOT NULL,
  end_date DATE DEFAULT NULL,
  acepted BOOLEAN NOT NULL DEFAULT FALSE,
  id_user_payer VARCHAR(50) NOT NULL,
  id_publication VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_user_payer) REFERENCES USERS(id),
  FOREIGN KEY (id_publication) REFERENCES PUBLICATION(id)
);

CREATE TABLE TRANSACTIONS
(
  id VARCHAR(36) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  amount INT NOT NULL,
  success BOOLEAN NOT NULL,
  id_booking VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_booking) REFERENCES BOOKING(id)
);

CREATE TABLE USER_PUBLICATION_FAVORITES
(
  id_user VARCHAR(50) NOT NULL,
  id_publication VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_user, id_publication),
  FOREIGN KEY (id_user) REFERENCES USERS(id),
  FOREIGN KEY (id_publication) REFERENCES PUBLICATION(id)
);
