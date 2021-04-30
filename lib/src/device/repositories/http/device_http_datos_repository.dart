import 'dart:convert';

import 'package:ss_crmeducativo_2/src/device/utils/http_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:http/http.dart' as http;

class DeviceHttpDatosRepositorio extends HttpDatosRepository{
  static const  TAG = "DeviceHttpDatosRepositorio";
  String getBody(String method, Object parameters){
    Map<String, dynamic> body = Map<String, dynamic>();
    body["interface"] = "RestAPI";
    body["method"] = method;
    body["parameters"] = parameters;
    String s = json.encode(body);
    print(TAG + " "+s);
    return s;
  }

  @override
  Future<Map<String, dynamic>> getDatosInicioDocente(String urlServidor, int usuarioId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    final response = await http.post(Uri.parse(urlServidor), body: getBody("flst_getDatosInicioSesion",parameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        throw Exception('Failed to load usuario 1');
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load usuario 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["UsuarioId"] = usuarioId;

    final response = await http.post(Uri.parse(urlServidor), body: getBody("fobj_ObtenerUsuario_By_Id",parameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){

        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni) async{

    Map<String, dynamic> obj_usuario = Map<String, dynamic>();
    obj_usuario["Opcion"] = opcion;
    obj_usuario["Usuario"] = usuario;
    obj_usuario["Passwordd"] = password;
    obj_usuario["Correo"] = correo;
    obj_usuario["NumDoc"] = dni;

    Map<String, dynamic>  parameters = Map<String, dynamic>();
    parameters["vobj_Usuario"] = obj_usuario;


    final response = await http.post(Uri.parse(HttpTools.GlobalHttp), body: getBody("f_BuscarUsuarioCent",parameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];;
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_EmpleadoId"] = empleadoId;
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("flst_getDatosAnioAcademico",parameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        throw Exception('Failed to load usuario 1');
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load usuario 0');
    }
  }

  @override
  Future<HttpStream> getDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int cargaCursoId, int empleadoId, {required HttpStreamListen onListen, onSucces = Function, onError = Function})  async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_ProgramaEducativoId"] = programaEducativoId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_CargaCursoId"] = cargaCursoId;
    parameters["vint_EmpleadoId"] = empleadoId;
    //Uri.parse(urlServidorLocal), body: getBody("getDatosParaCrearRubro",parameters)
    var request = http.Request('POST', Uri.parse(urlServidorLocal));
    request.body = getBody("getDatosParaCrearRubro",parameters);
    var response = await http.Client().send(request);
    int? _total = response.contentLength;

    var listen = response.stream.listen((value) {
      /* setState(() {
        _bytes.addAll(value);
        _received += value.length;
      });*/
      onListen(value, _total);
    });

    listen.onDone(() {
      //_image = utf8.decode(_bytes);

      /*setState(() {
        _image = file;
      });*/
      onSucces();
    });

    listen.onError((Object error){
      print(error.toString());
      onError();
    });
    //listen?.cancel();
    return _DeviceHttpStream(listen);
  }


}

class _DeviceHttpStream extends HttpStream{
  var listen;

  _DeviceHttpStream(this.listen);

  @override
  void cancel() {
   listen?.cancel();
  }

}