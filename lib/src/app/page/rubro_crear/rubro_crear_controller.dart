import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_ui.dart';

class RubroCrearController extends Controller{
  CursosUi cursosUi;
  RubroUi? rubroUi;
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  String? _mensaje = null;
  String? get mensaje => _mensaje;


  RubroCrearController(this.cursosUi, this.rubroUi);

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

  void successMsg() {
    _mensaje = null;
  }

  void onSave() {

  }

}