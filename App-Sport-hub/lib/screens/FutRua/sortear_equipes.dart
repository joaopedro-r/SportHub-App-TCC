import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/functions.dart';
//import 'package:SportHub/Componets/globals.dart' as globals;
import 'package:SportHub/models/models.dart';
import 'main_page.dart';

class SortearEquipes extends StatefulWidget {
  Map dadosJogo;
  List listPlayers;
  SortearEquipes({required this.dadosJogo, required this.listPlayers});
  @override
  _SortearEquipesState createState() => _SortearEquipesState();
}

class _SortearEquipesState extends State<SortearEquipes> {
  final TextEditingController _numeroTimesControlador = TextEditingController();
  late int maxTime;
  //bool sortear = false;

  @override
  void initState() {
    super.initState();
    maxTime = widget.listPlayers.length ~/ 2;
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sortear Equipes'),
      ),
      body: Container(
        width: _size.width,
        height: _size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: _size.height * 0.05),
              child: InputText1(
                controlador: _numeroTimesControlador,
                titulo: 'Insira o número de jogadores por time',
                tipoTexto: TextInputType.number,
                textoAjuda: 'máximo de $maxTime jogadores por time',
                icone: Icons.groups_rounded,
              ),
            ),
            Button1(
              label: 'Sortear times',
              funcao: _sortNow,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sortNow() async {
    int num_jogador_por_time = 0;
    try {
      num_jogador_por_time = int.tryParse(_numeroTimesControlador.text)!;
    } catch (e) {
      return null;
    }

    if (num_jogador_por_time > maxTime || num_jogador_por_time < 1) {
      showToast(
        context,
        texto: 'O número de jogadores por time deve ser entre 1 e $maxTime',
        cor: Colors.red,
      );
      return null;
    }

    jogoGlobal = Jogo(
      nome: widget.dadosJogo['nome'],
      numeroJogadoresPorTime: num_jogador_por_time,
      idJogo: widget.dadosJogo['idJogo'],
      modalidade: widget.dadosJogo['grupo']['modalidade']['nome'],
    );

    for (var _jogador in widget.listPlayers) {
      jogoGlobal.addPlayer(_jogador);
    }

    jogoGlobal.sortListPlayers();

    jogoGlobal.saveJogo(context);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => MainPage(),
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
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context, value);
    });
  }
}
