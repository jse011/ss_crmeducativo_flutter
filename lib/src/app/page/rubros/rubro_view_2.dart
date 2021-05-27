import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/response/respuesta_crear_rubro.dart';
import 'dart:math' as math;

class RubroView2 extends View {
  CursosUi cursosUi;

  RubroView2(this.cursosUi);

  @override
  RubroViewState createState() => RubroViewState(this.cursosUi);

}

class RubroViewState extends ViewState<RubroView2, RubroController> with TickerProviderStateMixin{



  RubroViewState(cursosUi) : super(RubroController(cursosUi, MoorCalendarioPeriodoRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio(), MoorRubroRepository()));

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    animationController.reset();

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        animationController.forward();
      });}

    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  int _seletedItem = 0;
  bool result = true;
  PageController _pageController = PageController();

  Widget get view => Scaffold(
    extendBody: true,
    backgroundColor: getBackground(),
    body: Stack(
      children: [
        getMainTab(),
        getAppBarUI(),

      ],
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)),
            child: BottomNavigationBar(
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey[500],
              items: [
                // ignore: deprecated_member_use
                BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                    icon: Container(),
                    // ignore: deprecated_member_use
                    title: Text('General')),
                BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                    icon: Container(),
                    // ignore: deprecated_member_use
                    title: Text('Sesión')),
                BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                    icon: Container(),
                    // ignore: deprecated_member_use
                    title: Text('Competencia'))
              ],
              currentIndex: _seletedItem,
              onTap: (index) {
                setState(() {
                  _seletedItem = index;
                  _pageController.jumpToPage(_seletedItem);
                });
              },
            ),
          )),
    ),
  );

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext? context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context!).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child:   ControlledWidgetBuilder<RubroController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child:  IconButton(
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                                      onPressed: () {
                                        animationController.reverse().then<dynamic>((data) {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                                  child:
                                  topBarOpacity >= 1  && _seletedItem == 0 ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          showDialogButtom(controller);
                                        },
                                        child: Text(_getnombreFiltro(controller.origenRubroUi),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16 + 6 - 1 * topBarOpacity,
                                              color: HexColor("#35377A"),
                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_rounded,
                                        color: HexColor("#35377A"),
                                        size: 24 + 4 - 1 * topBarOpacity,)
                                    ],
                                  ):
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(
                                          padding: EdgeInsets.only(left: 12, top: 8),
                                          child: Text(
                                            'Evaluación',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16 + 6 - 6 * topBarOpacity,
                                              letterSpacing: 0.8,
                                              color: AppTheme.darkerText,
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  child: ClipOval(
                                    child: Material(
                                      color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                      child: InkWell(
                                        splashColor: AppTheme.colorPrimary, // inkwell color
                                        child: SizedBox(width: 43 + 6 - 8 * topBarOpacity, height: 43 + 6 - 8 * topBarOpacity,
                                          child: Icon(Ionicons.sync, size: 24 + 6 - 8 * topBarOpacity,color: AppTheme.colorPrimary, ),
                                        ),
                                        onTap: () {
                                          controller.onSyncronizarCurso();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<RubroController>(
        builder: (context, controller) {

          var widthDp = context.widthPx;
          int count;
          if (widthDp >= 800) {
            count = 5;
          }if (widthDp >= 600) {
            count = 4;
          } else if (widthDp >= 480) {
            count = 3;
          } else {
            count = 2;
          }

          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        0,
                    left: 0,//24
                    right: 0//16
                ),
                child:  PageView(
                  //scrollDirection: Axis.vertical,
                  children: [
                    progress(tabRubroGeneral(controller, count)),
                    progress(tabRubroSesiones2(controller, count)),
                    progress(_seletedItem==2?showTableTipoNota(controller):Container())
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      topBarOpacity = 0;
                      _seletedItem = index;
                    });
                  },
                  controller: _pageController,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  width: 32,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        0,
                  ),
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.calendarioPeriodoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child:Container(
                                margin: const EdgeInsets.only(top: 0, left: 8, right: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  color: controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft:const Radius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  height: 110,
                                  margin: const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 1),
                                  decoration: BoxDecoration(
                                    color:controller.calendarioPeriodoList[index].selected??false ? AppTheme.white: controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft:const Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                                      splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.8),
                                      onTap: () {
                                        controller.onSelectedCalendarioPeriodo(controller.calendarioPeriodoList[index]);
                                      },
                                      child: Center(
                                        child: RotatedBox(quarterTurns: 1,
                                            child: Text(controller.calendarioPeriodoList[index].nombre??"".toUpperCase(), style: TextStyle(color: controller.calendarioPeriodoList[index].selected??false ? (controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent): AppTheme.white, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w600, fontSize: 9), )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void _guardarRubroyRetornar(BuildContext context, RubroController controller) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    RespuestaCrearRubro? response = await AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, null);
    controller.respuestaFormularioCrearRubro(response);
  }

  void showDialogButtom(RubroController controller) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
            title: const Text('Mis evaluaciones'),
            message: const Text('Reduzca su busqueda con las opciones a continuación'),
            actions: [
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.GENERADO_TAREA)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.GENERADO_TAREA);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.GENERADO_INSTRUMENTO)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.GENERADO_INSTRUMENTO);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.GENERADO_PREGUNTA)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.GENERADO_PREGUNTA);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.CREADO_DOCENTE)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.CREADO_DOCENTE);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.TODOS)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.TODOS);
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        );
      },
    );
  }


  String _getnombreFiltro(OrigenRubroUi origenRubroUi){
    String nombre = "";
    switch(origenRubroUi){
      case OrigenRubroUi.GENERADO_INSTRUMENTO:
        nombre = "Mostrar solo Instrumentos";
        break;
      case OrigenRubroUi.GENERADO_TAREA:
        nombre = "Mostrar solo Tareas";
        break;
      case OrigenRubroUi.GENERADO_PREGUNTA:
        nombre = "Mostrar solo Preguntas";
        break;
      case OrigenRubroUi.CREADO_DOCENTE:
        nombre = "Mostrar solo Registro";
        break;
      case OrigenRubroUi.TODOS:
        nombre = "Mostrar Todos";
        break;
    }
    return nombre;
  }

  Color getBackground() {
    switch(_seletedItem){
      case 15:
        return HexColor("#E3F8FA");
      default:
        return AppTheme.background;
    }
  }
  //#region Tab
  ScrollControllers _scrollControllers = ScrollControllers();
  Widget showTableTipoNota(RubroController controller) {

    List<double> tablecolumnWidths = [];
    for(String s in LandingPage.makeTitleColumn()){
      tablecolumnWidths.add(95.0);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 0, top: 24),
      child:  StickyHeadersTable(
        scrollControllers: _scrollControllers,
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight:125,
            stickyLegendWidth: 60,
            contentCellHeight: 45,
            columnWidths: tablecolumnWidths
        ),
        columnsLength: LandingPage.makeTitleColumn().length,
        rowsLength: LandingPage.makeTitleRow().length,
        columnsTitleBuilder: (i) {
          return  Container(
              constraints: BoxConstraints.expand(),
              child: Center(
                child:  Text("Apellidos y\n Nombres" , style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700 ),),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                  right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                ),
                color: HexColor("#EFEDEE")
              )
          );
        },
        rowsTitleBuilder: (i) {
          return  Container(
              constraints: BoxConstraints.expand(),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(2)),
                  Expanded(
                      child: Text((i+1).toString() + ".", style: TextStyle(color: AppTheme.black, fontSize: 12),)
                  ),
                  Container(
                    height: 32,
                    width: 32,
                    margin: EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor(controller.cursosUi.color3),
                    ),
                    child: true?
                    CachedNetworkImage(
                      placeholder: (context, url) => CircularProgressIndicator(),
                      imageUrl: 'https://thumbs.dreamstime.com/z/alumno-feliz-16935936.jpg',
                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                      imageBuilder: (context, imageProvider) =>
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                              )
                          ),
                    ):
                    Container(),
                  )
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                  right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                ),
                color: HexColor(controller.cursosUi.color2)
              )
          );
        },
        contentCellBuilder: (i, j) {
          return Container(
              constraints: BoxConstraints.expand(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Juan Anthonie", maxLines: 1, style: TextStyle(fontSize: 12, color: AppTheme.black),),
                  Text("Yujra Cañazaca", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10),),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                  right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                ),
                color: AppTheme.white
              )
          );
        },
        legendCell: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: HexColor(controller.cursosUi.color1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                )
            ),
            Container(
                child: Center(
                  child: Text('N°', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700),),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                  ),
                )
            ),

          ],
        ),
      ),

    );
  }

  Widget tabRubroGeneral(RubroController controller, int countRow) {
    return Padding(
        padding: EdgeInsets.only(left: 24, right: 48),
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(padding: EdgeInsets.only( top: 32)),
                        controller.contenedorSyncronizar?
                        Container(
                          margin: EdgeInsets.only(bottom: 32),
                          height: 140,
                          decoration: BoxDecoration(
                              color: HexColor("#4987F3"),
                              borderRadius: BorderRadius.circular(24) // use instead of BorderRadius.all(Radius.circular(20))
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 24, right: 36, top: 16, bottom: 16),
                                child:   Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Actualizando sus evaluaciones",
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              letterSpacing: 0.5,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 8)),
                                          Text("Congrats! Your progress are growing up",
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNormsLigth,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: AppTheme.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Container(
                                      width: 72,
                                      height: 72,
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: HexColor("#3C7BE9")),
                                      child:Container(
                                        child: Center(
                                          child: Text(controller.progresoSyncronizar.toString() + "%",
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11,
                                              letterSpacing: 0.5,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor("#4987F3")),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: -88,
                                child: Container(
                                  width: 280,
                                  child: Lottie.asset('assets/lottie/progress_portal_alumno.json',
                                      fit: BoxFit.fill
                                  ),
                                ),
                              )
                            ],
                          ),
                        ):Container(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialogButtom(controller);
                                },
                                child:  Text(_getnombreFiltro(controller.origenRubroUi),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14 + 6 - 3 * topBarOpacity,
                                      color: HexColor("#35377A"),
                                    )
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded,
                                color: HexColor("#35377A"),
                                size: 20 + 4 - 4 * topBarOpacity,)
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: countRow,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,

                  ),
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){

                        RubricaEvaluacionUi rubricaEvalProcesoUi = controller.rubricaEvaluacionUiList[index];
                        String origen = "";
                        switch(rubricaEvalProcesoUi.origenRubroUi??OrigenRubroUi.CREADO_DOCENTE){
                          case OrigenRubroUi.GENERADO_INSTRUMENTO:
                            origen = "Instrumento";
                            break;
                          case OrigenRubroUi.GENERADO_TAREA:
                            origen = "Tarea";
                            break;
                          case OrigenRubroUi.GENERADO_PREGUNTA:
                            origen = "Pregunta";
                            break;
                          case OrigenRubroUi.CREADO_DOCENTE:
                            origen = "";
                            break;
                          case OrigenRubroUi.TODOS:
                            origen = "";
                            break;
                        }

                        String origen2 = "";
                        if((rubricaEvalProcesoUi.sesionAprendizajeId??0) > 0){
                          origen2 =  "Sesion";
                        }else{
                          origen2 =  "Mi Registro";
                        }


                        return Container(
                          decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi.color1??"#FEFAE2").withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 0, left: 12, right: 8),
                                    width: 2.5,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: HexColor(controller.cursosUi.color2??"#8767EB"),
                                        borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10, right: 0),
                                          child: Text("${index+1}.${origen} ${origen2}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                letterSpacing: 0.5,
                                                color: AppTheme.darkerText,
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8, top: 4),
                                          child: Text("Media: ${rubricaEvalProcesoUi.mediaDesvicion}",
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNormsLigth,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10,
                                                letterSpacing: 0.5,
                                                color: AppTheme.darkerText.withOpacity(0.6),
                                              )

                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4, right: 14, left: 4),
                                    child: Icon(Ionicons.ellipsis_vertical_outline, color: AppTheme.darkerText, size: 14,),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(12)) // use instead of BorderRadius.all(Radius.circular(20))
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 14, top: 10, right: 14),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Ionicons.time, color: HexColor("#45D8B8"), size: 12,),
                                              Padding(padding: EdgeInsets.only(left: 4)),
                                              Expanded(
                                                child:  Text(rubricaEvalProcesoUi.efechaCreacion??"",
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNormsLigth,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 9,
                                                      letterSpacing: 0.5,
                                                      color: AppTheme.darkerText.withOpacity(0.6),
                                                    )
                                                ),
                                              ),
                                              if(rubricaEvalProcesoUi.rubroGrupal??false)
                                                Icon(Ionicons.people, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,),
                                              Padding(padding: EdgeInsets.only(left: 4)),
                                              if(rubricaEvalProcesoUi.publicado??false)
                                                Icon(Ionicons.earth, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 14, top: 8, right: 14),
                                          child: Text(rubricaEvalProcesoUi.titulo??"",
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNormsMedium,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                color: AppTheme.darkerText.withOpacity(0.8),
                                              )
                                          ),
                                        )
                                      ],
                                    )

                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      childCount: controller.rubricaEvaluacionUiList.length
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(padding: EdgeInsets.only( top: 150)),
                      ],
                    )
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 120,
              child: FloatingActionButton(
                backgroundColor: controller.cursosUi.color2!=null?HexColor(controller.cursosUi.color2):AppTheme.colorAccent,
                foregroundColor: Colors.white,
                onPressed: () {
                  _guardarRubroyRetornar(context, controller);
                },
                child: Icon(Ionicons.add),
              ),
            )
          ],
        ),
    );
  }

  Widget tabRubroSesiones(RubroController controller, int countRow) {
    return  Padding(
        padding: EdgeInsets.only(left: 24, right: 48),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(padding: EdgeInsets.only( top: 32)),
                  ],
                )
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      decoration: new BoxDecoration(
                          color: HexColor(controller.cursosUi.color1),
                          borderRadius: new BorderRadius.all(Radius.circular(25.0))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 24, right: 24, left: 24),
                            child: Row(
                              children: [
                                Expanded(child: Text("U3: ESPERANZA EN MEDIO DEL CAOS", style: TextStyle(color: AppTheme.white, fontSize: 16),)),
                                ClipOval(
                                  child: Material(
                                    color: HexColor(controller.cursosUi.color3), // button color
                                    child: InkWell(
                                      splashColor: HexColor(controller.cursosUi.color3).withOpacity(0.5), // inkwell color
                                      child: SizedBox(width: 43 , height: 43,
                                        child: Icon(Ionicons.chevron_down, size: 24 ,color: AppTheme.white, ),
                                      ),
                                      onTap: () {
                                        controller.onSyncronizarCurso();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: HexColor(controller.cursosUi.color3),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child:  Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(0),
                                child:   GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(20.0),
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: countRow,
                                  children: <Widget>[
                                    for(int i = 0; i <= 5; i++)
                                      InkWell(
                                        onTap: (){
                                          showRubroSesion(controller, countRow);
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: AppTheme.white,
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      decoration: new BoxDecoration(
                          color: HexColor(controller.cursosUi.color1),
                          borderRadius: new BorderRadius.all(Radius.circular(25.0))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 24, right: 24, left: 24),
                            child: Text("U3: ESPERANZA EN MEDIO DEL CAOS", style: TextStyle(color: AppTheme.white, fontSize: 16),),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: HexColor(controller.cursosUi.color3),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child:  Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(0),
                                child:   GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(20.0),
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: countRow,
                                  children: <Widget>[
                                    for(int i = 0; i <= 5; i++)
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: AppTheme.white,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(padding: EdgeInsets.only( top: 150)),
                  ],
                )
            ),
          ],
        ),
    );
  }

  Widget tabRubroSesiones2(RubroController controller, int countRow) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 48),
      child: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only( top: 48),
                        child: Text("U1: Iniciamos el año escolar cuidando el agua",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only( top: 8, bottom: 16, ),
                        child: Text("- S1: Escribimos frases y oraciones",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //crossAxisCount: countRow,
                    maxCrossAxisExtent: 150.0,
                    mainAxisExtent: 150.0,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                            RubricaEvaluacionUi? rubricaEvalProcesoUi = controller.rubricaEvaluacionUiList.isNotEmpty?controller.rubricaEvaluacionUiList[index]:null;


                        if(index == 0){
                          return Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi.color2),
                              borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: FDottedLine(
                              color: AppTheme.white,
                              strokeWidth: 3.0,
                              dottedLength: 10.0,
                              space: 3.0,
                              corner: FDottedLineCorner.all(14.0),

                              /// add widget
                              child: Container(
                                color: HexColor(controller.cursosUi.color2),
                                alignment: Alignment.center,
                                child: Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                              ),
                            ),
                          );
                        }else if(index == 9){
                          return InkWell(
                            onTap: (){
                              showRubroSesion(controller, countRow);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color2),
                                borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                              ),
                              child: FDottedLine(
                                color: AppTheme.white,
                                strokeWidth: 3.0,
                                dottedLength: 10.0,
                                space: 3.0,
                                corner: FDottedLineCorner.all(14.0),

                                /// add widget
                                child: Container(
                                  color: HexColor(controller.cursosUi.color2),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text("Ver más",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: AppTheme.fontTTNorms,
                                          color: AppTheme.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else{

                          String origen = "";
                          switch(rubricaEvalProcesoUi?.origenRubroUi??OrigenRubroUi.CREADO_DOCENTE){
                            case OrigenRubroUi.GENERADO_INSTRUMENTO:
                              origen = "Instrumento";
                              break;
                            case OrigenRubroUi.GENERADO_TAREA:
                              origen = "Tarea";
                              break;
                            case OrigenRubroUi.GENERADO_PREGUNTA:
                              origen = "Pregunta";
                              break;
                            case OrigenRubroUi.CREADO_DOCENTE:
                              origen = "";
                              break;
                            case OrigenRubroUi.TODOS:
                              origen = "";
                              break;
                          }

                          String origen2 = "";
                          if((rubricaEvalProcesoUi?.sesionAprendizajeId??0) > 0){
                            origen2 =  "Sesion";
                          }else{
                            origen2 =  "Mi Registro";
                          }


                          return Container(
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color1??"#FEFAE2").withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5, bottom: 0, left: 12, right: 8),
                                      width: 2.5,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: HexColor(controller.cursosUi.color2??"#8767EB"),
                                          borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10, right: 0),
                                            child: Text("${index+1}.${origen} ${origen2}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.darkerText,
                                                )),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 8, top: 4),
                                            child: Text("Media: ${rubricaEvalProcesoUi?.mediaDesvicion}",
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNormsLigth,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  letterSpacing: 0.5,
                                                  color: AppTheme.darkerText.withOpacity(0.6),
                                                )

                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4, right: 14, left: 4),
                                      child: Icon(Ionicons.ellipsis_vertical_outline, color: AppTheme.darkerText, size: 14,),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(12)) // use instead of BorderRadius.all(Radius.circular(20))
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 14, top: 10, right: 14),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Ionicons.time, color: HexColor("#45D8B8"), size: 12,),
                                                Padding(padding: EdgeInsets.only(left: 4)),
                                                Expanded(
                                                  child:  Text(rubricaEvalProcesoUi?.efechaCreacion??"",
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontTTNormsLigth,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 9,
                                                        letterSpacing: 0.5,
                                                        color: AppTheme.darkerText.withOpacity(0.6),
                                                      )
                                                  ),
                                                ),
                                                if(rubricaEvalProcesoUi?.rubroGrupal??false)
                                                  Icon(Ionicons.people, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,),
                                                Padding(padding: EdgeInsets.only(left: 4)),
                                                if(rubricaEvalProcesoUi?.publicado??false)
                                                  Icon(Ionicons.earth, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,)
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 14, top: 8, right: 14),
                                            child: Text(rubricaEvalProcesoUi?.titulo??"",
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNormsMedium,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  color: AppTheme.darkerText.withOpacity(0.8),
                                                )
                                            ),
                                          )
                                        ],
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      childCount: 10
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only( top: 8, bottom: 16, ),
                        child: Text("- S2: Aprendemos adivinanzas",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //crossAxisCount: countRow,
                    maxCrossAxisExtent: 100.0,
                    mainAxisExtent: 100.0,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                        if(index == 0){
                          return Container(
                            decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi.color2),
                              borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: Icon(Ionicons.add, color: AppTheme.white, size: 35,),
                          );
                        }else{
                          return Container(
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color3??"#FEFAE2").withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                          );
                        }
                      },
                      childCount: 11
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only( top: 32, bottom: 16),
                        child: Text("U3: ESPERANZA EN MEDIO DEL CAOS",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),),
                      ),
                    ],
                  )
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //crossAxisCount: countRow,
                  maxCrossAxisExtent: 100,
                  mainAxisExtent: 100.0,
                  mainAxisSpacing: 24.0,
                  crossAxisSpacing: 24.0,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index){
                      return Container(
                        decoration: BoxDecoration(
                            color: HexColor(controller.cursosUi.color3??"#FEFAE2").withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                        ),

                      );
                    },
                    childCount: 5
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(padding: EdgeInsets.only( top: 150)),
                    ],
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

