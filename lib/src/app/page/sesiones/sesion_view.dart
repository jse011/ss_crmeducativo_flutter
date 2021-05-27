import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class SesionView extends View{
  CursosUi cursosUi;
  SesionView(this.cursosUi);

  @override
  _CursoViewState createState() => _CursoViewState(cursosUi);

}

class _CursoViewState extends ViewState<SesionView, SesionController> with TickerProviderStateMixin{

  _CursoViewState(cursoUi) : super(SesionController(cursoUi));

  @override
  Widget get view => Container();

}