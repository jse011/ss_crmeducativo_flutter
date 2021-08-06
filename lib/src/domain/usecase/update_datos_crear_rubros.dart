import 'dart:async';
import 'dart:convert';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdateDatosCrearRubro extends UseCase<UpdateDatosCrearRubroResponse, UpdateDatosCrearRubroParams>{

  HttpDatosRepository httpDatosRepository;
  ConfiguracionRepository repository;
  RubroRepository rubroRepository;

  UpdateDatosCrearRubro(this.httpDatosRepository, this.repository, this.rubroRepository);

  @override
  Future<Stream<UpdateDatosCrearRubroResponse?>> buildUseCaseStream(UpdateDatosCrearRubroParams? params) async{
    final controller = StreamController<UpdateDatosCrearRubroResponse>();
    try{

      bool update = await rubroRepository.isUltimedUpdateServerCurso(params?.calendarioPeriodoId, params?.silaboEventoId);

      if(!update || (params?.forceUpdate??false)){

        int _total = 0, _received = 0;
        String? _image;
        List<int> _bytes = [];

        int usuarioId = await repository.getSessionUsuarioId();
        int empleadoId = await repository.getSessionEmpleadoId();
        int anioAcademicoId = await repository.getSessionAnioAcademicoId();
        int programaEducativoId = await repository.getSessionProgramaEducativoId();
        String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();


        httpDatosRepository.updateDatosParaCrearRubro(urlServidorLocal, anioAcademicoId, programaEducativoId, params?.calendarioPeriodoId??0, params?.cargaCursoId??0, empleadoId,
            onListen: (bytes, total) {
              _bytes.addAll(bytes);
              _total = total??0;
              _received += bytes.length;
              /* setState(() {
              _bytes.addAll(value);
              _received += value.length;
            });*/

              controller.add(UpdateDatosCrearRubroResponse(false, false, true, _total, _received));
            },onSucces: (){
              Map<String,dynamic> body = json.decode(utf8.decode(_bytes));
              if(body.containsKey("Successful")&&body.containsKey("Value")&&body["Value"]!=null){

                rubroRepository.saveDatosCrearRubros(body["Value"], params?.silaboEventoId??0, params?.calendarioPeriodoId??0);
                rubroRepository.saveUpdateServerCurso(params?.calendarioPeriodoId, params?.silaboEventoId);
                controller.add(UpdateDatosCrearRubroResponse(false, false, false, _total, _received));
              }else{
                controller.add(UpdateDatosCrearRubroResponse(false, true, false, _total, _received));
              }

              controller.close();
            },onError: (){
              logger.severe('UpdateDatosCrearRubro error');
              controller.add(UpdateDatosCrearRubroResponse(true, false, false, -_total, _received));
              controller.close();
            });

      }else{
        controller.add(UpdateDatosCrearRubroResponse(false, false, false, 100, 100));//Sucess
        controller.close();
      }

    } catch (e) {
    logger.severe('UpdateDatosCrearRubro unsuccessful: '+e.toString());
    controller.addError(e);
    }
    return controller.stream;

  }

}
class UpdateDatosCrearRubroParams{
  int calendarioPeriodoId;
  int cargaCursoId;
  int silaboEventoId;
  bool forceUpdate;

  UpdateDatosCrearRubroParams(this.calendarioPeriodoId, this.cargaCursoId, this.silaboEventoId, this.forceUpdate);

}
class UpdateDatosCrearRubroResponse{
  bool errorConexion;
  bool errorServidor;
  bool stream;
  int total;
  int recibido;

  UpdateDatosCrearRubroResponse(this.errorConexion, this.errorServidor,
      this.stream, this.total, this.recibido);
}

