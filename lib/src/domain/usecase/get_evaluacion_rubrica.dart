import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetEvaluacion extends UseCase<GetEvaluacionResponse, GetEvaluacionParams>{
  RubroRepository repository;

  GetEvaluacion(this.repository);

  @override
  Future<Stream<GetEvaluacionResponse?>> buildUseCaseStream(GetEvaluacionParams? params) async {
    final controller = StreamController<GetEvaluacionResponse>();
    try{
      controller.add(GetEvaluacionResponse(await repository.getEvaluacionRubrica(params?.rubroEvaluacionId)));
      controller.close();
    } catch (e) {
      logger.severe('GetTemaCriterios unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

}

class GetEvaluacionParams{
  String? rubroEvaluacionId;

  GetEvaluacionParams(this.rubroEvaluacionId);
}

class GetEvaluacionResponse{
  RubricaEvaluacionUi rubricaEvaluacionUi;

  GetEvaluacionResponse(this.rubricaEvaluacionUi);
}