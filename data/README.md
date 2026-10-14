# Datos estáticos

Los archivos JSON se derivaron de los scripts SQL del proyecto [gabrielhuav/Seismic-Data-Visualization-System](https://github.com/gabrielhuav/Seismic-Data-Visualization-System), revisión `8569667cf4f46fab640dba3f82a7b324ca7efaf7`. Se conservan los datos completos de la fuente y la licencia MIT copiada del repositorio de referencia. El artículo asociado solicita esta cita: [Cuando México tiembla: la historia contada por los datos](https://doi.org/10.24275/AZC2026E1004).

## Archivos y esquema

### `seismic-events.json`

Contiene 196,576 filas de `fact_impacto_sismos_imputed`, unidas con `dim_sismos` mediante la clave de sismo y con `dim_tiempo` mediante la clave de tiempo. Es la unión que alimenta la vista sísmica original. El orden de las columnas en cada fila es:

1. Latitud
2. Longitud
3. Magnitud
4. Profundidad
5. Referencia de localización
6. Fecha
7. Hora UTC
8. Población afectada
9. Impacto económico

La fuente contiene 319,592 filas en cada una de las dimensiones `dim_sismos` y `dim_tiempo`; la tabla de hechos determina las 196,576 filas del conjunto unido.

### `state-indicators.json`

Conserva dos arreglos, con 32 filas cada uno:

- `population`, de `dim_zonas`: nombre de la entidad, población total, población femenina y población masculina.
- `economy`, de `dim_economia`: nombre de la entidad, producción bruta total, consumo intermedio y valor agregado censal bruto.

Los indicadores económicos se conservan íntegros aunque la página estática no los muestra. Esto reproduce la salida actual de `std3.php`, cuyo filtro interpreta `entidad` como un código estatal y no produce filas. Por fidelidad solicitada, la vista presenta totales `0.00`, un mapa sin valores asociados a los estados y gráficas sin series de datos. No se eliminaron ni alteraron los 32 registros económicos del JSON.

## Límites de correspondencia

Los identificadores de `dim_zonas` y `dim_economia` no se pueden emparejar por su orden: por ejemplo, la zona 4 es Coahuila y la economía 4 es Chiapas. En `dim_economia`, `entidad` contiene agregados numéricos, no códigos estatales. El PHP de referencia intenta interpretarlos como códigos de dos dígitos y descarta todas las filas. La página estática reproduce ese resultado vacío en su interfaz y conserva el conjunto original en el JSON.

La tabla de zonas solo contiene 32 entidades; no contiene filas municipales. Por tanto, la fuente no aporta datos para desglosar población por municipio.

## Carga en la página

`index.html` obtiene ambos JSON mediante rutas locales relativas. No consulta PHP ni PostgreSQL. Los mapas usan Leaflet, teselas de OpenStreetMap y límites estatales GeoJSON externos; Chart.js también se obtiene de un CDN. Sin conexión a esos servicios, los JSON siguen estando presentes, pero las vistas cartográficas o los gráficos pueden no renderizarse completamente.
