import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_campotematico.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipo_evaluacion_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipo_nota_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipos_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/estado_sync.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';


import 'database/app_database.dart';
import 'model/criterios.dart';
import 'model/rubro/rubro_eval_rnpformula.dart';

class MoorRubroRepository extends RubroRepository{
  static const int TN_VALOR_NUMERICO = 410, TN_SELECTOR_NUMERICO = 411, TN_SELECTOR_VALORES = 412, TN_SELECTOR_ICONOS = 409, TN_VALOR_ASISTENCIA= 474;
  static const int COMPETENCIA_BASE = 347, COMPETENCIA_TRANS = 348, COMPETENCIA_ENFQ = 349;
  static const int TIPO_RUBRO_UNIDIMENCIONAL = 470, TIPO_RUBRO_BIMENSIONAL = 471, TIPO_RUBRO_BIDIMENCIONAL_DETALLE = 473;
  static const int FORMA_EVAL_INDIVIDUAL = 477, FORMA_EVAL_GRUPAL = 478;
  static const int ESTADO_ANCLADA=313, ESTADO_EVALUADO=314, ESTADO_CREADO =237, ESTADO_ACTUALIZADO = 239, ESTADO_ELIMINADO = 280;

  @override
  void saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId, int calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      int anioAcademicoId = 0;
      int  empleadoId = 0;
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        if(crearRubro.containsKey("sessionAprendizajeCriterios")||crearRubro.containsKey("unidadAprendizajeCriterios")){
        //&& t.calendarioPeriodoId.equals(calendarioPeriodoId)
          //batch.deleteWhere(SQL.criterio, (Criterio t) => t.silaboEventoId.equals(silaboEventoId));
          var query = SQL.delete(SQL.criterio)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
          query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
          query.go();
        }

