# Proyecto asignado: visualización del impacto de sismos

Repositorio independiente para la entrega asignada sobre datos sísmicos de México. Contiene el material del proyecto asignado y una versión estática del dashboard. No contiene el proyecto propio tipo Spotify ni los PDF de prácticas o materiales de referencia que no pertenecen a esta entrega.

## Integrantes indicados para la portada

- Hernandez Barrios Samuel Rodrigo
- Ramos Padrón Jesus Emmanuel
- Damas Garnica Adrian
- Esparza Ramón Fernando Adán

La portada de `correspondencia-con-el-esquema.pdf` se actualizó para mostrar estos cuatro nombres. La segunda página y el resto del contenido del PDF se conservaron. No se atribuye implementación individual a integrantes.

## Contenido

- `index.html`: dashboard estático con vistas de sismos, población y economía.
- `data/seismic-events.json`: eventos sísmicos de la tabla de hechos unidos con las dimensiones de sismos y tiempo.
- `data/state-indicators.json`: tablas completas de población y economía por entidad.
- `data/README.md`: procedencia, columnas, conversión y límites de los conjuntos JSON.
- `correspondencia-con-el-esquema.pdf`: documento asignado con la portada actualizada.
- `levantamiento.md`, `eer.png` y `capturas/`: material original de la entrega, conservado.
- `LICENSE`: licencia MIT copiada del proyecto de referencia.

## Procedencia y atribución

Los datos y el diseño funcional de referencia proceden de [gabrielhuav/Seismic-Data-Visualization-System](https://github.com/gabrielhuav/Seismic-Data-Visualization-System), revisión `8569667cf4f46fab640dba3f82a7b324ca7efaf7`. Se conserva la licencia MIT del proyecto de referencia. El artículo asociado que solicita citar es [Cuando México tiembla: la historia contada por los datos](https://doi.org/10.24275/AZC2026E1004).

La portada del PDF identifica a los cuatro integrantes anteriores. El resto de la memoria y los materiales de la entrega se conservaron como estaban; sus textos internos no se reescribieron para asignar autoría de implementación.

## Uso del dashboard

### Versión estática

La versión estática no requiere PHP, PostgreSQL ni Docker. Sirve los JSON incluidos junto a la página. Desde la raíz del repositorio, inicia un servidor HTTP local:

```powershell
python -m http.server 8000
```

Abre `http://localhost:8000/`. La página carga las vistas desde `index.html`; abrir el archivo directamente con `file://` puede impedir la lectura de los JSON. El menú cambia entre secciones dentro de esta página y el botón de regreso vuelve al menú; esto sustituye los iframes PHP de la interfaz original. La versión publicada es [GitHub Pages](https://samuel-hdzx07.github.io/Proyecto-Asig-Sismos/), configurada para desplegar la carpeta raíz de `main`.

Las librerías de Leaflet y Chart.js, las teselas de OpenStreetMap y los límites estatales GeoJSON se cargan desde servicios externos. Por ello, la página necesita conexión a Internet para mostrar mapas y gráficos completos.

### Proyecto original de referencia

El proyecto de referencia usa Docker Compose, PHP y PostgreSQL. En el checkout original, se inicia con `docker compose up -d` desde la carpeta que contiene `docker-compose.yml`. Su interfaz principal es `vista.html`, que abre `std.php`, `std2.php` o `std3.php` dentro de un iframe. Se accede a `http://localhost/vista.html`; la raíz `http://localhost/` no es su página de entrada. En esta tarea los contenedores existentes se inspeccionaron en modo de solo lectura y no se iniciaron, detuvieron ni modificaron.

## Correspondencia del contenido estático

- **Sismos:** el filtro inicial de 2020 y magnitud mínima 5 produce 21 eventos. Sus campos coinciden con las 21 filas incrustadas por `std.php` para el mismo filtro.
- **Población:** se conservan las 32 entidades de `dim_zonas`, con población total, femenina y masculina. Los totales nacionales se comprobaron contra la respuesta de `std2.php`. El mapa muestra cifras al pasar el cursor y, al seleccionar una entidad, mantiene el panel de población municipal sin datos que existe en la fuente.
- **Economía:** los 32 registros de `dim_economia` permanecen en `data/state-indicators.json`. La vista estática los deja sin cargar deliberadamente para reproducir el resultado actual de `std3.php`: mapa sin datos por entidad, indicadores en cero y gráficas vacías. La asignación de `entidad` a códigos estatales del PHP de referencia descarta todas sus filas.

La versión estática conserva la estructura de navegación y las vistas principales, usando archivos JSON locales en lugar de consultas PHP. Algunos detalles del dashboard se consolidaron en una sola página y no se validaron visualmente lado a lado. La comprobación visual de la interfaz y de una recarga del navegador queda pendiente de la captura solicitada.

## Verificaciones registradas

- Se comprobó la sintaxis del JavaScript incrustado, que no haya IDs HTML duplicados y que los IDs usados por `getElementById` existan.
- Los JSON se pudieron analizar: 196,576 eventos sísmicos, 32 registros de población y 32 registros económicos.
- El filtro predeterminado produjo 21 filas tanto en el JSON estático como en el resultado de `std.php`; una comparación de los campos de esas filas no encontró diferencias.
- `std3.php` respondió sin filas económicas; la vista estática fue ajustada a ese comportamiento. Los registros JSON siguen preservados.
- La página se publicó en GitHub Pages bajo la rama `main`. La revisión visual en navegador y la confirmación de recarga siguen pendientes; no se declaran como verificadas.

## Alcance de la copia

El repositorio se creó para separar el proyecto asignado de otros materiales. El repositorio original `Samuel-Hdzx07/Proyecto_BD` no se modificó. Issues, pull requests y configuración del repositorio original no se transfieren a esta copia.
