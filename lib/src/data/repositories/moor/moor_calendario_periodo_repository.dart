import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_curso_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';

class MoorCalendarioPeriodoRepository extends CalendarioPeriodoRepository{


  @override
  Future<List<CalendarioPeriodoUI>> getCalendarioPerios(int programaEducativoId, int cargaCursoId, int anioAcademicoId) async {
    print("calendarioPeriodoUI "+ programaEducativoId.toString() + " " +cargaCursoId.toString() + " "+ anioAcademicoId.toString());
      List<CalendarioPeriodoUI> calendarioPeriodoList = [];
      AppDataBase SQL = AppDataBase();
      var query=  await SQL.select(SQL.calendarioPeriodo).join([
        innerJoin(SQL.calendarioAcademico, SQL.calendarioAcademico.calendarioAcademicoId.equalsExp(SQL.calendarioPeriodo.calendarioAcademicoId)),
        innerJoin(SQL.anioAcademico, SQL.anioAcademico.idAnioAcademico.equalsExp(SQL.calendarioAcademico.idAnioAcademico)),
        innerJoin(SQL.tipos, SQL.tipos.tipoId.equalsExp(SQL.calendarioPeriodo.tipoId))
      ]);

      query.where(SQL.anioAcademico.idAnioAcademico.equals(anioAcademicoId));
      query.where(SQL.calendarioAcademico.programaEduId.equals(programaEducativoId));
      query.groupBy([SQL.calendarioPeriodo.calendarioPeriodoId]);

      CalendarioPeriodoUI? calendarioPeriodoUI = null;

      for(var row in await query.get()){
        CalendarioPeriodoData calendarioPeriodoData = row.readTable(SQL.calendarioPeriodo);
        Tipo tipo = row.readTable(SQL.tipos);
        CalendarioPeriodoUI calendarioPeriodoUI = CalendarioPeriodoUI();
        calendarioPeriodoUI.id = calendarioPeriodoData.calendarioPeriodoId;
        calendarioPeriodoUI.nombre = tipo.nombre;
        calendarioPeriodoList.add(calendarioPeriodoUI);
      }

      if (calendarioPeriodoList.isNotEmpty && calendarioPeriodoUI == null){
        final List<CalendarioPeriodoUI> orderList = [];
        orderList.addAll(calendarioPeriodoList);
        orderList.sort((a, b) => (b.fechaFin??DateTime(0)).compareTo(a.fechaFin??DateTime(0)));

        //#region Buscar el calendario en el estado creado proximo a estar vigente
        int count = 0;
        calendarioPeriodoUI =  orderList[0];
        for(var item in orderList){
          if ((calendarioPeriodoUI?.estadoId??0) == 214)
          {
            calendarioPeriodoUI =  item;
            if (count != 0 &&
                orderList[count - 1].estadoId == 217)
            {
              calendarioPeriodoUI = orderList[count - 1];
              break;
            }
          }

          count++;
        }

        calendarioPeriodoUI?.selected = true;
        //#endregion
      }

      return calendarioPeriodoList;
  }

}