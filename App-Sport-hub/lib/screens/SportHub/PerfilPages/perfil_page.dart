import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/PerfilPages/ajudaPage.dart';
import 'package:SportHub/screens/SportHub/PerfilPages/configuracoesPage.dart';
import 'package:SportHub/screens/SportHub/PerfilPages/notificacoesPage.dart';
import 'package:SportHub/screens/SportHub/PerfilPages/minha_contaPage.dart';
import 'package:SportHub/screens/SportHub/LoginPages/loginPage.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  @override
  State<PerfilPage> createState() => _PerfilPageState();

  const PerfilPage({Key? key}) : super(key: key);
}

class _PerfilPageState extends State<PerfilPage> {
  Map _dadosUser = {};
  bool _loading = true;

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

      setState(
        () {
          _dadosUser = dados;
          _loading = false;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDados();
  }

  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: _size.height * .02),
              ),
              CarregarFoto(
                loading: _loading,
                dadosUser: _dadosUser,
                size: _size.width * 0.12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: _size.height * .02),
                child: CarregamentoNome(
                  loading: _loading,
                  size: _size,
                  dadosUser: _dadosUser,
                  conteudo: '${_dadosUser['nome']}',
                  corfonte: preto,
                ),
              ),
              ButtonPerfil(
                size: _size,
                icon: Icon(
                  Icons.person,
                  color: preto,
                  size: 40,
                ),
                text: 'Minha conta',
                rota: MinhaContaPage(),
              ),
              // ButtonPerfil(
              //   size: _size,
              //   icon: Icon(
              //     Icons.notifications,
              //     color: preto,
              //     size: 40,
              //   ),
              //   text: 'Notificações',
              //   rota: NotificacoesPage(),
              // ),
              //  ButtonPerfil(
              //    size: _size,
              //    icon: Icon(
              //      Icons.settings,
              //      color: preto,
              //      size: 40,
              //    ),
              //    text: 'Configurações',
              //    rota: ConfiguracoesPage(),
              //  ),
              ButtonPerfil(
                size: _size,
                icon: Icon(
                  Icons.emoji_events,
                  color: preto,
                  size: 40,
                ),
                text: 'Prêmio projeto destaque',
                rota: AjudaPage(),
              ),
              ButtonPerfil(
                size: _size,
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: preto,
                  size: 40,
                ),
                text: 'Sair',
                funcao: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sair"),
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
              _logout();
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

  Future _logout() async {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => LoginPage(),
        ),
        (route) => false);
    await sendRequest(
      this.context,
      endPoint: 'autenticacao/logout',
      method: 'POST',
      logoutMethod: true,
    );
  }
}
