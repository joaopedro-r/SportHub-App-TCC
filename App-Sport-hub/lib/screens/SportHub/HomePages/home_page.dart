import 'dart:async';
import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:SportHub/screens/SportHub/JogoPages/verJogo.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../GrupoPages/grupo.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  double _posicaoScroll = 0;
  bool closeMap = false;
  Map _dadosUser = {};
  bool _loading = true;
  bool _loadNextGames = true;
  List _jogos = [];

  void _controlarScroll() {
    if (closeMap == true) {
      setState(() {
        _posicaoScroll = 0;
        closeMap = false;
      });
    } else {
      _scrollController.addListener(() {
        setState(() {
          _posicaoScroll = _scrollController.position.pixels;
        });
      });
    }
  }

  Future _loadDados() async {
    var response = await sendRequest(
      context,
      endPoint: 'usuario/ver',
      method: 'GET',
    );

    if (response != null) {
      final dados = response;
      //pegar as iniciais do nome
      String nome = dados['nome'];
      String nomeInicial = nome.substring(0, 2);
      dados['inicialNome'] = nomeInicial;
      userDataGlobal = dados;
      setState(() {
        _dadosUser = dados;

        _loading = false;
        print(_dadosUser);
      });
    }
  }

  Future _loadGamesNext() async {
    var response = await sendRequest(
      context,
      endPoint: 'jogo/proximos',
      method: 'GET',
    );

    if (response != null) {
      final dados = response;
      setState(() {
        _jogos = dados;
        _loadNextGames = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controlarScroll();
    _loadDados();
    _loadGamesNext();
  }

  String cardEsporte(modalidade) {
    if (modalidade == 'Futebol') {
      return 'assets/images/modelos/cardsModels/Card Futebol.png';
    } else if (modalidade == 'Basquete') {
      return 'assets/images/modelos/cardsModels/Card_basquete.png';
    } else if (modalidade == 'Volei') {
      return 'assets/images/modelos/cardsModels/Card Volei.png';
    } else if (modalidade == 'Handebol') {
      return 'assets/images/modelos/cardsModels/Card handball.png';
    } else {
      return 'assets/images/modelos/cardsModels/Card universal.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return (_posicaoScroll < 150)
        ? Container(
            width: _size.width,
            height: _size.height,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: _size.width,
                      padding: EdgeInsets.all(_size.width * 0.025),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            azul,
                            preto,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(30.0),
                          bottomRight: const Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: _size.height * 0.09,
                              bottom: _size.height * 0.04,
                              left: _size.width * 0.05,
                              right: _size.width * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Olá,',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: fontePrincipal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CarregamentoNome(
                                      loading: _loading,
                                      size: _size,
                                      dadosUser: _dadosUser,
                                      conteudo: '${_dadosUser['nome']}',
                                      corfonte: branco,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 5,
                                  ),
                                  child: CarregarFoto(
                                    loading: _loading,
                                    dadosUser: _dadosUser,
                                    size: _size.width * 0.1,
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Text(
                          //  'O que vai querer jogar?',
                          //  style: TextStyle(
                          //    fontFamily: fontePrincipal,
                          //    color: Colors.white,
                          //    fontSize: 20,
                          //    fontWeight: FontWeight.bold,
                          //  ),
                          //),
                          //Padding(
                          //  padding: EdgeInsets.only(
                          //    top: _size.height * 0.019,
                          //    bottom: _size.height * 0.019,
                          //  ),
                          //  child: Row(
                          //    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //    children: [
                          //      InkWell(
                          //        child: Image.asset(
                          //          'assets/images/modelos/icones/bola_basquete_transaprente.png',
                          //        ),
                          //        onTap: () {
                          //          print('Clicando na primeira bola');
                          //        },
                          //      ),
                          //      InkWell(
                          //        child: Image.asset(
                          //          'assets/images/modelos/icones/bola voleiball transparente.png',
                          //        ),
                          //        onTap: () {
                          //          print('Clicando na segunda bola');
                          //        },
                          //      ),
                          //      InkWell(
                          //        child: Image.asset(
                          //          'assets/images/modelos/icones/bola futebol transparente.png',
                          //        ),
                          //        onTap: () {
                          //          print('Clicando na terceira bola');
                          //        },
                          //      ),
                          //      InkWell(
                          //        child: Image.asset(
                          //          'assets/images/modelos/icones/bola handball transparente.png',
                          //        ),
                          //        onTap: () {
                          //          print('Clicando na quarta bola');
                          //        },
                          //      ),
                          //    ],
                          //  ),
                          //),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: _size.height * 0.02,
                        left: _size.width * 0.025,
                      ),
                      child: Text(
                        'Próximos jogos:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: fontePrincipal,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    (_loadNextGames == true)
                        ? Center(
                            child: Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              child: Container(
                                width: _size.width,
                                height: _size.height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: preto,
                                ),
                              ),
                            ),
                          )
                        : (_jogos.length == 0)
                            ? Container(
                                height: _size.height * 0.23,
                                width: _size.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: _size.height * 0.02),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Lottie.network(
                                          'https://assets8.lottiefiles.com/packages/lf20_muewqymz.json',
                                          reverse: true,
                                          repeat: true),
                                    ),
                                    Text(
                                      'Nenhum jogo encontrado nos próximos 7 dias.',
                                      style: TextStyle(
                                          fontFamily: fontePrincipal,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: _size.height * 0.23,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: _jogos.length,
                                  itemBuilder: (context, index) {
                                    String titulo = _jogos[index]['nome'];
                                    int idJogo = _jogos[index]['idJogo'];
                                    String modalidade = _jogos[index]['grupo']
                                        ['modalidade']['nome'];
                                    String dataParse = DateTime.parse(
                                            _jogos[index]['dataHora'])
                                        .toLocal()
                                        .toString();
                                    //formatar data para o formato brasileiro
                                    //formatar data
                                    var dataSep = dataParse.split(' ')[0];
                                    var dataFormatada = dataSep.split('-');
                                    String data = dataFormatada[2] +
                                        '/' +
                                        dataFormatada[1] +
                                        '/' +
                                        dataFormatada[0];

                                    var horario = dataParse.split(' ')[1];
                                    //formatar hora
                                    var horaFormatada = horario.split(':');
                                    var horaFinal = horaFormatada[0] +
                                        ':' +
                                        horaFormatada[1];

                                    String hora = horaFinal;
                                    String local =
                                        _jogos[index]['localizacao']['bairro'];
                                    String imagem = cardEsporte(modalidade);

                                    String iconemodalidade = _jogos[index]
                                            ['grupo']['modalidade']
                                        ['fotoModalidade'];

                                    Map rota = _jogos[index];

                                    bool confirmado = false;
                                    for (var conf in _jogos[index]
                                        ['confirmados']) {
                                      if (conf['usuario']['email'] ==
                                          _dadosUser['email']) {
                                        confirmado = true;
                                      }
                                    }

                                    return CardMeusJogos(
                                      index: index,
                                      titulo: titulo,
                                      modalidade: modalidade,
                                      data: data,
                                      hora: hora,
                                      local: local,
                                      imagem: imagem,
                                      iconemodalidade: iconemodalidade,
                                      confirmado: confirmado,
                                      rota: rota,
                                      idJogo: idJogo,
                                      funcao: accessJogo,
                                    );
                                  },
                                ),
                              ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: _size.width * 0.025,
                        bottom: _size.height * 0.02,
                      ),
                      child: Text(
                        'Jogos públicos:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: fontePrincipal,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Mapa(),
                  ],
                ),
              ],
            ),
          )
        : Stack(
            alignment: Alignment.topRight,
            children: [
              Mapa(),
              Positioned(
                top: _size.height * 0.05,
                right: _size.width * 0.05,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      closeMap = true;
                      _controlarScroll();
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: azulEscuro,
                    size: 40,
                  ),
                ),
              ),
            ],
          );
  }

  void accessJogo(index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => VerJogo(
          idJogo: _jogos[index]['idJogo'],
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
        _loading = true;
        _loadNextGames = true;
        _loadDados();
        _loadGamesNext();
      });
    });
  }
}
