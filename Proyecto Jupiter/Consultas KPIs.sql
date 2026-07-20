USE reconocimiento_emociones;

 # 1: Calcular la media diaria de visitantes. Jesus --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
   # Primero selecciono los visitantes de dada dia
    SELECT 
        DATE(f.tiempo_recogida_fecha) AS dia,
        COUNT(DISTINCT iv.id_visitante) AS visitantes_dia
    FROM info_visitantes iv
    LEFT JOIN fotografias f 
		ON iv.t_id = f.t_id
    GROUP BY DATE(f.tiempo_recogida_fecha);
 # Y de esta tabla, saco la media de la columna visitantes_dia. La voy a usar como tabla temporal (CTE)  
WITH visitantes_al_dia AS(
SELECT 
        DATE(f.tiempo_recogida_fecha) AS dia,
        COUNT(DISTINCT iv.id_visitante) AS visitantes_dia
    FROM info_visitantes iv
    LEFT JOIN fotografias f 
		ON iv.t_id = f.t_id
    GROUP BY DATE(f.tiempo_recogida_fecha)
    )
SELECT AVG(visitantes_dia) AS media_visitantes_diaria  
FROM visitantes_al_dia;

# ------ SOLUCION: La media de visitantes por dia es de 792.48 visitantes Resuelto por Jesus Sanchez 

 # 2: Calcular la cuantía total de visitantes. Dani ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 SELECT COUNT(DISTINCT id_visitante) AS total_visitantes 
FROM info_visitantes;

# --- SOLUCION: 1787 -----

 # 3: ¿Qué días del mes ha habido más visitas y cuántas? Mario ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT DATE(tiempo_recogida_fecha) AS dia, COUNT(*) AS num_visitas
FROM fotografias
GROUP BY DATE(tiempo_recogida_fecha)
ORDER BY num_visitas DESC;

# --- SOLUCION: El día del mes con más visitas ha sido el día 14 con 1246, seguido del 30 con 1240 y del 2 con 1236...

 # 4: ¿A qué horas del día sube más gente en la atracción más visitada? Jesus --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 # Primero sacamos el numero de visitas por cada id de atraccion: 
 SELECT id_atraccion, COUNT(*) AS total_visitas
 FROM registro_atracciones
 WHERE id_atraccion <> 100
 GROUP BY id_atraccion;
 
 # Ahora nos quedamos con el maximo usando la consulta anterior como CTE
 WITH visitas_atracciones AS (
 SELECT id_atraccion, COUNT(*) AS total_visitas
 FROM registro_atracciones
 WHERE id_atraccion <> 100 # Excluimos la atraccion 100 que es la desconocida
 GROUP BY id_atraccion 
 )
 SELECT id_atraccion
 FROM visitas_atracciones
 WHERE total_visitas = (SELECT MAX(total_visitas) FROM visitas_atracciones);

# Y Ahora nos queda sacar las horas mas visitadas de esta atraccion. Vamos a hacer dos tablas temporales en una.
 WITH visitas_atracciones AS ( # Nos saca las visitas por atraccion
	 SELECT id_atraccion, COUNT(*) AS total_visitas
	 FROM registro_atracciones
	 WHERE id_atraccion <> 100 # Excluimos la atraccion 100 que es la desconocida
	 GROUP BY id_atraccion 
 ),
 atraccion_mas_visitada AS ( # Nos cada la atraccion mas visitada
	 SELECT id_atraccion
	 FROM visitas_atracciones
	 WHERE total_visitas = (SELECT MAX(total_visitas) FROM visitas_atracciones)
 )
 # Y ahora hacemos la consulta de las horas en la atraccion mas visitada:
SELECT
	HOUR (comienzo_atraccion_fecha) AS hora,
    COUNT(*) AS total_subidas,
    r.id_atraccion,
    a.atraccion
FROM  registro_atracciones r
LEFT JOIN atracciones a 
	ON a.id_atraccion = r.id_atraccion
WHERE r.id_atraccion = (SELECT id_atraccion FROM atraccion_mas_visitada)
GROUP BY hora , r.id_atraccion
ORDER BY total_subidas DESC;
 
 #---- Solucion A las 6 de la mañana ha habido 59 visitas en la atraccion id 26 (Vuelta al mundo en 80 dias) --------
 # --- A las 15 horas ha habido 58 subidas
 # --- A las 10 horas ha habido 50 subidas
 
 # Resuelto por Jesus Sanchez 
  
 # 5: ¿Cuáles son los 5 visitantes que se han subido en más atracciones y en cuántas? Dani ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 SELECT 
    v.id_visitante, 
    COUNT(DISTINCT r.id_atraccion) AS total_atracciones
