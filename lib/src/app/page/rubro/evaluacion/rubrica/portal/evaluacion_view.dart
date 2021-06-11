import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_v2.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/rubrica/portal/evaluacion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';

class EvaluacionView extends View{
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  CursosUi? cursosUi;

  EvaluacionView(this.rubricaEvaluacionUi, this.cursosUi);

  @override
  _EvaluacionViewState createState() => _EvaluacionViewState(rubricaEvaluacionUi, cursosUi);

}

class _EvaluacionViewState extends ViewState<EvaluacionView, EvaluacionController> with TickerProviderStateMixin{
  ScrollControllers crollControllers = ScrollControllers();

  _EvaluacionViewState(rubricaEvaluacionUi, cursosUi) : super(EvaluacionController(rubricaEvaluacionUi, cursosUi, MoorRubroRepository()));
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

    Future.delayed(const Duration(milliseconds: 200), () {
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
    color: AppTheme.white,
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
                        child:   ControlledWidgetBuilder<EvaluacionController>(
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
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 54, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 25 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(padding: EdgeInsets.only(left: 16)),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Text(
                                              controller.rubricaEvaluacionUi.titulo??"",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12 + 6 - 6 * topBarOpacity,
                                                letterSpacing: 0.8,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),

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
    return ControlledWidgetBuilder<EvaluacionController>(
        builder: (context, controller) {
          return Container(
            padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(padding: EdgeInsets.only( top: 32)),
                            Text(controller.rubricaEvaluacionUi.titulo??"",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkerText,
                                  fontFamily: AppTheme.fontTTNorms
                              ),
                            ),

                          ],
                        )
                    ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(padding: EdgeInsets.only(bottom: 1500))
                    ])
                )
              ],
            ),
          );
        });
  }
/*
  ScrollControllers _scrollControllers = ScrollControllers();
  Widget tabRubCompetencia(EvaluacionController controller) {


    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(95.0);
      } else if(s is CalendarioPeriodoUI){
        tablecolumnWidths.add(70.0*3);
      }else{
        tablecolumnWidths.add(70.0);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 0, top: 24),
      child:  StickyHeadersTableV2(
        scrollControllers: _scrollControllers,
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight:125,
            stickyLegendWidth: 60,
            contentCellHeight: 45,
            columnWidths: tablecolumnWidths
        ),
        columnsLength: controller.columnList2.length,
        rowsLength: controller.rowList2.length,
        columnsTitleBuilder: (i) {
          dynamic o = controller.columnList2[i];
          if(o is PersonaUi){
            return Container(
                constraints: BoxConstraints.expand(),
                child: Center(
                  child:  Text("Apellidos y\n Nombres", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500 ),),
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                    ),
                    color: HexColor("#EFEDEE")
                )
            );
          }else if(o is RubricaEvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(8),
                child: Center(
                  child:  RotatedBox(
                    quarterTurns: -1,
                    child: Text(o.titulo??"", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                    ),
                    color: HexColor("#EFEDEE")
                )
            );
          }else{
            return Container();
          }

        },
        rowsTitleBuilder: (i) {
          dynamic o = controller.rowList2[i];
          if(o is PersonaUi){
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
                        imageUrl: o.foto??"",
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
          }else{
            return  Container();
          }

        },
        contentCellBuilder: (i, j) {
          dynamic o = controller.cellListList[j][i];
          if(o is PersonaUi){
            return Container(
                constraints: BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(o.nombreCompleto??"", maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppTheme.black),),
                    Text(o.apellidos??"", maxLines: 1, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10),),
                  ],
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                    ),
                    color: _getColorAlumnoBloqueados(o, 0)
                )
            );
          }else if(o is EvaluacionCapacidadUi){
            return InkWell(
              onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                    ),
                    color: _getColorAlumnoBloqueados(o.personaUi, 0)
                ),
                child: _getTipoNota(o.valorTipoNotaUi, o.nota),
              ),
            );
          }else if(o is EvaluacionCompetenciaUi){
            return Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                    right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                  ),
                  color: _getColorAlumnoBloqueados(o.personaUi, 1, c_default: HexColor("#EFEDEE"))
              ),
              child: _getTipoNota(o.valorTipoNotaUi, o.nota),
            );
          }else if(o is EvaluacionCalendarioPeriodoUi){
            return Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                            right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                          ),
                          color: _getColorAlumnoBloqueados(o.personaUi, 2, c_default: AppTheme.greyLighten1)
                      ),
                      child: _getTipoNota(o.valorTipoNotaUi, o.nota),
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                            ),
                            color: HexColor("#EFEDEE")
                        )
                    )
                ),
              ],
            );
          }else{
            return Container();
          }

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
*/
}