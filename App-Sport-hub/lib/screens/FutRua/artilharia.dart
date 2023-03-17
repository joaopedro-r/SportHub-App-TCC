import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';

class ConsultarArtilharia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados jogadores'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        children: [
          ShowArtilheiros(),
        ],
      ),
    );
  }
}

class Editor1 extends StatelessWidget {
  String text;
  Editor1(this.text);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      //width: 40,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

class EditorTitulo extends StatelessWidget {
  String text;
  EditorTitulo(this.text);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      //width: 40,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class ShowArtilheiros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            EditorTitulo('Jogador'),
            EditorTitulo('Pontos'),
            EditorTitulo('partidas'),
            EditorTitulo('Vitórias'),
            EditorTitulo('Empates'),
            EditorTitulo('Derrotas'),
          ],
        ),
        Divider(
          thickness: 3,
        ),
        ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: jogoGlobal.jogadores.length + jogoGlobal.excluidos.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                color: (index >= jogoGlobal.jogadores.length)
                    ? Colors.red.shade100
                    : (index % 2 == 0)
                        ? Colors.grey.shade300
                        : Colors.white,
                child: (index < jogoGlobal.jogadores.length)
                    ? Row(
                        children: [
                          Editor1('${jogoGlobal.jogadores[index].nome}'),
                          Editor1('${jogoGlobal.jogadores[index].pontos}'),
                          Editor1('${jogoGlobal.jogadores[index].partidas}'),
                          Editor1('${jogoGlobal.jogadores[index].vitorias}'),
                          Editor1('${jogoGlobal.jogadores[index].empates}'),
                          Editor1('${jogoGlobal.jogadores[index].derrotas}'),
                        ],
                      )
                    : Row(
                        children: [
                          Editor1(
                              '${jogoGlobal.excluidos[index - jogoGlobal.jogadores.length].nome} (Excluído)'),
                          Editor1(
                              '${jogoGlobal.excluidos[index - jogoGlobal.jogadores.length].pontos}'),
                          Editor1(
                              '${jogoGlobal.excluidos[index - jogoGlobal.jogadores.length].partidas}'),
                          Editor1(
                              '${jogoGlobal.excluidos[index - jogoGlobal.jogadores.length].vitorias}'),
                          Editor1(
                              '${jogoGlobal.excluidos[index - jogoGlobal.jogadores.length].empates}'),
                          Editor1(
                              '${jogoGlobal.excluidos[index - jogoGlobal.jogadores.length].derrotas}'),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
