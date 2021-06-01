import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
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

          }

        refreshUI();
      };

      presenter.getDatosCrearRubroOnError = (e){

      };

      presenter.getRubroEvaluacionOnNext = (List<RubricaEvaluacionUi> rubricaEvalUiList){
        _rubricaEvaluacionUiList = rubricaEvalUiList;
        refreshUI();
      };

      presenter.getRubroEvaluacionOnError = (e){
        _rubricaEvaluacionUiList = [];
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

}