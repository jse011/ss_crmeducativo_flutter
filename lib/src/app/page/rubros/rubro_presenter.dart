import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_datos_crear_rubros.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_unidad_rubro_eval.dart';

class RubroPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  GetDatosCrearRubro _getDatosCrearRubro;
  late Function getDatosCrearRubroOnNext, getDatosCrearRubroOnError;
  GetRubroEvaluacion _getRubroEvaluacion;
  late Function getRubroEvaluacionOnNext, getRubroEvaluacionOnError;

  GetUnidadRubroEval _getUnidadRubroEval;
  late Function getUnidadRubroEvalOnNext, getUnidadRubroEvalOnError;

  RubroPresenter(CalendarioPeriodoRepository calendarioPeriodoRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, RubroRepository rubroRepo) :
                          _getCalendarioPerido = new GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
                          _getDatosCrearRubro = new GetDatosCrearRubro(httpDatosRepo, configuracionRepo, rubroRepo),
                          _getRubroEvaluacion = GetRubroEvaluacion(rubroRepo),
                          _getUnidadRubroEval = GetUnidadRubroEval(rubroRepo);

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }


  @override
  void dispose() {
      _getCalendarioPerido.dispose();
      _getDatosCrearRubro.dispose();
      _getRubroEvaluacion.dispose();
      _getUnidadRubroEval.dispose();
  }

  void onActualizarCurso(CalendarioPeriodoUI? calendarioPeriodoUI, CursosUi cursosUi) {
    _getDatosCrearRubro.execute(_GetDatosCrearRubroCase(this), new GetDatosCrearRubroParams(calendarioPeriodoUI?.id??0, cursosUi.cargaCursoId??0, cursosUi.silaboEventoId??0));
  }

  void onGetRubricaList(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, OrigenRubroUi? origenRubroUi){
    _getRubroEvaluacion.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionParms(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId, origenRubroUi));
  }

  void onGetUnidadRubroEval(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getUnidadRubroEval.execute(_GetUnidadRubroEvalCase(this), GetUnidadRubroEvalParams(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
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
    assert(presenter.getDatosCrearRubroOnNext!=null);
    presenter.getDatosCrearRubroOnNext(response?.errorConexion, response?.errorServidor, response?.stream, response?.total, response?.recibido);
  }

}

class _GetRubroEvaluacionCase extends Observer<GetRubroEvaluacionResponse>{
  RubroPresenter presenter;

  _GetRubroEvaluacionCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getRubroEvaluacionOnError!=null);
    presenter.getRubroEvaluacionOnError(e);
  }

  @override
  void onNext(GetRubroEvaluacionResponse? response) {
    assert(presenter.getRubroEvaluacionOnNext!=null);
    presenter.getRubroEvaluacionOnNext(response?.rubricaEvaluacionList);
  }

}

class _GetUnidadRubroEvalCase extends Observer<GetUnidadRubroEvalResponse>{
  RubroPresenter presenter;

  _GetUnidadRubroEvalCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getUnidadRubroEvalOnError!=null);
    presenter.getUnidadRubroEvalOnError(e);
  }

  @override
  void onNext(GetUnidadRubroEvalResponse? response) {
    assert(presenter.getUnidadRubroEvalOnNext!=null);
    presenter.getUnidadRubroEvalOnNext(response?.unidadUiList);
  }

}