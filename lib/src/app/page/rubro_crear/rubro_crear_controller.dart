import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro_crear/rubro_crear_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'dart:math';

import 'package:ss_crmeducativo_2/src/domain/entities/tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class RubroCrearController extends Controller{

  RubroCrearPresenter presenter;

  CursosUi cursosUi;
  RubroUi? rubroUi;
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  String? _mensaje = null;
  String? get mensaje => _mensaje;
  String?  _tituloRubrica = null;
  String? get tituloRubrica => _tituloRubrica;
  FormaEvaluacionUi? _formaEvaluacionUi = null;
  FormaEvaluacionUi? get formaEvaluacionUi => _formaEvaluacionUi;
  List<FormaEvaluacionUi> _formaEvaluacionUiList = [];
  List<FormaEvaluacionUi> get formaEvaluacionUiList => _formaEvaluacionUiList;
  TipoEvaluacionUi? _tipoEvaluacionUi = null;
  TipoEvaluacionUi? get tipoEvaluacionUi => _tipoEvaluacionUi;
  List<TipoEvaluacionUi> _tipoEvaluacionUiList = [];
  List<TipoEvaluacionUi> get tipoEvaluacionUiList => _tipoEvaluacionUiList;

  TipoNotaUi? _tipoNotaUi = null;
  TipoNotaUi? get tipoNotaUi => _tipoNotaUi;
  List<TipoNotaUi> _tipoNotaUiList = [];
  List<TipoNotaUi> get tipoNotaUiList => _tipoNotaUiList;

  List<CriterioUi> _criterioUiList = [];
  List<CriterioUi> get criterioUiList => _criterioUiList;

  List<dynamic> _tableTipoNotaColumns = [];
  List<dynamic> get tableTipoNotaColumns => _tableTipoNotaColumns;
  List<List<dynamic>> _tableTipoNotaCells = [];
  List<List<dynamic>> get tableTipoNotaCells => _tableTipoNotaCells;
  List<double> _tableTipoNotacolumnWidths = [];
  List<double> get tableTipoNotacolumnWidths => _tableTipoNotacolumnWidths;



  RubroCrearController(this.cursosUi, this.rubroUi, rubroRepo, usuarioRepo): presenter = new RubroCrearPresenter(rubroRepo,usuarioRepo);

  @override
  void initListeners() {
    presenter.getFormaEvaluacionOnNext = (List<FormaEvaluacionUi> formaEvaluacionUiList, FormaEvaluacionUi? formaEvaluacionUi){
      _formaEvaluacionUiList = formaEvaluacionUiList;
      _formaEvaluacionUi = formaEvaluacionUi;
      //refreshUI();
    };

    presenter.getFormaEvaluacionOnError = (e){
      _formaEvaluacionUiList = [];
      _formaEvaluacionUi = null;
      refreshUI();
    };
    presenter.getTipoEvaluacionOnNext = (List<TipoEvaluacionUi> tipoEvaluacionUiList, TipoEvaluacionUi? tipoEvaluacionUi){
      _tipoEvaluacionUiList = tipoEvaluacionUiList;
      _tipoEvaluacionUi = tipoEvaluacionUi;
      //refreshUI();
    };

    presenter.getFormaEvaluacionOnError = (e){
      _tipoEvaluacionUiList = [];
      _tipoEvaluacionUi = null;
      refreshUI();
    };

    presenter.getTipoNotaOnNext = (List<TipoNotaUi> tipoNotaUiList, TipoNotaUi? tipoNotaUi){
      _tipoNotaUiList = tipoNotaUiList;
      _tipoNotaUi = tipoNotaUi;
      iniciarTablaTipoNota();
      refreshUI();
    };

    presenter.getTipoNotaOnError = (e){
      _tipoNotaUiList = [];
      _tipoNotaUi = null;
      iniciarTablaTipoNota();
      refreshUI();
    };

  }


  void iniciarTablaTipoNota(){

    _tableTipoNotaColumns.clear();
    _tableTipoNotacolumnWidths.clear();
    _tableTipoNotaCells.clear();

    if(_tipoNotaUi!=null){

      _tableTipoNotaColumns.add("Criterios");
      _tableTipoNotacolumnWidths.add(120.0);


      for (ValorTipoNotaUi valorTipoNotaUi in _tipoNotaUi?.valorTipoNotaList??[]) {
        _tableTipoNotaColumns.add(valorTipoNotaUi);
        _tableTipoNotacolumnWidths.add(50.0);
      }
      _tableTipoNotaColumns.add(true);
      _tableTipoNotacolumnWidths.add(45.0);

      List<List<dynamic>> output = [];
      for (CriterioUi criterioUi in _criterioUiList) {
        final List<dynamic> row = [];
        row.add(criterioUi);
        for (int i = 0; i < ( _tipoNotaUi?.valorTipoNotaList??[]).length; i++) {
          row.add(CriterioValorTipoNotaUi());
        }
        row.add(CriterioPesoUi());
        output.add(row);
      }

      _tableTipoNotaCells = output;

    }

  }

  @override
  void onInitState() {
    presenter.getFormaEvaluacion();
    presenter.getTipoEvaluacion();
    presenter.getTipoNota();
    print("getFormaEvaluacion");
    super.onInitState();
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

  void onSelectFormaEvaluacion(item) {
    _formaEvaluacionUi = item;
    refreshUI();
  }

  void onSelectTipoEvaluacion(item) {
    _tipoEvaluacionUi = item;
    refreshUI();
  }

  void onSelectedTipoNota(TipoNotaUi tipoNotaUi) {
    _tipoNotaUi = tipoNotaUi;
    iniciarTablaTipoNota();
    refreshUI();
  }



}