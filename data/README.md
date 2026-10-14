# Datos estáticos

Los archivos JSON se generaron a partir de los scripts SQL del repositorio de referencia [gabrielhuav/Seismic-Data-Visualization-System](https://github.com/gabrielhuav/Seismic-Data-Visualization-System), snapshot main 8569667cf4f46fab640dba3f82a7b324ca7efaf7, respetando la licencia MIT incluida en la raíz del repositorio.

- seismic-events.json: 196,576 filas de fact_impacto_sismos_imputed, unidas con dim_sismos y dim_tiempo mediante las claves del esquema. Es la misma unión que alimenta la pantalla sísmica original. El orden de cada fila es latitud, longitud, magnitud, profundidad, referencia de localización, fecha, hora UTC, población afectada e impacto económico.
- state-indicators.json: los 32 registros de dim_zonas y los 32 de dim_economia, con población total/femenina/masculina y los tres indicadores usados por la interfaz.

La página carga estos JSON locales en cada visita; no usa PHP, PostgreSQL ni datos de demostración. El mapa base, las bibliotecas de gráficos y los límites estatales usan servicios externos, igual que la referencia.

El repositorio de referencia solicita citar el artículo asociado: [Cuando México tiembla: la historia contada por los datos](https://doi.org/10.24275/AZC2026E1004).

## Límites de correspondencia

No se relacionan dim_zonas y dim_economia usando sus IDs: el orden de las claves no coincide (por ejemplo, zona 4 es Coahuila y economía 4 es Chiapas). En dim_economia, entidad contiene agregados numéricos, no códigos estatales; por eso los valores económicos del mapa estático se asignan por nombre_entidad. Esto evita perder estados al intentar interpretarlos como códigos, pero no reproduce el mapeo defectuoso de std3.php. La tabla de zonas solo contiene 32 entidades; no hay filas municipales para mostrar.