        if(crearRubro.containsKey("sessionAprendizajeCriterios")){
          batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["sessionAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("unidadAprendizajeCriterios")){
          batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["unidadAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("crearRubrosOfflinetipos")){
          batch.deleteWhere(SQL.tiposRubro, (row) => const Constant(true));
          batch.insertAll(SQL.tiposRubro, SerializableConvert.converListSerializeTiposRubro(crearRubro["crearRubrosOfflinetipos"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("crearRubrosOfflinetipos_evaluacion")){
          batch.deleteWhere(SQL.tipoEvaluacionRubro, (row) => const Constant(true));
          batch.insertAll(SQL.tipoEvaluacionRubro, SerializableConvert.converListSerializeTipoEvaluacionRubro(crearRubro["crearRubrosOfflinetipos_evaluacion"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("valorTipoNota")){
          batch.deleteWhere(SQL.valorTipoNotaRubro, (row) => const Constant(true));
          batch.insertAll(SQL.valorTipoNotaRubro, SerializableConvert.converListSerializeValorTipoNotaRubro(crearRubro["valorTipoNota"]), mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("tipoNotaEscala")){
          batch.deleteWhere(SQL.tipoNotaRubro, (row) => const Constant(true));
          batch.insertAll(SQL.tipoNotaRubro, SerializableConvert.converListSerializeTipoNotaRubro(crearRubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace );
        }

      });

    }catch(e){
      print("Error: " + e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<List<FormaEvaluacionUi>> getGetFormaEvaluacion() async {
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.tiposRubro)..where((tbl) => tbl.concepto.equals("Forma Evaluacion"));
    query.where((tbl) => tbl.objeto.equals("T_RN_MAE_RUBRO_EVALUACION_PROCESO"));
    List<TiposRubroData> formaEvaluacionData =  await query.get();
    List<FormaEvaluacionUi> formaEvaluacionUiList = [];
    for(TiposRubroData tipoRubroData in formaEvaluacionData){
      FormaEvaluacionUi formaEvaluacionUi = FormaEvaluacionUi();
      formaEvaluacionUi.id = tipoRubroData.tipoId;
      formaEvaluacionUi.nombre = tipoRubroData.nombre;
      formaEvaluacionUiList.add(formaEvaluacionUi);
    }
    return formaEvaluacionUiList;
  }

  @override
  Future<List<TipoEvaluacionUi>> getGetTipoEvaluacion() async{
    AppDataBase SQL = AppDataBase();
   List<TipoEvaluacionUi> tipoEvaluacionUiList = [];
    List<TipoEvaluacionRubroData> tipoEvaluacionRubroDataList =  await SQL.select(SQL.tipoEvaluacionRubro).get();
    for(TipoEvaluacionRubroData tipoEvaluacionRubroData in tipoEvaluacionRubroDataList){
      TipoEvaluacionUi tipoEvaluacionUi = TipoEvaluacionUi();
      tipoEvaluacionUi.id= tipoEvaluacionRubroData.tipoEvaluacionId;
      tipoEvaluacionUi.nombre = tipoEvaluacionRubroData.nombre;
      tipoEvaluacionUiList.add(tipoEvaluacionUi);
    }
    return tipoEvaluacionUiList;
  }

  @override
  Future<List<TipoNotaUi>> getGetTipoNota(int programaEducativoId) async{
    AppDataBase SQL = AppDataBase();
    List<TipoNotaUi> tipoNotaUiList = [];

    var query = SQL.select(SQL.tipoNotaRubro)..where((tbl) => tbl.programaEducativoId.equals(programaEducativoId));
    query.where((tbl) => tbl.tipoId.isNotIn([TN_VALOR_ASISTENCIA]));
    List<TipoNotaRubroData> tipoNotaList = await query.get();
    for(TipoNotaRubroData tipoNotaRubroData in tipoNotaList){

        TipoNotaUi tipoNotaUi = TipoNotaUi();
        tipoNotaUi.tipoNotaId = tipoNotaRubroData.tipoNotaId;
        tipoNotaUi.nombre = tipoNotaRubroData.nombre;
        tipoNotaUi.escalanombre = tipoNotaRubroData.escalanombre;
        tipoNotaUi.escalavalorMaximo = tipoNotaRubroData.escalavalorMaximo;
        tipoNotaUi.escalavalorMinimo = tipoNotaRubroData.escalavalorMinimo;
        tipoNotaUi.tiponombre = tipoNotaRubroData.tiponombre;
        tipoNotaUi.tipoId = tipoNotaRubroData.tipoId;
        tipoNotaUi.intervalo = tipoNotaRubroData.intervalo;

        switch(tipoNotaRubroData.tipoId??0){
          case TN_SELECTOR_ICONOS:
            tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
            break;
          case TN_SELECTOR_NUMERICO:
            tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
            break;
          case TN_SELECTOR_VALORES:
            tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
            break;
          case TN_VALOR_NUMERICO:
            tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
            break;
          case TN_VALOR_ASISTENCIA:
            tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
            break;
        }

        List<ValorTipoNotaUi> valorTipoNotaUiList = [];
        List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await (SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData.tipoNotaId))).get();
        valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

        for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
          ValorTipoNotaUi valorTipoNotaUi = ValorTipoNotaUi();
          valorTipoNotaUi.valorTipoNotaId = valorTipoNotaRubroData.valorTipoNotaId;
          valorTipoNotaUi.titulo = valorTipoNotaRubroData.titulo;
          valorTipoNotaUi.alias = valorTipoNotaRubroData.alias;
          valorTipoNotaUi.icono = valorTipoNotaRubroData.icono;
          valorTipoNotaUi.incluidoLInferior = valorTipoNotaRubroData.incluidoLInferior;
          valorTipoNotaUi.incluidoLSuperior = valorTipoNotaRubroData.incluidoLSuperior;
          valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
          valorTipoNotaUi.valorNumerico = valorTipoNotaRubroData.valorNumerico;
          valorTipoNotaUi.limiteInferior = valorTipoNotaRubroData.limiteInferior;
          valorTipoNotaUi.limiteSuperior = valorTipoNotaRubroData.limiteSuperior;
          valorTipoNotaUiList.add(valorTipoNotaUi);
        }

        tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
        tipoNotaUiList.add(tipoNotaUi);
        tipoNotaUiList.sort((a, b) => (b.valorTipoNotaList??[]).length.compareTo((a.valorTipoNotaList??[]).length));
    }
    return tipoNotaUiList;

  }

  @override
  Future<List<CompetenciaUi>> getTemasCriterios(int calendarioPeriodoId, int silaboEventoId) async{
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.criterio)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));

    List<CompetenciaUi> competenciaUiList = [];
    //List<CapacidadUi> capacidadUiList = [];
    //List<CriterioUi> criterioUiList = [];

    //List<TemaCriterioUi> padreTemaCriterioDataList = [];
    //List<TemaCriterioUi> temaCriterioDataList = [];

    List<CriterioData> criterioDataList = await query.get();
    for(CriterioData criterioData in criterioDataList){


      CompetenciaUi? competenciaUi = competenciaUiList.firstWhereOrNull((element) => element.competenciaId == criterioData.superCompetenciaId);
      if(competenciaUi==null){
        competenciaUi = CompetenciaUi();
        competenciaUi.capacidadUiList = [];
        competenciaUi.competenciaId = criterioData.superCompetenciaId;
        competenciaUi.nombre = criterioData.superCompetenciaNombre;
        competenciaUi.descripcion = criterioData.superCompetenciaDescripcion;
        switch( criterioData.superCompetenciaTipoId??0){
          case COMPETENCIA_BASE:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.BASE;
            break;
          case COMPETENCIA_ENFQ:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.ENFOQUE;
            break;
          case COMPETENCIA_TRANS:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.TRANSVERSAL;
            break;
        }

        competenciaUiList.add(competenciaUi);
      }

      CapacidadUi? capacidadUi = competenciaUi.capacidadUiList?.firstWhereOrNull((element) => element.capacidadId == criterioData.competenciaId);
      if(capacidadUi==null){
        capacidadUi = CapacidadUi();
        capacidadUi.criterioUiList = [];
        capacidadUi.capacidadId = criterioData.competenciaId;
        capacidadUi.nombre = criterioData.competenciaNombre;
        capacidadUi.descripcion = criterioData.competenciaDescripcion;
        capacidadUi.tipoId = criterioData.competenciaTipoId;
        capacidadUi.competenciaId = criterioData.superCompetenciaId;
        capacidadUi.competenciaUi = competenciaUi;
        competenciaUi.capacidadUiList?.add(capacidadUi);
      }

      CriterioUi? criterioUi = capacidadUi.criterioUiList?.firstWhereOrNull((element) => element.desempenioIcdId == criterioData.desempenioIcdId);
      if(criterioUi==null){
        criterioUi= CriterioUi();
        criterioUi.temaCriterioUiList = [];
        criterioUi.desempenioIcdId = criterioData.desempenioIcdId;
        criterioUi.desempenioId = criterioData.desempenioId;
        criterioUi.icdId = criterioData.icdId;
        criterioUi.desempenioDescripcion = criterioData.DesempenioDescripcion;
        criterioUi.peso = criterioData.peso;
        criterioUi.icdTitulo = criterioData.icdTitulo;
        criterioUi.icdDescripcion = criterioData.icdDescripcion;
        criterioUi.desempenioIcdDescripcion = criterioData.desempenioIcdDescripcion;
        criterioUi.capacidadId = criterioData.competenciaId;
        criterioUi.capacidadUi = capacidadUi;
        criterioUi.tipoId = criterioData.tipoId;
        criterioUi.url = criterioData.url;
        capacidadUi.criterioUiList?.add(criterioUi);

      }

      if((criterioData.campoTematicoParentId??0) > 0) {
        TemaCriterioUi? padreTemaCriterioUi = criterioUi.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoParentId);
        if (padreTemaCriterioUi == null) {
          padreTemaCriterioUi = TemaCriterioUi();
          padreTemaCriterioUi.temaCriterioUiList = [];
          padreTemaCriterioUi.campoTematicoId =
              criterioData.campoTematicoParentId;
          padreTemaCriterioUi.titulo = criterioData.campoTematicoParentTitulo;
          padreTemaCriterioUi.descripcion =
              criterioData.campoTematicoParentDescripcion;
          padreTemaCriterioUi.parentId = criterioData.campoTematicoParentId;
          criterioUi.temaCriterioUiList?.add(padreTemaCriterioUi);
        }


        TemaCriterioUi? temaCriterioUi = padreTemaCriterioUi.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoId);
        if(temaCriterioUi==null){
          temaCriterioUi = TemaCriterioUi();
          temaCriterioUi.campoTematicoId = criterioData.campoTematicoId;
          temaCriterioUi.titulo = criterioData.campoTematicoTitulo;
          temaCriterioUi.descripcion = criterioData.campoTematicoDescripcion;
          temaCriterioUi.parentId = criterioData.campoTematicoParentId;
          temaCriterioUi.parent = padreTemaCriterioUi;
          padreTemaCriterioUi.temaCriterioUiList?.add(temaCriterioUi);
        }

      }else{
        TemaCriterioUi? temaCriterioUi = criterioUi.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoId);
        if(temaCriterioUi==null){
          temaCriterioUi = TemaCriterioUi();
          temaCriterioUi.campoTematicoId = criterioData.campoTematicoId;
          temaCriterioUi.titulo = criterioData.campoTematicoTitulo;
          temaCriterioUi.descripcion = criterioData.campoTematicoDescripcion;
          temaCriterioUi.parentId = criterioData.campoTematicoParentId;
          criterioUi.temaCriterioUiList?.add(temaCriterioUi);
        }
      }

    }
   // print("competenciaUiList size "+competenciaUiList.length.toString());
    return competenciaUiList;
  }

  @override
  Future<void> saveRubroEvaluacion(String? rubroEvaluacionId, String? titulo, int? formaEvaluacionId, int? tipoEvaluacionId, String? promedioLogroId, int? calendarioPeriodoId, int? silaboEventoId, int? cargaCursoId, int? sesionAprendizajeId, String? tareaId, int? usuarioId, List<CriterioPesoUi>? criterioPesoUiList, List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList, TipoNotaUi? tipoNotaUi) async {
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {
        if((rubroEvaluacionId??"").isEmpty) {
          List<ContactoDocenteData> alumnoList = [];
          if(formaEvaluacionId == FORMA_EVAL_INDIVIDUAL) {
            var query = SQL.select(SQL.contactoDocente)
              ..where((tbl) => tbl.cargaCursoId.equals(cargaCursoId));
            query.where((tbl) => tbl.tipo.equals(1));
            query.where((tbl) => tbl.contratoVigente.equals(true));
            alumnoList = await query.get();
          }

          rubroEvaluacionId = IdGenerator.generateId();
          RubroEvaluacionProcesoData rubroEvaluacionProceso = RubroEvaluacionProcesoData(
            rubroEvalProcesoId: rubroEvaluacionId!,
            titulo: titulo,
            formaEvaluacionId: formaEvaluacionId,
            tipoEvaluacionId: tipoEvaluacionId,
            tipoNotaId: promedioLogroId,
            calendarioPeriodoId: calendarioPeriodoId,
            silaboEventoId: silaboEventoId,
            sesionAprendizajeId: sesionAprendizajeId,
            tiporubroid: TIPO_RUBRO_BIMENSIONAL,
            estadoId: ESTADO_CREADO,
            countIndicador: criterioPesoUiList?.length,
            //estrategiaEvaluacionId: Falta
            tareaId: tareaId,
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
          );

          batch.insert(SQL.rubroEvaluacionProceso, rubroEvaluacionProceso,
              mode: InsertMode.insertOrReplace);

          if(formaEvaluacionId == FORMA_EVAL_INDIVIDUAL){

            for(ContactoDocenteData alumno in alumnoList){
              EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
                evaluacionProcesoId: IdGenerator.generateId(),
                rubroEvalProcesoId: rubroEvaluacionId,
                alumnoId: alumno.personaId,
                syncFlag: EstadoSync.FLAG_ADDED,
                fechaCreacion: DateTime.now(),
                fechaAccion: DateTime.now(),
                usuarioAccionId: usuarioId,
                usuarioCreacionId: usuarioId,
              );
              batch.insert(SQL.evaluacionProceso, evaluacionProceso, mode: InsertMode.insertOrReplace);
            }

          }

          for(CriterioPesoUi criterioPesoUi in criterioPesoUiList??[]){

            CapacidadUi? capacidadUi = criterioPesoUi.criterioUi?.capacidadUi;
            int? peso = criterioPesoUi.peso;
            String rubroEvaluacionDetalleId = IdGenerator.generateId();
            RubroEvaluacionProcesoData procesoDetalle = RubroEvaluacionProcesoData(
                rubroEvalProcesoId: rubroEvaluacionDetalleId,
                titulo: criterioPesoUi.criterioUi?.icdTituloEditado??criterioPesoUi.criterioUi?.icdTitulo??"",
                subtitulo: '',
                desempenioIcdId: criterioPesoUi.criterioUi?.desempenioIcdId,
                tiporubroid: TIPO_RUBRO_BIDIMENCIONAL_DETALLE,
                tipoNotaId: tipoNotaUi?.tipoNotaId,
                silaboEventoId: silaboEventoId,
                competenciaId: capacidadUi?.capacidadId,
                calendarioPeriodoId: calendarioPeriodoId,
                sesionAprendizajeId: sesionAprendizajeId,
                tipoEvaluacionId: tipoEvaluacionId,
                formaEvaluacionId: formaEvaluacionId,
                estadoId: ESTADO_CREADO,
                rubroFormal: capacidadUi?.tipoId == COMPETENCIA_BASE? 1:0,
                syncFlag: EstadoSync.FLAG_ADDED,
                fechaCreacion: DateTime.now(),
                fechaAccion: DateTime.now(),
                usuarioAccionId: usuarioId,
                usuarioCreacionId: usuarioId,
            );

            batch.insert(SQL.rubroEvaluacionProceso, procesoDetalle, mode: InsertMode.insertOrReplace);

            if(formaEvaluacionId == FORMA_EVAL_INDIVIDUAL){

              for(ContactoDocenteData alumno in alumnoList){
                EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
                  evaluacionProcesoId: IdGenerator.generateId(),
                  rubroEvalProcesoId: rubroEvaluacionDetalleId,
                  alumnoId: alumno.personaId,
                  nombres: alumno.nombres,
                  apellidoMaterno: alumno.apellidoMaterno,
                  apellidoPaterno: alumno.apellidoPaterno,
                  foto: alumno.foto,
                  syncFlag: EstadoSync.FLAG_ADDED,
                  fechaCreacion: DateTime.now(),
                  fechaAccion: DateTime.now(),
                  usuarioAccionId: usuarioId,
                  usuarioCreacionId: usuarioId,
                );
                batch.insert(SQL.evaluacionProceso, evaluacionProceso, mode: InsertMode.insertOrReplace);
              }

            }

            RubroEvalRNPFormulaData rubroEvalRNPFormula = RubroEvalRNPFormulaData(
                rubroFormulaId: IdGenerator.generateId(),
                rubroEvaluacionPrimId: rubroEvaluacionId,
                rubroEvaluacionSecId: rubroEvaluacionDetalleId,
                peso: peso?.toDouble(),
                syncFlag: EstadoSync.FLAG_ADDED,
                fechaCreacion: DateTime.now(),
                fechaAccion: DateTime.now(),
                usuarioAccionId: usuarioId,
                usuarioCreacionId: usuarioId,
            );
            batch.insert(SQL.rubroEvalRNPFormula, rubroEvalRNPFormula, mode: InsertMode.insertOrReplace);

            for(CriterioValorTipoNotaUi criterioValorTipoNotaUi in criterioValorTipoNotaUiList??[]){
                if(criterioValorTipoNotaUi.criterioUi?.desempenioIcdId == criterioPesoUi.criterioUi?.desempenioIcdId){
                  CriterioRubroEvaluacionData criterioRubroEvaluacionData = CriterioRubroEvaluacionData(
                      criteriosEvaluacionId: IdGenerator.generateId(),
                      rubroEvalProcesoId: rubroEvaluacionDetalleId,
                      valorTipoNotaId: criterioValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId,
                      descripcion: "");
                  batch.insert(SQL.criterioRubroEvaluacion, criterioRubroEvaluacionData);
                }
            }

            List<TemaCriterioUi> temaCriterioUiList = [];
            for(TemaCriterioUi temaCriterioUi in criterioPesoUi.criterioUi?.temaCriterioUiList??[]){
              if((temaCriterioUi.temaCriterioUiList??[]).isEmpty && (temaCriterioUi.toogle??false))temaCriterioUiList.add(temaCriterioUi);
              for(TemaCriterioUi subtemaCriterioUi in temaCriterioUi.temaCriterioUiList??[]){
                if(subtemaCriterioUi.toogle??false)temaCriterioUiList.add(subtemaCriterioUi);
              }
            }

            for(TemaCriterioUi temaCriterioUi in temaCriterioUiList){
              if(temaCriterioUi.toogle??false){
                RubroCampotematicoData rubroCampotematicoData = RubroCampotematicoData(
                  rubroEvalProcesoId: rubroEvaluacionDetalleId,
                  campoTematicoId: temaCriterioUi.campoTematicoId??0,
                  syncFlag: EstadoSync.FLAG_ADDED,
                  fechaCreacion: DateTime.now(),
                  fechaAccion: DateTime.now(),
                  usuarioAccionId: usuarioId,
                  usuarioCreacionId: usuarioId,
                );

                batch.insert(SQL.rubroCampotematico, rubroCampotematicoData, mode: InsertMode.insertOrReplace);
              }
            }
          }

        }else{




        }

      });

    }catch(e){
      throw Exception(e);
    }


  }

  @override
  Future<List<RubricaEvaluacionUi>> getRubroEvaluacion(int calendarioPeriodoId, int silaboEventoId) {
    AppDataBase SQL = AppDataBase();



  }

}
