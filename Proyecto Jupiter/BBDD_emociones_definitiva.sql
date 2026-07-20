
# Creamos nuestra BBDD y la seleccionamos para usarla
DROP DATABASE IF EXISTS reconocimiento_emociones;
CREATE DATABASE reconocimiento_emociones;
USE reconocimiento_emociones;

# Vamos a crear las tablas que contienen las categorias, como emociones, atracciones y tipos de entrada ---------------------------------------------------

# Vamos a crear la tabla de emociones:
DROP TABLE IF EXISTS emociones;
CREATE TABLE emociones (
id_emocion TINYINT PRIMARY KEY , # Tenemos 7 emociones
emocion VARCHAR(25) # La mas larga es surprise.
);

# Vamos a crear la tabla de atracciones:
DROP TABLE IF EXISTS atracciones;
CREATE TABLE atracciones (
id_atraccion TINYINT PRIMARY KEY  , # Tenemos 35 atracciones
atraccion VARCHAR(40) # La mas larga es viaje al centro de la tierra con 28 caracteres.
);

# Vamos a crear la tabla de tipos_entrada:
DROP TABLE IF EXISTS tipos_entrada;
CREATE TABLE tipos_entrada (
id_tipo_entrada TINYINT PRIMARY KEY , # Tenemos 6 tipos de entrada
tipo_entrada VARCHAR(25) # La mas larga es "entrada individual"con 18 caracteres
);

# Vamos a crear la tabla de procedencias:
DROP TABLE IF EXISTS procedencias;
CREATE TABLE procedencias (
id_procedencia TINYINT PRIMARY KEY , # Tenemos 6 tipos de entrada
procedencia VARCHAR(25) # La mas larga es "republica dominicana"con 20 caracteres
);
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Vamos a crear la tabla fotografias:
DROP TABLE IF EXISTS fotografias;
CREATE TABLE fotografias (
t_id VARCHAR(30) PRIMARY KEY , # Tienen aprox 20 caracteres.
id_emocion TINYINT, # Hay solamente 7 emociones.
valoracion TINYINT,
tiempo_recogida SMALLINT, # De 2 a 719.
tiempo_recogida_date DATETIME,
CONSTRAINT fk_emocion FOREIGN KEY (id_emocion) REFERENCES emociones (id_emocion)
);
ALTER TABLE fotografias
CHANGE COLUMN tiempo_recogida_date tiempo_recogida_fecha DATETIME;

# Vamos a crear la tabla registro atracciones:
DROP TABLE IF EXISTS registro_atracciones;
CREATE TABLE registro_atracciones (
t_id VARCHAR(30) PRIMARY KEY ,
id_atraccion TINYINT,
comienzo_atraccion SMALLINT, # va de -1 A 719
comienzo_atraccion_date DATETIME, # el dato en int transformado a datetime
tiempo_espera TINYINT, # de -3 a 28 minutos
CONSTRAINT fk_fotografia FOREIGN KEY (t_id) REFERENCES fotografias (t_id),
CONSTRAINT fk_atracc FOREIGN KEY (id_atraccion) REFERENCES atracciones (id_atraccion)
);
ALTER TABLE registro_atracciones
CHANGE COLUMN comienzo_atraccion_date comienzo_atraccion_fecha DATETIME;

ALTER TABLE registro_atracciones
CHANGE COLUMN tiempo_espera tiempo_de_espera TINYINT;

# Vamos a crear la tabla registro tiquets:
DROP TABLE IF EXISTS registro_tiquets;
CREATE TABLE registro_tiquets (
t_id VARCHAR(30),
id_tipo_entrada TINYINT,
coste DECIMAL(5,3), # Aqui del dataframe lo tenemos que traer filtrado con 3 decimales. vA DE -2 A 39  
antelacion SMALLINT, # minimo 0, maximo 364
CONSTRAINT fk_foto FOREIGN KEY (t_id) REFERENCES fotografias (t_id),
CONSTRAINT fk_tipo FOREIGN KEY (id_tipo_entrada) REFERENCES tipos_entrada (id_tipo_entrada)
);

# Vamos a crear la tabla de la informacion de los usuarios. Por tener toda la info en la BBDD:
DROP TABLE IF EXISTS info_visitantes;
CREATE TABLE info_visitantes (
t_id VARCHAR(30),
id_visitante SMALLINT,
id_procedencia TINYINT, 
duracion SMALLINT, # tenemos desde -39 a 811 minutos 
CONSTRAINT fk_fot FOREIGN KEY (t_id) REFERENCES fotografias (t_id),
CONSTRAINT fk_proc FOREIGN KEY (id_procedencia) REFERENCES procedencias (id_procedencia)
);

select * from atracciones;
select * from emociones;
select * from procedencias;
select * from tipos_entrada;
select * from fotografias;
select * from registro_atracciones;
select * from registro_tiquets;
select * from info_visitantes;


