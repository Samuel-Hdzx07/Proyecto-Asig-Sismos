# Levantamiento del proyecto asignado: Sismos

- **Repositorio original:** https://github.com/gabrielhuav/Seismic-Data-Visualization-System
- **Fork:** https://github.com/Samuel-Hdzx07/Seismic-Data-Visualization-System
- **Commit con el que se puso en funcionamiento:** `8569667cf4f46fab640dba3f82a7b324ca7efaf7`
- **Fecha del levantamiento:** 26 de septiembre de 2026
- **Autor:** Hernandez Barrios Samuel Rodrigo (3CV4)

## 1. Requisitos

- Windows con Docker Desktop (plan Personal), con 16 CPUs y unos 7.4 GB de memoria disponibles para contenedores.
- Git.
- Navegador web (Chrome).
- Imágenes que descarga el proyecto: `postgres:17` (base de datos) y la imagen web del propio proyecto.
- Puertos publicados en el equipo: **80** (aplicación web) y **5433** (PostgreSQL, que escucha en el 5432 dentro del contenedor).

## 2. Pasos ejecutados (en orden)

1. Fork del repositorio original y clonación en el equipo:
```bash
   git clone https://github.com/Samuel-Hdzx07/Seismic-Data-Visualization-System
   cd Seismic-Data-Visualization-System
```
2. Arranque de los servicios con la definición de contenedores que trae el repositorio (Docker Compose), que crea el proyecto `seismic-data-visualization-system` con dos servicios, `db` y `web`:
```bash
   docker compose up -d
```
3. Verificación en Docker Desktop de que ambos contenedores están en ejecución:
   - `db-1`: imagen `postgres:17`, puertos `5433:5432`.
   - `web-1`: imagen del proyecto, puertos `80:80`.

   Captura: [arranque_docker.png](capturas/arranque_docker.png)
4. Apertura de la aplicación en el navegador: `http://localhost/vista.html`. La interfaz "Impacto de Sismos en México" muestra tres opciones en el panel lateral: Sismos en México, Población de México y Economía de México.

   Captura: [interfaz_web.png](capturas/interfaz_web.png)

## 3. Consulta directa sobre la base de datos

Desde Docker Desktop, en el contenedor `seismic-data-visualization-system-db-1`, pestaña **Exec**, se abrió una sesión de `psql` (versión 17.11) sobre la base `datawarehouse`:

```bash
psql -U postgres -d datawarehouse
```

```sql
SELECT * FROM dim_sismos LIMIT 5;
```

Resultado: 5 filas de la dimensión de sismos, con las columnas `id_sismo`, `magnitud`, `latitud`, `longitud`, `profundidad`, `referencia_de_localizacion`, `estado` y `nombre_estado`.

| id_sismo | magnitud | latitud | longitud | profundidad | referencia_de_localizacion | estado | nombre_estado |
|---|---|---|---|---|---|---|---|
| 0 | 7.4 | 20 | -105 | 33 | 71 km al NOROESTE de AUTLAN DE NAVARRO, JAL | JAL | Jalisco |
| 1 | 6.9 | 20 | -105 | 33 | 71 km al NOROESTE de AUTLAN DE NAVARRO, JAL | JAL | Jalisco |
| 2 | 6.9 | 25 | -110 | 33 | 100 km al NORESTE de LA PAZ, BCS | BCS | Baja California Sur |
| 3 | 7 | 26 | -110 | 33 | 83 km al OESTE de AHOME, SIN | SIN | Sinaloa |
| 4 | 7 | 17.62 | -99.72 | 33 | 21 km al OESTE de ZUMPANGO DEL RIO, GRO | GRO | Guerrero |

Captura: [consulta_sql.png](capturas/consulta_sql.png)

## 4. Errores encontrados y cómo se resolvieron

El registro histórico menciona problemas de configuración y puertos, pero no conserva el mensaje exacto ni la secuencia de corrección. No es posible reconstruir ese error como si se hubiera documentado. Los puertos finales observados en las capturas fueron 80 para la aplicación y 5433 para PostgreSQL.

## 5. Observaciones

