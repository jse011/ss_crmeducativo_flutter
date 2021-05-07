import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class RubroView extends View {
  CursosUi cursosUi;

  RubroView(this.cursosUi);

  @override
  RubroViewState createState() => RubroViewState(this.cursosUi);

}

class RubroViewState extends ViewState<RubroView, RubroController> with TickerProviderStateMixin{

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
    super.dispose();
  }

  @override
  Widget get view => Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainTab(),
          getAppBarUI(),
        ],
      ),
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
                        child: Stack(
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
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                                child: topBarOpacity >= 1 ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Mostrar Todos",
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
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_rounded,
                                      color: HexColor("#35377A"),
                                      size: 18 + 4 - 1 * topBarOpacity,)
                                  ],
                                ) :Text(
                                  'Mis evaluaciones',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            ControlledWidgetBuilder<RubroController>(
                                builder: (context, controller) {
                                  return Positioned(
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
                                  );
                                },
                            ),
                          ],
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
              Row(
                children: [
                  Expanded(child:
                  Container(
                    padding: EdgeInsets.only(
                        top: AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.top +
                            0,
                        left: 24,
                        right: 16
                    ),
                    child: CustomScrollView(
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
                                      Text("Mostrar Todos",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10 + 6 - 3 * topBarOpacity,
                                            color: HexColor("#35377A"),
                                          )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_rounded,
                                        color: HexColor("#35377A"),
                                        size: 14 + 4 - 4 * topBarOpacity,)
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: count,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,

                          ),
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
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
                                                  child: Text((index + 1).toString() +". Instrumento",
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
                                                  child: Text("Media: 3.18 (0.92)",
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
                                                        child:  Text("Viernes 21 Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 9,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )
                                                        ),
                                                      ),
                                                      Icon(Ionicons.people, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,),
                                                      Padding(padding: EdgeInsets.only(left: 4)),
                                                      Icon(Ionicons.earth, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,)
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 14, top: 8, right: 14),
                                                  child: Text("Examen parcial bimestre I",
                                                      maxLines: 4,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontTTNormsMedium,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 12,
                                                        letterSpacing: 0.5,
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
                            childCount: 45
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    width: 32,
                    padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top +
                          0,
                    ),
                    child: ControlledWidgetBuilder<RubroController>(
                        builder: (context, controller) {
                          return ListView.builder(
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
                          );
                        }),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 24,
                child:  FloatingActionButton(
                  backgroundColor: controller.cursosUi.color2!=null?HexColor(controller.cursosUi.color2):AppTheme.colorAccent,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, null);
                  },
                  child: Icon(Ionicons.add),
                ),
              )

              /*Center(
                  child: Text(
                    "${context.isLandscape}, \n"
                        "${context.sizePx},\n"
                        "${context.widthPx},\n"
                        "${context.heightPx},\n"
                        "${context.diagonalPx},\n"
                        "${context.sizeInches},\n"
                        "${context.widthInches},\n"
                        "${context.heightInches},\n"
                        "${context.diagonalInches},\n"
                        "${context.widthPct(.1)},\n"
                        "${context.heightPct(.1)},\n"
                        "${context.sizeInches},\n"
                        "${context.mq.padding},\n",
                  ))*/
            ],
          );
        });
  }

}