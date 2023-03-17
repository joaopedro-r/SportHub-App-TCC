import 'dart:io';
import 'dart:convert';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:SportHub/screens/FutRua/elencos.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;

String jsonString = '';

//Future<void> save_map(num_equipes, String nome, context) async {
//  Map<String, dynamic> partida_map = Map();
//  Map<String, dynamic> times_map = Map();
//  Map<String, dynamic> jogadores_map = Map();
//
//  for (int a = 0; a < num_equipes; a++) {
//    times_map[globals.equipes[a].nome] = {
//      'nome': globals.equipes[a].nome,
//      'jogadores': {}
//    };
//    for (var b in globals.equipes[a].jogadores) {
//      times_map[globals.equipes[a].nome]['jogadores'][b.nome] = {
//        'nome': b.nome,
//        'time': b.time,
//        'gols_marcados': b.gols_marcados,
//        'jogos': b.jogos,
//        'vitorias': b.vitorias,
//        'derrotas': b.derrotas,
//        'empates': b.empates
//      };
//    }
//  }
//
//  for (var times in times_map.values) {
//    for (var jogadores in times['jogadores'].values) {
//      jogadores_map[jogadores['nome']] = {
//        'nome': jogadores['nome'],
//        'time': jogadores['time'],
//        'gols_marcados': jogadores['gols_marcados'],
//        'jogos': jogadores['jogos'],
//        'vitorias': jogadores['vitorias'],
//        'derrotas': jogadores['derrotas'],
//        'empates': jogadores['empates']
//      };
//    }
//  }
//  if (globals.proximas.length > 0) {
//    for (var proxima in globals.proximas) {
//      jogadores_map[proxima.nome] = {
//        'nome': proxima.nome,
//        'time': proxima.time,
//        'gols_marcados': proxima.gols_marcados,
//        'jogos': proxima.jogos,
//        'vitorias': proxima.vitorias,
//        'derrotas': proxima.derrotas,
//        'empates': proxima.empates
//      };
//    }
//  }
//  globals.partida_map[nome] = {
//    'jogadores': jogadores_map,
//    'times': times_map,
//  };
//
//  //print(globals.partida_map);
//
//  //tojsonmap();
//
//  Map bodyRequest = {
//    'idJogo': globals.idJogo,
//    'informacoes': globals.partida_map,
//  };
//  await sendRequest(
//    context,
//    endPoint: 'jogo/addDoc',
//    method: 'PUT',
//    body: bodyRequest,
//  );

//print(jogadores_map);
//print('================');
//print(times_map);
//}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/dataFutRua.json');
}

Future<File> writeCounter(String data) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString(data);
}

Future<Map<String, dynamic>> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();
    Map<String, dynamic> partidaMap = jsonDecode(contents);

    return partidaMap;
  } catch (e) {
    // If encountering an error, return 0
    return {};
  }
}

//tojsonmap() {
//  jsonString = jsonEncode(globals.partida_map);
//  writeCounter(jsonString);
//  return jsonString;
//}

void showToast(context,
    {required String texto, int duracao = 5, Color cor = verdeEscuro}) {
  var fToast = FToast();
  fToast.init(context);

  fToast.showToast(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: cor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
        ],
      ),
    ),
    toastDuration: Duration(seconds: duracao),
    gravity: ToastGravity.BOTTOM,
  );
}

addSession(session) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('sessionid', session);
}

removeSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('sessionid');
}

Future sendRequest(
  context, {
  required String endPoint,
  required String method,
  body,
  bool showSuccessMsg = false,
  bool showErrorMsg = false,
  bool loginMethod = false,
  bool logoutMethod = false,
  bool multipart = false,
  List<XFile>? files,
}) async {
  var response;
  if (body == null) {
    body = {};
  }
  try {
    if (multipart == true) {
      response =
          http.MultipartRequest(method, Uri.parse('$urlBasica/$endPoint'));
      response.headers.addAll(headersWebService);
      response.fields.addAll(body);
      for (XFile image in files!) {
        response.files
            .add(await http.MultipartFile.fromPath('imagens', image.path));
      }
      response = await response.send();
      response = await http.Response.fromStream(response);
    } else {
      if (method == 'GET') {
        response = await http.get(
          Uri.parse("$urlBasica/$endPoint"),
          headers: headersWebService,
        );
      } else if (method == 'POST') {
        response = await http.post(
          Uri.parse("$urlBasica/$endPoint"),
          headers: headersWebService,
          body: jsonEncode(body),
        );
      } else if (method == 'PUT') {
        response = await http.put(
          Uri.parse("$urlBasica/$endPoint"),
          headers: headersWebService,
          body: jsonEncode(body),
        );
      } else if (method == 'DELETE') {
        response = await http.delete(
          Uri.parse("$urlBasica/$endPoint"),
          headers: headersWebService,
          body: jsonEncode(body),
        );
      } else {
        return null;
      }
    }
  } catch (e) {
    print(e);
    showToast(context,
        texto: mensagemNoConnection, cor: Colors.redAccent, duracao: 5);
    return null;
  }

  if (logoutMethod == true) {
    String? cookies = response.headers['set-cookie'];
    headersWebService['Cookie'] = cookies!;
    removeSession();
  }

  var _data = jsonDecode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 200 || response.statusCode == 202) {
    if (loginMethod == true) {
      String? cookie = response.headers['set-cookie'];
      addSession(cookie);
      headersWebService['Cookie'] = cookie!;
    }
    if (showSuccessMsg == true) {
      showToast(context, texto: _data['message'], duracao: 5);
    }
    return _data;
  } else {
    if (showErrorMsg == true) {
      showToast(context,
          texto: _data['message'], cor: Colors.redAccent, duracao: 5);
    }
    return null;
  }
}

Future getAddressFromLatLng(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude,
        localeIdentifier: 'pt_BR');

    return placemarks[1].toJson();
  } catch (e) {}
}

Future getLoc() async {
  var location = loc.Location();
  late loc.PermissionStatus _permissionGranted;
  late bool _serviceEnabled;
  late loc.LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == loc.PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != loc.PermissionStatus.granted) {
      return;
    }
  }
  location.changeSettings(accuracy: loc.LocationAccuracy.high);
  _locationData = await location.getLocation();
  return _locationData;
}

Future<void> mostrarElencos(context) async {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secAnimation) => Elencosclass(),
      transitionsBuilder: (context, animation, secAnimation, child) {
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
