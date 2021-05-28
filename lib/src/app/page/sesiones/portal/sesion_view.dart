import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class SesionView extends View{
  CursosUi cursosUi;
  SesionView(this.cursosUi);

  @override
  _CursoViewState createState() => _CursoViewState(cursosUi);

}

class _CursoViewState extends ViewState<SesionView, SesionController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  _CursoViewState(cursoUi) : super(SesionController(cursoUi));

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
    backgroundColor: AppTheme.background,
    body: Stack(
      children: [
        getMainTab(),
        getAppBarUI(),
      ],
    )
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
                        child: ControlledWidgetBuilder<SesionController>(
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
                                          Navigator.of(this.context).pop();
                                        });
                                      },
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_sesion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12, top: 8),
                                        child: Text(
                                          'Sesión',
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
                                          //controller.onSyncronizarCurso();
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
    return ControlledWidgetBuilder<SesionController>(
        builder: (context, controller) {
          return Container(
              padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      0,
                  left: 24,
                  right: 24
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: EdgeInsets.only(top: 32),
                          child: Text("U2: ESPERANZA EN MEDIO DEL CAOS", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Text("by Alexander Bliss"),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 24),
                          height: 180,
                          decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi.color1),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: new TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: new TextStyle(
                                    fontSize: 14.0,
                                    color: AppTheme.darkText,
                                      height: 1.5
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Propósito de la Sesión: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'En esta sesión se pretende que los niños y niñas saluden a sus compañeros con cortesía, respeto y buena educación.'),
                                    TextSpan(
                                      text: true ? " Ver más" : " show less",
                                      style: new TextStyle(color: Colors.blue),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 32),
                          child: Text("TRABAJOS", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),),
                        ),
                      ])
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 0, right: 8, top: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        //crossAxisCount: countRow,
                        maxCrossAxisExtent: 160.0,
                        mainAxisExtent: 160.0,
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 24.0,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
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
                                        child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                                            Text("Crear Tarea",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  color: AppTheme.white
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: HexColor(controller.cursosUi.color3??"#FEFAE2").withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, right: 16, top: 16, bottom: 0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.assignment, color: HexColor(controller.cursosUi.color1), size: 18,),
                                              Padding(padding: EdgeInsets.all(2)),
                                              Text("Tarea ${index+1}",
                                                style: TextStyle(
                                                    color: HexColor(controller.cursosUi.color1),
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
                                          child: Text("APRENDEMOS ADIVINANZAS", style: TextStyle(color: AppTheme.black, fontSize: 12),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                                          child: Text("Pare el Dom 11 de Abr. 09:11 p. m.", style: TextStyle(fontSize: 10),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                                          child: Row(
                                            children: [
                                              Expanded(child: Text("Sin Publicar", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 12),),),
                                              Text("0/15", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                          },
                          childCount: 2
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: EdgeInsets.only(top: 32),
                          child: Text("EVALUACIÓN", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),),
                        ),
                      ])
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 0, right: 8, top: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        //crossAxisCount: countRow,
                        maxCrossAxisExtent: 160.0,
                        mainAxisExtent: 160.0,
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 24.0,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
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
                                }else{
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: HexColor(controller.cursosUi.color3??"#FEFAE2").withOpacity(0.1),
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
                                                  color: HexColor("#8767EB"),
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
                                                    child: Text("${index+1}. Tarea",
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
                                                    child: Text("Media: 3.0 (0.0)",
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
                                                          child:  Text("Lin 1 de May",
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
                                                    child: Text("PR-1. Escribe dos cosas que los niños de tu ed..",
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
                          childCount: 4
                      ),
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
              )
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