import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/individual/evaluacion_indicador_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

class EvaluacionIndicadorController extends Controller{
  String? rubroEvaluacionId;
  CursosUi? cursosUi;
  RubricaEvaluacionUi? rubroEvaluacionUi;
  EvaluacionIndicadorPresenter presenter;
  List<dynamic> _columnList2 = [];
  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];
  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];
  List<List<dynamic>> get cellListList => _cellListList;


  EvaluacionIndicadorController(this.rubroEvaluacionId, this.cursosUi, rubroRepo, configuracionRepo): presenter = EvaluacionIndicadorPresenter(rubroRepo, configuracionRepo);

  @override
  void initListeners() {
    presenter.getRubroEvaluacionOnError = (e){
      this.rubroEvaluacionUi = null;
    };

    presenter.getRubroEvaluacionOnNext = (RubricaEvaluacionUi? rubroEvaluacionUi, List<PersonaUi> alumnoCursoList,){
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

  void initTable(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubricaEvaluacionUi){

   if((rubricaEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false)){
     rubricaEvaluacionUi = rubricaEvaluacionUi?.rubrosDetalleList?[0];
   }

    _rowList2.clear();
    _cellListList.clear();
    _columnList2.clear();

    _rowList2.addAll(alumnoCursoList);
    _rowList2.add("");//Espacio
    _rowList2.add("");//Espacio
    _rowList2.add("");//Espacio

    _columnList2.add(ContactoUi());//Titulo alumno
    if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
      _columnList2.addAll(rubroEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]);

    }else {
      _columnList2.add(EvaluacionUi());//Notas de tipo Numerico
    }

    _columnList2.add("");// espacio

    for(dynamic row in _rowList2){
      List<dynamic>  cellList = [];
      cellList.add(row);

      //#obtner Nota Tatal
      if(row is PersonaUi){
        EvaluacionUi? evaluacionUi = rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if(evaluacionUi==null)evaluacionUi = EvaluacionUi();//Una evaluacion vasia significa que el alumno no tiene evaluacion
        evaluacionUi.personaUi = row;//se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia

        if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          int notaMaxRubro = rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMaximo??0;
          int notaMinRubro = rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMinimo??0;
          TransformarValoTipoNotaResponse response = TransformarValoTipoNota.execute(TransformarValoTipoNotaParams(evaluacionUi.nota, notaMinRubro, notaMaxRubro, rubricaEvaluacionUi?.tipoNotaUi));

          for (ValorTipoNotaUi valorTipoNotaUi in rubricaEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]) {
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi =  valorTipoNotaUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            if(response.valorTipoNotaUi?.valorTipoNotaId == evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId){
              evaluacionRubricaValorTipoNotaUi.toggle = true;
            }
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }

        }else {
          cellList.add(evaluacionUi);//Notas de tipo Numerico
        }

      }else{
        if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for (ValorTipoNotaUi valorTipoNotaUi in rubricaEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]) {
            cellList.add("");//Espacio
          }
        }else {
          cellList.add("");//Espacio
        }

      }

      cellList.add("");// espacio
      _cellListList.add(cellList);
    }
  }

  onClicEvaluar(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi) {

    for(List cellList in cellListList){
      for(var cell in cellList){
         if(cell is EvaluacionRubricaValorTipoNotaUi){
           if(cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
               && cell != evaluacionRubricaValorTipoNotaUi){
             cell.toggle = false;
           }
         }
      }
    }

    evaluacionRubricaValorTipoNotaUi.toggle = !(evaluacionRubricaValorTipoNotaUi.toggle??false);
    refreshUI();
  }

}