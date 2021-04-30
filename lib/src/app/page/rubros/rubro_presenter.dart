import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_datos_crear_rubros.dart';

class RubroPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  GetDatosCrearRubro _getDatosCrearRubro;
  late Function getDatosCrearRubroOnNext, getDatosCrearRubroOnError;

  RubroPresenter(CalendarioPeriodoRepository calendarioPeriodoRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, RubroRepository rubroRepo) :
                          _getCalendarioPerido = new GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
                          _getDatosCrearRubro = new GetDatosCrearRubro(httpDatosRepo, configuracionRepo, rubroRepo);

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }


  @override
  void dispose() {
      _getCalendarioPerido.dispose();
      _getDatosCrearRubro.dispose();
  }

  void onActualizarCurso(CalendarioPeriodoUI? calendarioPeriodoUI, CursosUi cursosUi) {
    _getDatosCrearRubro.execute(_GetDatosCrearRubroCase(this), new GetDatosCrearRubroParams(calendarioPeriodoUI?.id??0, cursosUi.cargaCursoId??0, cursosUi.silaboEventoId??0));
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  RubroPresenter presenter;

  _GetCalendarioPeriodoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getCalendarioPeridoOnError!=null);
    presenter.getCalendarioPeridoOnError(e);
  }

  @override
  void onNext(GetCalendarioPeridoResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.getCalendarioPeridoOnComplete!=null);
    presenter.getCalendarioPeridoOnComplete(response?.calendarioPeriodoList, response?.calendarioPeriodoUI);
  }

}

class _GetDatosCrearRubroCase extends Observer<GetDatosCrearRubroResponse>{
  RubroPresenter presenter;

  _GetDatosCrearRubroCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getDatosCrearRubroOnError!=null);
    presenter.getDatosCrearRubroOnError(e);
  }

  @override
  void onNext(GetDatosCrearRubroResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.getDatosCrearRubroOnNext!=null);
    presenter.getDatosCrearRubroOnNext(response?.errorConexion, response?.errorServidor, response?.stream, response?.total, response?.recibido);
  }

}