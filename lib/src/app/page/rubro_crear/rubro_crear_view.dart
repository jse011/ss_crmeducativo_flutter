import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro_crear/rubro_crear_controller.dart';
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
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  late WhyFarther _selection;

  String? _myActivity = null;
  RubroCrearViewState(cursosUi, rubroUi) : super(RubroCrearController(cursosUi, rubroUi));
  var _tiuloRubricacontroller = TextEditingController();
  var _formaEvaluacioncontroller = TextEditingController(text: "Grupal");
  var _formaEvaluacionfocusNode = FocusNode();
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
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontTTNormsMedium,
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
                                              fontFamily: AppTheme.fontTTNormsMedium
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
                                            child: Text(e.nombre??""),
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
                                              fontFamily: AppTheme.fontTTNormsMedium
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
                                            child: Text(e.nombre??""),
                                          )
                                            , value: e,);
                                        }).toList(),
                                        value: controller.formaEvaluacionUi,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                      child:  TextFormField(
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        initialValue: '',
                                        //controller: accountController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: "Fecha de nacimiento",
                                          labelStyle: TextStyle(
                                            color:  AppTheme.colorPrimary,
                                          ),
                                          helperText: "Desabiliado",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          suffixIcon: Icon(
                                            Icons.today_outlined,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          hintText: "Ingrese su fecha de nacimiento",
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          focusColor: AppTheme.colorAccent,
                                        ),
                                        onChanged: (str) {
                                          // To do
                                        },
                                        onSaved: (str) {
                                          //  To do
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                      child:  TextFormField(
                                        enabled: true,
                                        maxLength: 50,
                                        autofocus: false,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        initialValue: '',
                                        //controller: accountController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: "Número de telefono",
                                          labelStyle: TextStyle(
                                            color:  AppTheme.colorPrimary,
                                          ),
                                          helperText: "Actualice su telefono",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          suffixIcon: Icon(
                                            Icons.call_end_outlined,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          hintText: "Ingrese su número de telefono",
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          focusColor: AppTheme.colorAccent,
                                        ),
                                        onChanged: (str) {


                                        },
                                        onSaved: (str) {
                                          //  To do
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                      child:  TextFormField(
                                        maxLength: 50,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context).textTheme.caption?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        initialValue: '',
                                        //controller: accountController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: "Correo",
                                          labelStyle: TextStyle(
                                            color:  AppTheme.colorPrimary,
                                          ),
                                          helperText: "Actualice su correo",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          suffixIcon: Icon(
                                            Icons.email_outlined,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          hintText: "Ingrese su correo",
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          focusColor: AppTheme.colorAccent,
                                        ),
                                        onChanged: (str) {

                                        },
                                        onSaved: (str) {
                                          //  To do
                                        },
                                      ),
                                    ),
                                  ])
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
    _tiuloRubricacontroller.dispose();
  }

}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }