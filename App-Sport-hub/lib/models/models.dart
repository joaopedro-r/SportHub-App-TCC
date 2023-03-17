import 'package:SportHub/models/tables/listagem.dart';
import 'package:SportHub/screens/SportHub/JogoPages/verJogo.dart';
import 'dart:async';
import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/screens/SportHub/cadastrarQuadra.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:lottie/lottie.dart' as lott;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';
import 'package:latlong2/latlong.dart';

class EditorGridView extends StatelessWidget {
  final String texto;
  final Color cor;
  final Function funcao;
  final IconData icone;

  const EditorGridView(this.texto, this.cor, this.funcao, this.icone);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: cor,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              color: Colors.tealAccent,
            ),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      onTap: () {
        funcao(context);
      },
    );
  }
}

class InputText1 extends StatelessWidget {
  TextEditingController? controlador;
  String? titulo;
  int? maximoCaracteres;
  TextInputType? tipoTexto;
  String? textoAjuda;
  String? textoDentro;
  IconData? icone;
  TextInputAction? acaoTeclado;
  Function? funcao;
  bool editable;
  InputText1({
    this.controlador,
    this.titulo,
    this.maximoCaracteres,
    this.tipoTexto,
    this.textoAjuda,
    this.textoDentro,
    this.icone,
    this.acaoTeclado,
    this.funcao,
    this.editable = true,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        enabled: editable,
        autofocus: false,
        controller: controlador,
        maxLength: maximoCaracteres,
        keyboardType: tipoTexto,
        cursorColor: Colors.black,
        textInputAction: acaoTeclado,
        onEditingComplete: () {
          if (funcao != null) {
            funcao!();
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: (icone != null) ? Icon(icone, color: cinza) : null,
          labelText: titulo,
          helperText: textoAjuda,
          hintText: textoDentro,
          hintStyle: TextStyle(fontSize: 14),
          labelStyle: TextStyle(
            color: azulEscuro,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: azulEscuro,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: cinza,
            ),
          ),
        ),
      ),
    );
  }
}

class InputText2 extends StatefulWidget {
  String label;
  TextEditingController? controlador;
  bool typeSenha;
  bool changeViewSenha;
  String maskType;
  TextInputType? tipoTeclado;
  bool lastInput;
  IconData? icone;
  int maximoCaracteres;
  bool loading;

  InputText2({
    required this.label,
    this.icone,
    this.loading = false,
    this.controlador,
    this.typeSenha = false,
    this.changeViewSenha = false,
    this.maskType = '',
    this.tipoTeclado,
    this.lastInput = false,
    this.maximoCaracteres = 100,
  });

  @override
  State<InputText2> createState() => _InputText2State();
}

class _InputText2State extends State<InputText2> {
  bool _showSenha = true;
  //mascara de data
  final _maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _size.height * .03),
      child: Container(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            (widget.loading == true)
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: _size.width * 0.8,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: preto,
                      ),
                    ),
                  )
                : TextField(
                    maxLength: widget.maximoCaracteres,
                    inputFormatters: (widget.maskType != '')
                        ? (widget.maskType == 'data')
                            ? [_maskFormatter]
                            : []
                        : [],
                    textInputAction: (widget.lastInput == false)
                        ? TextInputAction.next
                        : TextInputAction.done,
                    keyboardType: widget.tipoTeclado,
                    cursorColor: Colors.black,
                    controller: widget.controlador,
                    obscureText:
                        (widget.typeSenha == true) ? _showSenha : false,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: (widget.icone != null)
                          ? Icon(widget.icone, color: cinza)
                          : null,
                      hintText: widget.label,
                      labelStyle: TextStyle(
                        color: azulEscuro,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: azulEscuro,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: cinza,
                        ),
                      ),
                    ),
                  ),
            (widget.typeSenha == true)
                ? (widget.changeViewSenha == true)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _showSenha = !_showSenha;
                          });
                        },
                        icon: Icon((_showSenha == true)
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )
                    : Container()
                : Container()
          ],
        ),
      ),
    );
  }
}

