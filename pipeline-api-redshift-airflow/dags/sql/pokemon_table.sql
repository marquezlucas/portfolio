-- Tabla destino en Redshift. Se ejecuta una sola vez antes de activar el DAG.
CREATE TABLE IF NOT EXISTS pokemon (
    pokemon_id        INT          NOT NULL PRIMARY KEY,  -- id oficial de la API (permite cargas idempotentes)
    nombre            VARCHAR(100) NOT NULL,
    altura_dm         INT,          -- decímetros
    peso_hg           INT,          -- hectogramos
    tipos             VARCHAR(100), -- lista separada por comas, ej. "grass,poison"
    experiencia_base  INT,
    hp                INT,
    ataque            INT,
    defensa           INT,
    ataque_especial   INT,
    defensa_especial  INT,
    velocidad         INT,
    cargado_en        TIMESTAMP DEFAULT GETDATE()
);
