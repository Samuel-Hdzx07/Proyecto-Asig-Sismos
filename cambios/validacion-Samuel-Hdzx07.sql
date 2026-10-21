SELECT current_database() AS base_de_trabajo, version();
SELECT count(*) AS sismos, count(*) FILTER(WHERE id_sismo_principal IS NOT NULL) AS candidatos_asignados FROM dim_sismos;
SELECT count(*) AS invalidos FROM v_replicas WHERE magnitud_replica>=magnitud_principal OR intervalo_horas<=0 OR intervalo_horas>72 OR distancia_km>100;
SELECT count(*) AS sin_fecha_vinculada FROM dim_sismos s LEFT JOIN v_sismo_fecha_hora t USING(id_sismo) WHERE t.fecha_hora_utc IS NULL;
SELECT count(*) AS vinculos_con_fecha_ausente FROM dim_sismos s LEFT JOIN v_sismo_fecha_hora t USING(id_sismo) WHERE s.id_sismo_principal IS NOT NULL AND t.fecha_hora_utc IS NULL;
SELECT min(intervalo_horas) AS intervalo_min_horas, max(intervalo_horas) AS intervalo_max_horas, max(distancia_km) AS distancia_max_km FROM v_replicas;
