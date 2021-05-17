import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetTemaCriterios extends UseCase<GetRubroEvaluacionResponse, GetRubroEvaluacionParms>{

  RubroRepository repository;

  GetTemaCriterios(this.repository);

  @override
  Future<Stream<GetRubroEvaluacionResponse?>> buildUseCaseStream(GetRubroEvaluacionParms? params) async{
    final controller = StreamController<GetRubroEvaluacionResponse>();
    try{
      List<CompetenciaUi> temaCriterioUiList = await repository.getRubroEvaluacion(params?.calendarioPeriodoId??0, params?.silaboEventoId??0);
      controller.add(GetRubroEvaluacionResponse(temaCriterioUiList));
      controller.close();
    } catch (e) {
      logger.severe('GetTemaCriterios unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class GetRubroEvaluacionParms{
    int? calendarioPeriodoId;
    int? silaboEventoId;

    GetRubroEvaluacionParms(this.calendarioPeriodoId, this.silaboEventoId);
}

class GetRubroEvaluacionResponse{
  List<CompetenciaUi> competenciaUiList;

  GetRubroEvaluacionResponse(this.competenciaUiList);
}