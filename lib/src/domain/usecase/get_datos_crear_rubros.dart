import 'dart:async';
import 'dart:convert';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetDatosCrearRubro extends UseCase<GetDatosCrearRubroResponse, GetDatosCrearRubroParams>{

  HttpDatosRepository httpDatosRepository;
  ConfiguracionRepository repository;
  RubroRepository rubroRepository;

  GetDatosCrearRubro(this.httpDatosRepository, this.repository, this.rubroRepository);

  @override
  Future<Stream<GetDatosCrearRubroResponse?>> buildUseCaseStream(GetDatosCrearRubroParams? params) async{
    final controller = StreamController<GetDatosCrearRubroResponse>();
    try{
      int _total = 0, _received = 0;
      String? _image;
      List<int> _bytes = [];

      int usuarioId = await repository.getSessionUsuarioId();
      int empleadoId = await repository.getSessionEmpleadoId();
      int anioAcademicoId = await repository.getSessionAnioAcademicoId();
      int programaEducativoId = await repository.getSessionProgramaEducativoId();
      String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();

      httpDatosRepository.getDatosParaCrearRubro(urlServidorLocal, anioAcademicoId, programaEducativoId, params?.calendarioPeriodoId??0, params?.cargaCursoId??0, empleadoId,
          onListen: (bytes, total) {
            _bytes.addAll(bytes);
            _total = total??0;
            _received += bytes.length;
            /* setState(() {
              _bytes.addAll(value);
              _received += value.length;
            });*/
            logger.severe('GetDatosCrearRubro online ' + _received.toString()+" "+_total.toString());
            controller.add(GetDatosCrearRubroResponse(false, false, true, _total, _received));
          },onSucces: (){
            Map<String,dynamic> body = json.decode(utf8.decode(_bytes));
            if(body.containsKey("Successful")&&body.containsKey("Value")&&body["Value"]!=null){

              rubroRepository.saveDatosCrearRubros(body["Value"], params?.silaboEventoId??0, params?.calendarioPeriodoId??0);
               controller.add(GetDatosCrearRubroResponse(false, false, false, _total, _received));
            }else{
               controller.add(GetDatosCrearRubroResponse(false, true, false, _total, _received));
            }
            logger.severe('GetDatosCrearRubro success');
            controller.close();
          },onError: (){
            logger.severe('GetDatosCrearRubro error');
            controller.add(GetDatosCrearRubroResponse(true, false, false, -_total, _received));
            controller.close();
          });

    } catch (e) {
    logger.severe('GetDatosCrearRubro unsuccessful: '+e.toString());
    controller.addError(e);
    }
    return controller.stream;

  }

}
class GetDatosCrearRubroParams{
  int calendarioPeriodoId;
  int cargaCursoId;
  int silaboEventoId;

  GetDatosCrearRubroParams(this.calendarioPeriodoId, this.cargaCursoId, this.silaboEventoId);

}
class GetDatosCrearRubroResponse{
  bool errorConexion;
  bool errorServidor;
  bool stream;
  int total;
  int recibido;

  GetDatosCrearRubroResponse(this.errorConexion, this.errorServidor,
      this.stream, this.total, this.recibido);
}

