import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetCompetenciaRubroEval extends UseCase<GetCompetenciaRubroResponse, GetCompetenciaRubroParams>{
  RubroRepository repository;

  GetCompetenciaRubroEval(this.repository);

  @override
  Future<Stream<GetCompetenciaRubroResponse?>> buildUseCaseStream(GetCompetenciaRubroParams? params) async{
    final controller = StreamController<GetCompetenciaRubroResponse>();
    try{
      controller.add(GetCompetenciaRubroResponse(await repository.getRubroCompetencia(params?.silaboEventoId, params?.calendarioPeriodoId, params?.cargaCursoId)));
      controller.close();
    } catch (e) {
      logger.severe('GetUnidadRubroEval unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

}

class GetCompetenciaRubroResponse {
  List<CompetenciaUi> competenciaUiList;

  GetCompetenciaRubroResponse(this.competenciaUiList);
}

class GetCompetenciaRubroParams {
  int? calendarioPeriodoId;
  int? silaboEventoId;
  int? cargaCursoId;

  GetCompetenciaRubroParams(this.calendarioPeriodoId, this.silaboEventoId, this.cargaCursoId);
}