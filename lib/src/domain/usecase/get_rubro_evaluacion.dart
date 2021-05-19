import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetRubroEvaluacion extends UseCase<GetRubroEvaluacionResponse, GetRubroEvaluacionParms>{

  RubroRepository repository;

  GetRubroEvaluacion(this.repository);

  @override
  Future<Stream<GetRubroEvaluacionResponse?>> buildUseCaseStream(GetRubroEvaluacionParms? params) async{
    final controller = StreamController<GetRubroEvaluacionResponse>();
    try{

      controller.add(GetRubroEvaluacionResponse(await repository.getRubroEvaluacion(params?.calendarioPeriodoId??0, params?.silaboEventoId??0, params?.origenRubroUi??OrigenRubroUi.TODOS)));
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
    OrigenRubroUi? origenRubroUi;

    GetRubroEvaluacionParms(this.calendarioPeriodoId, this.silaboEventoId, this.origenRubroUi);
}

class GetRubroEvaluacionResponse{
  List<RubricaEvaluacionUi> rubricaEvaluacionList;

  GetRubroEvaluacionResponse(this.rubricaEvaluacionList);
}