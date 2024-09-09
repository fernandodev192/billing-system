-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_faturacao
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_faturacao
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_faturacao` DEFAULT CHARACTER SET utf8 ;
USE `db_faturacao` ;

-- -----------------------------------------------------
-- Table `db_faturacao`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NULL,
  `nome` VARCHAR(50) NULL,
  `senha` VARCHAR(60) NULL,
  `tipo` ENUM('v', 'n') NULL,
  `idade` INT NULL,
  `estado` ENUM('s', 'n') NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`servicos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NULL,
  `descricao` VARCHAR(255) NULL,
  `preco` DECIMAL(8,2) NULL,
  `categoria` VARCHAR(50) NULL,
  `estado` ENUM('s', 'n') NULL,
  `data_servico` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NULL,
  `nif` VARCHAR(50) NULL,
  `data_nascimento` VARCHAR(12) NULL,
  `genero` ENUM('m', 'f') NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`solicitacoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`solicitacoes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_solicitacao` DATE NULL,
  `id_cliente` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_solicitacoes_clientes1_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_solicitacoes_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `db_faturacao`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`solicitacao_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`solicitacao_servico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `desconto` DECIMAL(8,2) NULL,
  `quantidade` INT NULL,
  `id_servico` INT NULL,
  `id_solicitacao` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_solicitacao_servico_servicos1_idx` (`id_servico` ASC) VISIBLE,
  INDEX `fk_solicitacao_servico_solicitacoes1_idx` (`id_solicitacao` ASC) VISIBLE,
  CONSTRAINT `fk_solicitacao_servico_servicos1`
    FOREIGN KEY (`id_servico`)
    REFERENCES `db_faturacao`.`servicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_solicitacao_servico_solicitacoes1`
    FOREIGN KEY (`id_solicitacao`)
    REFERENCES `db_faturacao`.`solicitacoes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`productos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NULL,
  `fabricante` VARCHAR(50) NULL,
  `quantidade` INT NULL,
  `descricao` VARCHAR(225) NULL,
  `data_validade` DATE NULL,
  `preco_unitario` DECIMAL(8,2) NULL,
  `actualizado_em` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`stock` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NULL,
  `estado` ENUM('s', 'n') NULL,
  `local_armazenamento` VARCHAR(50) NULL,
  `data_entrada` DATE NULL,
  `data_actualizacao` DATE NULL,
  `status` ENUM('s', 'n') NULL,
  `id_producto` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_stock_productos1_idx` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_stock_productos1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `db_faturacao`.`productos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`vendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`vendas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_venda` DATE NULL,
  `valor_venda` DECIMAL(8,2) NULL,
  `id_usuario` INT NULL,
  INDEX `fk_vendas_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_vendas_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `db_faturacao`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`pagamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipo_pagamento` VARCHAR(50) NULL,
  `valor` DECIMAL(8,2) NULL,
  `data_pagamento` DATE NULL,
  `status` VARCHAR(50) NULL,
  `detalhes` VARCHAR(225) NULL,
  `criado_em` DATE NULL,
  `actualizado_em` DATE NULL,
  `id_venda` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pagamento_vendas1_idx` (`id_venda` ASC) VISIBLE,
  CONSTRAINT `fk_pagamento_vendas1`
    FOREIGN KEY (`id_venda`)
    REFERENCES `db_faturacao`.`vendas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`endereco` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(50) NULL,
  `municipio` VARCHAR(50) NULL,
  `cidade` VARCHAR(50) NULL,
  `id_usuario` INT NULL,
  `id_cliente` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_endereco_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_endereco_clientes1_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_endereco_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `db_faturacao`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_endereco_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `db_faturacao`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`contactos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`contactos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `telefone` VARCHAR(12) NULL,
  `email` VARCHAR(60) NULL,
  `id_usuario` INT NOT NULL,
  `id_cliente` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contactos_usuarios_idx` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_contactos_clientes1_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_contactos_usuarios`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `db_faturacao`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contactos_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `db_faturacao`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`itens_vendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`itens_vendas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NULL,
  `id_producto` INT NULL,
  `id_venda` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_itens_vendas_vendas1_idx` (`id_venda` ASC) VISIBLE,
  INDEX `fk_itens_vendas_productos1_idx` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `fk_itens_vendas_vendas1`
    FOREIGN KEY (`id_venda`)
    REFERENCES `db_faturacao`.`vendas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_itens_vendas_productos1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `db_faturacao`.`productos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`agendamentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`agendamentos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_agendamento` DATE NULL,
  `descricao` VARCHAR(225) NULL,
  `id_cliente` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_agendamentos_clientes1_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_agendamentos_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `db_faturacao`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_faturacao`.`agendamento_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_faturacao`.`agendamento_servico` (
  `id_agendamento` INT NULL,
  `id_servico` INT NULL,
  INDEX `fk_agendamento_servico_agendamentos1_idx` (`id_agendamento` ASC) VISIBLE,
  INDEX `fk_agendamento_servico_servicos1_idx` (`id_servico` ASC) VISIBLE,
  CONSTRAINT `fk_agendamento_servico_agendamentos1`
    FOREIGN KEY (`id_agendamento`)
    REFERENCES `db_faturacao`.`agendamentos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_agendamento_servico_servicos1`
    FOREIGN KEY (`id_servico`)
    REFERENCES `db_faturacao`.`servicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
