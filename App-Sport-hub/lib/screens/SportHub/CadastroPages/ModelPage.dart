import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';

class ModelCadastroPage extends StatelessWidget {
  int nivelPage;
  List<Widget> conteudo;
  Function proximo;
  bool ultimo;
  ModelCadastroPage(
      {required this.nivelPage,
      required this.conteudo,
      required this.proximo,
      this.ultimo = false});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    //pegar tamanho da status bar
    var _paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        toolbarHeight: _size.height * 0.15,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _size.width,
          height: _size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: _paddingTop),
              ProgressRegister(nivel: nivelPage),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: _size.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //conteudo
                      ...conteudo,

                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: _size.height * 0.04),
                        child: Button1(
                          label: (ultimo == false) ? 'PRÓXIMO' : 'CADASTRAR',
                          funcao: proximo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
