
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class EvaluacionProceso extends BaseSync {

    /*
    String? evaluacionProcesoId;
    long? evaluacionResultadoId;
    double? nota;
    String? escala;
    String? rubroEvalProcesoId;
    int? sesionAprendizajeId;
    String? valorTipoNotaId;
    String? equipoId;
    int? alumnoId;
    int? calendarioPeriodoId;
    bool? formulaSinc;
    int? msje;
    int? publicado;
    int? visto;]*/

    TextColumn get evaluacionProcesoId => text()();
    IntColumn get evaluacionResultadoId => integer().nullable()();
    RealColumn get nota => real().nullable()();
    TextColumn get escala => text().nullable()();
    TextColumn get rubroEvalProcesoId => text().nullable()();
    IntColumn get sesionAprendizajeId => integer().nullable()();
    TextColumn get valorTipoNotaId => text().nullable()();
    TextColumn get equipoId => text().nullable()();
    IntColumn get alumnoId => integer().nullable()();
    IntColumn get calendarioPeriodoId => integer().nullable()();
    BoolColumn get formulaSinc => boolean().nullable()();
    IntColumn get msje => integer().nullable()();
    IntColumn get publicado => integer().nullable()();
    IntColumn get visto => integer().nullable()();

    @override
  Set<Column> get primaryKey => {evaluacionProcesoId};
}
