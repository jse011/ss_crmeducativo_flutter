import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

import 'database/app_database.dart';
import 'model/criterios.dart';

class MoorRubroRepository extends RubroRepository{

  @override
  void saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      int anioAcademicoId = 0;
      int  empleadoId = 0;
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        if(crearRubro.containsKey("sessionAprendizajeCriterios")||crearRubro.containsKey("unidadAprendizajeCriterios")){
          batch.deleteWhere(SQL.criterio, (Criterio t) => t.silaboEventoId.equals(silaboEventoId));
        }

        if(crearRubro.containsKey("sessionAprendizajeCriterios")){
          batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["sessionAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("unidadAprendizajeCriterios")){
          batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["unidadAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
        }

      });

    }catch(e){
      print("Error: " + e.toString());
      throw Exception(e);
    }
  }

}