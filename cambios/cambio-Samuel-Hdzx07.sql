-- Clasificacion operativa de candidatos; no es una catalogacion sismologica validada.
-- =====================================================================
-- Práctica 3, Ejercicio 8 - Cambio de esquema por integrante
-- Propuesta 1: Réplicas y secuencias sísmicas (issue #1: https://github.com/Samuel-Hdzx07/Proyecto-Asig-Sismos/issues/1)
-- Proyecto asignado: Sismos (data warehouse en PostgreSQL)
--
-- EJECUTAR SOBRE UNA COPIA de la base del proyecto asignado:
--   (desde otra base, sin conexiones abiertas a la original)
--   createdb -U postgres sismos_p3;
--   psql -U <usuario> -d sismos_p3 -f cambio-Samuel-Hdzx07.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Regla 4 (relación recursiva 1:N)
--    ES_REPLICA_DE: SISMO [principal] (0,N) - SISMO [réplica] (0,1)
--    La clave del lado uno (principal) se propaga como FK al lado muchos
--    (réplica), que es la misma tabla. La mínima del lado réplica es 0,
--    así que la columna admite NULL: NULL = el sismo no es réplica.
-- ---------------------------------------------------------------------
BEGIN;

ALTER TABLE dim_sismos
    ADD COLUMN id_sismo_principal INT NULL;

ALTER TABLE dim_sismos
    ADD CONSTRAINT fk_sismo_principal
        FOREIGN KEY (id_sismo_principal)
        REFERENCES dim_sismos (id_sismo)
        ON DELETE SET NULL
        ON UPDATE CASCADE;

ALTER TABLE dim_sismos
    ADD CONSTRAINT ck_sismo_no_es_replica_de_si_mismo
        CHECK (id_sismo_principal IS NULL OR id_sismo_principal <> id_sismo);

CREATE INDEX ix_dim_sismos_principal ON dim_sismos (id_sismo_principal);

-- ---------------------------------------------------------------------
-- 2. Apoyo para los atributos DERIVADOS (no se almacenan):
--    intervalo_horas (de fecha_hora_utc) y distancia_km (de latitud y longitud)
-- ---------------------------------------------------------------------

-- Distancia entre dos epicentros (fórmula de haversine, radio terrestre 6371 km)
CREATE OR REPLACE FUNCTION distancia_km(
    lat1 DOUBLE PRECISION, lon1 DOUBLE PRECISION,
    lat2 DOUBLE PRECISION, lon2 DOUBLE PRECISION)
RETURNS DOUBLE PRECISION
LANGUAGE sql IMMUTABLE AS $$
    SELECT 2 * 6371.0 * asin(LEAST(1.0, sqrt(
        power(sin(radians(lat2 - lat1) / 2), 2) +
        cos(radians(lat1)) * cos(radians(lat2)) *
        power(sin(radians(lon2 - lon1) / 2), 2))))
$$;

-- fecha_hora_utc del sismo: en este esquema la fecha y la hora viven en
-- dim_tiempo y se llega a ellas desde la tabla de hechos.
CREATE OR REPLACE VIEW v_sismo_fecha_hora AS
SELECT f.id_sismo,
       MIN(t.fecha + t.hora_utc) AS fecha_hora_utc
  FROM fact_impacto_sismos_imputed f
  JOIN dim_tiempo t ON t.id_tiempo = f.id_tiempo
 GROUP BY f.id_sismo;

-- ---------------------------------------------------------------------
-- 3. Criterio de asignación (regla de negocio de la propuesta).
--    Un sismo es réplica de a lo sumo un principal que:
--      - ocurrió antes, dentro de p_horas,
--      - está a no más de p_radio_km,
--      - tiene mayor magnitud.
--    Si hay varios candidatos, se asigna el de mayor magnitud
--    (desempate: el más antiguo, luego el menor id_sismo).
--    Los parámetros son configurables; devuelve cuántas réplicas asignó.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION asignar_replicas(
    p_horas NUMERIC DEFAULT 72,
    p_radio_km NUMERIC DEFAULT 100)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
    n INT;
BEGIN
    IF p_horas IS NULL OR p_radio_km IS NULL OR p_horas <= 0 OR p_radio_km <= 0
       OR p_horas::TEXT IN ('NaN','Infinity','-Infinity')
       OR p_radio_km::TEXT IN ('NaN','Infinity','-Infinity') THEN
        RAISE EXCEPTION 'Horas y radio deben ser positivos y finitos' USING ERRCODE='22023';
    END IF;
    -- Serializa asignaciones y materializa las fechas una sola vez.
    PERFORM pg_advisory_xact_lock(806231,8);
    CREATE TEMP TABLE catalogo_replicas ON COMMIT DROP AS
      SELECT s.id_sismo,s.magnitud,s.latitud,s.longitud,t.fecha_hora_utc
      FROM dim_sismos s JOIN v_sismo_fecha_hora t USING(id_sismo)
      WHERE t.fecha_hora_utc IS NOT NULL;
    CREATE INDEX ON catalogo_replicas(fecha_hora_utc);
    ANALYZE catalogo_replicas;
    CREATE TEMP TABLE asignacion_replicas ON COMMIT DROP AS
      SELECT r.id_sismo, candidato.id_sismo AS id_principal
      FROM catalogo_replicas r
      LEFT JOIN LATERAL (
        SELECT p.id_sismo
        FROM catalogo_replicas p
        WHERE p.fecha_hora_utc >= r.fecha_hora_utc - make_interval(secs => (p_horas*3600)::DOUBLE PRECISION)
          AND p.fecha_hora_utc < r.fecha_hora_utc
          AND p.magnitud > r.magnitud
          AND distancia_km(p.latitud,p.longitud,r.latitud,r.longitud) <= p_radio_km
        ORDER BY p.magnitud DESC,p.fecha_hora_utc,p.id_sismo
        LIMIT 1
      ) candidato ON TRUE;
    CREATE UNIQUE INDEX ON asignacion_replicas(id_sismo);
    ANALYZE asignacion_replicas;
    UPDATE dim_sismos s SET id_sismo_principal=a.id_principal
      FROM asignacion_replicas a WHERE a.id_sismo=s.id_sismo;
    UPDATE dim_sismos s SET id_sismo_principal=NULL
      WHERE NOT EXISTS(SELECT 1 FROM asignacion_replicas a WHERE a.id_sismo=s.id_sismo)
      AND s.id_sismo_principal IS NOT NULL;
    SELECT COUNT(*) INTO n FROM dim_sismos WHERE id_sismo_principal IS NOT NULL;
    RETURN n;
END;
$$;

-- Derivados sin redondear para validar; solo se redondean al presentar resultados.
CREATE OR REPLACE VIEW v_replicas AS
SELECT r.id_sismo                         AS id_replica,
       p.id_sismo                         AS id_principal,
       p.magnitud                         AS magnitud_principal,
       r.magnitud                         AS magnitud_replica,
       (EXTRACT(EPOCH FROM (tr.fecha_hora_utc - tp.fecha_hora_utc)) / 3600)::NUMERIC
                                          AS intervalo_horas,
       distancia_km(p.latitud, p.longitud, r.latitud, r.longitud)::NUMERIC
                                          AS distancia_km
  FROM dim_sismos r
  JOIN dim_sismos p            ON p.id_sismo = r.id_sismo_principal
  JOIN v_sismo_fecha_hora tr   ON tr.id_sismo = r.id_sismo
  JOIN v_sismo_fecha_hora tp   ON tp.id_sismo = p.id_sismo;

COMMIT;

-- ---------------------------------------------------------------------
-- 4. Poblar la relación con los valores por omisión (72 h, 100 km).
--    Se puede volver a ejecutar con otros parámetros:
--      SELECT asignar_replicas(48, 50);
-- ---------------------------------------------------------------------
SELECT asignar_replicas(72, 100) AS replicas_asignadas;

-- ---------------------------------------------------------------------
-- 5. Validación de la regla de negocio (debe devolver 0 filas)
-- ---------------------------------------------------------------------
SELECT id_replica, id_principal
  FROM v_replicas
 WHERE magnitud_replica >= magnitud_principal
    OR intervalo_horas <= 0
    OR intervalo_horas > 72
    OR distancia_km > 100;

-- ---------------------------------------------------------------------
-- 6. CONSULTA QUE SOLO ES POSIBLE DESPUÉS DEL CAMBIO
--    Secuencias sísmicas: sismos principales con más réplicas, con el
--    conteo de la secuencia, la magnitud máxima de sus réplicas y hasta
--    cuántas horas y kilómetros se extendió.
-- ---------------------------------------------------------------------
SELECT v.id_principal,
       v.magnitud_principal,
       s.nombre_estado,
       COUNT(*)                 AS num_replicas,
       MAX(v.magnitud_replica)  AS magnitud_max_replica,
       ROUND(MAX(v.intervalo_horas),2) AS horas_hasta_ultima_replica,
       ROUND(MAX(v.distancia_km),2) AS km_replica_mas_lejana
  FROM v_replicas v
  JOIN dim_sismos s ON s.id_sismo = v.id_principal
 GROUP BY v.id_principal, v.magnitud_principal, s.nombre_estado
 ORDER BY num_replicas DESC, v.magnitud_principal DESC, v.id_principal
 LIMIT 10;
