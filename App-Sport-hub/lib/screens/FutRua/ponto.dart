import 'package:SportHub/models/models.dart';
import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';

//import 'package:SportHub/Componets/globals.dart' as globals;

class MarcarPonto extends StatefulWidget {
  @override
  _MarcarPontoState createState() => _MarcarPontoState();
}

class _MarcarPontoState extends State<MarcarPonto> {
  bool value = false;
  int _groupValue = -1;
  bool showlistPlayers = false;
  late List seletedTeam;

  Widget lista = Container();

  @override
  Widget build(BuildContext context) {
    List timeA = [];
    List timeB = [];

    for (var i = 0; i < jogoGlobal.numeroJogadoresPorTime * 2; i++) {
      if (i < jogoGlobal.numeroJogadoresPorTime) {
        timeA.add(jogoGlobal.jogadores[i]);
      } else {
        timeB.add(jogoGlobal.jogadores[i]);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcar ponto'),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditorEquipes('Ponto para:'),
          ListTile(
            title: Text('Time A'),
            leading: Radio(
                value: 0,
                groupValue: _groupValue,
                onChanged: (int? value) {
                  setState(() {
                    _groupValue = value!;
                    showlistPlayers = true;
                    seletedTeam = timeA;
                  });
                }),
          ),
          ListTile(
            title: Text('Time B'),
            leading: Radio(
                value: 1,
                groupValue: _groupValue,
                onChanged: (int? value) {
                  setState(() {
                    _groupValue = value!;
                    showlistPlayers = true;
                    seletedTeam = timeB;
                  });
                }),
          ),
          (showlistPlayers)
              ? ListaPlayerSelect(
                  jogadores: seletedTeam,
                  time: _groupValue,
                  type: 'ponto',
                )
              : Container(),
        ],
      ),
    );
  }
}
