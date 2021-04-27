import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubros/rubro_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class RubroView extends View {
  CursosUi cursosUi;

  RubroView(this.cursosUi);

  @override
  RubroViewState createState() => RubroViewState(this.cursosUi);

}

class RubroViewState extends ViewState<RubroView, RubroController> with TickerProviderStateMixin{

  RubroViewState(cursosUi) : super(RubroController(cursosUi, MoorCalendarioPeriodoRepository(), MoorConfiguracionRepository()));

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
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                animationController.reverse().then<dynamic>((data) {
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Mis Evaluaciones',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
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
                      left: 24
                    ),
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
                        SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: count,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,

                          ),
                          delegate: SliverChildListDelegate(
                              [
                                Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FEFAE2"),
                                        borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: 12, bottom: 6, left: 10, right: 8),
                                                  width: 2.5,
                                                  decoration: BoxDecoration(
                                                      color: HexColor("#8767EB"),
                                                      borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                  ),
                                                ),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 12, right: 8),
                                                          child: Text("1. Rubrica Instrumento",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 10,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.darkerText,
                                                              )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom: 8),
                                                        child: Text("Jueves 22 de Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 8,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )

                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            height: 110
                                        )
                                      ],
                                    ),
                                    height: 150.0),
                                Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FEFAE2"),
                                        borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 12, bottom: 6, left: 10, right: 8),
                                                width: 2.5,
                                                decoration: BoxDecoration(
                                                    color: HexColor("#8767EB"),
                                                    borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 12, right: 8),
                                                          child: Text("2. Rubrica Sesion",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 10,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.darkerText,
                                                              )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom: 8),
                                                        child: Text("Jueves 22 de Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 8,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )

                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            height: 110
                                        )
                                      ],
                                    ),
                                    height: 150.0),
                                Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FEFAE2"),
                                        borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 12, bottom: 6, left: 10, right: 8),
                                                width: 2.5,
                                                decoration: BoxDecoration(
                                                    color: HexColor("#8767EB"),
                                                    borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 12, right: 8),
                                                          child: Text("3. Rubrica Tarea",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 10,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.darkerText,
                                                              )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom: 8),
                                                        child: Text("Jueves 22 de Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 8,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )

                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            height: 110
                                        )
                                      ],
                                    ),
                                    height: 150.0),
                                Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FEFAE2"),
                                        borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 12, bottom: 6, left: 10, right: 8),
                                                width: 2.5,
                                                decoration: BoxDecoration(
                                                    color: HexColor("#8767EB"),
                                                    borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 12, right: 8),
                                                          child: Text("4. Rubrica Pregunta",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 10,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.darkerText,
                                                              )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom: 8),
                                                        child: Text("Jueves 22 de Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 8,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )

                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            height: 110
                                        )
                                      ],
                                    ),
                                    height: 150.0),
                                Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FEFAE2"),
                                        borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 12, bottom: 6, left: 10, right: 8),
                                                width: 2.5,
                                                decoration: BoxDecoration(
                                                    color: HexColor("#8767EB"),
                                                    borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 12, right: 8),
                                                          child: Text("1. Rubrica Instrumento",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 10,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.darkerText,
                                                              )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom: 8),
                                                        child: Text("Jueves 22 de Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 8,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )

                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            height: 110
                                        )
                                      ],
                                    ),
                                    height: 150.0),
                                Container(
                                    decoration: BoxDecoration(
                                        color: HexColor("#FEFAE2"),
                                        borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 12, bottom: 6, left: 10, right: 8),
                                                width: 2.5,
                                                decoration: BoxDecoration(
                                                    color: HexColor("#8767EB"),
                                                    borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                                                ),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 12, right: 8),
                                                          child: Text("1. Rubrica Instrumento",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 10,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.darkerText,
                                                              )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom: 8),
                                                        child: Text("Jueves 22 de Abr.",
                                                            style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsLigth,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 8,
                                                              letterSpacing: 0.5,
                                                              color: AppTheme.darkerText.withOpacity(0.6),
                                                            )

                                                        ),
                                                      )
                                                    ],
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12) // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            height: 110
                                        )
                                      ],
                                    ),
                                    height: 150.0),
                                Container(
                                    color: Colors.teal,
                                    height: 150.0),
                                Container(
                                    color: Colors.teal,
                                    height: 150.0)
                              ]
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
                                        color: AppTheme.colorAccent,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          bottomLeft:const Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Container(
                                        height: 110,
                                        margin: const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 1),
                                        decoration: BoxDecoration(
                                          color:controller.calendarioPeriodoList[index].selected??false ? AppTheme.white: AppTheme.colorAccent,
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
                                                  child: Text(controller.calendarioPeriodoList[index].nombre??"".toUpperCase(), style: TextStyle(color: controller.calendarioPeriodoList[index].selected??false ? AppTheme.colorAccent: AppTheme.white, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w600, fontSize: 9), )
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