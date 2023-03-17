import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';
//import 'package:SportHub/Componets/globals.dart' as globals;

class ExcluirPlayer extends StatefulWidget {
  @override
  _ExcluirPlayerState createState() => _ExcluirPlayerState();
}

class _ExcluirPlayerState extends State<ExcluirPlayer> {
  int _jogadorValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excluir Jogador'),
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditorEquipes('Selecione o Jogador: '),
          Container(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              //padding: EdgeInsets.symmetric(horizontal: 20),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: jogoGlobal.jogadores.length,
              itemBuilder: (context, index) {
                return new ListTile(
                  title: Text('${jogoGlobal.jogadores[index].nome}'),
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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Button1(
              label: 'Excluir jogador',
              funcao: _verificar,
            ),
          ),
        ],
      ),
    );
  }

  void _verificar() {
    if (_jogadorValue == -1) {
      showToast(context, texto: 'Selecione um jogador', cor: Colors.red);
      return null;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Deseja excluir ${jogoGlobal.jogadores[_jogadorValue].nome}?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Ao fazer isso apagará esse jogador de todas as equipes e próximas (se houver)'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('Não'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _excluirJogador();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

//
  void _excluirJogador() {
    jogoGlobal.excluiPlayer(_jogadorValue);
    showToast(context, texto: 'Jogador excluído com sucesso!');
    Navigator.of(context).pop();
  }
}
