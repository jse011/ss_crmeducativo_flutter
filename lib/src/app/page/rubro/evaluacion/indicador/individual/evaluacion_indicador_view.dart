import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/individual/evaluacion_indicador_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class EvaluacionIndicadorView extends View{
  String? rubroEvaluacionId;
  CursosUi? cursosUi;

  EvaluacionIndicadorView(this.rubroEvaluacionId, this.cursosUi);

  @override
  EvaluacionIndicadorState createState() => EvaluacionIndicadorState(rubroEvaluacionId, cursosUi);

}

class EvaluacionIndicadorState extends ViewState<EvaluacionIndicadorView, EvaluacionIndicadorController> with TickerProviderStateMixin{

  EvaluacionIndicadorState(rubroEvaluacionId, cursosUi) : super(EvaluacionIndicadorController(rubroEvaluacionId, cursosUi, MoorRubroRepository(), MoorConfiguracionRepository()));

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late final ScrollControllers crollControllers = ScrollControllers();
  Function()? statetDialogPresion = null;
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
                        child:   ControlledWidgetBuilder<EvaluacionIndicadorController>(
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
    return ControlledWidgetBuilder<EvaluacionIndicadorController>(
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
                  padding: EdgeInsets.only(left: 8, right: 8),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                              padding: EdgeInsets.only( top: 48, left: 16, right: 16),
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                        onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: controller.precision?AppTheme.colorAccent:null
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.apps, color:controller.precision?AppTheme.white:AppTheme.colorAccent, size: 20, ),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Precisión",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                        color:  controller.precision?AppTheme.white:AppTheme.colorPrimary,
                                                        fontSize: 12
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.trash, color: AppTheme.colorAccent, size: 20,),
                                            Padding(padding: EdgeInsets.all(2),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Eliminar",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                    color: AppTheme.colorPrimary,
                                                      fontSize: 12
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      child:  Container(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.help_circle, color: AppTheme.colorAccent, size: 20,),
                                            Padding(padding: EdgeInsets.all(2),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Ayuda",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    letterSpacing: 0.5,
                                                      fontWeight: FontWeight.bold,
                                                    color: AppTheme.colorPrimary,
                                                      fontSize: 12
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),


                                ],
                              ),
                            ),
                          ),


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

  Widget showTableRubrica(EvaluacionIndicadorController controller) {
    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(95.0);
      } else if(s is EvaluacionUi){
        tablecolumnWidths.add(65);
      } else if(s == "comentario"){
        tablecolumnWidths.add(55);
      } else if(s is EvaluacionPublicadoUi){
        tablecolumnWidths.add(60);
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
            padding: const EdgeInsets.only( top: 24, left: 16, ),
            child: SingleChildScrollView(
              child: StickyHeadersTableNotExpandedCustom(
                cellDimensions: CellDimensions.variableColumnWidth(
                    stickyLegendHeight:60,
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
                              top: BorderSide(color: AppTheme.colorPrimary),
                              right: BorderSide(color:AppTheme.colorPrimary),
                            ),
                            color: AppTheme.colorPrimary
                        )
                    );
                  }else if(o is EvaluacionUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child:  RotatedBox(
                            quarterTurns: -1,
                            child: Text(" ", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
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
                  }if(o is ValorTipoNotaUi){
                    return InkWell(
                      onTap: () =>  controller.onClicEvaluacionAll(o),
                      child: Stack(
                        children: [
                          _getTipoNotaCabecera(o, controller,i)
                        ],
                      ),
                    );
                  }else if(o is EvaluacionPublicadoUi){
                    return InkWell(
                      onTap: (){
                        controller.onClicPublicarAll(o);
                      },
                      child: Container(
                        child: Icon(Ionicons.globe_outline, size: 38, color: o.publicado? AppTheme.colorAccent:AppTheme.grey,),
                      ),
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
                            border: (controller.cellListList.length-4) <= i ? Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                              left: BorderSide(color:  AppTheme.greyLighten2),
                              bottom:  BorderSide(color:  AppTheme.greyLighten2),
                            ):Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                              left: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color: AppTheme.white
                        )
                    );
                  }else {
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
                            border: (controller.cellListList.length-4) <= j ? Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                              bottom:  BorderSide(color:  AppTheme.greyLighten2),
                            ):Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color: _getColorAlumnoBloqueados(o, 0)
                        )
                    );
                  }else if(o is EvaluacionRubricaValorTipoNotaUi){
                    return InkWell(
                      onTap: () {
                        if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false))
                          showDialogPresion(context, o, i);
                        else
                        controller.onClicEvaluar(o);

                      },
                      child: Stack(
                        children: [
                          _getTipoNota(o, controller,i, j),
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                          ),
                        ],
                      ),
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
                            //child: _getTipoNota(o.valorTipoNotaUi, o.nota, i),
                          ),
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                          ),
                        ],
                      ),
                    );
                  }else if(o == "comentario"){
                    return InkWell(
                      onTap: (){},
                      child: Container(
                        child: Icon(Ionicons.chatbox_ellipses_outline, size: 30, color: AppTheme.tealDarken4,),
                      ),
                    );
                  }else if(o is EvaluacionPublicadoUi){//publicado
                    return InkWell(
                      onTap: (){
                        controller.onClicPublicado(o);
                      },
                      child: Container(
                        child: Icon(Ionicons.globe_outline, size: 30, color:o.publicado? AppTheme.colorAccent:AppTheme.grey ),
                      ),
                    );
                  }else {
                    return Container();
                  }

                },
                legendCell: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: AppTheme.colorPrimary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16))
                        )
                    ),
                    Container(
                        child: Center(
                          child: Text('N°', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700),),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppTheme.colorPrimary),
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

  Color getPosition(int position){
    if(position == 1){
     return HexColor("#1976d2");
    }else if(position == 2){
      return  HexColor("#388e3c");
    }else if(position == 3){
      return   HexColor("#FF6D00");
    }else if(position == 4){
      return  HexColor("#D32F2F");
    }else{
      return  AppTheme.greyLighten2;
    }
  }

  Widget _getTipoNotaCabecera(ValorTipoNotaUi? valorTipoNotaUi,EvaluacionIndicadorController controller, int position) {
    Widget? nota = null;
    Color color_fondo;
    Color? color_texto;
    if(position == 1){
      color_fondo = HexColor("#1976d2");
      color_texto = AppTheme.white;
    }else if(position == 2){
      color_fondo =  HexColor("#388e3c");
      color_texto = AppTheme.white;
    }else if(position == 3){
      color_fondo =  HexColor("#FF6D00");
      color_texto = AppTheme.white;
    }else if(position == 4){
      color_fondo =  HexColor("#D32F2F");
      color_texto = AppTheme.white;
    }else{
      color_fondo =  AppTheme.greyLighten2;
      color_texto = null;//defaul
    }

    var ver_detalle = false;
    //if(valorTipoNotaUi?.tipoNotaUi?.intervalo??false)
    ver_detalle = controller.precision;

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO) {
      case TipoNotaTiposUi.SELECTOR_VALORES:
        nota = Container(
          child: Center(
            child: Text(valorTipoNotaUi?.titulo ?? "",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNormsMedium,
                    fontSize: 16,
                    color: color_texto
                )),
          ),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        nota = Container(
          width: ver_detalle?35:45,
          height: ver_detalle?35:45,
          child: CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono ?? "",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
        break;
      default:
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color_fondo),
          right: BorderSide(color:  color_fondo),
        ),
        color: color_fondo,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nota??Container(),
          if(ver_detalle)
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text("${(valorTipoNotaUi?.valorNumerico??0).toStringAsFixed(1)}", style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 12,
                  color: color_texto
              ),),
            )
        ],
      ),
    );
  }

  Widget _getTipoNota(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, EvaluacionIndicadorController controller, int positionX, int positionY) {
    Widget? widget = null;
    Color color_fondo;
    Color? color_texto;
    Color color_borde;

    if(positionX == 1){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#1976d2");
        color_texto = AppTheme.white;
        color_borde = HexColor("#1976d2");
      }else{
        color_fondo = AppTheme.white;
        color_texto = HexColor("#1976d2");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 2){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#388e3c");
        color_texto = AppTheme.white;
        color_borde = HexColor("#388e3c");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#388e3c");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 3){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#FF6D00");
        color_texto = AppTheme.white;
        color_borde = HexColor("#FF6D00");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#FF6D00");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 4){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#D32F2F");
        color_texto = AppTheme.white;
        color_borde = HexColor("#D32F2F");
      }else {
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#D32F2F");
        color_borde = AppTheme.greyLighten2;
      }
    }else{
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = AppTheme.white;
        color_texto =  null;
        color_borde = AppTheme.greyLighten2;
      }else{
        color_fondo = AppTheme.greyLighten2;
        color_texto = null;
        color_borde = AppTheme.greyLighten2;
      }
    }

    color_fondo = color_fondo.withOpacity(0.8);
    color_borde = AppTheme.greyLighten2.withOpacity(0.8);

    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        widget = Center(
          child: Text(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 14,
                  color: color_texto
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.5,
          child: Container(
            padding: EdgeInsets.all(4),
            child:  CachedNetworkImage(
              imageUrl: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
        break;
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        var nota = 0.0;
        if(evaluacionRubricaValorTipoNotaUi.toggle??false)nota = evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota??0;
        else nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico??0;
      widget = Center(
        child: Text("${nota.toStringAsFixed(1)}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: 14,
            color: color_texto
        ),),
      );;
      break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          border: (controller.cellListList.length-4) <= positionY ? Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
            bottom:  BorderSide(color:  AppTheme.greyLighten2),
          ):Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
          ),
          color: (evaluacionRubricaValorTipoNotaUi.toggle??false)?color_fondo:_getColorAlumnoBloqueados(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi, 0)
      ),
      child: widget,
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  void showDialogPresion(BuildContext context, EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, int position) {
    EvaluacionIndicadorController controller =
    FlutterCleanArchitecture.getController<EvaluacionIndicadorController>(context, listen: false);

    String titulo = "";
    if(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
      titulo =  evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.alias??"";
    }else{
      titulo =  evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.alias??"";
    }

    String descripcion = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.nombre??"";
    if(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.intervalo??false){

    }else{

    }


    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              statetDialogPresion = (){
                if (mounted) {
                  setState((){});
                }
              };
              controller.addListener(statetDialogPresion!);
              bool isLandscape = context.isLandscape;
              return Container(
                height: MediaQuery.of(context).size.height * (isLandscape?1:0.7),
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Container(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(this.context).padding.top,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 16 - 8.0,
                                  bottom: 12 - 8.0),
                              child:   Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 70),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          imageUrl: evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi?.foto??"",
                                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                                  width: 50,
                                                  height: 50,
                                                  margin: EdgeInsets.only(right: 16, left: 24, top: 0, bottom: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                              ),
                                        ),
                                       Expanded(
                                           child: Text((evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi?.nombreCompleto??"").toUpperCase(),
                                               maxLines: 2,
                                               overflow: TextOverflow.ellipsis,
                                               style: TextStyle(
                                                 fontFamily: AppTheme.fontTTNorms,
                                                 fontWeight: FontWeight.w800,
                                                 fontSize: 14,
                                                 letterSpacing: 0.8,
                                                 color: AppTheme.darkerText,
                                               ))
                                       ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: ClipOval(
                                      child: Material(
                                        color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                        child: InkWell(
                                          splashColor: AppTheme.colorPrimary, // inkwell color
                                          child: SizedBox(width: 43 + 6, height: 43 + 6,
                                            child: Icon(Ionicons.close, size: 24 + 6,color: AppTheme.colorPrimary, ),
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
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                children: [
                                 Expanded(
                                     child:  Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Container(
                                           width: 60,
                                           height: 60,
                                           child: _getTipoNotaCabecera(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi, controller, position),
                                         ),
                                       ],
                                     )
                                 ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(titulo,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                letterSpacing: 0.8,
                                                color: AppTheme.darkerText,
                                              )
                                          ),
                                          Padding(padding: EdgeInsets.all(4)),
                                          if(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.intervalo??false)
                                          Text(controller.getRangoNota(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi))
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: DefaultTabController(
                                  length: 2,
                                  child: SizedBox(
                                    child: Column(
                                      children: <Widget>[
                                        TabBar(
                                          //physics: AlwaysScrollableScrollPhysics(),
                                          labelColor: getPosition(position),
                                          unselectedLabelColor: AppTheme.dark_grey,
                                          indicatorSize: TabBarIndicatorSize.tab,
                                          indicatorColor: getPosition(position),
                                          tabs: [
                                            Tab(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("LISTA"),
                                              ),
                                            ),
                                            Tab(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("TECLADO"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            color: AppTheme.colorShimmer,
                                            child: TabBarView(
                                              children: [
                                                CustomScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    slivers: <Widget>[
                                                      SliverPadding(
                                                        padding: EdgeInsets.only(left: 48, right: 48, top: 16, bottom: 16),
                                                        sliver: SliverList(
                                                            delegate: SliverChildListDelegate([

                                                            ])
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                                CustomScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    slivers: <Widget>[
                                                      SliverPadding(
                                                        padding: EdgeInsets.only(left: 48, right: 48, top: 16, bottom: 16),
                                                        sliver: SliverList(
                                                            delegate: SliverChildListDelegate([

                                                            ])
                                                        ),
                                                      ),
                                                    ]
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        if(false)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        })
        .then((value) => {
      if(statetDialogPresion!=null)controller.removeListener(statetDialogPresion!), statetDialogPresion = null
    });
  }


}
