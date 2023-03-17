import 'dart:convert';

import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:SportHub/models/tables/listagem.dart';
import 'package:SportHub/screens/FutRua/inserir_jogador.dart';
import 'package:SportHub/screens/FutRua/main_page.dart';
import 'package:SportHub/screens/SportHub/JogoPages/verJogo.dart';
import 'package:SportHub/screens/SportHub/grupoPages/agendarJogo.dart';
import 'package:SportHub/screens/SportHub/grupoPages/grupo.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/Componets/globals.dart' as globals;

class ListaJogo extends StatefulWidget {
  List _dadosJogos;
  bool _admView;
  ListaJogo(this._dadosJogos, this._admView);
  @override
  State<ListaJogo> createState() => _ListaJogoState();
}

class _ListaJogoState extends State<ListaJogo> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return (widget._dadosJogos.length == 0)
        ? Center(
            child: Text(
              'Nenhum jogo encontrado.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontePrincipal, fontSize: 20),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: _size.height * 0.1),
            itemCount: widget._dadosJogos.length,
            itemBuilder: (context, index) {
              return CardJogo(
                dadosJogo: widget._dadosJogos[index],
                admView: widget._admView,
                deleteFunc: () {
                  deleteGame(widget._dadosJogos[index]['idJogo']);
                },
              );
            },
          );
  }

  Future deleteGame(idJogo) async {
    var response = await sendRequest(
      context,
      endPoint: 'jogo/deletar',
      method: 'DELETE',
      body: {
        'idJogo': idJogo,
      },
      showSuccessMsg: true,
      showErrorMsg: true,
    );

    if (response != null) {
      //atualiza a lista de jogos
      setState(() {
        widget._dadosJogos
            .removeWhere((element) => element['idJogo'] == idJogo);
      });
    }
  }
}

class CardJogo extends StatefulWidget {
  Map dadosJogo;
  bool admView;
  Function deleteFunc;

  CardJogo({
    required this.dadosJogo,
    this.admView = false,
    required this.deleteFunc,
  });

  @override
  State<CardJogo> createState() => _CardJogoState();
}

