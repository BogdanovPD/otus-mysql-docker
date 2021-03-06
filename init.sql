-- MySQL Script generated by MySQL Workbench
-- Mon 02 Dec 2019 12:37:10 MSK
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema otus
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema otus
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `otus` DEFAULT CHARACTER SET latin1 ;
USE `otus` ;

-- -----------------------------------------------------
-- Table `otus`.`postal_codes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`postal_codes` (
  `postal_code` VARCHAR(50) NOT NULL,
  `id_postal_codes` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_postal_codes`),
  UNIQUE INDEX `postal_code_UNIQUE` (`postal_code` ASC)  COMMENT 'Postal codes can not be repeated')
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`countries` (
  `name` VARCHAR(100) NOT NULL,
  `abv` VARCHAR(2) NOT NULL COMMENT 'Country\'s abbreviation',
  `id_countries` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_countries`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT 'Name must be unique',
  UNIQUE INDEX `abv_UNIQUE` (`abv` ASC)  COMMENT 'Abbreviation must be unique because name is unique',
  UNIQUE INDEX `id_countries_UNIQUE` (`id_countries` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`regions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`regions` (
  `id_regions` INT(11) NOT NULL AUTO_INCREMENT,
  `region` VARCHAR(150) NOT NULL,
  `id_countries` INT(11) NOT NULL,
  PRIMARY KEY (`id_regions`),
  UNIQUE INDEX `region_country_UNIQUE` (`region` ASC, `id_countries` ASC)  COMMENT 'Combination of region-country must be unique',
  UNIQUE INDEX `id_countries_UNIQUE` (`id_countries` ASC),
  INDEX `fk_regions_id_countries_idx` (`id_countries` ASC),
  CONSTRAINT `fk_regions_id_countries`
    FOREIGN KEY (`id_countries`)
    REFERENCES `otus`.`countries` (`id_countries`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`cities` (
  `id_cities` INT(11) NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(150) NOT NULL,
  `id_regions` INT(11) NOT NULL,
  PRIMARY KEY (`id_cities`),
  UNIQUE INDEX `id_regions_city_UNIQUE` (`id_regions` ASC, `city` ASC)  COMMENT 'Combination of region-city must be unique',
  UNIQUE INDEX `id_regions_UNIQUE` (`id_regions` ASC),
  INDEX `fk_cities_region_idx` (`id_regions` ASC),
  INDEX `city_idx` (`city` ASC),
  CONSTRAINT `fk_cities_id_regions`
    FOREIGN KEY (`id_regions`)
    REFERENCES `otus`.`regions` (`id_regions`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`streets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`streets` (
  `id_streets` INT(11) NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(200) NOT NULL,
  `id_cities` INT(11) NOT NULL,
  PRIMARY KEY (`id_streets`),
  UNIQUE INDEX `id_cities_street_UNIQUE` (`id_cities` ASC, `street` ASC)  COMMENT 'Combination of city-street msut be unique',
  INDEX `fk_streets_city_idx` (`id_cities` ASC),
  INDEX `street_idx` (`street` ASC),
  CONSTRAINT `fk_streets_city`
    FOREIGN KEY (`id_cities`)
    REFERENCES `otus`.`cities` (`id_cities`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`addresses` (
  `id_addresses` INT(11) NOT NULL AUTO_INCREMENT,
  `id_streets` INT(11) NULL DEFAULT NULL COMMENT 'Address content map: street -> city -> region -> country. Because any of subsequent entities may have similar names',
  `building_number` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Building number with codes etc.',
  `id_postal_codes` INT(11) NULL DEFAULT NULL COMMENT 'Different addresses can have similar postal code',
  PRIMARY KEY (`id_addresses`),
  UNIQUE INDEX `id_streets_building_number_UNIQUE` (`id_streets` ASC, `building_number` ASC)  COMMENT 'street-to-building number combination must be unique',
  INDEX `fk_addresses_street_idx` (`id_streets` ASC),
  INDEX `fk_addresses_postal_code_idx` (`id_postal_codes` ASC),
  CONSTRAINT `fk_addresses_id_postal_codes`
    FOREIGN KEY (`id_postal_codes`)
    REFERENCES `otus`.`postal_codes` (`id_postal_codes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_addresses_id_streets`
    FOREIGN KEY (`id_streets`)
    REFERENCES `otus`.`streets` (`id_streets`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`categories` (
  `id_categories` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `id_parent_category` INT(11) NULL DEFAULT NULL COMMENT 'Can be recursive',
  PRIMARY KEY (`id_categories`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT 'Name must be unique',
  INDEX `fk_categories_id_parent_category_idx` (`id_parent_category` ASC),
  CONSTRAINT `fk_categories_id_parent_category`
    FOREIGN KEY (`id_parent_category`)
    REFERENCES `otus`.`categories` (`id_categories`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`genders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`genders` (
  `gender` VARCHAR(10) NOT NULL,
  `id_genders` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_genders`),
  UNIQUE INDEX `gender_UNIQUE` (`gender` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`languages` (
  `abv` VARCHAR(2) NOT NULL COMMENT 'Language\'s abbreviation',
  `language` VARCHAR(100) NOT NULL,
  `id_languages` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_languages`),
  UNIQUE INDEX `language_abv_UNIQUE` (`abv` ASC)  COMMENT 'Abbreviation must be unique because language is unique',
  UNIQUE INDEX `language_UNIQUE` (`language` ASC)  COMMENT 'Language name must be unique')
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`marital_statuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`marital_statuses` (
  `name` VARCHAR(20) NOT NULL,
  `id_marital_statuses` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_marital_statuses`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`titles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`titles` (
  `title` VARCHAR(45) NOT NULL COMMENT 'Mr. Mrs. Dr. etc.',
  `abv` VARCHAR(10) NOT NULL COMMENT 'Title\'s abbreviation',
  `id_titles` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_titles`),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC),
  UNIQUE INDEX `title_abv_UNIQUE` (`abv` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`customers` (
  `id_customers` INT(11) NOT NULL AUTO_INCREMENT,
  `id_titles` INT(11) NULL DEFAULT NULL COMMENT 'Title id e.g. Mr. Mrs. etc.',
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `birth_date` DATE NOT NULL,
  `id_marital_statuses` INT(11) NOT NULL,
  `id_genders` INT(11) NOT NULL,
  `id_languages` INT(11) NOT NULL,
  `id_address` INT(11) NOT NULL,
  PRIMARY KEY (`id_customers`),
  UNIQUE INDEX `id_UNIQUE` (`id_customers` ASC),
  INDEX `fk_customers_title_idx` (`id_titles` ASC),
  INDEX `fk_customers_id_maritial_statuses_idx` (`id_marital_statuses` ASC),
  INDEX `fk_customers_id_genders_idx` (`id_genders` ASC),
  INDEX `last_name_birth_date_idx` (`last_name` ASC, `birth_date` ASC),
  INDEX `fk_customers_id_languages_idx` (`id_languages` ASC),
  INDEX `fk_customers_id_addresses_idx` (`id_address` ASC),
  CONSTRAINT `fk_customers_id_addresses`
    FOREIGN KEY (`id_address`)
    REFERENCES `otus`.`addresses` (`id_addresses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customers_id_genders`
    FOREIGN KEY (`id_genders`)
    REFERENCES `otus`.`genders` (`id_genders`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customers_id_languages`
    FOREIGN KEY (`id_languages`)
    REFERENCES `otus`.`languages` (`id_languages`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customers_id_marital_statuses`
    FOREIGN KEY (`id_marital_statuses`)
    REFERENCES `otus`.`marital_statuses` (`id_marital_statuses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customers_id_titles`
    FOREIGN KEY (`id_titles`)
    REFERENCES `otus`.`titles` (`id_titles`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`producers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`producers` (
  `id_producers` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `id_addresses` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id_producers`),
  INDEX `fk_producers_id_addresses_idx` (`id_addresses` ASC),
  INDEX `name_idx` (`name` ASC),
  CONSTRAINT `fk_producers_id_addresses`
    FOREIGN KEY (`id_addresses`)
    REFERENCES `otus`.`addresses` (`id_addresses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`products` (
  `id_products` BIGINT(20) NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `id_producers` INT(11) NOT NULL COMMENT 'Product must have a producer',
  `id_categories` INT(11) NOT NULL,
  PRIMARY KEY (`id_products`),
  UNIQUE INDEX `name_provider_category_UNIQUE` (`name` ASC, `id_categories` ASC, `id_producers` ASC)  COMMENT 'Combination of name-category-provider must be unique (product names can be repeated)',
  INDEX `fk_products_id_categories_idx` (`id_categories` ASC),
  INDEX `name_category_idx` (`name` ASC),
  INDEX `fk_products_id_producers_idx` (`id_producers` ASC),
  CONSTRAINT `fk_products_id_categories`
    FOREIGN KEY (`id_categories`)
    REFERENCES `otus`.`categories` (`id_categories`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_products_id_producers`
    FOREIGN KEY (`id_producers`)
    REFERENCES `otus`.`producers` (`id_producers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`prices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`prices` (
  `id_prices` BIGINT(25) NOT NULL AUTO_INCREMENT,
  `id_products` BIGINT(20) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `date` DATE NOT NULL COMMENT 'A price start date. The price of the last date considers as current',
  PRIMARY KEY (`id_prices`),
  UNIQUE INDEX `id_products_price_date_UNIQUE` (`id_products` ASC, `date` ASC, `price` ASC)  COMMENT 'Combination of product-price-date must be unique',
  INDEX `fk_prices_id_products_idx` (`id_products` ASC),
  INDEX `date_idx` (`date` ASC),
  CONSTRAINT `fk_prices_id_products`
    FOREIGN KEY (`id_products`)
    REFERENCES `otus`.`products` (`id_products`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`providers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`providers` (
  `id_providers` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `id_addresses` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id_providers`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `fk_providers_id_addresses_idx` (`id_addresses` ASC),
  INDEX `name_idx` (`name` ASC),
  CONSTRAINT `fk_providers_id_addresses`
    FOREIGN KEY (`id_addresses`)
    REFERENCES `otus`.`addresses` (`id_addresses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `otus`.`purchases`
-- -----------------------------------------------------
CREATE TABLE `purchases` (
  `id_purchases` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Reduces product''s count in the warehouse',
  `id_customers` int(11) NOT NULL,
  `id_products` bigint(20) NOT NULL,
  `date_time` datetime NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Defines whether the purchase is canceled. false - canceled',
  `id_addresses` int(11) NOT NULL,
  `id_languages` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`id_purchases`),
  UNIQUE KEY `id_customers_products_date_UNIQUE` (`id_customers`,`id_products`,`date_time`) COMMENT 'Combination of customer-producr-date must be unique',
  KEY `fk_purchases_id_products_idx` (`id_products`),
  KEY `fk_purchases_id_addresses_idx` (`id_addresses`),
  KEY `fk_purchases_id_languages_idx` (`id_languages`),
  CONSTRAINT `fk_purchases_id_addresses` FOREIGN KEY (`id_addresses`) REFERENCES `addresses` (`id_addresses`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_purchases_id_customers` FOREIGN KEY (`id_customers`) REFERENCES `customers` (`id_customers`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_purchases_id_languages` FOREIGN KEY (`id_languages`) REFERENCES `languages` (`id_languages`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_purchases_id_products` FOREIGN KEY (`id_products`) REFERENCES `products` (`id_products`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- -----------------------------------------------------
-- Table `otus`.`supplies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`supplies` (
  `id_supply` INT(11) NOT NULL COMMENT 'Supplies new products to warehouse from providers',
  `id_products` BIGINT(20) NOT NULL,
  `id_provider` INT(11) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_supply`),
  INDEX `fk_supplies_id_products_idx` (`id_products` ASC),
  INDEX `fk_supplies_id_providers_idx` (`id_provider` ASC),
  CONSTRAINT `fk_supplies_id_products`
    FOREIGN KEY (`id_products`)
    REFERENCES `otus`.`products` (`id_products`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_supplies_id_providers`
    FOREIGN KEY (`id_provider`)
    REFERENCES `otus`.`providers` (`id_providers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

ALTER TABLE `otus`.`supplies` 
ADD COLUMN `count` INT(11) NOT NULL AFTER `price`;

ALTER TABLE `otus`.`supplies` 
ADD COLUMN `date_time` DATETIME NOT NULL AFTER `count`;

-- -----------------------------------------------------
-- Table `otus`.`warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `otus`.`warehouse` (
  `id_warehouse` INT(11) NOT NULL AUTO_INCREMENT,
  `id_products` VARCHAR(45) NOT NULL,
  `count` INT(11) NOT NULL COMMENT 'Rest count of product',
  PRIMARY KEY (`id_warehouse`),
  INDEX `fk_warehouse_products_id_idx` (`id_products` ASC),
  CONSTRAINT `fk_warehouse_products_id`
    FOREIGN KEY (`id_products`)
    REFERENCES `otus`.`products` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

ALTER TABLE `otus`.`warehouse` 
ADD UNIQUE INDEX `id_products_UNIQUE` (`id_products` ASC);

-- -----------------------------------------------------
-- Table `otus`.`purchases` partitioning
-- -----------------------------------------------------
ALTER TABLE `otus`.`purchases` 
DROP FOREIGN KEY `fk_purchases_id_products`,
DROP FOREIGN KEY `fk_purchases_id_languages`,
DROP FOREIGN KEY `fk_purchases_id_customers`,
DROP FOREIGN KEY `fk_purchases_id_addresses`; --drops foreign keys, but indexes still remain 

ALTER TABLE `otus`.`purchases` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id_purchases`, `date_time`);

ALTER TABLE otus.purchases PARTITION BY RANGE (TO_DAYS(ftime)) --partitioning depending on date
(
PARTITION p20190101 VALUES LESS THAN (TO_DAYS('2019-01-01')) ENGINE = InnoDB,
PARTITION p20200101 VALUES LESS THAN (TO_DAYS('2020-01-01')) ENGINE = InnoDB,
PARTITION p20210101 VALUES LESS THAN (TO_DAYS('2021-01-01')) ENGINE = InnoDB,
PARTITION future VALUES LESS THAN MAXVALUE ENGINE = InnoDB,
);

-- -----------------------------------------------------
-- Table `otus`.`languages` insert
-- -----------------------------------------------------
insert into otus.languages values ('RU', 'Russian', 1);
insert into otus.languages values ('EN', 'English', 2);

-- -----------------------------------------------------
-- Table `otus`.`genders` insert
-- -----------------------------------------------------
insert into otus.genders values ('Male', 1);
insert into otus.genders values ('Female', 2);

-- -----------------------------------------------------
-- Table `otus`.`titles` insert
-- -----------------------------------------------------
insert into otus.titles values ('Mister', 'Mr', 1);
insert into otus.titles values ('Missis', 'Mrs', 2);
insert into otus.titles values ('Miss', 'Ms', 3);
insert into otus.titles values ('Doctor', 'Dr', 4);

-- -----------------------------------------------------
-- Table `otus`.`marital_statuses` insert
-- -----------------------------------------------------
insert into otus.marital_statuses values ('Married', 1);
insert into otus.marital_statuses values ('Single', 2);

-- -----------------------------------------------------
-- Table `otus`.`postal_codes` insert
-- -----------------------------------------------------
insert into otus.postal_codes values ('123456', 1);
insert into otus.postal_codes values ('234567', 2);

-- -----------------------------------------------------
-- Table `otus`.`countries` insert
-- -----------------------------------------------------
insert into otus.countries values ('Russia', 'RU', 1);
insert into otus.countries values ('United States of America', 'US', 2);

-- -----------------------------------------------------
-- Table `otus`.`regions` insert
-- -----------------------------------------------------
insert into otus.regions values (1, 'St.Petersburg', 1);
insert into otus.regions values (2, 'New York', 2);

-- -----------------------------------------------------
-- Table `otus`.`cities` insert
-- -----------------------------------------------------
insert into otus.cities values (1, 'St.Petersburg', 1);
insert into otus.cities values (2, 'New York', 2);

-- -----------------------------------------------------
-- Table `otus`.`streets` insert
-- -----------------------------------------------------
insert into otus.streets values (1, 'Nevskiy Prospect', 1);
insert into otus.streets values (2, '1st Avenue', 2);

-- -----------------------------------------------------
-- Table `otus`.`addresses` insert
-- -----------------------------------------------------
insert into otus.addresses values (1, 1, '1', 1);
insert into otus.addresses values (2, 2, '1', 2);

-- -----------------------------------------------------
-- Table `otus`.`customers` insert
-- -----------------------------------------------------
insert into otus.customers values (1, 1, 'Pavel', 'Bogdanov', '1992-04-18', 1, 1, 1, 1);
insert into otus.customers values (2, 1, 'John', 'Smith', '1982-03-10', 2, 2, 2, 2);

-- -----------------------------------------------------
-- Table `otus`.`producers` insert
-- -----------------------------------------------------
insert into otus.producers values (1, 'Samsung', 1);
insert into otus.producers values (2, 'Apple', 2);

-- -----------------------------------------------------
-- Table `otus`.`providers` insert
-- -----------------------------------------------------
insert into otus.providers values (1, 'Tech Dealer', 1);

-- -----------------------------------------------------
-- Table `otus`.`categories` insert
-- -----------------------------------------------------
insert into otus.categories values (1, 'Computers', NULL);
insert into otus.categories values (2, 'Mobile', NULL);

-- -----------------------------------------------------
-- Table `otus`.`products` insert
-- -----------------------------------------------------
insert into otus.products values (1, 'Apple Mac', 2, 1);
insert into otus.products values (2, 'Apple IPhone 11', 2, 2);
insert into otus.products values (3, 'Samsung Galaxy S10', 1, 2);

-- -----------------------------------------------------
-- Table `otus`.`supplies` insert
-- ---------------------------------------------------
insert into otus.supplies values (1, 1, 1, 150000.00, 20, '2020-01-01 12:00:00');
insert into otus.supplies values (2, 2, 1, 80000.00, 20, '2020-01-02 12:00:00');
insert into otus.supplies values (3, 3, 1, 75000.00, 20, '2020-01-03 12:00:00');

-- -----------------------------------------------------
-- Table `otus`.`prices` insert
-- ---------------------------------------------------
insert into otus.prices values (1, 1, 180000.00,'2020-01-01 00:00:00');
insert into otus.prices values (2, 2, 95000.00,'2020-01-01 00:00:00');
insert into otus.prices values (3, 3, 90000.00,'2020-01-01 00:00:00');

-- -----------------------------------------------------
-- Table `otus`.`purchases` insert
-- ---------------------------------------------------
insert into otus.purchases values (1, 1, 1, '2020-01-04 15:00:00', 1, 1, 1, 180000.00, 1);
insert into otus.purchases values (2, 1, 2, '2020-01-04 15:00:00', 1, 1, 1, 95000.00, 1);
insert into otus.purchases values (3, 2, 3, '2020-01-04 17:00:00', 1, 2, 2, 90000.00, 1);

-- -----------------------------------------------------
-- Table `otus`.`warehouse` insert
-- ---------------------------------------------------
insert into otus.warehouse values (1, 1, 19);
insert into otus.warehouse values (2, 2, 19);
insert into otus.warehouse values (3, 3, 19);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
