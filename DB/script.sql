-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS db_escencity;

-- Seleccionar la base de datos para trabajar en ella
USE db_escencity;

-- Crear la tabla 'perfumes'
CREATE TABLE IF NOT EXISTS perfumes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_perfume VARCHAR(100) NOT NULL,
    marca VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Activo'
);

-- Crear la tabla 'usuarios'
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    contraseña VARCHAR(255) NOT NULL
);