class _CardJogoState extends State<CardJogo> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    //pegar e converter data e horario
    var dataHora = widget.dadosJogo['dataHora'];
    //coverter para DateTime e utc local
    var dataHoraConvertidaParse = DateTime.parse(dataHora).toLocal();
    var dataHoraConvertida = dataHoraConvertidaParse.toString();

    var data = dataHoraConvertida.split(' ')[0];
    //formatar data
    var dataFormatada = data.split('-');
    var dataFinal =
        dataFormatada[2] + '/' + dataFormatada[1] + '/' + dataFormatada[0];

    var hora = dataHoraConvertida.split(' ')[1];
    //formatar hora
    var horaFormatada = hora.split(':');
    var horaFinal = horaFormatada[0] + ':' + horaFormatada[1];

    bool confirmado = false;
    if (widget.dadosJogo['confirmados'].length > 0) {
      for (var i = 0; i < widget.dadosJogo['confirmados'].length; i++) {
        if (widget.dadosJogo['confirmados'][i]['usuario']['email'] ==
            userDataGlobal['email']) {
          confirmado = true;
        }
      }
    }

    //pegar data e hora atual
    var dataHoraAtual = DateTime.now();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: _size.height * 0.005),
      child: Card(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            ListTile(
              title: Row(
                children: [
                  Row(
                    children: [
                      (widget.dadosJogo['privado'] == true)
                          ? Padding(
                              padding:
                                  EdgeInsets.only(right: _size.width * 0.02),
                              child: Icon(
                                Icons.lock,
                                color: verdeClaro,
                              ),
                            )
                          : Container(),
                      Text(
                        widget.dadosJogo['nome'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontePrincipal),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: _size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Local: ${widget.dadosJogo['localizacao']['bairro']}'),
                          Text('Data: $dataFinal'),
                          Text('Horário: $horaFinal'),
                          Text(
                              'Confirmados: ${widget.dadosJogo['confirmados'].length}'),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.35,
                      child: (dataHoraAtual.isBefore(dataHoraConvertidaParse))
                          ? OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: (confirmado == false)
                                    ? verdeEscuro
                                    : Colors.white,
                                backgroundColor: (confirmado == false)
                                    ? Colors.transparent
                                    : Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (confirmado == false) {
                                  confirmar();
                                } else {
                                  desconfirmar();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (_loading == true)
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: _size.width * 0.02),
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: verdeClaro,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    (confirmado == false)
                                        ? 'Confirmar'
                                        : 'Desistir',
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
            (widget.admView == true)
                ? PopupMenuButton(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: (dataHoraConvertidaParse
                                    .difference(dataHoraAtual)
                                    .inDays >=
                                0)
                            ? true
                            : false,
                        child: Text(
                          (widget.dadosJogo['informacoes'] == null)
                              ? 'Iniciar jogo'
                              : 'Continuar jogo',
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text('Detalhes jogo'),
                        value: 2,
                      ),
                      PopupMenuItem(
                          child: Text(
                            'Editar',
                          ),
                          value: 3),
                      PopupMenuItem(
                        child: Text('Excluir'),
                        value: 4,
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        _goGame();
                      } else if (value == 2) {
                        verJogo(widget.dadosJogo);
                      } else if (value == 3) {
                        editJogo();
                      } else if (value == 4) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Deletar jogo"),
                            content: Text("Você tem certeza disso?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Não",
                                  style: TextStyle(
                                    fontFamily: fontePrincipal,
                                    fontSize: 18,
                                    color: azul,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.deleteFunc();
                                },
                                child: Text(
                                  "Sim",
                                  style: TextStyle(
                                    fontFamily: fontePrincipal,
                                    fontSize: 18,
                                    color: azul,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  )
                : PopupMenuButton(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Ver jogo'),
                        value: 1,
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        verJogo(widget.dadosJogo);
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }

  void editJogo() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => AgendarJogo(
          editMode: true,
          dadosJogo: widget.dadosJogo,
        ),
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
      if (value != null) {
        setState(() {
          widget.dadosJogo = value;
        });
      }
    });
  }

  void verJogo(Map dadosJogo) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => VerJogo(
          idJogo: dadosJogo['idJogo'],
        ),
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

  Future confirmar() async {
    setState(() {
      _loading = true;
    });
    var request = await sendRequest(
      context,
      endPoint: 'confirmado/novo',
      method: 'POST',
      body: {
        'jogo': widget.dadosJogo['idJogo'],
      },
      showSuccessMsg: true,
    );

    if (request != null) {
      setState(
        () {
          widget.dadosJogo['confirmados'].add(
            {
              'usuario': userDataGlobal,
            },
          );
          _loading = false;
        },
      );
    }
  }

  Future desconfirmar() async {
    setState(() {
      _loading = true;
    });
    var request = await sendRequest(
      context,
      endPoint: 'confirmado/deletar',
      method: 'DELETE',
      body: {
        'jogo': widget.dadosJogo['idJogo'],
      },
      showSuccessMsg: true,
      showErrorMsg: true,
    );

    if (request != null) {
      setState(() {
        widget.dadosJogo['confirmados'].removeWhere(
          (element) => element['usuario']['email'] == userDataGlobal['email'],
        );
        _loading = false;
      });
    }
  }

  void _goGame() {
    //print(widget.informacoes);
    if (widget.dadosJogo['informacoes'] != null) {
      loadgame(widget.dadosJogo['informacoes']);
    } else {
      if (widget.dadosJogo['privado'] == true &&
          widget.dadosJogo['confirmados'].length < 2) {
        showToast(context,
            texto:
                'Não é possível iniciar o jogo, pois não há jogadores suficientes',
            cor: Colors.red);
        return null;
      }
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secAnimation) => InsereClass(
            confirmados: widget.dadosJogo['confirmados'],
            dadosJogo: widget.dadosJogo,
          ),
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
          if (value != null) {
            widget.dadosJogo['informacoes'] = value;
          }
        });
      });
      _initDialog();
    }
  }

  void _initDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //rounded border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'GERENCIADOR DE JOGOS',
            style: TextStyle(
              fontFamily: fontePrincipal,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Bem vindo ao gerenciador de jogos do SportHub\n\n'
            'Aqui você poderá gerenciar os jogos que você criou, como por exemplo, '
            'sortear times, adicionar jogadores, somar pontos '
            'e muito mais.\n\n'
            'Para iniciar insira os jogadores presentes',
            style: TextStyle(
              fontFamily: fontePrincipal,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(color: azulEscuro),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loadgame(Map informacoes) {
    jogoGlobal = Jogo(
      idJogo: widget.dadosJogo['idJogo'],
      nome: informacoes['nome'],
      numeroJogadoresPorTime: informacoes['numeroJogadoresPorTime'],
      modalidade: widget.dadosJogo['grupo']['modalidade']['nome'],
    );

    for (var jogador in informacoes['jogadores']) {
      jogoGlobal.addPlayerLoaded(jogador);
    }

    for (var jogador in informacoes['excluidos']) {
      jogoGlobal.addExcluidoLoaded(jogador);
    }
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
      setState(() {
        widget.dadosJogo['informacoes'] = value;
      });
    });
  }
}