class Button1 extends StatelessWidget {
  String label;
  Function? funcao;
  bool changeColors;
  bool sendContext;
  Button1(
      {required this.label,
      this.funcao,
      this.changeColors = false,
      this.sendContext = false});
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: (changeColors == true) ? Colors.transparent : azulEscuro,
        elevation: (changeColors == true) ? 0 : 5,
        side: (changeColors == true)
            ? BorderSide(
                color: verde,
                width: 1,
              )
            : null,
        fixedSize: Size(_size.width * 0.6, _size.height * 0.07),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        if (funcao != null) {
          if (sendContext == true) {
            funcao!(context);
          } else {
            funcao!();
          }
        }
      },
      child: Text(
        label,
        style: TextStyle(
            fontFamily: fontePrincipal,
            fontSize: 18,
            color: (changeColors == true) ? azulEscuro : Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Mapa extends StatefulWidget {
  flutterMap.MapController? mapController;
  double? pontoLatitude;
  double? pontoLongitude;
  double? inicialLatitude;
  double? inicialLongitude;
  bool showPointer;
  Mapa({
    this.mapController,
    this.showPointer = false,
    this.pontoLatitude,
    this.pontoLongitude,
    this.inicialLatitude,
    this.inicialLongitude,
  });

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  List<Marker> _markers = <Marker>[];
  double? _latitude;
  double? _longitude;
  double? _myLatitude;
  double? _myLongitude;
  bool _isMapReady = false;
  bool _localizacaoActive = false;

  Future _loadGamesMapa() async {
    print(widget.pontoLatitude);
    print(widget.pontoLongitude);
    var response = await sendRequest(context,
        endPoint: 'localizacao/todos', method: 'GET');
    if (response != null) {
      for (var item in response) {
        var flutterMapmarker = flutterMap.Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(item['latitude'], item['longitude']),
          builder: (ctx) => InkWell(
            onTap: () {
              showLocInfo(item);
            },
            child: Container(
              decoration: BoxDecoration(
                color: verde,
                shape: BoxShape.circle,
                image:
                    //(item['grupo']['modalidade']['fotoModalidade'] == null)
                    //    ?
                    //DecorationImage(
                    //    image: AssetImage(
                    //        'assets/images/modelos/imagensEsportes/esportesGerais1.jpg'),
                    //    fit: BoxFit.cover,
                    //  )
                    //:
                    DecorationImage(
                        image: AssetImage('assets/images/app/quadra.png'),
                        fit: BoxFit.fitHeight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
        );
        setState(() {
          _markers.add(flutterMapmarker);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.mapController == null) {
      controlador = flutterMap.MapController();
    } else {
      controlador = widget.mapController;
    }
    getLoc().then((value) {
      if (value != null) {
        setState(() {
          if (widget.inicialLatitude != null &&
              widget.inicialLongitude != null) {
            _latitude = widget.inicialLatitude;
            _longitude = widget.inicialLongitude;
          } else {
            _latitude = value.latitude;
            _longitude = value.longitude;
          }
          _myLatitude = value.latitude;
          _myLongitude = value.longitude;
          if (widget.pontoLatitude != null && widget.pontoLongitude != null) {
            widget.pontoLatitude = value.latitude;
            widget.pontoLongitude = value.longitude;
          }
        });
        _loadGamesMapa().then((value) {
          setState(() {
            _localizacaoActive = true;
            _isMapReady = true;
          });
        });
      } else {
        setState(() {
          _localizacaoActive = false;
          _isMapReady = true;
        });
      }
    });
  }

  var controlador;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return (_isMapReady == false)
        ? Stack(
            children: [
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: _size.width,
                  height: _size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: preto,
                  ),
                ),
              ),
              Center(
                  child: CarregarPagina(
                texto: 'Carregando...',
              )),
            ],
          )
        : (_localizacaoActive == false)
            ? Center(
                child: Text(
                  'Ative a sua localização',
                  style: TextStyle(fontFamily: fontePrincipal, fontSize: 20),
                ),
              )
            : Container(
                width: _size.width,
                height: _size.height,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    flutterMap.FlutterMap(
                      mapController: controlador,
                      options: flutterMap.MapOptions(
                        center: LatLng(
                          _latitude!,
                          _longitude!,
                        ),
                        zoom: 16,
                        maxZoom: 18,
                        interactiveFlags:
                            InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                      layers: [
                        flutterMap.TileLayerOptions(
                            urlTemplate:
                                "https://api.maptiler.com/maps/streets/{z}/{x}/{y}@2x.png?key=9Np9JnVrCrKrmcIdLm3l",
                            //    "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=9Np9JnVrCrKrmcIdLm3l",
                            //2 - "https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}@2x.png?key=9Np9JnVrCrKrmcIdLm3l",
                            //3 - "https://api.maptiler.com/maps/openstreetmap/{z}/{x}/{y}@2x.jpg?key=9Np9JnVrCrKrmcIdLm3l",
                            //4 - "https://api.maptiler.com/maps/topo-v2/{z}/{x}/{y}@2x.png?key=9Np9JnVrCrKrmcIdLm3l",
                            subdomains: ['a', 'b', 'c']),
                        flutterMap.MarkerLayerOptions(
                          markers: (widget.showPointer == true)
                              ? [
                                  flutterMap.Marker(
                                    point: LatLng(
                                      _myLatitude!,
                                      _myLongitude!,
                                    ),
                                    builder: (context) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade500,
                                        shape: BoxShape.circle,
                                        //adicionar contorno
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ..._markers,
                                  flutterMap.Marker(
                                    point: LatLng(
                                      widget.pontoLatitude!,
                                      widget.pontoLongitude!,
                                    ),
                                    builder: (context) => const Icon(
                                      Icons.location_on,
                                      size: 50,
                                      color: verdeEscuro,
                                    ),
                                  ),
                                ]
                              : [
                                  flutterMap.Marker(
                                      width: 35.0,
                                      height: 35.0,
                                      point: LatLng(
                                        _myLatitude!,
                                        _myLongitude!,
                                      ),
                                      builder: (context) => Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade500,
                                              shape: BoxShape.circle,
                                              //adicionar contorno
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4.0,
                                              ),
                                            ),
                                          )),
                                  ..._markers
                                ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 80,
                      child: Column(
                        children: [
                          (widget.inicialLatitude != null &&
                                  widget.inicialLongitude != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        //mover o mapa para a minha localização
                                        if (widget.mapController == null) {
                                          controlador.move(
                                              LatLng(widget.inicialLatitude!,
                                                  widget.inicialLongitude!),
                                              16);
                                        } else {
                                          widget.mapController!.move(
                                              LatLng(widget.inicialLatitude!,
                                                  widget.inicialLongitude!),
                                              16);
                                        }

                                        widget.pontoLatitude =
                                            widget.inicialLatitude!;
                                        widget.pontoLongitude =
                                            widget.inicialLongitude!;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.sports_soccer,
                                      color: azul,
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  //mover o mapa para a minha localização
                                  if (widget.mapController == null) {
                                    controlador.move(
                                        LatLng(_myLatitude!, _myLongitude!),
                                        16);
                                  } else {
                                    widget.mapController!.move(
                                        LatLng(_myLatitude!, _myLongitude!),
                                        16);
                                  }

                                  widget.pontoLatitude = _myLatitude;
                                  widget.pontoLongitude = _myLongitude;
                                });
                              },
                              icon: Icon(
                                Icons.gps_fixed,
                                color: azul,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }

  void showLocInfo(Map dados) {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          var _size = MediaQuery.of(context).size;
          return AlertDialog(
            title: Text(dados['nome']),
            content: Container(
              width: _size.width * 0.8,
              height: _size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //mostrar as modaliades de lado
                  (dados['modalidades'].length > 0)
                      ? Container(
                          height: _size.height * 0.1,
                          child: ListView.builder(
                            itemCount: dados['modalidades'].length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Tooltip(
                                message: dados['modalidades'][index]
                                    ['idModalidade']['nome'],
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _size.width * 0.02),
                                  child: CircleAvatar(
                                    backgroundColor: azul,
                                    child: Image(
                                      image: NetworkImage(
                                          '$urlBasica${dados['modalidades'][index]['idModalidade']['fotoModalidade']}'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: _size.height * 0.02),
                          child: Text(
                            'Ainda não há modalidades cadastradas',
                          ),
                        ),
                  Text('BAIRRO', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${dados['bairro']}'),
                  Text('\nRUA', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${dados['rua']}'),
                  (dados['complemento'] != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\nPONTO DE REFERÊNCIA',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${dados['complemento']}'),
                          ],
                        )
                      : Container(),

                  Text('\nAGENDAMENTOS',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dados['jogos'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        //pegar e converter data e horario
                        var dataHora = dados['jogos'][index]['dataHora'];
                        //coverter para DateTime e utc local
                        var dataHoraConvertidaParse =
                            DateTime.parse(dataHora).toLocal();
                        var dataHoraConvertida =
                            dataHoraConvertidaParse.toString();

                        var data = dataHoraConvertida.split(' ')[0];
                        //formatar data
                        var dataFormatada = data.split('-');
                        var dataFinal = dataFormatada[2] +
                            '/' +
                            dataFormatada[1] +
                            '/' +
                            dataFormatada[0];

                        var hora = dataHoraConvertida.split(' ')[1];
                        //formatar hora
                        var horaFormatada = hora.split(':');
                        var horaFinal =
                            horaFormatada[0] + ':' + horaFormatada[1];
                        print(dados);
                        return Card(
                          child: ListTile(
                              title: Row(
                                children: [
                                  (dados['jogos'][index]['privado'] == true)
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: _size.width * 0.02),
                                          child: Icon(
                                            Icons.lock,
                                            color: verdeClaro,
                                            size: _size.width * 0.05,
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    '${dados['jogos'][index]['nome']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${dados['jogos'][index]['grupo']['modalidade']['nome']}'),
                                  Text('$dataFinal - $horaFinal'),
                                ],
                              ),
                              trailing:
                                  (dados['jogos'][index]['privado'] == true)
                                      ? null
                                      : TextButton(
                                          style: TextButton.styleFrom(
                                            primary: verdeClaro,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, _, __) =>
                                                    VerJogo(
                                                  idJogo: dados['jogos'][index]
                                                      ['idJogo'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('ver'),
                                        )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Fechar',
                  style: TextStyle(color: azulEscuro),
                ),
              ),
              (widget.pontoLatitude != null && widget.pontoLongitude != null)
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, dados);
                      },
                      child: Text(
                        'Marcar',
                        style: TextStyle(color: azulEscuro),
                      ),
                    )
                  : Container(),
              (widget.pontoLatitude != null && widget.pontoLongitude != null)
                  ? TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, _, __) => CadastroQuadra(
                              dadosQuadra: dados,
                              isedit: true,
                            ),
                          ),
                        ).then((value) {
                          Navigator.pop(context);
                          if (value != null) {
                            Navigator.pop(context, value);
                          }
                        });
                      },
                      child: Text(
                        'Editar informações',
                        style: TextStyle(color: azulEscuro),
                      ),
                    )
                  : Container(),
            ],
          );
        });
  }
}

class ProgressRegister extends StatelessWidget {
  int nivel;
  ProgressRegister({required this.nivel});
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: verde,
      ),
      height: 6,
      width: (_size.width * 0.2) * nivel,
    );
  }
}

class CardMeusJogos extends StatelessWidget {
  String imagem;
  String titulo;
  String modalidade;
  String data;
  String hora;
  String local;
  String iconemodalidade;
  bool confirmado;
  Map rota;
  int idJogo;
  Function funcao;
  int index;

  CardMeusJogos({
    required this.imagem,
    required this.titulo,
    required this.modalidade,
    required this.data,
    required this.hora,
    required this.local,
    required this.iconemodalidade,
    required this.confirmado,
    required this.rota,
    required this.idJogo,
    required this.funcao,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(_size.width * 0.02),
      child: InkWell(
        onTap: () {
          funcao(index);
        },
        child: Container(
          width: _size.width * .8,
          padding: EdgeInsets.all(_size.width * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            image: DecorationImage(
              image: AssetImage(imagem),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      (titulo.length > 13)
                          ? titulo.substring(0, 13) + '...'
                          : titulo,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: fontePrincipal,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      modalidade,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: fontePrincipal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: _size.height * 0.01),
                      child: Image(
                        image: NetworkImage('$urlBasica$iconemodalidade'),
                        width: _size.width * 0.07,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    data,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontePrincipal,
                    ),
                  ),
                  Text(
                    hora,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontePrincipal,
                    ),
                  ),
                  Text(
                    local,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontePrincipal,
                    ),
                  ),
                  Text(
                    (confirmado == false)
                        ? "Não confirmado ❌"
                        : "Confirmado ✔️",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontePrincipal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarregarPagina extends StatelessWidget {
  String? texto;
  CarregarPagina({this.texto});
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lott.Lottie.asset('assets/Animations/animacao carregamento mod.json',
              fit: BoxFit.fill,
              height: _size.height * 0.18,
              frameRate: lott.FrameRate.max),
          (texto != null)
              ? Padding(
                  padding: EdgeInsets.only(
                    top: _size.height * 0.01,
                  ),
                  child: Text(
                    texto!,
                    style: TextStyle(fontFamily: fontePrincipal, fontSize: 18),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class ButtonPerfil extends StatelessWidget {
  Size _size;
  String text;
  Icon icon;
  Widget? rota;
  Function? funcao;

  ButtonPerfil({
    Key? key,
    required Size size,
    required this.text,
    required this.icon,
    this.funcao,
    this.rota,
  })  : _size = size,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _size.width * .05, vertical: _size.height * .01),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: branco,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          if (funcao != null) {
            funcao!();
          } else {
            if (rota != null) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secAnimation) => rota!,
                  transitionsBuilder:
                      (context, animation, secAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1, 0),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            }
          }
        },
        child: Container(
          height: _size.height * 0.08,
          child: Row(
            children: [
              icon,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: preto,
                        fontFamily: fontePrincipal,
                        //fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: preto,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CarregarFoto extends StatelessWidget {
  bool loading;
  Map? dadosUser;
  double? size;
  String? foto;
  String? fotocompleta;

  CarregarFoto({
    required this.loading,
    required this.dadosUser,
    this.size = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    String? foto = dadosUser!['fotoPerfil'];

    return loading
        ? Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child:
                CircleAvatar(backgroundColor: Colors.grey[300]!, radius: size),
          )
        : CircleAvatar(
            backgroundColor: verde,
            radius: size,
            backgroundImage:
                (foto == null) ? null : NetworkImage('$urlBasica$foto'),
            child: (foto == null)
                ? Text(
                    '${dadosUser!['inicialNome']}',
                    style: TextStyle(
                      fontFamily: fontePrincipal,
                      color: branco,
                      fontSize: 30,
                    ),
                  )
                : null);
  }
}

class CarregamentoNome extends StatelessWidget {
  String conteudo;
  Color corfonte;
  final bool _loading;
  final Size _size;
  final Map _dadosUser;

  CarregamentoNome({
    Key? key,
    required bool loading,
    required Size size,
    required Map dadosUser,
    required this.conteudo,
    required this.corfonte,
  })  : _loading = loading,
        _size = size,
        _dadosUser = dadosUser,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _loading
          ? Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: _size.width * 0.4,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: preto,
                ),
              ),
            )
          : Text(
              conteudo,
              style: TextStyle(
                fontFamily: fontePrincipal,
                fontSize: 20,
                color: corfonte,
              ),
            ),
    );
  }
}

class ListaPlayerSelect extends StatefulWidget {
  List jogadores;
  int time;
  String type;
  ListaPlayerSelect(
      {required this.jogadores, required this.time, required this.type});

  @override
  State<ListaPlayerSelect> createState() => _ListaPlayerSelectState();
}

class _ListaPlayerSelectState extends State<ListaPlayerSelect> {
  int _jogadorValue = 0;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 10,
              thickness: 5,
              color: Colors.cyan.shade800,
            ),
            EditorEquipes((widget.type == 'ponto')
                ? 'Quem fez o ponto?'
                : 'Quem vai sair?'),
            Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                //padding: EdgeInsets.symmetric(horizontal: 20),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.jogadores.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: Text('${widget.jogadores[index].nome}'),
                    leading: Radio(
                      value: index,
                      groupValue: _jogadorValue,
                      onChanged: (int? value) {
                        setState(() {
                          _jogadorValue = value!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            (widget.type == 'ponto')
                ? Container(
                    padding: EdgeInsets.only(left: 10),
                    child: ListTile(
                      title: Text(
                        'Não selecionar jogador',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                      leading: Radio(
                        value: -1,
                        groupValue: _jogadorValue,
                        onChanged: (int? value) {
                          setState(() {
                            _jogadorValue = value!;
                          });
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        Container(
          width: _size.width * 0.6,
          child: (widget.type == 'ponto')
              ? Button1(
                  label: 'Marcar o ponto',
                  funcao: _marcarPonto,
                )
              : Button1(
                  label: 'Substituir jogador',
                  funcao: _substituir,
                ),
        )
      ],
    );
  }

  void _marcarPonto() {
    //print(widget.time);
    //print(_jogadorValue);

    String nomeJogador = '';
    if (_jogadorValue == -1) {
      nomeJogador = 'Jogador não selecionado';
      return Navigator.pop(this.context, [widget.time, nomeJogador]);
    }

    if (widget.time == 0) {
      jogoGlobal.jogadores[_jogadorValue].pontos++;
      nomeJogador = jogoGlobal.jogadores[_jogadorValue].nome;
    } else {
      jogoGlobal.jogadores[jogoGlobal.numeroJogadoresPorTime + _jogadorValue]
          .pontos++;
      nomeJogador = jogoGlobal
          .jogadores[jogoGlobal.numeroJogadoresPorTime + _jogadorValue].nome;
    }
    return Navigator.pop(this.context, [widget.time, nomeJogador]);
  }

  void _substituir() {
    String saiu;
    String entrou =
        jogoGlobal.jogadores[jogoGlobal.numeroJogadoresPorTime * 2].nome;
    if (widget.time == 0) {
      saiu = jogoGlobal.jogadores[_jogadorValue].nome;
      jogoGlobal.substituirPlayer(_jogadorValue);
    } else {
      saiu = jogoGlobal
          .jogadores[jogoGlobal.numeroJogadoresPorTime + _jogadorValue].nome;
      jogoGlobal
          .substituirPlayer(jogoGlobal.numeroJogadoresPorTime + _jogadorValue);
    }

    Navigator.pop(this.context, [entrou, saiu]);
  }
}

class EditorEquipes extends StatelessWidget {
  String texto;

  EditorEquipes(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 24, color: Colors.teal.shade900),
      ),
    );
  }
}

class CardMembros extends StatelessWidget {
  String nome;
  String apelido;
  String? foto;
  bool viewAdm;
  int idUsuarioBD;
  bool isAdmin;

  CardMembros({
    required this.nome,
    required this.apelido,
    required this.foto,
    required this.idUsuarioBD,
    this.viewAdm = false,
    this.isAdmin = false,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (foto == null)
              ? NetworkImage(
                  'https://media.discordapp.net/attachments/846919745050902539/1052055534523658392/avatar.png')
              : NetworkImage('$urlBasica$foto'),
        ),
        title: Row(
          children: [
            Text(nome),
            (isAdmin == true) ? Icon(Icons.admin_panel_settings) : Container(),
          ],
        ),
        subtitle: Text('#$idUsuarioBD'),
        trailing: //popUpMenu
            (viewAdm == true)
                ? (isAdmin == false)
                    ? PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Remover'),
                            value: 1,
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            print('Remover');
                          }
                        },
                      )
                    : null
                : null,
      ),
    );
  }
}
