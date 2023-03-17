import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/grupoPages/agendarJogo.dart';
import 'package:SportHub/screens/SportHub/grupoPages/grupoWidgets/listJogos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:SportHub/screens/SportHub/grupoPages/grupoWidgets/listMembros.dart';
import 'package:lottie/lottie.dart';

class Grupo extends StatefulWidget {
  int _idGrupo;
  Grupo(this._idGrupo);
  @override
  State<Grupo> createState() => _GrupoState();
}

class _GrupoState extends State<Grupo> with TickerProviderStateMixin {
  //controller para tabBar
  late TabController _tabController;
  Map _dadosGrupo = {};
  bool _loading = true;
  bool _admView = false;
  int _pedidos = 0;

  Future _getDadosGrupo() async {
    _pedidos = 0;
    var response = await sendRequest(this.context,
        endPoint: 'grupo/ver/${widget._idGrupo}', method: 'GET');

    if (response != null) {
      setState(() {
        _dadosGrupo = response;
        _loading = false;
        dadosGrupoGlobal = response;
        print(response['admin']['email']);
        print(userDataGlobal['email']);
        if (response['admin']['email'] == userDataGlobal['email']) {
          _admView = true;
        }
        for (var i = 0; i < response['membros'].length; i++) {
          if (response['membros'][i]['aprovado'] == false) {
            _pedidos++;
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getDadosGrupo();

    //ver qual tab está selecionada
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return (_loading == true)
        ? Scaffold(
            body: CarregarPagina(texto: 'Carregando grupo...'),
          )
        : DefaultTabController(
            initialIndex: 1,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${_dadosGrupo['nome']}'),
                        Padding(
                          padding: EdgeInsets.only(left: _size.width * 0.02),
                          child: Text(
                            '#${_dadosGrupo['idGrupo']}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_dadosGrupo['modalidade']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                actions: [
                  (_admView == true)
                      ? Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            IconButton(
                              onPressed: () {
                                showListAprove();
                              },
                              icon: Icon(Icons.group, size: _size.width * 0.08),
                            ),
                            (_pedidos > 0)
                                ? Container(
                                    margin: EdgeInsets.only(left: 7, top: 30),
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$_pedidos',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text((_admView == false)
                            ? 'Sair do grupo'
                            : 'Deletar grupo'),
                        value: 1,
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Deletar grupo"),
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
                                  sairDeleteGrupo();
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
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: 'Jogos',
                      icon: Icon(Icons.sports_score_rounded),
                    ),
                    Tab(
                      text: 'Membros',
                      icon: Icon(Icons.groups_sharp),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: _getDadosGrupo,
                    child: ListaJogo(_dadosGrupo['jogos'], _admView),
                    color: verdeClaro,
                  ),
                  RefreshIndicator(
                    onRefresh: _getDadosGrupo,
                    child: ListaMembros(
                      _dadosGrupo['membros'],
                      viewAdm: _admView,
                      admin: _dadosGrupo['admin'],
                    ),
                  ),
                ],
              ),
              floatingActionButton: (_tabController.index == 0)
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, _, __) => AgendarJogo(),
                          ),
                        ).then((value) {
                          setState(() {
                            _loading = true;
                            _getDadosGrupo();
                          });
                        });
                      },
                      label: Text('Criar jogo'),
                      icon: Icon(Icons.add),
                    )
                  : null,
              //(_tabController.index == 1)
              //    ? FloatingActionButton.extended(
              //        onPressed: () {},
              //        label: Text('Adicionar membro'),
              //        icon: Icon(Icons.add),
              //      )
              //    : null,
            ),
          );
  }

  //caixa de dialogo para aprovar membros
  showListAprove() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AprovePlayers(_dadosGrupo);
      },
    ).then((value) {
      if (value == true) {
        setState(() {
          _loading = true;
          _getDadosGrupo();
        });
      }
    });
  }

  Future sairDeleteGrupo() async {
    var response = await sendRequest(
      context,
      endPoint: 'grupo/sair',
      method: 'PUT',
      body: {
        'idGrupo': _dadosGrupo['idGrupo'],
      },
      showSuccessMsg: true,
      showErrorMsg: true,
    );

    if (response != null) {
      Navigator.pop(context);
    }
  }
}

