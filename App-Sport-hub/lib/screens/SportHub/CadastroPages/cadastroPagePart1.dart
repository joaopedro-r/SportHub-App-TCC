import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/CadastroPagePart2.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/ModelPage.dart';

class CadastroPagePart1 extends StatefulWidget {
  @override
  State<CadastroPagePart1> createState() => _CadastroPagePart1State();
}

class _CadastroPagePart1State extends State<CadastroPagePart1> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confirmarSenha = TextEditingController();
  bool _loadingPage = false;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return (_loadingPage == true)
        ? Scaffold(
            body: CarregarPagina(),
          )
        : ModelCadastroPage(
            nivelPage: 1,
            conteudo: [
              Padding(
                padding: EdgeInsets.only(bottom: _size.height * 0.08),
                child: Text(
                  'Dados cadastrais',
                  style: TextStyle(
                      fontFamily: fontePrincipal,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              InputText2(
                label: 'E-mail',
                tipoTeclado: TextInputType.emailAddress,
                controlador: _emailController,
                icone: Icons.email_outlined,
              ),
              InputText2(
                label: 'Senha',
                typeSenha: true,
                tipoTeclado: TextInputType.visiblePassword,
                changeViewSenha: true,
                controlador: _senhaController,
                icone: Icons.lock_outline_rounded,
              ),
              InputText2(
                label: 'Confirmar Senha',
                typeSenha: true,
                tipoTeclado: TextInputType.visiblePassword,
                controlador: _confirmarSenha,
                icone: Icons.lock_outline_rounded,
                lastInput: true,
              ),
            ],
            proximo: _proximo);
  }

  Future _proximo() async {
    if (_emailController.text == '' ||
        !_emailController.text.contains(RegExp(r'[a-zA-Z0-9]')) ||
        _senhaController.text == '' ||
        _confirmarSenha.text == '') {
      showToast(context,
          texto: 'Preencha todos os campos', cor: Colors.red, duracao: 5);
    } else if (_senhaController.text != _confirmarSenha.text) {
      showToast(context,
          texto: 'As senhas não coincidem', cor: Colors.red, duracao: 5);
    } else {
      // _verificarEmail();
      //final response = await http.get(
      //  Uri.parse('$urlBasica/usuario/todos'),
      //  headers: headersWebService,
      //);
      setState(() {
        _loadingPage = true;
      });

      var response = await sendRequest(
        context,
        endPoint: 'autenticacao/verificarEmail/${_emailController.text}',
        method: 'GET',
        showErrorMsg: true,
      );
      if (response != null) {
        usuarioCadastro.email = _emailController.text;
        usuarioCadastro.senha = _senhaController.text;

        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secAnimation) =>
                CadastroPagePart2(),
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
      }
      setState(() {
        _loadingPage = false;
      });
    }
  }
}
