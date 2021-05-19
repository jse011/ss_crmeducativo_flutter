import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/check_conex_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/usecases/get_evento_agenda.dart';
import 'package:padre_mentor/src/domain/usecases/get_usuario_usecase.dart';
import 'package:padre_mentor/src/domain/usecases/update_session_usuario.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';

class EventoAgendaPresenter extends Presenter{

  GetEventoAgenda _getEventoAgenda;
  late Function getEventoAgendaOnNext, getEventoAgendaOnError;

  EventoAgendaPresenter(CheckConexRepository checkConext, UsuarioAndConfiguracionRepository usuarioRepo, HttpDatosRepository httpRepo): this._getEventoAgenda = GetEventoAgenda(checkConext ,usuarioRepo, httpRepo), this.getSessionUsuarioCase = GetSessionUsuarioCase(usuarioRepo), updateSession = UpdateSession(usuarioRepo);

  void getEventoAgenda(int usuarioId, int tipoEventoId, List<int> hijoIdList){
    _getEventoAgenda.execute(_GetEventoAgendaCase(this), GetEventoAgendaParams(usuarioId, tipoEventoId, hijoIdList));
  }

  void onInitState() {
    getDatosGenerales();
  }

  @override
  void dispose() {
    _getEventoAgenda.dispose();
  }

}

class _GetEventoAgendaCase extends Observer<GetEvaluacionCaseResponse>{
  final EventoAgendaPresenter presenter;

  _GetEventoAgendaCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getEventoAgendaOnComplete != null);
    presenter.getEventoAgendaOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getEventoAgendaOnError != null);
    presenter.getEventoAgendaOnError(e);
  }

  @override
  void onNext(GetEvaluacionCaseResponse response) {
    assert(presenter.getEventoAgendaOnNext != null);
    presenter.getEventoAgendaOnNext(response.tipoEventoUiList, response.eventoUiList, response.errorServidor, response.datosOffline);
  }

}

