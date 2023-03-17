import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/CadastroPagePart4.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/ModelPage.dart';
import '../../../Componets/globals.dart' as globals;

class CadastroPagePart3 extends StatefulWidget {
  @override
  State<CadastroPagePart3> createState() => _CadastroPagePart3State();
}

class _CadastroPagePart3State extends State<CadastroPagePart3> {
  TextEditingController _dataController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _paddingTop = MediaQuery.of(context).padding.top;
    return ModelCadastroPage(
        nivelPage: 3,
        conteudo: [
          Padding(
            padding: EdgeInsets.only(bottom: _size.height * 0.08),
            child: Text(
              'Qual a sua data de nascimento?',
              style: TextStyle(
                  fontFamily: fontePrincipal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          InputText2(
            label: 'Data de Nascimento',
            maskType: 'data',
            tipoTeclado: TextInputType.datetime,
            lastInput: true,
            controlador: _dataController,
            icone: Icons.calendar_month_outlined,
          ),
        ],
        proximo: _proximo);
  }

  void _proximo() {
    if (_dataController.text.length < 10) {
      showToast(context,
          texto: 'Preencha o campo data de nascimento',
          cor: Colors.red,
          duracao: 5);
    } else {
      String dia = _dataController.text.substring(0, 2);
      String mes = _dataController.text.substring(3, 5);
      String ano = _dataController.text.substring(6, 10);
      usuarioCadastro.dataNascimento = '$ano-$mes-$dia';
      print('$ano-$mes-$dia');

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => CadastroPagePart4(),
        ),
      );
    }
  }
}
