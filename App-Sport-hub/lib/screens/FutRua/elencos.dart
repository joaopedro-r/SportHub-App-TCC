import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';
//import '../../Componets/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class Elencosclass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    List _times = [];
    int indexTime = 0;
    Map time = {
      'nome': '',
      'jogadores': [],
    };

    for (var i = 0; i < jogoGlobal.jogadores.length; i++) {
      if (time['jogadores'].length == jogoGlobal.numeroJogadoresPorTime) {
        _times.add(time);
        time = {
          'nome': '',
          'jogadores': [],
        };
        indexTime++;
      }

      if (indexTime == 0) {
        time['nome'] = 'Time A';
      } else if (indexTime == 1) {
        time['nome'] = 'Time B';
      } else {
        time['nome'] = '${indexTime - 1}º próxima';
      }

      time['jogadores'].add(jogoGlobal.jogadores[i].nome);
    }
    if (time['jogadores'].length > 0) {
      _times.add(time);
    }
    //print(_times);

    return Scaffold(
      appBar: AppBar(
        title: Text('Elencos'),
      ),
      body: Container(
        width: _size.width,
        height: _size.height,
        child: ListView(
          children: [
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: _times.length,
              itemBuilder: (context, index) {
                return GerarLista(
                  cor: verde,
                  dados: _times[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GerarLista extends StatelessWidget {
  Color cor;
  Map dados;

  GerarLista({
    required this.cor,
    required this.dados,
  });

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(_size.width * 0.02),
          child: Card(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(_size.width * 0.04),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: cor,
                  ),
                  child: Text(
                    dados['nome'],
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_size.width * 0.02),
                  child: ListView.builder(
                    //remover scroll
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: dados['jogadores'].length,
                    itemBuilder: (context, index2) {
                      return Text(
                        '${dados['jogadores'][index2]}',
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 3,
          color: azul.withOpacity(0.25),
          indent: 120,
          endIndent: 120,
        )
      ],
    );
  }
}
