import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro_crear/rubro_crear_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield_2.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipos_ui.dart';

class RubroCrearView extends View{
  CursosUi cursosUi;
  RubroUi? rubroUi;
  RubroCrearView(this.cursosUi, this.rubroUi);

  @override
  RubroCrearViewState createState() => RubroCrearViewState(cursosUi, rubroUi);

}
class RubroCrearViewState extends ViewState<RubroCrearView, RubroCrearController> with TickerProviderStateMixin{
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late final ScrollController verticalscrollController = ScrollController();
  late final ScrollControllers crollControllers = ScrollControllers();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  late WhyFarther _selection;

  String? _myActivity = null;
  RubroCrearViewState(cursosUi, rubroUi) : super(RubroCrearController(cursosUi, rubroUi));
  var _tiuloRubricacontroller = TextEditingController();

  int? selectedRow;
  int? selectedColumn;

  Color getContentColor(int i, int j) {
    if (i == selectedRow && j == selectedColumn) {
      return Colors.amber;
    } else if (i == selectedRow || j == selectedColumn) {
      return Colors.amberAccent;
    } else {
      return Colors.transparent;
    }
  }

  void clearState() => setState(() {
    selectedRow = null;
    selectedColumn = null;
  });

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



  }


  @override
  Widget get view =>
      Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              getMainTab(),
              getAppBarUI(),
              ControlledWidgetBuilder<RubroCrearController>(
                  builder: (context, controller) {
                    return controller.showDialog?ArsProgressWidget(
                        blur: 2,
                        backgroundColor: Color(0x33000000),
                        animationDuration: Duration(milliseconds: 500)
                    ):Container();
                  }
              )
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
                              icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                animationController.reverse().then<dynamic>((data) {
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pop(context, false);
                                });
                              },
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Crear evaluación',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            ControlledWidgetBuilder<RubroCrearController>(
                              builder: (context, controller) {

                                if(controller.mensaje!=null&&controller.mensaje!.isNotEmpty){
                                  Fluttertoast.showToast(
                                    msg: controller.mensaje!,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                  controller.successMsg();
                                }

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                    onTap: () {
                                      //if(widget.cabecera){
                                      //Navigator.pop(context, true);
                                      //}
                                      controller.onSave();
                                    },
                                    child:
                                    Container(
                                        padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
                                        child: Row(
                                          children: [
                                            Text("Guardar",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppTheme.colorAccent,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNormsMedium,
                                              ),),
                                          ],
                                        )
                                    ),
                                  ),
                                );
                              },
                            )
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


  int countView = 4;
  @override
  Widget getMainTab(){

    return ControlledWidgetBuilder<RubroCrearController>(
        builder: (context, controller) {

          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
              ),
              child:  AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext? context, Widget? child) {
                  return FadeTransition(
                    opacity: topBarAnimation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                      child:  Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: CustomScrollView(
                            controller: scrollController,
                            slivers: <Widget>[
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                                      child:  InkWell(
                                        onTap: (){
                                        },
                                        child: TextFormField(
                                          controller: _tiuloRubricacontroller,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context!).textTheme.caption?.copyWith(
                                            fontFamily: AppTheme.fontName,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Título de la rubica *",
                                            labelStyle: TextStyle(
                                                color:  AppTheme.colorPrimary,
                                                fontFamily: AppTheme.fontTTNormsMedium
                                            ),
                                            helperText: " ",
                                            contentPadding: EdgeInsets.all(15.0),
                                            prefixIcon: Icon(
                                              Ionicons.apps_outline,
                                              color: AppTheme.colorPrimary,
                                            ),

                                            suffixIcon:(controller.tituloRubrica?.isNotEmpty??false) ?
                                            IconButton(
                                              onPressed: (){
                                                controller.clearTitulo();
                                                _tiuloRubricacontroller.clear();
                                              },
                                              icon: Icon(
                                                Ionicons.close_circle,
                                                color: AppTheme.colorPrimary,
                                              ),
                                            ):null,
                                            errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary.withOpacity(0.5),
                                              ),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary,
                                              ),
                                            ),
                                            hintText: "Ingrese un título",
                                            hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 14,
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary,
                                              ),
                                            ),
                                            focusColor: AppTheme.colorAccent,
                                          ),
                                          onChanged: (str) {
                                            controller.changeTituloRubrica(str);
                                          },
                                          onSaved: (str) {
                                            //  To do
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                      child: DropDownFormField2<TiposUi>(
                                        inputDecoration: InputDecoration(
                                          labelText: "Forma de evaluación",
                                          labelStyle: TextStyle(
                                              color:  AppTheme.colorPrimary,
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 14,
                                          ),
                                          helperText: " ",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Icons.people_alt_outlined,
                                            color: AppTheme.colorPrimary,
                                          ),

                                          suffixIcon:  IconButton(
                                            onPressed: (){
                                              controller.clearTitulo();
                                              _tiuloRubricacontroller.clear();
                                            },
                                            icon: Icon(
                                              Ionicons.caret_down,
                                              color: AppTheme.colorPrimary,
                                            ),
                                            iconSize: 15,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                          ),
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                        ),
                                        onChanged: (item){

                                        },
                                        menuItems: controller.formaEvaluacionUiList.map<DropdownMenuItem<TiposUi>>((e) {
                                          return DropdownMenuItem<TiposUi>(child:
                                          Padding(
                                            padding: EdgeInsets.only(left: 32),
                                            child: Text(e.nombre??"", style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontSize: 15,
                                              color: Colors.black,),),
                                          )
                                            , value: e,);
                                        }).toList(),
                                        value: controller.formaEvaluacionUi,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                      child: DropDownFormField2<TiposUi>(
                                        inputDecoration: InputDecoration(
                                          labelText: "Tipo de evaluación",
                                          labelStyle: TextStyle(
                                              color:  AppTheme.colorPrimary,
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 14,
                                          ),
                                          helperText: " ",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Ionicons.apps_outline,
                                            color: AppTheme.colorPrimary,
                                          ),

                                          suffixIcon:  IconButton(
                                            onPressed: (){
                                              controller.clearTitulo();
                                              _tiuloRubricacontroller.clear();
                                            },
                                            icon: Icon(
                                              Ionicons.caret_down,
                                              color: AppTheme.colorPrimary,
                                            ),
                                            iconSize: 15,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                          ),
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                        ),
                                        onChanged: (item){

                                        },
                                        menuItems: controller.formaEvaluacionUiList.map<DropdownMenuItem<TiposUi>>((e) {
                                          return DropdownMenuItem<TiposUi>(child:
                                          Padding(
                                            padding: EdgeInsets.only(left: 32),
                                            child: Text(e.nombre??"", style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),),
                                          )
                                            , value: e,);
                                        }).toList(),
                                        value: controller.formaEvaluacionUi,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Container(),),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8, top: 4,right: 24),
                                          child: Icon(
                                            Ionicons.help_circle_outline,
                                            color: AppTheme.colorPrimary,
                                          ),
                                        )

                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 4),
                                      child:  InputDecorator(
                                        textAlign: TextAlign.start,
                                        decoration:  InputDecoration(
                                          labelText: "Promedio de logro",
                                          labelStyle: TextStyle(
                                              color:  AppTheme.colorPrimary,
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 14,
                                          ),
                                          helperText: "Opcional, puede dar clic en la interrogación para conocer más del promedio de logro seleccionado.",
                                          helperMaxLines: 3,
                                          helperStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontSize: 10,
                                          ),
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Container(padding: EdgeInsets.all(12), height: 15, width:15, child: SvgPicture.asset(AppIcon.ic_evaluar, color: AppTheme.colorPrimary),),
                                          suffixIcon:  IconButton(
                                            onPressed: (){
                                              controller.clearTitulo();
                                              _tiuloRubricacontroller.clear();
                                            },
                                            icon: Icon(
                                              Ionicons.ellipsis_vertical,
                                              color: AppTheme.colorPrimary,
                                            ),
                                            iconSize: 15,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                          ),
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                        ),
                                        child: Text("Selector de Caritas", style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 24, top: 16),
                                          child:  ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              primary: AppTheme.colorPrimary, // background
                                              onPrimary: Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              // Respond to button press
                                            },
                                            icon: SvgPicture.asset(AppIcon.ic_velocimetro, color: AppTheme.white, width: 18, height: 18,),
                                            label: Text("AGREGAR CRITERIO"),
                                          ),
                                        )
                                      ],
                                    ),

                                  ])
                              ),
                              SliverToBoxAdapter(
                                child:      Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                  child: SingleChildScrollView(
                                    child: StickyHeadersTableNotExpandedCustom(
                                        cellDimensions: CellDimensions.variableColumnWidth(
                                            stickyLegendHeight:45,
                                            stickyLegendWidth: 20,
                                            contentCellHeight: 45,
                                            columnWidths: [50, 45, 93, 70, 70,70, 45, 93, 70, 70,]
                                        ),
                                        //cellAlignments: CellAlignments.,
                                        scrollControllers: crollControllers,
                                        columnsLength: LandingPage.makeTitleColumn().length,
                                        rowsLength: LandingPage.makeTitleRow().length,
                                        columnsTitleBuilder: (i) => Container(
                                          child: Center(
                                            child:  Text(LandingPage.makeTitleColumn()[i]),
                                          ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(color: AppTheme.colorPrimary)
                                              ),
                                            )
                                        ),
                                        rowsTitleBuilder: (i) => Container(
                                            child: Center(
                                              child:  Text(LandingPage.makeTitleRow()[i]),
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(color: AppTheme.colorPrimary),
                                                  right: BorderSide(color: AppTheme.colorPrimary),
                                              ),
                                            )
                                        ),
                                        contentCellBuilder: (i, j) => Container(
                                          child: Center(
                                            child: Text(LandingPage.makeData()[i][j]),
                                          ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(color: AppTheme.colorPrimary),
                                                right: BorderSide(color: AppTheme.colorPrimary),
                                              ),
                                            )
                                        ),
                                        legendCell: Expanded(
                                          child: Container(
                                              child: Center(
                                                child: Text('N°'),
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(color: AppTheme.colorPrimary),
                                                ),
                                              )
                                          ),
                                        )
                                    ),
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
                      ),
                    ),
                  );
                },
              )
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class TableCell extends StatelessWidget {
  TableCell.content(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.white,
        this.onTap,
      })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.amber,
        this.onTap,
      })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.only(left: 24.0);

  TableCell.stickyRow(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.amber,
        this.onTap,
      })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.stickyColumn(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.white,
        this.onTap,
      })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.only(left: 24.0);

  final CellDimensions cellDimensions;

  final String text;
  final Function()? onTap;

  final double? cellWidth;
  final double? cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  text,
                  style: textStyle,
                  maxLines: 2,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}