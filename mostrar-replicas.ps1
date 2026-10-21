param(
 [ValidateSet('ejecucion','consulta','validacion')][string]$Seccion='consulta',
 [string]$Base='sismos_p3_samuel_final_20261020'
)
$ErrorActionPreference='Stop'
Set-Location -LiteralPath $PSScriptRoot
$contenedorReplicas='seismic-data-visualization-system-db-1'
docker cp cambios/. "${contenedorReplicas}:/tmp/sismos-cambios"
if ($LASTEXITCODE -ne 0) { throw 'Inicia Docker y el contenedor de Sismos' }
if ($Seccion -eq 'ejecucion') {
 $Base='sismos_evidencia_'+(Get-Date -Format 'yyyyMMdd_HHmmss_fff')
 $archivoReplicas='/tmp/'+$Base+'.dump'
 docker exec $contenedorReplicas pg_dump -U postgres -d datawarehouse -Fc -f $archivoReplicas
 if ($LASTEXITCODE -ne 0) { throw 'Fallo respaldo consistente' }
 docker exec $contenedorReplicas createdb -U postgres $Base
 if ($LASTEXITCODE -ne 0) { throw 'Fallo crear copia' }
 docker exec $contenedorReplicas pg_restore -U postgres -d $Base --exit-on-error $archivoReplicas
 if ($LASTEXITCODE -ne 0) { throw 'Fallo restaurar copia' }
 Write-Host "Copia nueva: $Base. Original: datawarehouse." -ForegroundColor Cyan
 docker exec $contenedorReplicas psql -X -P pager=off -v ON_ERROR_STOP=1 -U postgres -d $Base -f /tmp/sismos-cambios/cambio-Samuel-Hdzx07.sql
 if ($LASTEXITCODE -ne 0) { throw 'Fallo cambio de esquema' }
 Write-Host 'Cambio ejecutado; consulta y comprobacion sin inconsistencias mostradas arriba.' -ForegroundColor Green
 exit 0
}
if ($Base -eq 'datawarehouse') { throw 'Usa exclusivamente una copia modificada' }
Write-Host "Base de trabajo: $Base" -ForegroundColor Cyan
$archivoConsultaReplicas=if ($Seccion -eq 'consulta') {'consulta-Samuel-Hdzx07.sql'} else {'validacion-Samuel-Hdzx07.sql'}
docker exec $contenedorReplicas psql -X -P pager=off -v ON_ERROR_STOP=1 -U postgres -d $Base -f ( '/tmp/sismos-cambios/'+$archivoConsultaReplicas)
if ($LASTEXITCODE -ne 0) { throw 'Fallo consulta' }
