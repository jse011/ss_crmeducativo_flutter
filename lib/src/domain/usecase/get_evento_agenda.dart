import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';

class GetEventoAgenda extends UseCase<GetEvaluacionCaseResponse, GetEventoAgendaParams>{
  ConfiguracionRepository  repository;
  HttpDatosRepository httpRepository;

  GetEventoAgenda(this.repository, this.httpRepository);

  @override
  Future<Stream<GetEvaluacionCaseResponse?>> buildUseCaseStream(GetEventoAgendaParams? params) async{
    final controller = StreamController<GetEvaluacionCaseResponse>();
    try {
      //printTime();
      List<TipoEventoUi> tiposUiList = await repository.getTiposEvento();
      for(TipoEventoUi tipoEventoUi in tiposUiList)tipoEventoUi.disable = false;
      controller.add(GetEvaluacionCaseResponse(tiposUiList, null, false, false));
      //printTime();
      print("EventoAgenda executeServidor init");
      int georeferenciaId =  await repository.getGeoreferenciaId();
      int usuarioId = await repository.getSessionUsuarioId();
       executeServidor() async{
        bool offlineServidor = false;
        bool errorServidor = false;
        try{
          String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();
          Map<String, dynamic>? eventoAgenda = await httpRepository.getEventoAgenda(urlServidorLocal, usuarioId,  georeferenciaId,  params?.tipoEventoId??0);
          errorServidor = eventoAgenda==null;
          if(!errorServidor){
            //printTime();
            await repository.saveEventoAgenda(eventoAgenda, usuarioId, georeferenciaId, params?.tipoEventoId??0);
            //printTime();
          }
        }catch(e){
          offlineServidor = true;
        }

        List<TipoEventoUi> tiposUiList = await repository.getTiposEvento();
        //printTime();
        for(TipoEventoUi tipoEventoUi in tiposUiList)tipoEventoUi.disable = false;
        List<EventoUi> eventoUIList = await repository.getEventosAgenda(usuarioId, georeferenciaId,params?.tipoEventoId??0);
        //printTime();

        for(var eventosUi in eventoUIList){
          DateTime fechaEntrega =  eventosUi.fecha??DateTime(1950);
          if(fechaEntrega.millisecondsSinceEpoch>912402000000){
            switch (eventosUi.tipoEventoUi?.tipo??EventoIconoEnumUI.EVENTO){
              case EventoIconoEnumUI.EVENTO:
                eventosUi.nombreFecha = AppTools.tiempoFechaCreacion(eventosUi.fecha);
                break;
              case EventoIconoEnumUI.NOTICIA:
                eventosUi.nombreFecha = AppTools.getFechaDiaMesAnho(eventosUi.fecha);
                break;
              default:
                eventosUi.nombreFecha = AppTools.tiempoFechaCreacion(eventosUi.fecha);
                break;
            }
          }else{
            eventosUi.nombreFecha = "";
          }
        }

        controller.add(GetEvaluacionCaseResponse(tiposUiList, eventoUIList, errorServidor, offlineServidor));
        controller.close();
      }

      executeServidor().catchError((e) {
        controller.addError(e);
        // Finally, callback fires.
        // throw Exception(e);              // Future completes with 42.
      }).timeout(const Duration (seconds:60),onTimeout : () {
        throw Exception("GetEventoAgenda timeout 60 seconds");
      });

    } catch (e) {
      logger.severe('EventoAgenda unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }

/*static void  printTime(){
    DateTime now = DateTime.now();
    print("GetEventoAgenda Hola Jse timer: " + now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString()+" "+ now.millisecond.toString());
  }*/

}

class GetEventoAgendaParams {
  int tipoEventoId;

  GetEventoAgendaParams(this.tipoEventoId);
}

class GetEvaluacionCaseResponse {
  List<TipoEventoUi> tipoEventoUiList;
  bool datosOffline;
  List<EventoUi>? eventoUiList;
  bool errorServidor;

  GetEvaluacionCaseResponse(this.tipoEventoUiList, this.eventoUiList, this.errorServidor, this.datosOffline);
}