FROM info_visitantes v
JOIN registro_atracciones r ON v.t_id = r.t_id
GROUP BY v.id_visitante
ORDER BY total_atracciones DESC
LIMIT 5;

# ------- SOLUCION -----------
# Id_visitante  Total_atracciones
#    43             	31
#    56	                29
#    73	                29
#    92	                28
#    66	                28

 # 6: ¿Cuáles son los 5 visitantes que se han subido en menos atracciones y en cuántas? Mario ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT iv.id_visitante, COUNT(*) AS total_atracciones
FROM info_visitantes iv
INNER JOIN registro_atracciones ra
ON iv.t_id = ra.t_id
GROUP BY iv.id_visitante
ORDER BY total_atracciones ASC
LIMIT 5;
 
 # ------- SOLUCION -----------
# Id_visitante  Total_atracciones
#    1777             	2
#    1723	            2
#    1787               2
#    1760	            2
#    1786	            2
 
 # 7: ¿Cuál ha sido la recaudación total del parque de atracciones? Jesus ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT SUM(coste) AS recaudacion_total
FROM registro_tiquets;

# ------ SOLUCION: LA REAUDACION TOTAL HA SIDO: 609416.130 euros ----- Resuelto por Jesus Sanchez 
 
 # 8: Por cada atracción, ¿cuál ha sido la emoción más frecuente? Dani ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 WITH conteo_emociones AS (
    SELECT 
        a.atraccion,
        e.emocion,
        COUNT(*) AS total_votos,
        ROW_NUMBER() OVER (PARTITION BY r.id_atraccion ORDER BY COUNT(*) DESC) AS ranking
    FROM registro_atracciones r
    JOIN fotografias f ON r.t_id = f.t_id
    JOIN atracciones a ON r.id_atraccion = a.id_atraccion
    JOIN emociones e ON f.id_emocion = e.id_emocion
    GROUP BY r.id_atraccion, f.id_emocion
)
SELECT atraccion, emocion, total_votos
FROM conteo_emociones
WHERE ranking = 1;
# ------ SOLUCION: En todas las atracciones la emocion mas frecuente ha sido happy ------

 # 9: ¿Cuál es la media de valoración de cada atracción? Mario ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT a.atraccion, AVG(f.valoracion) AS media_valoracion
FROM atracciones a
INNER JOIN registro_atracciones ra
ON a.id_atraccion = ra.id_atraccion
INNER JOIN fotografias f
ON ra.t_id = f.t_id
GROUP BY a.id_atraccion, a.atraccion
ORDER BY media_valoracion DESC;
 
 # ------------- SOLUCION ----------------------
#  Atraccion               media_valoracion
#  Rapido del Trueno              5.1508
#  Montana Rusa de la Luna        5.1201
#  Arana Saltarina                5.1177                 
#  Carrusel Encantado             5.1159
#  Tren del Terror                5.0789
#  Tirolina Extrema               5.0778
#  Caravana de Aventuras          5.0676
#  Fiesta de los Dulces           5.0536
#  Espejos de la Risuena          5.0494
#  Gran Caida Libre               5.0359
#  Vuelo Magico                   5.0289
#  Torbellino Espacial            5.0286
#  Tobogan del Arco Iris          5.0262
#  Montana del Misterio           5.0225
#  Aventuras Acuaticas            5.0176
#  Circuito Veloz                 5.0163
#  Barco Pirata Misterioso        5.0040
#  Cupula Estelar                 4.9980
#  Cascada Encantada              4.9938
#  Mansion Embrujada              4.9912
#  Circus Fantastico              4.9776
#  Vuelta al Mundo en 80 Dias     4.9750
#  Laberinto de Suenos            4.9727
#  Viaje al Centro de la Tierra   4.9360
#  Dragon Volador                 4.9319
#  Jardin de las Hadas            4.9298
#  Cohetes Galacticos             4.9216
#  Atraccion desconocida          4.9077
#  Mundo de las Maravillas        4.8997
#  Selva Encantada                4.8941
#  Carros Chocones Divertidos     4.8860
#  Cine 4D Emocionante            4.8839
#  Safari Salvaje                 4.8665
#  Carrera de Autos Locos         4.8295
#  Simulador Espacial 3D          4.8272
#  Rueda de la Fortuna            4.7978
           

 # 10: ¿De dónde son los 3 visitantes que peores valoraciones de media han puesto? Jesus ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Primero sacamos los 3 id con peor media de valoracion:
    SELECT 
		iv.id_visitante,
		AVG(f.valoracion) AS valoracion_media,
		COUNT(*) AS contador_valoraciones
	FROM fotografias f
	LEFT JOIN info_visitantes iv 
		ON iv.t_id = f.t_id
	GROUP BY iv.id_visitante
	ORDER BY valoracion_media ASC
	limit 3;
    
