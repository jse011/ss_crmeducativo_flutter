import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/response/respuesta_crear_rubro.dart';

class RubroController extends Controller{
  OrigenRubroUi _origenRubroUi = OrigenRubroUi.TODOS;
  OrigenRubroUi get origenRubroUi => _origenRubroUi;
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  bool _contenedorSyncronizar = false;
  bool get contenedorSyncronizar => _contenedorSyncronizar;
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  RubroPresenter presenter;
  int _progresoSyncronizar = 0;
  int get progresoSyncronizar => _progresoSyncronizar;
  List<RubricaEvaluacionUi> _rubricaEvaluacionUiList = [];
  List<RubricaEvaluacionUi> get rubricaEvaluacionUiList => _rubricaEvaluacionUiList;
  List<UnidadUi> _unidadUiList = [];
  List<UnidadUi> get unidadUiList => _unidadUiList;
  String? _msgToast = null;
  String? get msgToast => _msgToast;
  bool _progress = false;
  bool get progress => _progress;
  List<dynamic> _columnList2 = [];
  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];
  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];
  List<List<dynamic>> get cellListList => _cellListList;

  RubroController(this.cursosUi, calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo)
      :this.presenter = RubroPresenter(calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo)
        , super();

  @override
  void initListeners() {
      presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
        _calendarioPeriodoList = calendarioPeridoList??[];
        _calendarioPeriodoUI = calendarioPeriodoUI;
        _origenRubroUi = OrigenRubroUi.TODOS;
        presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
        presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
        presenter.onGetAlumnoCurso(cursosUi);
      };

      presenter.getCalendarioPeridoOnError = (e){
        _calendarioPeriodoList = [];
        _calendarioPeriodoUI = null;
        _origenRubroUi = OrigenRubroUi.TODOS;
        refreshUI();
      };

      presenter.getDatosCrearRubroOnNext = (bool? errorConexion, bool? errorServidor, bool? stream, int? total, int? recibido){
        _contenedorSyncronizar = (stream??false);
        int progreso = (((recibido??0)/(total??1))*100).toInt();

        _progresoSyncronizar = progreso>100?100:progreso;

        if(stream??false){

        }else{
          presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
          presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
          presenter.onGetAlumnoCurso(cursosUi);
          _progress = true;
          _progresoSyncronizar = 0;
          _msgToast = (errorServidor??false)? "!Oops! Al parecer ocurrió un error involuntario.":null;
          _msgToast = (errorConexion??false)? "No hay Conexión a Internet...":null;
        }

        refreshUI();
      };

      presenter.getDatosCrearRubroOnError = (e){
        _progresoSyncronizar = 0;
      };

      presenter.getRubroEvaluacionOnNext = (List<RubricaEvaluacionUi> rubricaEvalUiList){
        _rubricaEvaluacionUiList = rubricaEvalUiList;
        _progress = false;
        refreshUI();
      };

      presenter.getRubroEvaluacionOnError = (e){
        _rubricaEvaluacionUiList = [];
        _progress = false;
        refreshUI();
      };

      presenter.getUnidadRubroEvalOnNext = (List<UnidadUi> unidadUiList){
        _unidadUiList = unidadUiList;
        refreshUI();
      };

      presenter.getUnidadRubroEvalOnError = (e){
        _unidadUiList = [];
        refreshUI();
      };

      presenter.getAlumnoCursoOnNext = (List<ContactoUi> contactoUiList){
        _rowList2.clear();
        _rowList2.addAll(contactoUiList);
        _rowList2.add("");//Espacio
        _rowList2.add("");//Espacio
        _rowList2.add("");//Espacio

        presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
      };

      presenter.getAlumnoCursoOnError = (e){
        _rowList2 = [];
        _columnList2.clear();
        _cellListList.clear();
        refreshUI();
      };

      presenter.getCompetenciaRubroEvalOnNext = (List<CompetenciaUi> competenciaUiList){
        _cellListList.clear();
        _columnList2.clear();
        _columnList2.add(ContactoUi());//Titulo alumno

        //Competencia Base
        for(CompetenciaUi competenciaUi in competenciaUiList){
          if(competenciaUi.tipoCompetenciaUi == TipoCompetenciaUi.BASE){
            _columnList2.addAll(competenciaUi.capacidadUiList??[]);
            _columnList2.add(competenciaUi);
          }
        }
        //Competencia Base

        _columnList2.add(calendarioPeriodoUI);

        //Competencia Enfoque Transversal
        for(CompetenciaUi competenciaUi in competenciaUiList){
          if(competenciaUi.tipoCompetenciaUi != TipoCompetenciaUi.BASE){
            _columnList2.addAll(competenciaUi.capacidadUiList??[]);
            _columnList2.add(competenciaUi);
          }
        }
        //Competencia Enfoque Transversal

        _columnList2.add("");// espacio

        for(dynamic column in _rowList2){
            List<dynamic>  cellList = [];
            cellList.add(column);

            //Competencia Base
            for(CompetenciaUi competenciaUi in competenciaUiList){
              if(competenciaUi.tipoCompetenciaUi == TipoCompetenciaUi.BASE){
                for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
                  if(column is String){//si el row is un espacio
                    cellList.add("");// espacio
                  }else{
                    cellList.add(EvaluacionCapacidadUi());
                  }
                }
                if(column is String){//si el row is un espacio
                  cellList.add("");// espacio
                }else{
                  cellList.add(EvaluacionCompetenciaUi());
                }
              }
            }
            //Competencia Base
            //Nota Final
            if(column is String){//si el row is un espacio
              cellList.add("");// espacio
            }else{
              EvaluacionCalendarioPeriodoUi evaluacionCalendarioPeriodoUi = EvaluacionCalendarioPeriodoUi();
              evaluacionCalendarioPeriodoUi.calendarioPeriodoUI = calendarioPeriodoUI;
              cellList.add(evaluacionCalendarioPeriodoUi);
            }
            //Nota Final
            //Competencia Enfoque y Transversal
            for(CompetenciaUi competenciaUi in competenciaUiList){
              if(competenciaUi.tipoCompetenciaUi != TipoCompetenciaUi.BASE){
                for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
                  if(column is String){//si el row is un espacio
                    cellList.add("");// espacio
                  }else{
                    cellList.add(EvaluacionCapacidadUi());
                  }

                }
                if(column is String){//si el row is un espacio
                  cellList.add("");// espacio
                }else{
                  cellList.add(EvaluacionCompetenciaUi());
                }
              }
            }
            //Competencia Enfoque y Transversal


            cellList.add("");// espacio
            _cellListList.add(cellList);
        }


        refreshUI();
      };

      presenter.getAlumnoCursoOnError = (e){
        _cellListList.clear();
        _columnList2.clear();
        refreshUI();
      };

  }


  @override
  void onInitState() {
    presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    _origenRubroUi = OrigenRubroUi.TODOS;
    //showProgress();
    //presenter.getEvaluacion(calendarioPeriodoUi);
    refreshUI();
    presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
    presenter.onGetAlumnoCurso(cursosUi);
  }

  void onSyncronizarCurso() {
    if(!_contenedorSyncronizar){
      _contenedorSyncronizar = true;
      presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);
      refreshUI();
    }

  }

  void respuestaFormularioCrearRubro(RespuestaCrearRubro? response) {
    if(response!=null){
        switch(response){
          case RespuestaCrearRubro.CERRAR_ENVIO_TERMINADO:
            presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, null);
            break;
          case RespuestaCrearRubro.CERRAR_ENVIO_MAS_TARDE:
            presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, null);
            break;
          case RespuestaCrearRubro.CERRAR_ENVIO_ERROR:
            presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, null);
            break;
          case RespuestaCrearRubro.CERRAR_NO_CAMBIO:

            break;
        }
    }else{

    }
  }

  void clicMostrarSolo(OrigenRubroUi origenRubroUi) {
    _origenRubroUi = origenRubroUi;
    presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    refreshUI();
  }

  void successMsg() {
    _msgToast = null;
  }

}