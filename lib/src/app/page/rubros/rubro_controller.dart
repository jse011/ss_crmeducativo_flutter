import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class RubroController extends Controller{
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

  RubroController(this.cursosUi, calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo)
      :this.presenter = RubroPresenter(calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo)
        , super();

  @override
  void initListeners() {
      presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
        _calendarioPeriodoList = calendarioPeridoList??[];
        _calendarioPeriodoUI = calendarioPeriodoUI;
        print("getCalendarioPeridoOnComplete "+_calendarioPeriodoList.length.toString());
        refreshUI();
      };

      presenter.getCalendarioPeridoOnError = (e){
        _calendarioPeriodoList = [];
        _calendarioPeriodoUI = null;
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
    //showProgress();
    //presenter.getEvaluacion(calendarioPeriodoUi);
    refreshUI();
  }

  void onSyncronizarCurso() {
    if(!_contenedorSyncronizar){
      _contenedorSyncronizar = true;
      presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);
      refreshUI();
    }

  }

}