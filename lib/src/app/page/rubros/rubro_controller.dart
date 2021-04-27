import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class RubroController extends Controller{
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  RubroPresenter presenter;

  RubroController(this.cursosUi, calendarioPeriodoRepo, configuracionRepo)
      :this.presenter = RubroPresenter(calendarioPeriodoRepo, configuracionRepo)
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

}