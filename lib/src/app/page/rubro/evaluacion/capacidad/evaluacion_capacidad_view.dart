import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_controller.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';

class EvaluacionCapacidadView extends View{
  EvaluacionCapacidadUi evaluacionCapacidadUi;
  CursosUi cursosUi;

  EvaluacionCapacidadView(this.evaluacionCapacidadUi, this.cursosUi);

  @override
  _EvaluacionCapacidadViewState createState() => _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi);

}

class _EvaluacionCapacidadViewState extends ViewState<EvaluacionCapacidadView, EvaluacionCapacidadController>{
  _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi) : super(EvaluacionCapacidadController());

  @override
  Widget get view => Container();

}