import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/CadastroPagePart5.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/ModelPage.dart';

class CadastroPagePart4 extends StatefulWidget {
  @override
  State<CadastroPagePart4> createState() => _CadastroPagePart4State();
}

class _CadastroPagePart4State extends State<CadastroPagePart4> {
  String dropdownValue = 'Selecionar sexo';
  List<String> list = ['Selecionar sexo'];
  List _dadosSexo = [];
  bool _loadingSexo = true;

  Future _loadDados() async {
    var response = await sendRequest(
      context,
      endPoint: 'sexo/todos',
      method: 'GET',
    );

    if (response != null) {
      final dados = response;
      print(dados);
      setState(() {
        _dadosSexo = dados;
        for (var item in dados) {
          list.add(item['nome']);
        }
      });
    }
    setState(() {
      _loadingSexo = false;
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
    return ModelCadastroPage(
        nivelPage: 4,
        conteudo: [
          Padding(
            padding: EdgeInsets.only(bottom: _size.height * 0.08),
            child: Text(
              'Como você se identifica?',
              style: TextStyle(
                  fontFamily: fontePrincipal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          (_loadingSexo == true)
              ? SizedBox(
                  child: CircularProgressIndicator(
                    color: verdeClaro,
                  ),
                  //height: 200.0,
                  width: _size.width * 0.05,
                  height: _size.width * 0.05,
                )
              : Container(
                  width: _size.width * 0.8,
                  child: DropdownButton<String>(
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
                )
        ],
        proximo: _proximo);
  }

  void _proximo() {
    int idSexo = 0;
    if (dropdownValue != 'Selecionar sexo') {
      for (var item in _dadosSexo) {
        if (item['nome'] == dropdownValue) {
          idSexo = item['idSexo'];
        }
      }

      usuarioCadastro.sexo = idSexo;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secAnimation) =>
              CadastroPagePart5(),
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
    } else {
      showToast(context,
          texto: 'Selecione um sexo', cor: Colors.red, duracao: 5);
    }
  }
}
