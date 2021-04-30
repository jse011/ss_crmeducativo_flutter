import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_ui.dart';
import 'dart:math';

import 'package:ss_crmeducativo_2/src/domain/entities/tipos_ui.dart';

class RubroCrearController extends Controller{
  CursosUi cursosUi;
  RubroUi? rubroUi;
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  String? _mensaje = null;
  String? get mensaje => _mensaje;
  String?  _tituloRubrica = null;
  String? get tituloRubrica => _tituloRubrica;
  TiposUi formaEvaluacionUi = TiposUi(id: 1, nombre: "Individual");
  List<TiposUi> formaEvaluacionUiList = [];

  RubroCrearController(this.cursosUi, this.rubroUi);

  @override
  void initListeners() {
    formaEvaluacionUiList.add(formaEvaluacionUi);
    formaEvaluacionUiList.add(TiposUi(id: 1, nombre: "Grupal"));

  }

  void successMsg() {
    _mensaje = null;
  }

  void onSave() {

  }

  void clearTitulo() {
    _tituloRubrica = null;
    refreshUI();

  }

  void changeTituloRubrica(String str) {
    _tituloRubrica = str;
    refreshUI();
  }



}