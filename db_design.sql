-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema interly
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema interly
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `interly` DEFAULT CHARACTER SET utf8 ;
USE `interly` ;

-- -----------------------------------------------------
-- Table `interly`.`admin_lang`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`admin_lang` (
  `admin_lang_id` INT(11) NOT NULL AUTO_INCREMENT,
  `lang` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`admin_lang_id`),
  UNIQUE INDEX `lang_UNIQUE` (`lang` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`complexity_level`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`complexity_level` (
  `level_id` INT(11) NOT NULL AUTO_INCREMENT,
  `difficulty` VARCHAR(50) NOT NULL,
  `speed` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`level_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 31
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`currency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`currency` (
  `currency_id` INT(11) NOT NULL AUTO_INCREMENT,
  `currency` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`currency_id`),
  UNIQUE INDEX `currency_UNIQUE` (`currency` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`customer` (
  `customer_id` INT(11) NOT NULL AUTO_INCREMENT,
  `first_name_EN` VARCHAR(50) NOT NULL,
  `last_name_EN` VARCHAR(50) NOT NULL,
  `first_name_JAP` VARCHAR(50) NULL DEFAULT NULL,
  `last_name_JAP` VARCHAR(50) NULL DEFAULT NULL,
  `company_EN` VARCHAR(255) NULL DEFAULT NULL,
  `company_SPA` VARCHAR(255) NULL DEFAULT NULL,
  `company_JAP` VARCHAR(255) NULL DEFAULT NULL,
  `phone` VARCHAR(50) NULL DEFAULT NULL,
  `email` VARCHAR(255) NOT NULL,
  `other_info_EN` VARCHAR(255) NULL DEFAULT NULL,
  `other_info_SPA` VARCHAR(255) NULL DEFAULT NULL,
  `other_info_JAP` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`payment_source`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`payment_source` (
  `payment_source_id` INT(11) NOT NULL AUTO_INCREMENT,
  `source` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`payment_source_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`unit` (
  `unit_id` INT(11) NOT NULL AUTO_INCREMENT,
  `unit_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`unit_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`text`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`text` (
  `text_id` INT(11) NOT NULL AUTO_INCREMENT,
  `count` INT(11) NOT NULL,
  `unit_id` INT(11) NOT NULL,
  `original_title` VARCHAR(255) NULL DEFAULT NULL,
  `delivered_title` VARCHAR(255) NULL DEFAULT NULL,
  `complexity_level` INT(11) NOT NULL,
  PRIMARY KEY (`text_id`),
  INDEX `fk_complexity_level_level_id_idx` (`complexity_level` ASC),
  INDEX `fk_unit_unit_id_idx` (`unit_id` ASC),
  CONSTRAINT `fk_complexity_level_level_id`
    FOREIGN KEY (`complexity_level`)
    REFERENCES `interly`.`complexity_level` (`level_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_unit_unit_id`
    FOREIGN KEY (`unit_id`)
    REFERENCES `interly`.`unit` (`unit_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`type` (
  `type_id` INT(11) NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(50) NOT NULL,
  `original_lang` VARCHAR(50) NOT NULL,
  `target_lang` VARCHAR(50) NULL DEFAULT NULL,
  `is_academic` BIT(1) NOT NULL,
  PRIMARY KEY (`type_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`service` (
  `service_id` INT(11) NOT NULL AUTO_INCREMENT,
  `customer_id` INT(11) NOT NULL,
  `type_id` INT(11) NOT NULL,
  `text_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`service_id`, `customer_id`, `type_id`),
  INDEX `fk_service_customer1_idx` (`customer_id` ASC),
  INDEX `fk_service_type1_idx` (`type_id` ASC),
  INDEX `fk_service_text1_idx` (`text_id` ASC),
  CONSTRAINT `fk_service_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `interly`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_service_text1`
    FOREIGN KEY (`text_id`)
    REFERENCES `interly`.`text` (`text_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_service_type1`
    FOREIGN KEY (`type_id`)
    REFERENCES `interly`.`type` (`type_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`quotation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`quotation` (
  `quotation_id` INT(4) UNSIGNED ZEROFILL NOT NULL,
  `service_id` INT(11) NOT NULL,
  `date` DATE NOT NULL,
  `customer_id` INT(11) NOT NULL,
  `request_date` DATE NOT NULL,
  `validity_deadline_date` DATE NOT NULL,
  `admin_lang_id` INT(11) NOT NULL,
  `currency_id` INT(11) NOT NULL,
  `price_per_count` DECIMAL(8,2) NOT NULL,
  `payment_source_id` INT(11) NOT NULL,
  `admin_cost` DECIMAL(8,2) NOT NULL,
  `signature_reception_date` DATE NULL DEFAULT NULL,
  `is_rejected` BINARY(2) NOT NULL,
  PRIMARY KEY (`quotation_id`, `service_id`, `customer_id`, `admin_lang_id`, `currency_id`, `payment_source_id`, `is_rejected`),
  INDEX `fk_quotation_payment_source1_idx` (`payment_source_id` ASC),
  INDEX `fk_quotation_admin_lang1_idx` (`admin_lang_id` ASC),
  INDEX `fk_quotation_service1_idx` (`service_id` ASC),
  INDEX `fk_quotation_currency1_idx` (`currency_id` ASC),
  INDEX `fk_quotation_customer1_idx` (`customer_id` ASC),
  CONSTRAINT `fk_quotation_admin_lang1`
    FOREIGN KEY (`admin_lang_id`)
    REFERENCES `interly`.`admin_lang` (`admin_lang_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quotation_currency1`
    FOREIGN KEY (`currency_id`)
    REFERENCES `interly`.`currency` (`currency_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_quotation_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `interly`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quotation_payment_source`
    FOREIGN KEY (`payment_source_id`)
    REFERENCES `interly`.`payment_source` (`payment_source_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_quotation_service1`
    FOREIGN KEY (`service_id`)
    REFERENCES `interly`.`service` (`service_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`invoice` (
  `invoice_id` INT(4) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `quotation_id` INT(4) UNSIGNED ZEROFILL NOT NULL,
  `date_actual_delivery` DATE NOT NULL,
  `delivery_number` INT(4) UNSIGNED ZEROFILL NOT NULL,
  `payment_due` DATE NOT NULL,
  PRIMARY KEY (`invoice_id`, `quotation_id`),
  INDEX `fk_invoice_quotation1_idx` (`quotation_id` ASC),
  CONSTRAINT `fk_invoice_quotation`
    FOREIGN KEY (`quotation_id`)
    REFERENCES `interly`.`quotation` (`quotation_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`payment` (
  `payment_id` INT(11) NOT NULL,
  `invoice_id` INT(4) UNSIGNED ZEROFILL NOT NULL,
  `payment_date` DATE NOT NULL,
  `receipt_number` INT(4) UNSIGNED ZEROFILL NOT NULL,
  `receipt_date` DATE NOT NULL,
  PRIMARY KEY (`payment_id`, `invoice_id`),
  INDEX `fk_payment_invoice1_idx` (`invoice_id` ASC),
  CONSTRAINT `fk_payment_invoice`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `interly`.`invoice` (`invoice_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `interly`.`referral_discount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interly`.`referral_discount` (
  `referral_discount_id` INT(11) NOT NULL AUTO_INCREMENT,
  `customer_id` INT(11) NOT NULL,
  `discounted_quote_date` DATE NULL DEFAULT NULL,
  `referred_customer_id` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`referral_discount_id`),
  INDEX `fk_referral_discount_customer1_idx` (`customer_id` ASC),
  CONSTRAINT `fk_referral_discount_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `interly`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
