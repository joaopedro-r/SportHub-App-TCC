import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/CadastroPagePart3.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/ModelPage.dart';
import '../../../Componets/globals.dart' as globals;

class CadastroPagePart2 extends StatefulWidget {
  @override
  State<CadastroPagePart2> createState() => _CadastroPagePart2State();
}

class _CadastroPagePart2State extends State<CadastroPagePart2> {
  TextEditingController _nomeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return ModelCadastroPage(
        nivelPage: 2,
        conteudo: [
          Padding(
            padding: EdgeInsets.only(bottom: _size.height * 0.08),
            child: Text(
              'Qual o seu nome?',
              style: TextStyle(
                  fontFamily: fontePrincipal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          InputText2(
            label: 'Nome Completo',
            controlador: _nomeController,
            icone: Icons.person,
            lastInput: true,
          ),
        ],
        proximo: _proximo);
  }

  void _proximo() {
    if (_nomeController.text == '' ||
        !_nomeController.text.contains(RegExp(r'[a-zA-Z0-9]'))) {
      showToast(context,
          texto: 'Preencha o campo nome', cor: Colors.red, duracao: 5);
    } else {
      usuarioCadastro.nome = _nomeController.text;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => CadastroPagePart3(),
        ),
      );
    }
  }
}
