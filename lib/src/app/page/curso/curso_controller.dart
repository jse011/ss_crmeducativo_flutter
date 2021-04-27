import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_acemico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class CursoController extends Controller{
  CursoPresenter cursoPresenter;
  CursosUi? _cursosUi = null;
  CursosUi? get cursos => _cursosUi;

  CursoController(cursosUi,configuracionRepo):this._cursosUi = cursosUi, this.cursoPresenter = CursoPresenter(configuracionRepo);

  @override
  void initListeners() {
    cursoPresenter.getCursoOnComplete = (CursosUi cursosUi){
      _cursosUi = cursos;
      refreshUI();
    };
    cursoPresenter.getCursoOnError = (e){
      _cursosUi = null;
      refreshUI();
    };
  }

  @override
  void onInitState() {
    super.onInitState();
  }

}