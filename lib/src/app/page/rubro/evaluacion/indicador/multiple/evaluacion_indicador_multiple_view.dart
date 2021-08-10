import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class EvaluacionIndicadorMultipleView extends View{
  String? rubroEvaluacionId;
  CursosUi? cursosUi;

  EvaluacionIndicadorMultipleView(this.rubroEvaluacionId, this.cursosUi);

  @override
  _EvaluacionIndicadorMultiplePortalState createState() => _EvaluacionIndicadorMultiplePortalState(rubroEvaluacionId, cursosUi);

}

class _EvaluacionIndicadorMultiplePortalState extends ViewState<EvaluacionIndicadorMultipleView, EvaluacionIndicadorMultipleController> with TickerProviderStateMixin{
  ScrollControllers crollController = ScrollControllers();
  late final ScrollControllers crollControllers = ScrollControllers();

  _EvaluacionIndicadorMultiplePortalState(rubroEvaluacionId, cursosUi) : super(EvaluacionIndicadorMultipleController(rubroEvaluacionId, cursosUi, MoorRubroRepository(), MoorConfiguracionRepository()));
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
                        child:   ControlledWidgetBuilder<EvaluacionIndicadorMultipleController>(
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
                                              controller.rubroEvaluacionUi?.titulo??"",
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
    return ControlledWidgetBuilder<EvaluacionIndicadorMultipleController>(
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
                            Padding(padding: EdgeInsets.only( top: 16)),
                          ],
                        )
                    ),
                ),
                SliverToBoxAdapter(
                  child: showTableRubrica(controller),
                ),
              ],
            ),
          );
        });
  }

  Widget showTableRubrica(EvaluacionIndicadorMultipleController controller) {
    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(95.0);
      } else if(s is EvaluacionUi){
        tablecolumnWidths.add(50);
      }else{
        tablecolumnWidths.add(70.0);
      }
    }

    return  FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return  Padding(
            padding: const EdgeInsets.only( top: 16, left: 8, ),
            child: SingleChildScrollView(
              child: StickyHeadersTableNotExpandedCustom(
                  cellDimensions: CellDimensions.variableColumnWidth(
                      stickyLegendHeight:125,
                      stickyLegendWidth: 65,
                      contentCellHeight: 45,
                      columnWidths: tablecolumnWidths
                  ),
                  //cellAlignments: CellAlignments.,
                  scrollControllers: crollControllers,
                  columnsLength: controller.columnList2.length,
                  rowsLength: controller.rowList2.length,
                  columnsTitleBuilder: (i) {
                    dynamic o = controller.columnList2[i];
                    if(o is ContactoUi){
                      return Container(
                          constraints: BoxConstraints.expand(),
                          child: Center(
                            child:  Text("Apellidos y\n Nombres", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.white ),),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.lightBlueAccent4),
                                right: BorderSide(color:AppTheme.lightBlueAccent4),
                              ),
                              color: AppTheme.lightBlueAccent4
                          )
                      );
                    }else if(o is EvaluacionUi){
                      return Container(
                          constraints: BoxConstraints.expand(),
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child:  RotatedBox(
                              quarterTurns: -1,
                              child: Text("Nota Final", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color: AppTheme.greyLighten2),
                              ),
                              color: AppTheme.white
                          )
                      );
                    }if(o is RubricaEvaluacionUi){
                      return Container(
                          constraints: BoxConstraints.expand(),
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child:  RotatedBox(
                              quarterTurns: -1,
                              child: Text(o.titulo??"", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color:  AppTheme.lightBlueAccent4 ),),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color: AppTheme.greyLighten2),
                              ),
                              color: AppTheme.white
                          )
                      );
                    }else
                      return Container();
                  },
                  rowsTitleBuilder: (i) {
                    dynamic o = controller.rowList2[i];
                    if(o is PersonaUi){
                      return  Container(
                          constraints: BoxConstraints.expand(),
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.all(4)),
                              Expanded(
                                  child: Text((i+1).toString() + ".", style: TextStyle(color: AppTheme.darkText, fontSize: 12),)
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.only(right: 3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.greyLighten2,
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
                              ),
                              Padding(padding: EdgeInsets.all(1)),
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color: AppTheme.greyLighten2),
                                left: BorderSide(color: AppTheme.greyLighten2),
                              ),
                              color: AppTheme.white
                          )
                      );
                    }else{
                      return  Container();
                    }
                  },
                  contentCellBuilder: (i, j){
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
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color:  AppTheme.greyLighten2),
                              ),
                              color: _getColorAlumnoBloqueados(o, 0)
                          )
                      );
                    }else if(o is EvaluacionUi){
                      return InkWell(
                        //onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
                        child: Stack(
                          children: [
                            Container(
                              constraints: BoxConstraints.expand(),
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppTheme.greyLighten2),
                                    right: BorderSide(color:  AppTheme.greyLighten2),
                                  ),
                                  color: _getColorAlumnoBloqueados(o.personaUi, 0)
                              ),
                              child: _getTipoNota(o.valorTipoNotaUi, o.nota),
                            ),
                            Positioned(
                                bottom: 4,
                                right: 4,
                                child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                            ),
                          ],
                        ),
                      );
                    }else{
                      return Container();
                    }

                  },
                  legendCell: Stack(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: AppTheme.lightBlueAccent4,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16))
                          )
                      ),
                      Container(
                          child: Center(
                            child: Text('N°', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700),),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: AppTheme.lightBlueAccent4),
                            ),
                          )
                      ),

                    ],
                  ),
              ),
            ),

          );
        }
      },
    );
  }

  Color _getColorAlumnoBloqueados(PersonaUi? personaUi, int intenciadad, {Color c_default = Colors.white}) {
    if(!(personaUi?.contratoVigente??false)){
      print("contratoVigente true");
      if(intenciadad == 0){
        return AppTheme.redLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.redLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.redLighten2;
      }else{
        return AppTheme.redLighten4;
      }
    }else if((personaUi?.soloApareceEvaluacion??false)){
      print("soloApareceEvaluacion true");
      if(intenciadad == 0){
        return AppTheme.deepOrangeLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.deepOrangeLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.deepOrangeLighten2;
      }else{
        return AppTheme.deepOrangeLighten4;
      }
    }else{
      return c_default;
    }
  }

  Widget? _getTipoNota(ValorTipoNotaUi? valorTipoNotaUi, double? nota) {

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (valorTipoNotaUi?.titulo??"") || "C" == (valorTipoNotaUi?.titulo??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (valorTipoNotaUi?.titulo??"")) || "A" == (valorTipoNotaUi?.titulo??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Center(
          child: Text(valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                fontFamily: AppTheme.fontTTNormsMedium,
                fontSize: 14,
                color: color
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        return Container(
          child:  CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono??"",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        return Center(
          child: Text("${(nota??0).toStringAsFixed(1)}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: 14
          ),),
        );
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

}