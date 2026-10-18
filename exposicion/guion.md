# Guion del proyecto asignado: Sismos

## Orden de exposición

1. Problema y procedencia de los datos.
2. Demo local del sistema original: año 2020, magnitud mínima 5 y después 6.
3. Consulta directa a PostgreSQL y resultado.
4. Modelo conceptual EER y correspondencia con las cinco tablas publicadas.
5. Propuestas de mejora, explicadas por su responsable después de validar los borradores.
6. Diferencias entre el dashboard estático de este repo y el sistema original.

La consigna completa contempla 12–15 minutos e incluye también el proyecto propio. Este archivo y la presentación contienen únicamente el bloque asignado, separado a petición del equipo. El bloque de música permanece en su repositorio y puede abrirse durante la exposición si el docente lo solicita.

## Demo verificada el 18/10/2026

- En `http://localhost/vista.html`, abrir Sismos en México.
- Año 2020 y magnitud mínima 5: la aplicación muestra 21 sismos.
- Cambiar la magnitud mínima a 6: muestra 3 sismos.
- Abrir mapas, indicadores y gráficas con datos visibles.
- La consulta `SELECT COUNT(*) FROM dim_sismos;` devuelve 319592.
- Capturas actuales en `../capturas/`; comandos reales en `../capturas/ejecucion-2026-10-18.txt`.

Falta una captura auténtica del arranque en terminal. La consulta y los indicadores no certifican por sí solos la metodología científica de impacto.

## Pendientes de participación

Validar responsables del nuevo equipo, revisar los nueve borradores, registrar sus issues y obtener revisión real de un compañero. La presentación no acredita que estas acciones ya ocurrieron.
