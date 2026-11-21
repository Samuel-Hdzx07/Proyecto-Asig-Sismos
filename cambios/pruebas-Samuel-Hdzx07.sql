-- Ejecutar unicamente en la copia modificada. No conserva inserciones ni actualizaciones.
BEGIN;
DO $$ BEGIN BEGIN
 UPDATE dim_sismos SET id_sismo_principal=id_sismo WHERE id_sismo=(SELECT min(id_sismo) FROM dim_sismos);
 RAISE EXCEPTION 'FALLO: autorreferencia aceptada';
EXCEPTION WHEN check_violation THEN RAISE NOTICE 'OK: autorreferencia rechazada'; END; END $$;
DO $$ BEGIN BEGIN
 UPDATE dim_sismos SET id_sismo_principal=-1 WHERE id_sismo=(SELECT min(id_sismo) FROM dim_sismos);
 RAISE EXCEPTION 'FALLO: principal inexistente aceptado';
EXCEPTION WHEN foreign_key_violation THEN RAISE NOTICE 'OK: principal inexistente rechazado'; END; END $$;
DO $$ BEGIN BEGIN
 PERFORM asignar_replicas(0,100);
 RAISE EXCEPTION 'FALLO: horas cero aceptadas';
EXCEPTION WHEN invalid_parameter_value THEN RAISE NOTICE 'OK: parametro invalido rechazado'; END; END $$;
ROLLBACK;
