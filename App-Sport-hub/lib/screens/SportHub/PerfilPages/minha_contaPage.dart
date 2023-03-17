import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class MinhaContaPage extends StatefulWidget {
  @override
  State<MinhaContaPage> createState() => _MinhaContaPageState();
  const MinhaContaPage({Key? key}) : super(key: key);
}

class _MinhaContaPageState extends State<MinhaContaPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _dataController = TextEditingController();
  Map _dadosUser = {};
  bool _loading = true;
  String _data = '';

  Future _loadDados() async {
    var response =
        await sendRequest(context, endPoint: 'usuario/ver', method: 'GET');

    if (response != null) {
      final dados = response;
      print(dados);
      //pegar as iniciais do nome
      String nome = dados['nome'];
      String nomeInicial = nome.substring(0, 2);
      dados['inicialNome'] = nomeInicial;

      String data = dados['dataNascimento'];
      List dataSplit = data.split('-');
      String dataString =
          dataSplit[2] + '/' + dataSplit[1] + '/' + dataSplit[0];

      setState(
        () {
          _dadosUser = dados;
          _emailController.text = '${_dadosUser['email']}';
          _nomeController.text = '${_dadosUser['nome']}';
          _dataController.text = dataString;

          _loading = false;

          print(_dadosUser);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha conta',
          style: TextStyle(
            fontFamily: fontePrincipal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: _size.height * .02, horizontal: _size.height * .05),
          child: Column(
            children: [
              Container(
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    CarregarFoto(
                      loading: _loading,
                      dadosUser: _dadosUser,
                      size: _size.width * 0.12,
                    ),
                    Positioned(
                      right: -1,
                      bottom: 0,
                      child: Container(
                        height: _size.height * 0.05,
                        width: _size.width * 0.1,
                        decoration: BoxDecoration(
                          color: branco,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.all(3.5),
                            child: Image.asset(
                              "assets/images/icon camera.png",
                            ),
                          ),
                          onTap: () {
                            print('Adicionar foto de perfil');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InputText2(
                label: 'Nome Completo',
                controlador: _nomeController,
                icone: Icons.person,
                loading: _loading,
              ),
              InputText2(
                label: 'Data de Nascimento',
                maskType: 'data',
                tipoTeclado: TextInputType.datetime,
                lastInput: true,
                controlador: _dataController,
                icone: Icons.calendar_month_outlined,
                loading: _loading,
              ),
              Button1(
                label: 'Atualizar',
              )
            ],
          ),
        ),
      ),
    );
  }
}
