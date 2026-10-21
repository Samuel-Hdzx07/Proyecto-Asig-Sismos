-- Consulta nueva: vinculacion directa de candidatos por tiempo, distancia y magnitud.
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
