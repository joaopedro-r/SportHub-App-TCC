import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/JogoPages/jogoWidgets/confirmados.dart';
import 'package:SportHub/screens/SportHub/JogoPages/jogoWidgets/informacoes.dart';
import 'package:flutter/material.dart';

class VerJogo extends StatefulWidget {
  int idJogo;

  VerJogo({required this.idJogo});
  @override
  State<VerJogo> createState() => _VerJogoState();
}

class _VerJogoState extends State<VerJogo> with TickerProviderStateMixin {
  late TabController _tabController;
  late Map _dadosJogo;
  bool _loadingPage = true;
  Future _loadDadosJogo() async {
    var response = await sendRequest(
      context,
      endPoint: 'jogo/ver/${widget.idJogo}',
      method: 'GET',
    );
    if (response != null) {
      setState(() {
        _dadosJogo = response;
        _loadingPage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDadosJogo();
    _tabController = TabController(length: 2, vsync: this);

    //ver qual tab está selecionada
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_loadingPage == true)
        ? Scaffold(
            body: CarregarPagina(
              texto: 'Carregando jogo',
            ),
          )
        : DefaultTabController(
            initialIndex: 1,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Detalhes jogo'),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: 'Confirmados',
                      icon: Icon(Icons.groups_sharp),
                    ),
                    Tab(
                      text: 'Informações',
                      icon: Icon(Icons.info),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  ConfirmadosWidget(
                    confirmados: _dadosJogo['confirmados'],
                    idJogo: widget.idJogo,
                  ),
                  InformacoesWidget(
                    dadosJogo: _dadosJogo,
                  ),
                ],
              ),
            ),
          );
  }
}
