abstract class HttpDatosRepository{

  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni);
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId);
  Future<Map<String, dynamic>?> getDatosInicioDocente(String urlServidorLocal, int usuarioId);
  Future<Map<String, dynamic>?> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId);
  Future<HttpStream> getDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int cargaCursoId, int empleadoId, { required HttpStreamListen onListen , onSucces: Function, onError: Function });

}

abstract class HttpStream {
  void cancel();
}
typedef HttpStreamListen = void Function(List<int> bytes, int? total);