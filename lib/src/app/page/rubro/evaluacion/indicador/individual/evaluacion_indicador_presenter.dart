import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion.dart';

class EvaluacionIndicadorPresenter extends Presenter{
  GetRubroEvaluacion _getRubroEvaluacion;
  late Function getRubroEvaluacionOnError, getRubroEvaluacionOnNext;

  EvaluacionIndicadorPresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo):_getRubroEvaluacion = GetRubroEvaluacion(rubroRepo, configuracionRepo);

  void getRubroEvaluacion(String? rubroEvaluacionId, CursosUi? cursosUi ){
    _getRubroEvaluacion.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionParms(rubroEvaluacionId, cursosUi?.cargaCursoId));
  }

  @override
  void dispose() {
    _getRubroEvaluacion.dispose();
  }


}

class _GetRubroEvaluacionCase extends Observer<GetRubroEvaluacionResponse> {
  EvaluacionIndicadorPresenter presenter;

  _GetRubroEvaluacionCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getRubroEvaluacionOnError != null);
    presenter.getRubroEvaluacionOnError(e);
  }

  @override
  void onNext(GetRubroEvaluacionResponse? response) {
    assert(presenter.getRubroEvaluacionOnNext != null);
    presenter.getRubroEvaluacionOnNext(
        response?.rubricaEvaluacionUi, response?.alumnoCursoList);
  }

}