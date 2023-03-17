import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:SportHub/screens/SportHub/LoginPages/loginPage.dart';
import 'package:SportHub/screens/SportHub/pagina_inicial_sporthub.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/ModelPage.dart';

class CadastroPagePart5 extends StatefulWidget {
  @override
  State<CadastroPagePart5> createState() => _CadastroPagePart5State();
}

class _CadastroPagePart5State extends State<CadastroPagePart5> {
  List<int> _valuesSelected = [];
  List _modalidades = [];
  bool _loadingModalidades = true;
  bool _loadingPage = false;

  Future _loadDados() async {
    var response = await sendRequest(
      context,
      endPoint: 'modalidade/todos',
      method: 'GET',
    );
    if (response != null) {
      setState(() {
        _modalidades = response;
      });
    }
    setState(() {
      _loadingModalidades = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDados();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    //pegar tamanho da status bar
    var _paddingTop = MediaQuery.of(context).padding.top;
    return (_loadingPage == true)
        ? Scaffold(body: CarregarPagina(texto: 'Cadastrando...'))
        : ModelCadastroPage(
            nivelPage: 5,
            proximo: _proximo,
            ultimo: true,
            conteudo: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: _size.height * 0.08, top: _size.height * 0.1),
                child: Text(
                  'Quais seus esportes favoritos?',
                  style: TextStyle(
                      fontFamily: fontePrincipal,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              (_loadingModalidades == true)
                  ? SizedBox(
                      child: CircularProgressIndicator(
                        color: verdeClaro,
                      ),
                      //height: 200.0,
                      width: _size.width * 0.05,
                      height: _size.width * 0.05,
                    )
                  : Container(
                      height: _size.height * 0.43,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        children: [
                          Wrap(
                            runSpacing: 20,
                            spacing: 10,
                            children: List<Widget>.generate(
                              _modalidades.length,
                              (int index) {
                                return ChoiceChip(
                                    label: Text(
                                      '${_modalidades[index]['nome']}',
                                      style:
                                          TextStyle(fontFamily: fontePrincipal),
                                    ),
                                    selected: _valuesSelected.contains(
                                        _modalidades[index]['idModalidade']),
                                    selectedColor: verdeClaro,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          _valuesSelected.add(
                                              _modalidades[index]
                                                  ['idModalidade']);
                                        } else {
                                          _valuesSelected.remove(
                                              _modalidades[index]
                                                  ['idModalidade']);
                                        }
                                        print(_valuesSelected);
                                      });
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          );
  }

  Future _proximo() async {
    if (_valuesSelected.length == 0) {
      //se não selecionou nenhuma modalidade
      showToast(context,
          texto: 'Selecione pelo menos uma modalidade',
          cor: Colors.red,
          duracao: 5);
    } else {
      setState(() {
        _loadingPage = true;
      });
      usuarioCadastro.modalidades = _valuesSelected;
      print(usuarioCadastro.createJson());

      // conexao api para cadastrar usuario
      var response = await sendRequest(
        context,
        endPoint: 'usuario/novo',
        method: 'POST',
        body: usuarioCadastro.createJson(),
        showSuccessMsg: true,
        showErrorMsg: true,
      );

      if (response != null) {
        //se a resposta for 200, o usuario foi cadastrado e agora fará o login
        var userData = usuarioCadastro.createJson();
        var responseLogin = await sendRequest(
          this.context,
          endPoint: 'autenticacao/login',
          body: {'email': userData["email"], 'senha': userData["senha"]},
          method: 'POST',
          loginMethod: true,
        );
        if (responseLogin != null) {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, _, __) => PaginaInicialSporthub()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(pageBuilder: (context, _, __) => LoginPage()),
              (route) => false);
        }
      } else {
        setState(() {
          _loadingPage = false;
        });
      }
    }
  }
}
