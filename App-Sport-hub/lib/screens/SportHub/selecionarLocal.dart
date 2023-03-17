import 'dart:async';

import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/cadastrarQuadra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;

class SelecionarLocal extends StatefulWidget {
  @override
  State<SelecionarLocal> createState() => _SelecionarLocalState();
}

class _SelecionarLocalState extends State<SelecionarLocal> {
  double _latitudeInicial = 0;
  double _longitudeInicial = 0;

  flutterMap.MapController mapController = flutterMap.MapController();
  late StreamSubscription subscription;
  bool enableButton = true;
  bool addLocal = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mapController.onReady.then((value) {
      subscription = mapController.mapEventStream.listen((event) {
        if (event is flutterMap.MapEventMove) {
          setState(() {
            _latitudeInicial = event.center.latitude;
            _longitudeInicial = event.center.longitude;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Selecionar Local'),
        actions: [
          IconButton(
            icon: Icon((addLocal == false)
                ? Icons.add_location_alt
                : Icons.select_all),
            onPressed: () {
              setState(() {
                if (addLocal == false) {
                  addLocal = true;
                } else {
                  addLocal = false;
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Mapa(
            mapController: mapController,
            showPointer: addLocal,
            pontoLatitude: _latitudeInicial,
            pontoLongitude: _longitudeInicial,
          ),
          (addLocal == true)
              ? Positioned(
                  bottom: _size.height * 0.05,
                  child: Button1(
                    label: 'SELECIONAR',
                    funcao: (enableButton == true) ? selecionarLocal : null,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future selecionarLocal() async {
    //print(mapController.center);
    if (_latitudeInicial == null || _longitudeInicial == null) {
      showToast(context,
          texto: 'Não foi possível determinar a localização', cor: Colors.red);

      return null;
    }
    setState(() {
      enableButton = false;
    });

    var response = await sendRequest(
      context,
      endPoint: 'localizacao/ver/$_latitudeInicial/$_longitudeInicial',
      method: 'GET',
      showErrorMsg: true,
    );

    if (response == null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Quadra não cadastrada'),
              content: Text(
                  'Para agendar aqui é necessário cadastrar essa quadra.\n\nIsso ajudará a '
                  'comunidade a encontrar quadras próximas!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      enableButton = true;
                    });
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: azulEscuro,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await irCadastrar();
                  },
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: azulEscuro,
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            var _size = MediaQuery.of(context).size;
            return AlertDialog(
              title: Text('Selecione uma quadra?'),
              content: Container(
                width: _size.width * 0.8,
                height: _size.height * 0.5,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: response.length,
                  itemBuilder: (context, index) {
                    print(response[index]);
                    return ListTile(
                      title: Text(response[index]['nome']),
                      subtitle: Text(response[index]['rua']),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context, response[index]);
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      enableButton = true;
                    });
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: azulEscuro,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await irCadastrar();
                  },
                  child: Text(
                    'Cadastrar outra quadra',
                    style: TextStyle(
                      color: azulEscuro,
                    ),
                  ),
                ),
              ],
            );
          });

      //await getAddressFromLatLng(_latitudeInicial!, _longitudeInicial!)
      //    .then((value) {
      //  value['latitude'] = _latitudeInicial;
      //  value['longitude'] = _longitudeInicial;
//
      //  Navigator.pop(context, value);
      //});
    }
  }

  Future irCadastrar() async {
    await getAddressFromLatLng(_latitudeInicial, _longitudeInicial)
        .then((value) {
      value['latitude'] = _latitudeInicial;
      value['longitude'] = _longitudeInicial;

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => CadastroQuadra(dadosQuadra: value),
        ),
      ).then((value) {
        if (value != null) {
          Navigator.pop(context);
          Navigator.pop(context, value);
        } else {
          Navigator.pop(context);
          setState(() {
            enableButton = true;
          });
        }
      });
    });
  }
}
