-- Crear una nueva base de datos (si no existe)
-- CREATE DATABASE IF NOT EXISTS marquezlucas_coderhouse;

-- Usar la base de datos creada
SET marquezlucas_coderhouse;

-- Crear una tabla para almacenar la información de los Pokémon
-- Crear una tabla para almacenar la información de los Pokémon
CREATE TABLE IF NOT EXISTS pokemon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(255),
    altura DECIMAL(10, 4),
    peso DECIMAL(10, 4),
    tipos VARCHAR(255),
    experiencia_base INT,
    hp INT,
    ataque INT,
    defensa INT,
    ataque_especial INT,
    defensa_especial INT,
    velocidad INT
);