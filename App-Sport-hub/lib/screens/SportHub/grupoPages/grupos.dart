import 'dart:math';
import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/grupoPages/criarGrupo.dart';
import 'package:SportHub/screens/SportHub/pagina_inicial_sporthub.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/screens/SportHub/grupoPages/grupo.dart';
import 'package:SportHub/screens/SportHub/GrupoPages/search_method.dart';

class GrupoPage extends StatefulWidget {
  const GrupoPage({Key? key}) : super(key: key);

  @override
  State<GrupoPage> createState() => _GrupoPageState();
}

class _GrupoPageState extends State<GrupoPage> {
  ScrollController _controleScroll = ScrollController();
  TextEditingController _idGrupoController = TextEditingController();
  double _posicaoScroll = 0;
  bool _loading = true;

  //estes dados vao vim do banco de dados
  List _dados = [];

  Future _getGrupos() async {
    var response = await sendRequest(context,
        endPoint: 'usuario/getGrupos', method: 'GET');

    if (response != null) {
      setState(() {
        _dados = response;

        for (var i in _dados) {
          if (i['grupo']['modalidade'] == 'Futebol') {
            i['imagem'] = imagensCardsEsportes['futebol'][Random().nextInt(3)];
          } else if (i['grupo']['modalidade'] == 'Basquete') {
            i['imagem'] = imagensCardsEsportes['basquete'][Random().nextInt(3)];
          } else if (i['grupo']['modalidade'] == 'Handball') {
            i['imagem'] = imagensCardsEsportes['handball'][Random().nextInt(3)];
          } else if (i['grupo']['modalidade'] == 'Voleibol') {
            i['imagem'] = imagensCardsEsportes['volei'][Random().nextInt(3)];
          } else {
            i['imagem'] = imagensCardsEsportes['gerais'][Random().nextInt(3)];
          }
        }
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controleScroll.addListener(() {
      setState(() {
        _posicaoScroll = _controleScroll.position.pixels;
      });
    });
    _getGrupos();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: _size.height * .15,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRUPOS',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontePrincipal,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secAnimation) =>
                                CriarGrupo(),
                            transitionsBuilder:
                                (context, animation, secAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                ).animate(animation),
                                child: child,
                              );
                            },
                          )).then((value) {
                        if (value != null) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, _, __) => Grupo(value),
                            ),
                          ).then((value) {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, _, __) =>
                                    PaginaInicialSporthub(
                                  setIndex: 0,
                                ),
                              ),
                            );
                          });
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: cinza,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _size.width * .03,
                          vertical: _size.height * .01,
                        ),
                        child: Text(
                          'CRIAR',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontePrincipal),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _enterGroup();
                    },
                    icon: Icon(Icons.group_add),
                  ),
                  //IconButton(
                  //    onPressed: () {
                  //      Navigator.push(
                  //        context,
                  //        PageRouteBuilder(
                  //          pageBuilder: (context, _, __) => SearchMethod(),
                  //        ),
                  //      );
                  //    },
                  //    icon: Icon(Icons.search)),
                ],
              ),
            ],
          )),
      body: (_loading == true)
          ? CarregarPagina()
          : (_dados.length == 0)
              ? Center(
                  child: Text(
                  'Você não está em nenhum grupo',
                  style: TextStyle(fontFamily: fontePrincipal, fontSize: 22),
                ))
              : RefreshIndicator(
                  color: verdeClaro,
                  onRefresh: _getGrupos,
                  child: ListView.builder(
                    controller: _controleScroll,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: _dados.length,
                    itemBuilder: ((context, index) {
                      bool _ultimo = false;

                      if (index == _dados.length - 1 && _dados.length > 3) {
                        _ultimo = true;
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: (_ultimo == true)
                                ? EdgeInsets.only(bottom: _size.height * .1)
                                : EdgeInsets.zero,
                            child: CardGrupos(
                              dados: _dados[index],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
      floatingActionButton: (_posicaoScroll > 140)
          ? Padding(
              padding: EdgeInsets.only(
                bottom: _size.height * 0.07,
              ),
              child: FloatingActionButton(
                backgroundColor: (_posicaoScroll < 280)
                    ? azulEscuro.withOpacity(_posicaoScroll / 280)
                    : azulEscuro,
                foregroundColor: Colors.white,
                onPressed: () {
                  //ir para o topo da tela
                  _controleScroll.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: Icon(Icons.arrow_upward),
              ),
            )
          : Container(),
    );
  }

  //caixa de dialogo para entrar em um grupo
  void _enterGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Entrar em um grupo',
            style: TextStyle(
              fontFamily: fontePrincipal,
              fontSize: 20,
            ),
          ),
          content: InputText1(
            titulo: 'Id do grupo',
            icone: Icons.group,
            controlador: _idGrupoController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontFamily: fontePrincipal,
                  fontSize: 18,
                  color: azul,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                var response = await sendRequest(
                  context,
                  endPoint: 'acesso/novo',
                  method: 'POST',
                  body: {
                    'grupo': _idGrupoController.text,
                    'convite': false,
                  },
                  showSuccessMsg: true,
                  showErrorMsg: true,
                );

                if (response != null) {
                  Navigator.pop(context);
                }
                //limpar o campo
                _idGrupoController.clear();
              },
              child: Text(
                'Pedir para entrar',
                style: TextStyle(
                  fontFamily: fontePrincipal,
                  fontSize: 18,
                  color: azul,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardGrupos extends StatelessWidget {
  Map dados;

  CardGrupos({
    required this.dados,
  });
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    //deixar o titulo todo maiusculo
    String titulo = dados['grupo']['nome'];
    titulo = titulo.toUpperCase();

    var dataFinal;
    var dataAtual;
    var dataJogo;
    var dataToShow;
    int qtdIntegrantes = 0;
    if (dados["grupo"]["jogos"].length > 0) {
      var jogos = dados["grupo"]["jogos"];

      //pegar o proximo jogo a partir da data atual
      int ultimo = 0;
      for (var i in jogos) {
        var dataJogoCheck = DateTime.parse(i["dataHora"]).toLocal();
        dataAtual = DateTime.now();
        if (dataJogoCheck.isBefore(dataAtual)) {
          try {
            dataToShow = dados["grupo"]["jogos"][ultimo - 1];
          } catch (e) {
            dataToShow = dados["grupo"]["jogos"][ultimo];
          }

          break;
        }
        ultimo++;
      }
      if (dataToShow == null) {
        dataToShow =
            dados["grupo"]["jogos"][dados["grupo"]["jogos"].length - 1];
      }

      var dataHoraConvertida =
          DateTime.parse(dataToShow["dataHora"]).toLocal().toString();
      var data = dataHoraConvertida.split(' ')[0];

      //formatar data
      var dataFormatada = data.split('-');
      dataFinal =
          dataFormatada[2] + '/' + dataFormatada[1] + '/' + dataFormatada[0];
      //data e horario de hoje
      dataAtual = DateTime.now();
      //transformar a data do jogo em um objeto DateTime
      dataJogo = DateTime.parse(dados["grupo"]["jogos"][0]["dataHora"]);
      //coverter para o fuso local
      dataJogo = dataJogo.toLocal();
    }

    for (var i in dados["grupo"]["membros"]) {
      if (i["aprovado"] == true) {
        qtdIntegrantes++;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: _size.height * .025),
      child: Container(
        padding: EdgeInsets.all(_size.width * .05),
        width: _size.width * .9,
        height: _size.height * .23,
        decoration: BoxDecoration(
          image: (dados['imagem'] != null)
              ? DecorationImage(
                  image: AssetImage(dados['imagem']),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7),
                    BlendMode.multiply,
                  ),
                )
              : null,
          borderRadius: BorderRadius.circular(30),
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _size.height * .005),
                  child: Text(
                    dados['grupo']['modalidade'],
                    style: TextStyle(color: verdeClaro),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$qtdIntegrantes integrantes',
                      style: TextStyle(
                          color: Colors.white, fontFamily: fontePrincipal),
                    ),
                    (dados['grupo']["jogos"].length > 0)
                        ? (dataAtual.isBefore(dataJogo))
                            ? Text(
                                'Próximo jogo: $dataFinal',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: fontePrincipal),
                              )
                            : Text(
                                'Último jogo: $dataFinal',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: fontePrincipal),
                              )
                        : Container(),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secAnimation) =>
                            Grupo(
                          dados['grupo']['idGrupo'],
                        ),
                        transitionsBuilder:
                            (context, animation, secAnimation, child) {
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
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, _, __) =>
                              PaginaInicialSporthub(
                            setIndex: 0,
                          ),
                        ),
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: verdeClaro),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        'Acessar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
