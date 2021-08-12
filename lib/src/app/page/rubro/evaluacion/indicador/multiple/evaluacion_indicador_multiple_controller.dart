import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
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
  List<PersonaUi> _alumnoCursoList = [];
  List<PersonaUi> _alumnoCursoListDesordenado = [];
  List<PersonaUi> get alumnoCursoList => _alumnoCursoListDesordenado;

  Map<PersonaUi, List<dynamic>> _mapColumnList = Map();
  Map<PersonaUi, List<RubricaEvaluacionUi>> _mapRowList = Map();
  Map<PersonaUi, List<List<dynamic>>> _mapCellListList = Map();
  Map<PersonaUi, List<dynamic>> get mapColumnList => _mapColumnList;
  Map<PersonaUi, List<RubricaEvaluacionUi>> get mapRowList => _mapRowList;
  Map<PersonaUi, List<List<dynamic>>> get mapCellListList => _mapCellListList;

  bool _tipoMatriz = true;
  bool get tipoMatriz => _tipoMatriz;

  bool _precision = false;
  bool get precision => _precision;

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
      initLista(alumnoCursoList, rubroEvaluacionUi);
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
    _columnList2.add(EvaluacionPublicadoUi(EvaluacionUi()));
    _columnList2.add(""); // espacio

    for (dynamic row in _rowList2) {
      List<dynamic> cellList = [];
      EvaluacionPublicadoUi? evaluacionPublicadoUi = null;
      cellList.add(row);

      //#obtner Nota Tatal
      if (row is PersonaUi) {
        EvaluacionUi? evaluacionUi = rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if (evaluacionUi == null) evaluacionUi = EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
        evaluacionUi.personaUi = row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
        evaluacionUi.valorTipoNotaUi = null; // se elimina el obj tipo nota para que solo muestre la nota numerica
        evaluacionPublicadoUi = EvaluacionPublicadoUi(evaluacionUi);
        cellList.add(evaluacionUi);
      } else {
        cellList.add(""); //Espacio
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList ?? []) {
        if (row is PersonaUi) {
          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
          if (evaluacionUi == null) evaluacionUi = EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
          evaluacionUi.personaUi = row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
          cellList.add(evaluacionUi);
        } else {
          cellList.add(""); //Espacio
        }
      }

      //#obtner Validar si todos los rubros detalles esta publicados
      cellList.add(evaluacionPublicadoUi);
      cellList.add("");

      print("length: f "+cellList.length.toString());
      _cellListList.add(cellList);
    }
  }

  void onClicPublicadoAll(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi){
          cell.publicado = evaluacionPublicadoUi.publicado;
        }
      }
    }
    refreshUI();
  }

  void onClicPublicado(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    bool todosPublicados = true;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi){
          if(!cell.publicado)todosPublicados = false;
        }
      }
    }

    for(var column in columnList2){
      if(column is EvaluacionPublicadoUi){
        column.publicado = todosPublicados;
      }
    }
    refreshUI();
  }

  void initLista(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubroEvaluacionUi) {
    _alumnoCursoList = alumnoCursoList;
    _alumnoCursoListDesordenado.clear();
    _alumnoCursoListDesordenado.addAll(alumnoCursoList);
    _mapColumnList.clear();
    _mapRowList.clear();
    _mapCellListList.clear();
    for(PersonaUi personaUi in alumnoCursoList){

      _mapColumnList[personaUi] = [];
      _mapRowList[personaUi] = [];
      _mapCellListList[personaUi] = [];

      _mapRowList[personaUi]?.addAll(rubroEvaluacionUi?.rubrosDetalleList??[]);

      _mapColumnList[personaUi]?.add(RubricaEvaluacionUi());
      TipoNotaUi? tipoNotaUi = null;
      if(rubroEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false){
        tipoNotaUi = rubroEvaluacionUi?.rubrosDetalleList?[0].tipoNotaUi;
      }
      if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
        _mapColumnList[personaUi]?.addAll(tipoNotaUi?.valorTipoNotaList??[]);
      }else{
        _mapColumnList[personaUi]?.add(EvaluacionUi());//Teclado numerico
      }
      _mapColumnList[personaUi]?.add(RubricaEvaluacionPesoUi(RubricaEvaluacionUi()));//peso

      for(RubricaEvaluacionUi row in _mapRowList[personaUi]??[]){
        List<dynamic> cellList = [];
        cellList.add(row);
        EvaluacionUi? evaluacionUi = row.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaUi.personaId);
        if(evaluacionUi==null)evaluacionUi = EvaluacionUi();//Una evaluacion vasia significa que el alumno no tiene evaluacion
        evaluacionUi.personaUi = personaUi;//se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia

        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for(ValorTipoNotaUi valorTipoNotaUi in tipoNotaUi?.valorTipoNotaList??[]){
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi = valorTipoNotaUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            evaluacionRubricaValorTipoNotaUi.toggle = (evaluacionUi.evaluacionId??"").isNotEmpty && valorTipoNotaUi.valorTipoNotaId == evaluacionUi.valorTipoNotaId;
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }
        }else{
          cellList.add(evaluacionUi);
        }
        RubricaEvaluacionPesoUi pesoUi = RubricaEvaluacionPesoUi(row);
        cellList.add(pesoUi);
        _mapCellListList[personaUi]?.add(cellList);
      }
    }

    refreshUI();

  }

  onClicEvaluacionRubrica(EvaluacionUi evaluacionUi) {
    _alumnoCursoListDesordenado.clear();
    _alumnoCursoListDesordenado.addAll(_alumnoCursoList);
    _alumnoCursoListDesordenado.firstWhereOrNull((element) => false);

    _alumnoCursoListDesordenado.remove(evaluacionUi.personaUi);
    _alumnoCursoListDesordenado.insert(0,evaluacionUi.personaUi??PersonaUi());

    _tipoMatriz = false;
    refreshUI();
  }

  onClicVolverMatriz(){
    _tipoMatriz = true;
    refreshUI();
  }


}