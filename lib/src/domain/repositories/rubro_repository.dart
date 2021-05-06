import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';

abstract class RubroRepository{
  void saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId, int calendarioPeriodoId);

  Future<List<FormaEvaluacionUi>> getGetFormaEvaluacion();

  Future<List<TipoEvaluacionUi>> getGetTipoEvaluacion();

  Future<List<TipoNotaUi>> getGetTipoNota(int programaEducativoId);
}