//#region Tab

  void showRubroSesion(RubroController controller, int countRow) {
    //FocusScope.of(context).unfocus();
    //_tiuloCriteriocontroller.text = criterioUi.icdTituloEditado??criterioUi.icdTituloEditado??criterioUi.icdTitulo??"";
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, dialogState) {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(this.context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 16 - 8.0,
                            bottom: 12 - 8.0),
                        child:   Stack(
                          children: <Widget>[
                            Positioned(
                                child:  IconButton(
                                  icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6,),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 , width: 35 +  6,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12, top: 8),
                                    child: Text(
                                      'Evaluación',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16 + 6,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: ClipOval(
                                child: Material(
                                  color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                  child: InkWell(
                                    splashColor: AppTheme.colorPrimary, // inkwell color
                                    child: SizedBox(width: 43 + 6, height: 43 + 6,
                                      child: Icon(Ionicons.sync, size: 24 + 6,color: AppTheme.colorPrimary, ),
                                    ),
                                    onTap: () {

                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: CustomScrollView(
                              scrollDirection: Axis.vertical,
                              slivers: <Widget>[
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                      Padding(padding: EdgeInsets.only( top: 24)),
                                      Container(
                                        height: 180,
                                        margin: EdgeInsets.only(left: 24, right: 24),
                                        decoration: BoxDecoration(
                                            color: HexColor(controller.cursosUi.color1),
                                            borderRadius: BorderRadius.all(Radius.circular(28))
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              right: 16,
                                              top: 16,
                                              bottom: 0,
                                              child: Opacity(
                                                opacity: 0.7,
                                                child: SvgPicture.asset(AppIcon.ic_curso_sesion, width: 130, height: 130,),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(right: 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 24, top: 24, right: 24),
                                                        child: Text("Sesión 4: Escribimos palabras y frases",
                                                          maxLines: 3,
                                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700 ),),
                                                      )
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 24, top: 20),
                                                    child: Text("Mié 26 de Mayo",
                                                      maxLines: 3,
                                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700 ),),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 24, bottom: 20),
                                                    child: Row(
                                                      children: [
                                                        Text("Conocer más de la sesión", style: TextStyle(color: Colors.white, fontSize: 12)),
                                                        Padding(
                                                            padding: EdgeInsets.all(2)
                                                        ),
                                                        SvgPicture.asset(AppIcon.ic_curso_flecha, color: AppTheme.white, width: 18, height: 18,)
                                                      ],
                                                    ) ,
                                                  )

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ])
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                                  sliver: SliverGrid(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: countRow,
                                      mainAxisSpacing: 16.0,
                                      crossAxisSpacing: 16.0,

                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index){

                                          RubricaEvaluacionUi rubricaEvalProcesoUi = controller.rubricaEvaluacionUiList[index];
                                          String origen = "";
                                          switch(rubricaEvalProcesoUi.origenRubroUi??OrigenRubroUi.CREADO_DOCENTE){
                                            case OrigenRubroUi.GENERADO_INSTRUMENTO:
                                              origen = "Instrumento";
                                              break;
                                            case OrigenRubroUi.GENERADO_TAREA:
                                              origen = "Tarea";
                                              break;
                                            case OrigenRubroUi.GENERADO_PREGUNTA:
                                              origen = "Pregunta";
                                              break;
                                            case OrigenRubroUi.CREADO_DOCENTE:
                                              origen = "";
                                              break;
                                            case OrigenRubroUi.TODOS:
                                              origen = "";
                                              break;
                                          }

                                          String origen2 = "";
                                          if((rubricaEvalProcesoUi.sesionAprendizajeId??0) > 0){
                                            origen2 =  "Sesion";
                                          }else{
                                            origen2 =  "Mi Registro";
                                          }


                                          return Container(
                                            decoration: BoxDecoration(
                                                color: HexColor(controller.cursosUi.color1??"#FEFAE2").withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5, bottom: 0, left: 12, right: 8),
                                                      width: 2.5,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color2??"#8767EB"),
                                                          borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 10, right: 0),
                                                            child: Text("${index+1}.${origen} ${origen2}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12,
                                                                  letterSpacing: 0.5,
                                                                  color: AppTheme.darkerText,
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 8, top: 4),
                                                            child: Text("Media: ${rubricaEvalProcesoUi.mediaDesvicion}",
                                                                style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNormsLigth,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10,
                                                                  letterSpacing: 0.5,
                                                                  color: AppTheme.darkerText.withOpacity(0.6),
                                                                )

                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 4, right: 14, left: 4),
                                                      child: Icon(Ionicons.ellipsis_vertical_outline, color: AppTheme.darkerText, size: 14,),
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.all(Radius.circular(12)) // use instead of BorderRadius.all(Radius.circular(20))
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 14, top: 10, right: 14),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Icon(Ionicons.time, color: HexColor("#45D8B8"), size: 12,),
                                                                Padding(padding: EdgeInsets.only(left: 4)),
                                                                Expanded(
                                                                  child:  Text(rubricaEvalProcesoUi.efechaCreacion??"",
                                                                      style: TextStyle(
                                                                        fontFamily: AppTheme.fontTTNormsLigth,
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 9,
                                                                        letterSpacing: 0.5,
                                                                        color: AppTheme.darkerText.withOpacity(0.6),
                                                                      )
                                                                  ),
                                                                ),
                                                                if(rubricaEvalProcesoUi.rubroGrupal??false)
                                                                  Icon(Ionicons.people, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,),
                                                                Padding(padding: EdgeInsets.only(left: 4)),
                                                                if(rubricaEvalProcesoUi.publicado??false)
                                                                  Icon(Ionicons.earth, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,)
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 14, top: 8, right: 14),
                                                            child: Text(rubricaEvalProcesoUi.titulo??"",
                                                                maxLines: 4,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNormsMedium,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12,
                                                                  letterSpacing: 1,
                                                                  color: AppTheme.darkerText.withOpacity(0.8),
                                                                )
                                                            ),
                                                          )
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        childCount: controller.rubricaEvaluacionUiList.length
                                    ),
                                  ),
                                ),
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                      Container(
                                        height: 100,
                                      )
                                    ])
                                ),
                              ]
                          ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget progress(Widget widget){
    return FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return widget;
          }

        });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}

