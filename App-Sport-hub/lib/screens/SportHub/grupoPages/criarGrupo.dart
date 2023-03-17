import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:flutter/material.dart';

class CriarGrupo extends StatefulWidget {
  @override
  State<CriarGrupo> createState() => _CriarGrupoState();
}

class _CriarGrupoState extends State<CriarGrupo> {
  TextEditingController _nomeGrupo = TextEditingController();
  String dropdownValue = 'Selecionar esporte';
  List<String> list = ['Selecionar esporte'];
  List _listDados = [];
  bool _loading = true;

  Future _loadDados() async {
    var response = await sendRequest(
      context,
      endPoint: 'modalidade/todos',
      method: 'GET',
    );

    if (response != null) {
      final dados = response;
      setState(() {
        _listDados = dados;
        //adiciona os dados na lista
        for (var i = 0; i < _listDados.length; i++) {
          list.add(_listDados[i]['nome']);
        }
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDados();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: (_loading == true)
          ? CarregarPagina()
          : Container(
              width: _size.width,
              height: _size.height,
              padding: EdgeInsets.symmetric(horizontal: _size.width * 0.05),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: _size.height * 0.05, bottom: _size.height * 0.1),
                    child: Text(
                      'Criar Grupo',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontePrincipal),
                    ),
                  ),
                  InputText2(
                    label: 'Nome do grupo',
                    lastInput: true,
                    controlador: _nomeGrupo,
                    maximoCaracteres: 80,
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down, color: azulEscuro),
                    elevation: 8,
                    underline: Container(
                      height: 1,
                      color: azulEscuro,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _size.height * 0.1),
                    child: Button1(
                      label: 'Criar',
                      funcao: _criarGrupo,
                    ),
                  ),
                ],
              )),
    );
  }

  Future _criarGrupo() async {
    setState(() {
      _loading = true;
    });
    if (_nomeGrupo.text == '' ||
        !_nomeGrupo.text.contains(RegExp(r'[a-zA-Z]')) ||
        dropdownValue == 'Selecionar esporte') {
      showToast(context,
          texto: 'Preencha todos os campos', cor: Colors.red, duracao: 5);
      setState(() {
        _loading = false;
      });
    } else {
      var idModalidade;
      for (var i = 0; i < _listDados.length; i++) {
        if (_listDados[i]['nome'] == dropdownValue) {
          idModalidade = _listDados[i]['idModalidade'];
        }
      }
      var response = await sendRequest(
        context,
        endPoint: 'grupo/novo',
        method: 'POST',
        body: {
          'nome': _nomeGrupo.text,
          'modalidade': idModalidade,
        },
        showSuccessMsg: true,
        showErrorMsg: true,
      );

      if (response != null) {
        Navigator.pop(context, response['idGrupo']);
      } else {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
