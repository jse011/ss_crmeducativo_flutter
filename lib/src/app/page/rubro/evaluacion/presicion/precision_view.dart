import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_valor_tipo_nota_presicion.dart';

class PresicionView extends StatefulWidget {
  ValorTipoNotaUi? valorTipoNotaUi;
  PersonaUi? personaUi;
  Color? color;


  PresicionView(this.valorTipoNotaUi, this.personaUi, this.color);

  @override
  _PresicionView createState() => _PresicionView();
}

class _PresicionView extends State<PresicionView> {
  GetValorTipoNotaPresicion _getValorTipoNotaPresicion;
  _PresicionView():
  this._getValorTipoNotaPresicion = GetValorTipoNotaPresicion();

  @override
  Widget build(BuildContext context) {

    String titulo = "";
    if(widget.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
      titulo =  widget.valorTipoNotaUi?.alias??"";
    }else{
      titulo =  widget.valorTipoNotaUi?.alias??"";
    }

    String descripcion = widget.valorTipoNotaUi?.tipoNotaUi?.nombre??"";
    if(widget.valorTipoNotaUi?.tipoNotaUi?.intervalo??false){

    }else{

    }
    List<int> presicionList = _getValorTipoNotaPresicion.execute(widget.valorTipoNotaUi);

    return Container(
      decoration: new BoxDecoration(
        color: AppTheme.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: Stack(
              children: [
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
                ),
                Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 70),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        placeholder: (context, url) => CircularProgressIndicator(),
                        imageUrl: widget.personaUi?.foto??"",
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
                          child: Text((widget.personaUi?.nombreCompleto??"").toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 0.8,
                                color: AppTheme.darkerText,
                              ))
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
              )
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
              )
          )
        ],
      ),
    );

  }


}