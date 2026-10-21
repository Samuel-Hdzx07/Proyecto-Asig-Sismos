# Proyecto asignado: visualización del impacto de sismos

Repositorio independiente para la entrega asignada sobre datos sísmicos de México. Contiene el material del proyecto asignado y una versión estática del dashboard. No contiene el proyecto propio tipo Spotify ni los materiales de Natfy. Incluye la documentación académica correspondiente al proyecto asignado.

## Integrantes

- Hernandez Barrios Samuel Rodrigo
- Ramos Padrón Jesus Emmanuel
- Damas Garnica Adrian
- Esparza Ramón Fernando Adán

Grupo: 3CV4. Carrera: Ingeniería en Sistemas Computacionales.

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

El proyecto de referencia usa Docker Compose, PHP y PostgreSQL. En el checkout original, se inicia con `docker compose up -d` desde la carpeta que contiene `docker-compose.yml`. Su interfaz principal es `vista.html`, que abre `std.php`, `std2.php` o `std3.php` dentro de un iframe. Se accede a `http://localhost/vista.html`; la raíz `http://localhost/` no es su página de entrada. La base original se conserva; el cambio de Práctica 3 se ejecutó exclusivamente sobre una copia restaurada de ella.

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

El proyecto asignado se mantiene separado del proyecto musical. Los tres issues de Samuel se transfirieron a este repositorio; la equivalencia de sus números está documentada en propuestas/transferencia-issues.md. Los pull requests anteriores conservan su ubicación original.


## Documentación académica

Documentación del modelado, análisis y propuestas del proyecto asignado.

### Práctica 2

- [Levantamiento original y revisión actual](levantamiento.md).
- [EER conceptual](eer.png) y [correspondencia con el esquema](correspondencia-con-el-esquema.pdf).
- [Resúmenes de los tres artículos](articulos/resumenes.pdf).
- [Propuestas documentadas](propuestas/propuestas-de-mejora.pdf), [datos de propuestas](propuestas/propuestas-equipo.json) y [nueve borradores de issues](propuestas/issues-por-publicar/README.md).
- [Presentación de Sismos en PDF](exposicion/presentacion.pdf), [PowerPoint editable](exposicion/presentacion.pptx) y [guion](exposicion/guion.md).
- [Estado de participación y revisión](revision-equipo.md).

