import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipo_evaluacion_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipo_nota_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipos_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

import 'database/app_database.dart';
import 'model/criterios.dart';

class MoorRubroRepository extends RubroRepository{
  static const int TN_VALOR_NUMERICO = 410, TN_SELECTOR_NUMERICO = 411, TN_SELECTOR_VALORES = 412, TN_SELECTOR_ICONOS = 409, TN_VALOR_ASISTENCIA= 474;
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

}