# CTE para ver los id de las 3 peores medias de valoracion
WITH visitantes_peor_valoracion AS(
	SELECT 
		iv.id_visitante,
		AVG(f.valoracion) AS valoracion_media,
		COUNT(*) AS contador_valoraciones
	FROM fotografias f
	LEFT JOIN info_visitantes iv 
		ON iv.t_id = f.t_id
	GROUP BY iv.id_visitante
	ORDER BY valoracion_media ASC
	limit 3
)
SELECT 
    iv.id_visitante,
    p.procedencia
FROM info_visitantes iv
LEFT JOIN procedencias p
    ON p.id_procedencia = iv.id_procedencia
WHERE iv.id_visitante IN (SELECT id_visitante FROM visitantes_peor_valoracion)
GROUP BY iv.id_visitante, p.procedencia;

# ----- SOLUCION: LAS 3 PROCEDENCIAS SON FILIPINAS, ESPAÑA Y JAMAICA/PANAMA (Este id tiene dos nacionalidades....) ---- Resuelto por Jesus Sanchez 


 # 11: ¿Cuál es la antelación máxima con la que se adquiere cada tipo de entrada? Dani ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 SELECT 
    t.tipo_entrada,
    MAX(r.antelacion) AS antelacion_maxima
FROM tipos_entrada t
JOIN registro_tiquets r ON t.id_tipo_entrada = r.id_tipo_entrada
GROUP BY t.id_tipo_entrada, t.tipo_entrada;

# ----- SOLUCION: para cada tipo de entrada la antelacion maxima ha sido de 364 minutos.... Todas igual. -----



 # 12: ¿Qué día y hora del mes se producen los tiempos de espera máximos en cada atracción? Mario ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 # 13: Para cada cliente, calcular el tiempo que no ha estado esperando durante su estancia en el parque. Jesus ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 SELECT 
	iv.id_visitante,
    iv.duracion - IFNULL(SUM(ra.tiempo_de_espera), 0) AS tiempo_no_espera # Tiempo de no esperar es duracion menos la suma del tiempo de espera
FROM info_visitantes iv
LEFT JOIN registro_atracciones ra
	ON ra.t_id = iv.t_id
GROUP BY iv.id_visitante, iv.duracion
ORDER BY tiempo_no_espera DESC;

 # -----SOLUCION----- son 1700 registros, aqui pongo los 3 que mas han esperado:
 # id_visitante     Tiempo_no_espera
 #      903               796 
 #      1000              738  
 #      1141              733     Resuelto por Jesus Sanchez 
 
 
 # 14: El tiempo total de espera de las 3 atracciones mejor valoradas y las 3 peor valoradas. Dani ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 # 15: De los visitantes que compraron la entrada en taquilla, ¿cuál fue la atracción a la que más se subieron? Mario ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT a.atraccion, COUNT(*) AS veces_subida
FROM atracciones a
INNER JOIN registro_atracciones ra
	ON a.id_atraccion = ra.id_atraccion
INNER JOIN registro_tiquets rt
    ON ra.t_id = rt.t_id
WHERE rt.antelacion = 0  AND a.id_atraccion <> 100
GROUP BY a.atraccion, a.id_atraccion
ORDER BY veces_subida DESC
LIMIT 1;

# ----- SOLUCION: La atracción a la que más se subieron fue Fiesta de los Dulces con un total de 289 veces

 # 16: ¿Cuál es la atracción que tiene más número de visitantes con entrada de tipo fast-pass? Jesus ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 # en esta consulta tengo que unir praticamente todas las tablas......
 SELECT count(DISTINCT iv.id_visitante) AS visitantes_pase_rapido , ra.id_atraccion, atracc.atraccion
 FROM atracciones atracc
 LEFT JOIN registro_atracciones ra
	ON atracc.id_atraccion = ra.id_atraccion 
 LEFT JOIN fotografias f
	ON ra.t_id = f.t_id
 LEFT JOIN registro_tiquets rt
	ON f.t_id = rt.t_id
 LEFT JOIN tipos_entrada te
	ON rt.id_tipo_entrada = te.id_tipo_entrada
 LEFT JOIN info_visitantes iv # Este join lo hago para hacer un distinct de los visitantes.
	ON f.t_id = iv.t_id
WHERE te.tipo_entrada LIKE "pase rapido"  and ra.id_atraccion <> 100
GROUP BY ra.id_atraccion
ORDER BY visitantes_pase_rapido desc
limit 1;

# ----- SOLUCION: la atraccion que tiene mas visitantes con pase rapido es: Mansion embrujada con 177 pases rapidos.  Resuelto por Jesus Sanchez 

 
 
 