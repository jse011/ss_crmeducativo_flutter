import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class SaveRubroEvaluacion extends UseCase<SaveRubroEvaluacionResponse, SaveRubroEvaluacionParams>{
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;

  SaveRubroEvaluacion(this.repository, this.configuracionRepository);

  @override
  Future<Stream<SaveRubroEvaluacionResponse?>> buildUseCaseStream(SaveRubroEvaluacionParams? params) async{
    final controller = StreamController<SaveRubroEvaluacionResponse>();
    try{

      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      repository.saveRubroEvaluacion(params?.rubroEvaluacionId, params?.titulo, params?.formaEvaluacionId, params?.tipoEvaluacionId, params?.promedioLogroId,
                                          params?.calendarioPeriodoId ,params?.silaboEventoId, params?.sesionAprendizajeId, params?.tareaId,
                                              usuarioId, params?.criterioPesoUiList, params?.criterioValorTipoNotaUiList);
      controller.add(SaveRubroEvaluacionResponse());
      controller.close();
    } catch (e) {
      logger.severe('GetTipoNota unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

}
class SaveRubroEvaluacionResponse {

}
class SaveRubroEvaluacionParams {
  String? rubroEvaluacionId;
  String? titulo;
  int? formaEvaluacionId;
  int? tipoEvaluacionId;
  String? promedioLogroId;
  int? calendarioPeriodoId;
  int? silaboEventoId;
  int? sesionAprendizajeId;
  String? tareaId;
  List<CriterioPesoUi>? criterioPesoUiList;
  List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList;

  SaveRubroEvaluacionParams(
      this.rubroEvaluacionId,
      this.titulo,
      this.formaEvaluacionId,
      this.tipoEvaluacionId,
      this.promedioLogroId,
      this.calendarioPeriodoId,
      this.silaboEventoId,
      this.sesionAprendizajeId,
      this.tareaId,
      this.criterioPesoUiList,
      this.criterioValorTipoNotaUiList);
}