import 'package:moor_flutter/moor_flutter.dart';

class Criterio extends Table{
  
IntColumn get sesionAprendizajeId => integer()();
IntColumn get unidadAprendiajeId => integer()();
IntColumn get silaboEventoId => integer()();
/// <summary>
/// Tabla Competencias
/// </summary>
IntColumn get competenciaId => integer().nullable()();
TextColumn get competenciaNombre => text().nullable()();
TextColumn get competenciaDescripcion => text().nullable()();
IntColumn get competenciaTipoId => integer().nullable()();
IntColumn get superCompetenciaId => integer().nullable()();
TextColumn get superCompetenciaNombre => text().nullable()();
TextColumn get superCompetenciaDescripcion => text().nullable()();
IntColumn get superCompetenciaTipoId => integer().nullable()();


/// <summary>
/// Tabla DesempenioIcd Desempenio Icd
/// </summary>
IntColumn get desempenioIcdId => integer().nullable()();
TextColumn get DesempenioDescripcion => text().nullable()();
IntColumn get peso => integer().nullable()();
TextColumn get codigo => text().nullable()();
IntColumn get tipoId => integer().nullable()();
TextColumn get url => text().nullable()();
IntColumn get desempenioId => integer().nullable()();
TextColumn get desempenioIcdDescripcion => text().nullable()();
IntColumn get icdId => integer().nullable()();
TextColumn get icdTitulo => text().nullable()();
TextColumn get icdDescripcion => text().nullable()();
TextColumn get icdAlias => text().nullable()();

/// <summary>
/// Tabla CampoTematico
/// </summary>
/// 

IntColumn get campoTematicoId => integer().nullable()();
TextColumn get campoTematicoTitulo => text().nullable()();
TextColumn get campoTematicoDescripcion => text().nullable()();
IntColumn get campoTematicoEstado => integer().nullable()();
IntColumn get campoTematicoParentId => integer().nullable()();
TextColumn get campoTematicoParentTitulo => text().nullable()();
TextColumn get campoTematicoParentDescripcion => text().nullable()();
IntColumn get campoTematicoParentEstado => integer().nullable()();
IntColumn get campoTematicoParentParentId => integer().nullable()();

@override
  Set<Column> get primaryKey => { silaboEventoId, unidadAprendiajeId, silaboEventoId};
}