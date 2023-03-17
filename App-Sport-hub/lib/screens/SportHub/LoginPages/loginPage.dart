import 'package:SportHub/Componets/functions.dart';
import 'package:flutter/material.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/CadastroPages/cadastroPagePart1.dart';
import 'package:SportHub/screens/SportHub/pagina_inicial_sporthub.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  bool _loadingButtons = false;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: _size.width,
        height: _size.height,
        padding: EdgeInsets.only(
            bottom: _size.height * 0.02,
            left: _size.width * 0.1,
            right: _size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: _size.height * .1),
              child: Image(
                image: AssetImage('assets/images/LogoSportHub.png'),
                width: _size.width * 0.6,
              ),
            ),
            Column(
              children: [
                InputText2(
                  label: 'E-mail',
                  controlador: _usuarioController,
                  icone: Icons.email_outlined,
                ),
                InputText2(
                  label: 'Senha',
                  typeSenha: true,
                  changeViewSenha: true,
                  lastInput: true,
                  controlador: _senhaController,
                  icone: Icons.lock_outline_rounded,
                ),
                TextButton(
                  onPressed: () {},
                  child: Container(
                    width: _size.width * 0.8,
                    child: Text(
                      'Esqueci minha senha',
                      style: TextStyle(
                        color: azulEscuro,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            (_loadingButtons == false)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button1(
                        label: 'ENTRAR',
                        funcao: _entrar,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: _size.height * 0.04),
                        child: Button1(
                          label: 'CADASTRE-SE',
                          changeColors: true,
                          funcao: _irCadastro,
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    child: CircularProgressIndicator(
                      color: verdeClaro,
                    ),
                    //height: 200.0,
                    width: _size.width * 0.05,
                    height: _size.width * 0.05,
                  )
          ],
        ),
      ),
    );
  }

  Future _entrar() async {
    //verificar se os campos estão preenchidos
    setState(() {
      _loadingButtons = true;
    });

    if (_usuarioController.text == '' || _senhaController.text == '') {
      showToast(context,
          texto: 'Preencha todos os campos', duracao: 5, cor: Colors.red);
      setState(() {
        _loadingButtons = false;
      });
    } else {
      var response = await sendRequest(
        context,
        endPoint: 'autenticacao/login',
        method: 'POST',
        body: {
          'email': _usuarioController.text,
          'senha': _senhaController.text,
        },
        loginMethod: true,
        showErrorMsg: true,
        showSuccessMsg: true,
      );
      if (response != null) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => PaginaInicialSporthub(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          _loadingButtons = false;
        });
      }
    }
  }

  void _irCadastro() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => CadastroPagePart1(),
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
}