class AprovePlayers extends StatefulWidget {
  Map _dadosGrupo;
  AprovePlayers(this._dadosGrupo);
  @override
  State<AprovePlayers> createState() => _AprovePlayersState();
}

class _AprovePlayersState extends State<AprovePlayers> {
  bool _loading = false;
  bool alterei = false;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    int qtdNaoAprovados = 0;
    for (int i = 0; i < widget._dadosGrupo['membros'].length; i++) {
      if (widget._dadosGrupo['membros'][i]['aprovado'] == false) {
        qtdNaoAprovados++;
      }
    }
    return
        //identificar botao voltar
        WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, alterei);
              return false;
            },
            child: AlertDialog(
              title: Text('Pedidos de entrada'),
              content: (qtdNaoAprovados == 0)
                  ? Container(
                      child: Text('Nenhum pedido'),
                    )
                  : Container(
                      width: _size.width * 0.8,
                      height: _size.height * 0.5,
                      child: ListView.builder(
                        itemCount: widget._dadosGrupo['membros'].length,
                        itemBuilder: (context, index) {
                          return (widget._dadosGrupo['membros'][index]
                                      ['aprovado'] ==
                                  false)
                              ? ListTile(
                                  leading: (widget._dadosGrupo['membros'][index]
                                              ['usuario']['foto'] !=
                                          null)
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget._dadosGrupo['membros']
                                                  [index]['usuario']['foto']),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/images/avatar.png'),
                                        ),
                                  title: Text(
                                      '${widget._dadosGrupo['membros'][index]['usuario']['nome']}'),
                                  subtitle: Text(
                                      '${widget._dadosGrupo['membros'][index]['usuario']['email']}'),
                                  trailing: (_loading == true)
                                      ? Container(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            color: verdeClaro,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _loading = true;
                                                });
                                                _aprovarMembro(
                                                  widget._dadosGrupo['membros']
                                                          [index]['usuario']
                                                      ['email'],
                                                ).then((value) {
                                                  setState(() {
                                                    widget._dadosGrupo[
                                                            'membros'][index]
                                                        ['aprovado'] = true;
                                                    _loading = false;
                                                    alterei = true;
                                                  });
                                                });
                                              },
                                              icon: Icon(Icons.check),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _loading = true;
                                                });
                                                removerMembro(
                                                  widget._dadosGrupo['membros']
                                                          [index]['usuario']
                                                      ['email'],
                                                ).then((value) {
                                                  setState(() {
                                                    widget._dadosGrupo[
                                                            'membros'][index]
                                                        ['aprovado'] = true;
                                                    _loading = false;
                                                  });
                                                });
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                )
                              : Container();
                        },
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, alterei);
                  },
                  child: Text(
                    'Fechar',
                    style: TextStyle(
                      fontFamily: fontePrincipal,
                      fontSize: 18,
                      color: azul,
                    ),
                  ),
                ),
              ],
            ));
  }

  Future _aprovarMembro(String email) async {
    var response = await sendRequest(
      context,
      endPoint: 'acesso/editar',
      method: 'PUT',
      body: {
        "grupo": widget._dadosGrupo['idGrupo'],
        "email": email,
      },
      showSuccessMsg: true,
    );
    if (response != null) {
      return true;
    }
  }

  Future removerMembro(String email) async {
    var response = await sendRequest(
      context,
      endPoint: 'acesso/deletar',
      method: 'DELETE',
      body: {
        "grupo": widget._dadosGrupo['idGrupo'],
        "email": email,
      },
    );
    if (response != null) {
      return true;
    }
  }
}
