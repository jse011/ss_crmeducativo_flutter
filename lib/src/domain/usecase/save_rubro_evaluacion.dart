import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class SaveRubroEvaluacion extends UseCase<SaveRubroEvaluacionResponse, SaveRubroEvaluacionParms>{
  ConfiguracionRepository configuracionRepository;
  RubroRepository repository;

  SaveRubroEvaluacion(this.configuracionRepository, this.repository);

  @override
  Future<Stream<SaveRubroEvaluacionResponse?>> buildUseCaseStream(SaveRubroEvaluacionParms? params) async{
    final controller = StreamController<SaveRubroEvaluacionResponse>();
    try{
      int usuarioId = await configuracionRepository.getSessionUsuarioId();

      await repository.saveRubroEvaluacion(params?.rubroEvaluacionId, params?.titulo, params?.formaEvaluacionId, params?.tipoEvaluacionId, params?.promedioLogroId, params?.calendarioPeriodoId, params?.silaboEventoId, params?.cargaCursoId, params?.sesionAprendizajeId, params?.tareaId, usuarioId, params?.criterioPesoUiList, params?.criterioValorTipoNotaUiList, params?.tipoNotaUi);
      controller.add(SaveRubroEvaluacionResponse());
      controller.close();
    } catch (e) {
      logger.severe('GetTipoNota unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class SaveRubroEvaluacionParms{
  String? rubroEvaluacionId;
  String? titulo;
  int? formaEvaluacionId;
  int? tipoEvaluacionId;
  String? promedioLogroId;
  int? calendarioPeriodoId;
  int? silaboEventoId;
  int? cargaCursoId;
  int? sesionAprendizajeId;
  String? tareaId;
  List<CriterioPesoUi>? criterioPesoUiList;
  List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList;
  TipoNotaUi? tipoNotaUi;

  SaveRubroEvaluacionParms(this.rubroEvaluacionId, this.titulo,
      this.formaEvaluacionId, this.tipoEvaluacionId, this.promedioLogroId,
      this.calendarioPeriodoId, this.silaboEventoId, this.cargaCursoId,
      this.sesionAprendizajeId, this.tareaId, this.criterioPesoUiList,
      this.criterioValorTipoNotaUiList, this.tipoNotaUi);

}

class SaveRubroEvaluacionResponse{

}