//import 'package:SportHub/screens/FutRua/pre_inicio.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/models/models.dart';

import 'package:share/share.dart';
//import 'package:SportHub/Componets/globals.dart' as globals;
import 'package:SportHub/screens/FutRua/artilharia.dart';
import 'package:SportHub/screens/FutRua/excluir_jogador.dart';
import 'package:SportHub/screens/FutRua/partida.dart';
//import 'elencos.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _newPlayer = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    clearFutRua(); //volta para sortear

    return true;
  }

  void clearFutRua({bool all = false}) {
    if (all == false) {
      Navigator.pop(context, jogoGlobal.jsonJogo());
    } else {
      Navigator.pop(context, null);
    }

    jogoGlobal.clearJogo();
  }

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

    String img;
    if (jogoGlobal.modalidade == 'Futebol') {
      img = imagensCardsEsportes['futebol'][0];
    } else if (jogoGlobal.modalidade == 'Basquete') {
      img = imagensCardsEsportes['basquete'][0];
    } else if (jogoGlobal.modalidade == 'Handball') {
      img = imagensCardsEsportes['handball'][0];
    } else if (jogoGlobal.modalidade == 'Volei') {
      img = imagensCardsEsportes['volei'][0];
    } else {
      img = imagensCardsEsportes['gerais'][0];
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text('Painel'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              clearFutRua();
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
              child: ListaJogo(
                text: 'Próximo jogo',
                timeA: timeA,
                timeB: timeB,
                imagem: img,
              ),
            ),
            GridView.count(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              crossAxisCount: 2,
              children: <Widget>[
                EditorGridView('Times', Colors.indigo.shade400, mostrarElencos,
                    Icons.view_list),
                EditorGridView('Ir para a partida', verde, _irPartida,
                    Icons.arrow_forward),
                EditorGridView('Adicionar um novo jogador',
                    Colors.indigo.shade600, _adicionarJogador, Icons.group_add),
                EditorGridView('Excluir um jogador', Colors.indigo.shade700,
                    _excluirJogador, Icons.delete_forever),
                EditorGridView('Consultar dados', Colors.indigo.shade800,
                    _consultarArtilharia, Icons.vertical_split),
                EditorGridView('Resetar jogo', Colors.indigo.shade900, _resetar,
                    Icons.cleaning_services_rounded)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> choiceAction() async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(
      '*Quer organizar o seu futebol com os amigos?*\n\nConheça o aplicativo FutRua, que foi desenvolvido pensando nos peladeiros e jogadores de futebol que querem organizar um jogo entre amigos de forma fácil e bem interativa, com placar, temporizador, artilharia...\n*Baixe agora e curta a sua pelada:* https://play.google.com/store/apps/details?id=my.app.fut_rua',
      subject: 'Conheça o FutRua',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _consultarArtilharia(context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) =>
            ConsultarArtilharia(),
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

  void _adicionarJogador(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar novo jogador'),
          content: SingleChildScrollView(),
          actions: <Widget>[
            TextField(
              maxLength: 16,
              controller: _newPlayer,
              decoration: InputDecoration(labelText: 'Nome do jogador'),
            ),
            Row(
              children: [
                TextButton(
                  child: Text(
                    'Voltar',
                    style: TextStyle(color: azul),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: azul),
                  ),
                  onPressed: () {
                    if (_newPlayer.text == '' ||
                        !_newPlayer.text.contains(RegExp(r'[a-zA-Z0-9]'))) {
                      showToast(context,
                          texto: 'preencha o nome do jogador', cor: Colors.red);
                      _newPlayer.clear();
                      return null;
                    }

                    for (var i = 0; i < jogoGlobal.jogadores.length; i++) {
                      if (jogoGlobal.jogadores[i].nome == _newPlayer.text) {
                        showToast(context,
                            texto: 'já existe um jogador com esse nome',
                            cor: Colors.red);
                        _newPlayer.clear();
                        return null;
                      }
                    }
                    setState(() {
                      jogoGlobal.addPlayer(_newPlayer.text);
                      _newPlayer.clear();
                    });
                    Navigator.of(context).pop();
                    jogoGlobal.saveJogo(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
    //}
  }

//
  void _excluirJogador(context) {
    int maxForGame = jogoGlobal.numeroJogadoresPorTime * 2;
    if (jogoGlobal.jogadores.length <= maxForGame) {
      showToast(context,
          texto:
              'Não é possivel excluir um jogador quando tem apenas 2 equipes e nenhuma pessoa de próxima',
          cor: Colors.red);
      return null;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => ExcluirPlayer(),
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
      setState(() {
        jogoGlobal.saveJogo(context);
      });
    });
  }

//
  void _resetar(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Resetar jogo'),
            content: Text(
                'Tem certeza que deseja resetar o jogo e apagar todos os dados?'),
            actions: [
              TextButton(
                child: Text(
                  'Não',
                  style: TextStyle(color: azul),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Sim',
                  style: TextStyle(color: azul),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await jogoGlobal.limparPlayers(context);
                  //jogoGlobal.saveJogo(context);
                  clearFutRua(all: true);
                },
              ),
            ],
          );
        });
  }

//
  void _irPartida(context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => Partida(),
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
      setState(() {
        jogoGlobal.saveJogo(context);
      });
    });
  }
}

class ListaJogo extends StatelessWidget {
  List timeA;
  List timeB;
  String text;
  bool showTime;
  int golA;
  int golB;
  bool showGols;
  String? time;
  String imagem;

  ListaJogo(
      {required this.text,
      required this.timeA,
      required this.timeB,
      this.showTime = false,
      this.showGols = false,
      this.time,
      this.golA = 0,
      this.golB = 0,
      required this.imagem});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(_size.width * 0.02),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(imagem),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.srcOver),
          ),
          color: Colors.teal.shade600,
          boxShadow: [
            BoxShadow(
                blurRadius: 7,
                offset: Offset(0, 3),
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.5)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              (showTime == true)
                  ? Text((time != '00:00') ? '$time' : 'Fim de jogo',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                  : Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: _size.height * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeWidget(
                  time: timeA,
                  nome: (showGols == false) ? 'Time A' : 'Time A - $golA',
                ),
                Text(
                  'X',
                  style: TextStyle(
                      fontSize: 24, wordSpacing: 2, color: Colors.white),
                ),
                TimeWidget(
                  time: timeB,
                  nome: (showGols == false) ? 'Time B' : '$golB - Time B',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  List time;
  String nome;
  TimeWidget({required this.time, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            nome,
            style: TextStyle(
              fontSize: 24,
              wordSpacing: 2,
              color: Colors.white,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: time.length,
            itemBuilder: (context, index) {
              return Text(
                time[index].nome,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ],
      ),
    );
  }
}