Las propuestas P01–P03 están registradas en los issues [#1](https://github.com/Samuel-Hdzx07/Proyecto-Asig-Sismos/issues/1), [#2](https://github.com/Samuel-Hdzx07/Proyecto-Asig-Sismos/issues/2) y [#3](https://github.com/Samuel-Hdzx07/Proyecto-Asig-Sismos/issues/3) de este repositorio. Se transfirieron desde música conservando autoría y contenido. P04–P12 siguen siendo borradores para validación; no se acredita autoría por incluir un nombre.

### Práctica 3

- [Análisis del esquema](analisis-del-esquema.pdf).
- [Comparación EER–relacional del bloque asignado](comparacion-eer-relacional.pdf).
- [Cambio de réplicas sísmicas en SQL](cambios/cambio-Samuel-Hdzx07.sql) y [explicación del cambio](cambios/cambio-Samuel-Hdzx07.pdf).

El cambio de Samuel se ejecutó el 20/10/2026 sobre `sismos_p3_samuel_final_20261020`, copia de `datawarehouse`: 159,305 candidatos, cero violaciones del criterio y consulta nueva con resultados. Es un criterio operativo, no una clasificación sismológica validada. La comparación EER-relacional ya incluye Natfy y Sismos. Las capturas PNG y la revisión real del PR siguen pendientes.

### Evidencias reales del 18/10/2026

- [Filtro de año 2020 y magnitud mínima 6](capturas/demo-filtro-2026-10-18.png).
- [Mapa e indicadores con datos](capturas/demo-resultados-2026-10-18.png).
- [Gráficas](capturas/demo-graficas-2026-10-18.png).
- [Comandos y consulta SQL](capturas/ejecucion-2026-10-18.txt).
- [Diagnóstico previo de Docker](capturas/diagnostico-2026-10-16.txt).

La base original respondió con 319592 filas de dim_sismos. Para 2020, la aplicación mostró 21 eventos con magnitud mínima 5 y 3 con magnitud mínima 6. Estas pruebas corresponden al sistema original local con PostgreSQL, no a la página estática. El motor ya estaba activo al retomar el trabajo; no se atribuye una reparación que no se realizó.

Pendientes: validación de propuestas, nueve issues y cambios individuales de los compañeros, capturas PNG del cambio de Samuel, demostraciones y revisión de un compañero. No se implementaron propuestas ajenas en esta actualización.

### Fork de referencia

https://github.com/Samuel-Hdzx07/Seismic-Data-Visualization-System — commit 8569667cf4f46fab640dba3f82a7b324ca7efaf7. El clon ejecutable se mantiene separado de este repositorio de entrega.

### Declaración de IA

Codex (OpenAI): apoyo en la elaboración del proyecto.

### Referencias

- Villa Vargas, J. M., Hurtado Avilés, G., y Climent Hernández, J. A. (2026). Cuando México tiembla: la historia contada por los datos. AZCATL Revista de Divulgación de la Ciencia, la Ingeniería y la Innovación, 4(6), 28–33. https://doi.org/10.24275/AZC2026E1004
- Las referencias de los tres artículos se incluyen completas en articulos/resumenes.pdf.


## Cobertura de las prácticas

Consulta [pendientes-practicas.md](pendientes-practicas.md) para distinguir documentos disponibles y evidencia pendiente.

[Registro de transferencia y equivalencia de números](propuestas/transferencia-issues.md).

[Captura de arranque en terminal](capturas/arranque-terminal-2026-10-18.png): ambos servicios Running y puertos publicados.

## Resultado de Práctica 3 - Samuel (20/10/2026)

- [Ejecución real del SQL](capturas/replicas-ejecucion-2026-10-20.txt).
- [Consulta nueva con diez filas](capturas/replicas-consulta-2026-10-20.csv) y [consulta SQL](cambios/consulta-Samuel-Hdzx07.sql).
- [Validación del criterio](capturas/replicas-validacion-2026-10-20.txt).
- [Restricciones rechazadas](capturas/replicas-pruebas-2026-10-20.txt).
- [Comprobación de la base original](capturas/replicas-original-conservado-2026-10-20.txt).
- [Manifiesto de parámetros y versiones](capturas/replicas-manifiesto-2026-10-20.json).
- [Comparación conjunta Natfy-Sismos](comparacion-eer-relacional.pdf).
- [Nota individual y guion de demostración](cambios/cambio-Samuel-Hdzx07.pdf).

La copia conserva 319,592 sismos; 123,016 no tienen fecha vinculada al hecho y no se clasifican. Se obtuvieron 159,305 vínculos directos bajo ventana de 72 horas, radio de 100 km y mayor magnitud del principal. La fila principal del resultado es 111111 (Oaxaca, magnitud 7.2), con 926 candidatos. Validar tiempo, magnitud y distancia sin redondear produce cero inconsistencias; solo se redondea la presentación.

### Capturas y demostración

Desde la raíz de este repositorio, con Docker iniciado:

```powershell
powershell -ExecutionPolicy Bypass -File .\mostrar-replicas.ps1 -Seccion ejecucion
powershell -ExecutionPolicy Bypass -File .\mostrar-replicas.ps1 -Seccion consulta
powershell -ExecutionPolicy Bypass -File .\mostrar-replicas.ps1 -Seccion validacion
```

La primera sección genera otra copia con nombre único, restaura el origen y ejecuta el cambio. No modifica `datawarehouse`. Las otras secciones consultan la copia final ya disponible; se puede pasar `-Base` para usar otra copia. El cambio DDL se instala una sola vez en cada copia. Repetir la función reemplaza la asignación según los parámetros suministrados.

Las transcripciones y el CSV son evidencia de ejecución real; las capturas de pantalla requeridas se añadirán cuando el usuario las adjunte. Cada persona realiza su demostración y revisión desde su propia cuenta. Los materiales de los compañeros no se modificaron.

### Revisión del avance

[PR #4: réplicas ejecutadas y comparación conjunta](https://github.com/Samuel-Hdzx07/Proyecto-Asig-Sismos/pull/4), abierto en borrador. [Resultado registrado en issue #1](https://github.com/Samuel-Hdzx07/Proyecto-Asig-Sismos/issues/1#issuecomment-6305335312). No está fusionado ni revisado por un compañero; faltan las capturas PNG y la demostración individual.
