import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:collection/collection.dart';

class EvaluacionIndicadorMultipleController extends Controller {
  String rubroEvaluacionId;
  CursosUi cursosUi;
  EvaluacionIndicadorMultiplePresenter presenter;
  RubricaEvaluacionUi? rubroEvaluacionUi;
  List<dynamic> _columnList2 = [];

  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];

  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];

  List<List<dynamic>> get cellListList => _cellListList;

  EvaluacionIndicadorMultipleController(this.rubroEvaluacionId, this.cursosUi,
      RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo) :
        presenter = EvaluacionIndicadorMultiplePresenter(
            rubroRepo, configuracionRepo);

  @override
  void initListeners() {
    presenter.getRubroEvaluacionOnError = (e) {
      this.rubroEvaluacionUi = null;
    };

    presenter.getRubroEvaluacionOnNext =
        (RubricaEvaluacionUi? rubroEvaluacionUi,
        List<PersonaUi> alumnoCursoList,) {
      this.rubroEvaluacionUi = rubroEvaluacionUi;
      initTable(alumnoCursoList, rubroEvaluacionUi);
      refreshUI();
    };
  }

  @override
  void onInitState() {
    super.onInitState();
    presenter.getRubroEvaluacion(rubroEvaluacionId, cursosUi);
  }

  void initTable(List<PersonaUi> alumnoCursoList,
      RubricaEvaluacionUi? rubricaEvaluacionUi) {
    _rowList2.clear();
    _cellListList.clear();
    _columnList2.clear();

    _rowList2.addAll(alumnoCursoList);
    _rowList2.add(""); //Espacio
    _rowList2.add(""); //Espacio
    _rowList2.add(""); //Espacio

    _columnList2.add(ContactoUi()); //Titulo alumno
    _columnList2.add(EvaluacionUi()); //Titulo Nota Final
    _columnList2.addAll(rubricaEvaluacionUi?.rubrosDetalleList??[]);


    _columnList2.add(""); // espacio

    for (dynamic row in _rowList2) {
      List<dynamic> cellList = [];
      cellList.add(row);

      //#obtner Nota Tatal
      if (row is PersonaUi) {
        EvaluacionUi? evaluacionUi = rubricaEvaluacionUi?.evaluacionUiList
            ?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if (evaluacionUi == null) evaluacionUi =
            EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
        evaluacionUi.personaUi =
            row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
        evaluacionUi.valorTipoNotaUi =
        null; // se elimina el obj tipo nota para que solo muestre la nota numerica
        cellList.add(evaluacionUi);
      } else {
        cellList.add(""); //Espacio
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi
          ?.rubrosDetalleList ?? []) {
        if (row is PersonaUi) {
          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList
              ?.firstWhereOrNull((element) =>
          element.alumnoId == row.personaId);
          if (evaluacionUi == null) evaluacionUi =
              EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
          evaluacionUi.personaUi =
              row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
          cellList.add(evaluacionUi);
        } else {
          cellList.add(""); //Espacio
        }
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi
          ?.rubrosDetalleList ?? []) {
        if (row is PersonaUi) {
          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList
              ?.firstWhereOrNull((element) =>
          element.alumnoId == row.personaId);
          if (evaluacionUi == null) evaluacionUi =
              EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
          evaluacionUi.personaUi =
              row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia

          int notaMaxRubro = rubricaEvaluacionUi.tipoNotaUi
              ?.escalavalorMaximo ?? 0;
          int notaMinRubro = rubricaEvaluacionUi.tipoNotaUi
              ?.escalavalorMinimo ?? 0;
          TransformarValoTipoNotaResponse response = TransformarValoTipoNota
              .execute(TransformarValoTipoNotaParams(
              evaluacionUi.nota, notaMinRubro, notaMaxRubro,
              rubricaEvaluacionUi.tipoNotaUi));

          for (int i = 0; i <
              (rubricaEvaluacionUi.tipoNotaUi?.valorTipoNotaList ?? [])
                  .length; i++) {
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi =
                rubricaEvaluacionUi;
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi =
            rubricaEvaluacionUi.tipoNotaUi?.valorTipoNotaList?[i];
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            if (response.valorTipoNotaUi?.valorTipoNotaId ==
                evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi
                    ?.valorTipoNotaId) {
              evaluacionRubricaValorTipoNotaUi.toggle = true;
            }
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }
        } else {
          cellList.add(""); //Espacio
        }
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi
          ?.rubrosDetalleList ?? []) {
        if (row is PersonaUi) {
          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList
              ?.firstWhereOrNull((element) =>
          element.alumnoId == row.personaId);
          if (evaluacionUi == null) evaluacionUi =
              EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
          evaluacionUi.personaUi =
              row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
          cellList.add(evaluacionUi);
        } else {
          cellList.add(""); //Espacio
        }

        cellList.add(""); // espacio
        _cellListList.add(cellList);
      }
    }
  }


}