- La base de datos se llama `datawarehouse` y la tabla consultada, `dim_sismos`, guarda el estado dos veces: abreviado (`estado`) y con nombre completo (`nombre_estado`). Es la redundancia que señala la tabla de correspondencia con el modelo EER.
- En las cinco filas consultadas `profundidad` vale 33. Podría ser un valor por defecto o imputado; conviene revisarlo con una consulta sobre toda la tabla.
- Las tres opciones de la interfaz (sismos, población y economía) corresponden a las tres fuentes de datos que se modelan en el EER.
- En el mismo Docker Desktop sigue existiendo el contenedor de la Práctica 1 (`pg-practica1`, `postgres:16`, puerto 5454). Los puertos publicados de ambos proyectos no se solapan.

## 6. Revisión actual del 16 de octubre de 2026

Se localizó Docker Desktop instalado por usuario y se intentó iniciar su motor. El cliente respondió, pero el servidor no estuvo disponible. El log del backend registra un fallo de acceso al socket interno sailor-ingest.sock.

- [Diagnóstico real y comandos](capturas/diagnostico-2026-10-16.txt).
- Este fallo ocurre antes de iniciar Sismos. No prueba un conflicto de sus puertos.
- Las capturas anteriores son históricas, correspondientes al levantamiento registrado arriba.
- En esta revisión del día 16 faltaban las capturas de terminal y de la interfaz con datos. Ambas se incorporaron después, el día 18.
- [Guion de demo y exposición](exposicion/guion.md).

No se borraron contenedores ni volúmenes. Para retomar, primero hay que recuperar el arranque normal de Docker Desktop; después ejecutar Compose desde el clon separado del proyecto asignado.


## 7. Ejecución y demo comprobadas el 18 de octubre de 2026

Al retomar el trabajo, Docker ya estaba activo. Los dos contenedores de Sismos estaban en ejecución. No se necesitó borrar sockets, recrear contenedores ni modificar el volumen de PostgreSQL. No se conoce qué acción externa hizo disponible el motor después del fallo del día 16.

Desde `C:\Users\sami-dev\Seismic-Data-Visualization-System` se ejecutó:

```powershell
docker compose up -d --no-build
docker compose ps
docker exec seismic-data-visualization-system-db-1 psql -U postgres -d datawarehouse -c "SELECT COUNT(*) AS sismos_cargados FROM dim_sismos;" -c "SELECT * FROM dim_sismos LIMIT 5;"
```

Ambos servicios respondieron en ejecución. La consulta devolvió 319,592 filas totales en `dim_sismos` y cinco filas de muestra. [Registro actual de comandos y resultados](capturas/ejecucion-2026-10-18.txt).

### Aviso concreto de Compose

Compose mostró `the attribute version is obsolete, it will be ignored`. Es una advertencia de compatibilidad de la propiedad `version: '3.8'`, no un fallo de arranque. Los servicios siguieron funcionando. No se cambió el Compose del proyecto asignado durante esta revisión.

### Demostración con datos

1. Abrir `http://localhost/vista.html` y pulsar **Sismos en México**.
2. En la vista cargada, mantener año 2020 y magnitud mínima 5: la aplicación mostró 21 sismos y el indicador de población potencialmente afectada de 87,810,893.
3. Cambiar la magnitud mínima a 6 y pulsar **Aplicar Filtros**: mostró 3 sismos y el indicador de población de 11,291,239.
4. Comprobar mapa, indicadores y gráficas con datos visibles.

Capturas reales del navegador:

- [Filtro 2020 / magnitud mínima 6](capturas/demo-filtro-2026-10-18.png).
- [Mapa e indicadores resultantes](capturas/demo-resultados-2026-10-18.png).
- [Gráficas con registros cargados](capturas/demo-graficas-2026-10-18.png).

Los indicadores se reportan tal como los calcula la aplicación. No equivalen a personas damnificadas observadas ni demuestran por sí solos que el cálculo evite dobles conteos.

**Evidencia de arranque:** [captura auténtica de PowerShell](capturas/arranque-terminal-2026-10-18.png), proporcionada por el integrante. Muestra `docker compose up -d`, ambos servicios en Running y `docker compose ps` con sus puertos. La advertencia de `version` obsoleta no impidió el funcionamiento.
