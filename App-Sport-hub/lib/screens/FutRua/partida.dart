import 'dart:async';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/tables/listagem.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/FutRua/ponto.dart';
import 'package:SportHub/screens/FutRua/main_page.dart';
import 'package:SportHub/screens/FutRua/substituir_jogador.dart';
import 'package:audioplayers/audioplayers.dart';

class Partida extends StatefulWidget {
  @override
  _PartidaState createState() => _PartidaState();
}

const int maxFailedLoadAttempts = 3;

class _PartidaState extends State<Partida> {
  late final AudioCache player;
  final TextEditingController _tempo = TextEditingController();
  int golsTimeA = 0;
  int golsTimeB = 0;

  //Configurar anuncio

  late Timer timer;

  //void add_num_game() {
  //  for (int a = 0; a < 2; a++) {
  //    globals.equipes[a].add_status_game();
  //  }
  //}
  List timeA = [];
  List timeB = [];

  void _loadData() {
    timeA = [];
    timeB = [];
    for (var i = 0; i < jogoGlobal.numeroJogadoresPorTime * 2; i++) {
      if (i < jogoGlobal.numeroJogadoresPorTime) {
        timeA.add(jogoGlobal.jogadores[i]);
      } else {
        timeB.add(jogoGlobal.jogadores[i]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    //add_num_game();

    player = AudioCache(
      prefix: 'assets/sounds/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  int _counterSeconds = 0;
  int _counterMinutes = 11;
  int _totalSeconds = 600;
  late Timer _timerMinutes;
  late Timer _timerSeconds;
  bool _cronometroComeca = false;
  bool jaFoi = false;
  String pausado_text = '';

  TextEditingController _newPlayer = TextEditingController();

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Não é possivel fazer essa ação!'),
            content: new Text(
                'Para voltar ao painel de controle voce deve encerrar a partida'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('ok'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    //transformar totalsecconds em minutos e segundos
    int _minutos = (_totalSeconds / 60).floor();
    int _segundos = _totalSeconds % 60;

    //formatar _minutos _segundos tempo para 00:00
    String _minutosFormatado = _minutos.toString().padLeft(2, '0');
    String _segundosFormatado = _segundos.toString().padLeft(2, '0');

    //juntar
    String _tempoFormatado = '$_minutosFormatado:$_segundosFormatado';

    String img;
    if (jogoGlobal.modalidade == 'Futebol') {
      img = imagensCardsEsportes['futebol'][1];
    } else if (jogoGlobal.modalidade == 'Basquete') {
      img = imagensCardsEsportes['basquete'][1];
    } else if (jogoGlobal.modalidade == 'Handball') {
      img = imagensCardsEsportes['handball'][1];
    } else if (jogoGlobal.modalidade == 'Volei') {
      img = imagensCardsEsportes['volei'][1];
    } else {
      img = imagensCardsEsportes['gerais'][1];
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Partida'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: (jogoGlobal.eventos.length > 0)
                  ? EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10)
                  : EdgeInsets.all(20.0),
              child: ListaJogo(
                text: 'Jogo atual',
                timeA: timeA,
                timeB: timeB,
                showTime: jaFoi,
                time: _tempoFormatado,
                showGols: true,
                golA: golsTimeA,
                golB: golsTimeB,
                imagem: img,
              ),
            ),
            (jogoGlobal.eventos.length > 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Eventos: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: _size.height * .12,
                              child: ListView(
                                children: [
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemCount: jogoGlobal.eventos.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3),
                                        child: Container(
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100),
                                          child:
                                              Text(jogoGlobal.eventos[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            GridView.count(
              padding: (jogoGlobal.eventos.length > 0)
                  ? EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                  : EdgeInsets.symmetric(horizontal: 20),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              crossAxisCount: 2,
              children: <Widget>[
                EditorGridView('Times', Colors.deepPurple.shade400,
                    mostrarElencos, Icons.view_list),
                (_cronometroComeca == false)
                    ? EditorGridView(
                        'Iniciar temporizador',
                        Colors.deepPurple.shade500,
                        _definirTime,
                        Icons.av_timer)
                    : EditorGridView('Pausar temporizador',
                        Colors.deepPurple.shade500, _pauseTimer, Icons.pause),
                EditorGridView('Marcar ponto', Colors.deepPurple.shade600,
                    _marcarPonto, Icons.control_point),
                EditorGridView('Substituir jogador', Colors.deepPurple.shade700,
                    _substituirJogador, Icons.compare_arrows),
                EditorGridView('Adicionar jogador', Colors.deepPurple.shade800,
                    _adicionarJogador, Icons.group_add),
                EditorGridView('Encerrar a partida', Colors.redAccent.shade400,
                    _confirmarEncerramento, Icons.sports),
              ],
            ),
          ],
        ),
        //bottomNavigationBar: Container(
        //  child: AdWidget(
        //    ad: _anuncio_banner.bannerAd!,
        //  ),
        //  width: _anuncio_banner.bannerAd!.size.width.toDouble(),
        //  height: _anuncio_banner.bannerAd!.size.height.toDouble(),
        //),
      ),
    );
  }

  void _definirTime(context) {
    if (jaFoi == false) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Defina o tempo da partida'),
            content: SingleChildScrollView(),
            actions: <Widget>[
              TextField(
                controller: _tempo,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Tempo em minutos'),
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
                      'Definir',
                      style: TextStyle(color: azul),
                    ),
                    onPressed: () {
                      int? numerotempo = int.tryParse(_tempo.text);
                      setState(() {
                        _counterMinutes = numerotempo!;
                      });
                      _startTimer(context);
                      Navigator.of(context).pop();
                      showToast(
                        context,
                        texto:
                            'Cronômetro de ${_counterMinutes} minutos foi iniciado',
                      );
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    } else {
      _startTimer(context);
    }
  }

  void _pauseTimer(context) {
    _timerSeconds.cancel();
    setState(() {
      _cronometroComeca = false;
      pausado_text = '(pausado)';
    });
  }

  void _startTimer(context) {
    _cronometroComeca = true;

    setState(() {
      if (jaFoi == false) {
        _totalSeconds = _counterMinutes * 60;
      }
      jaFoi = true;
    });

    pausado_text = '';

    _timerSeconds = new Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(
          () {
            if (_totalSeconds > 0) {
              _totalSeconds--;
            } else {
              player.play('timeout.mp3');
              _timerSeconds.cancel();
              _cronometroComeca = false;
            }
          },
        );
      },
    );
  }

  Future<void> _marcarPonto(context) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => MarcarPonto(),
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
      print(value);
      if (value.length > 0) {
        setState(() {
          String _time = '';
          if (value[0] == 0) {
            golsTimeA++;
            _time = 'Time A';
          } else {
            golsTimeB++;
            _time = 'Time B';
          }

          //transformar tempo em minutos e segundos
          int minutos = (_totalSeconds / 60).floor();
          int segundos = _totalSeconds - (minutos * 60);

          //formatar minutos e segundos
          String minutosFormatado = minutos.toString().padLeft(2, '0');
          String segundosFormatado = segundos.toString().padLeft(2, '0');

          if (jaFoi == true) {
            jogoGlobal.eventos.add(
                'Ponto do $_time com ${value[1]} aos ${minutosFormatado}:${segundosFormatado}');
          } else {
            jogoGlobal.eventos.add('Ponto do $_time com ${value[1]}');
          }
        });
      }
    });
  }

  Future<void> _substituirJogador(context) async {
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
        pageBuilder: (context, _, __) => SubstituirPlayer(),
      ),
    ).then((value) {
      if (value != null) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Substituição feita com sucesso'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(text: 'Sai '),
                            TextSpan(
                              text: '${value[1]} ',
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(text: 'para entrar o '),
                            TextSpan(
                              text: '${value[0]}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text('As equipes foram reformuladas'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('ok!'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _loadData();
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

//
  void _confirmarEncerramento(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja encerrar a partida?'),
          content: SingleChildScrollView(),
          actions: <Widget>[
            Row(
              children: [
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    _encerrarPartida(context);
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
  void _encerrarPartida(context) async {
    if (jaFoi == true && _cronometroComeca == true) {
      _timerSeconds.cancel();
    }

    List resultado = jogoGlobal.encerrarJogo(golsTimeA, golsTimeB);
    if (resultado[1] == true) {
      showToast(context,
          texto:
              'Jogo empatado, portanto após um sorteio, foi definido vitória para o Time ${resultado[0]}',
          duracao: 10);
    } else {
      showToast(context,
          texto: 'Jogo encerrado, vitória para o Time ${resultado[0]}',
          duracao: 10);
    }

    Navigator.pop(context);

    player.play('encerramento.mp3');
    //_anuncio_Interstitial.carregarInterstitial();
  }

//
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
                      jogoGlobal.eventos.add(
                          'O jogador ${_newPlayer.text} foi adicionado no jogo');
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
  }
}
