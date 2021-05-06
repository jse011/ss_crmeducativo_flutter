import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_forma_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota.dart';

class RubroCrearPresenter extends Presenter{

  GetFormaEvaluacion _getFormaEvaluacion;
  late Function getFormaEvaluacionOnNext, getFormaEvaluacionOnError;
  GetTipoEvaluacion _getTipoEvaluacion;
  late Function getTipoEvaluacionOnNext, getTipoEvaluacionOnError;
  GetTipoNota _getTipoNota;
  late Function getTipoNotaOnNext, getTipoNotaOnError;

  RubroCrearPresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo):
      _getFormaEvaluacion = new GetFormaEvaluacion(rubroRepo),
      _getTipoEvaluacion = new GetTipoEvaluacion(rubroRepo),
      _getTipoNota = new GetTipoNota(configuracionRepo, rubroRepo),
        super();

  getFormaEvaluacion(){
    _getFormaEvaluacion.execute(_GetFormaEvaluacionCase(this), GetFormaEvaluacionParams());
  }

  @override
  void dispose() {
   _getFormaEvaluacion.dispose();
   _getTipoEvaluacion.dispose();
   _getTipoNota.dispose();
  }

  void getTipoEvaluacion() {
    _getTipoEvaluacion.execute(_GetTipoEvaluacionCase(this), GetTipoEvaluacionParms());
  }

  void getTipoNota() {
    _getTipoNota.execute(_GetTipoNotaCase(this), GetTipoNotaParms());
  }


}

class _GetFormaEvaluacionCase extends Observer<GetFormaEvaluacionResponse>{
  RubroCrearPresenter presenter;

  _GetFormaEvaluacionCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getFormaEvaluacionOnError!=null);
    presenter.getFormaEvaluacionOnError(e);
  }

  @override
  void onNext(GetFormaEvaluacionResponse? response) {
    assert(presenter.getFormaEvaluacionOnNext!=null);
    presenter.getFormaEvaluacionOnNext(response?.formaEvaluacionUiList, response?.formaEvaluacionUi);
  }

}

class _GetTipoEvaluacionCase extends Observer<GetTipoEvaluacionResponse> {
  RubroCrearPresenter presenter;

  _GetTipoEvaluacionCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getTipoEvaluacionOnError != null);
    presenter.getTipoEvaluacionOnError(e);
  }

  @override
  void onNext(GetTipoEvaluacionResponse? response) {
    assert(presenter.getTipoEvaluacionOnNext != null);
    presenter.getTipoEvaluacionOnNext(
        response?.tipoEvaluacionUiList, response?.tipoEvaluacionUi);
  }

}

class _GetTipoNotaCase extends Observer<GetTipoNotaResponse>{
  RubroCrearPresenter presenter;

  _GetTipoNotaCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getTipoNotaOnError!=null);
    presenter.getTipoNotaOnError(e);
  }

  @override
  void onNext(GetTipoNotaResponse? response) {
    assert(presenter.getTipoNotaOnNext!=null);
    presenter.getTipoNotaOnNext(response?.tipoNotaUiList, response?.tipoEvaluacionUi);
  }

}