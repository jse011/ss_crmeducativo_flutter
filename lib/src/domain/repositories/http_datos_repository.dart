abstract class HttpDatosRepository{

  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni);
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId);
  Future<Map<String, dynamic>?> getDatosInicioDocente(String urlServidorLocal, int usuarioId);
  Future<Map<String, dynamic>?> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId);
  Future<Map<String, dynamic>?> getDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int cargaCursoId, int empleadoId);

}

typedef TapBuilder = void Function(BuildContext context, int position, AnimationController? animationController);