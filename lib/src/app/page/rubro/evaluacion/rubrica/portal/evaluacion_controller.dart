import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/rubrica/portal/evaluacion_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class EvaluacionController extends Controller{
  RubricaEvaluacionUi rubricaEvaluacionUi;
  CursosUi cursosUi;
  EvaluacionPresenter presenter;


  EvaluacionController(this.rubricaEvaluacionUi, this.cursosUi, RubroRepository rubroRepo):
      presenter = EvaluacionPresenter();

  @override
  void initListeners() {

  }

  @override
  void onInitState() {
    super.onInitState();

  }


}