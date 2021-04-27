import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetCalendarioPerido extends UseCase<GetCalendarioPeridoResponse, GetCalendarioPeridoParams>{
  ConfiguracionRepository configuracionRepository;
  CalendarioPeriodoRepository repository;


  GetCalendarioPerido(this.configuracionRepository, this.repository);

  @override
  Future<Stream<GetCalendarioPeridoResponse?>> buildUseCaseStream(GetCalendarioPeridoParams? params) async{
    final controller = StreamController<GetCalendarioPeridoResponse>();
    try {
      int programaEducativoId = await configuracionRepository.getSessionProgramaEducativoId();
      int anioAcademicoId = await configuracionRepository.getSessionAnioAcademicoId();

      CalendarioPeriodoUI? calendarioPeriodoUI = null;
      final List<CalendarioPeriodoUI> calendarioPeriodoList = await repository.getCalendarioPerios(programaEducativoId, params?.cargaCursoId??0, anioAcademicoId);

      for(CalendarioPeriodoUI item in calendarioPeriodoList){
          if(item.selected??false){
              calendarioPeriodoUI = item;
          }
      }

      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      controller.add(GetCalendarioPeridoResponse(calendarioPeriodoList, calendarioPeriodoUI));
      logger.finest('GetCalendarioPeridoResponse successful. ');
      controller.close();
    } catch (e) {
      logger.severe('GetCalendarioPeridoResponse unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }

}
class GetCalendarioPeridoResponse{
  List<CalendarioPeriodoUI> calendarioPeriodoList;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  GetCalendarioPeridoResponse(
      this.calendarioPeriodoList, this.calendarioPeriodoUI);
}
class GetCalendarioPeridoParams{
  int cargaCursoId;

  GetCalendarioPeridoParams(this.cargaCursoId);
}