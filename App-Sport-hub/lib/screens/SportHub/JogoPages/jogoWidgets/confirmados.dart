import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:flutter/cupertino.dart';

class ConfirmadosWidget extends StatefulWidget {
  List confirmados;
  int idJogo;

  ConfirmadosWidget({required this.confirmados, required this.idJogo});
  @override
  State<ConfirmadosWidget> createState() => _ConfirmadosWidgetState();
}

class _ConfirmadosWidgetState extends State<ConfirmadosWidget> {
  bool confirmado = false;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.confirmados.length; i++) {
      if (widget.confirmados[i]['usuario']['email'] ==
          userDataGlobal['email']) {
        confirmado = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Column(
      children: [
        (widget.confirmados.length == 0)
            ? Expanded(
                child: Center(
                  child: Text(
                    'Ninguém confirmado para este jogo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: fontePrincipal, fontSize: 20),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: _size.height * 0.1),
                  shrinkWrap: true,
                  itemCount: widget.confirmados.length,
                  itemBuilder: (context, index) {
                    return CardMembros(
                      nome: widget.confirmados[index]['usuario']['nome'],
                      apelido: widget.confirmados[index]['usuario']['nome'],
                      foto: widget.confirmados[index]['usuario']['fotoPerfil'],
                      idUsuarioBD: widget.confirmados[index]['usuario']
                          ['idUsuario'],
                      viewAdm: false,
                    );
                  },
                ),
              ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: _size.height * 0.03),
          child: Button1(
            label: (confirmado == false) ? 'Confirmar' : 'Desistir',
            funcao: _alterStatus,
          ),
        )
      ],
    );
  }

  Future _alterStatus() async {
    var response;
    if (confirmado) {
      //desconfirmar
      response = await sendRequest(
        context,
        endPoint: 'confirmado/deletar',
        method: 'DELETE',
        body: {
          'jogo': widget.idJogo,
        },
        showErrorMsg: true,
        showSuccessMsg: true,
      );
    } else {
      //confirmar
      response = await sendRequest(
        context,
        endPoint: 'confirmado/novo',
        method: 'POST',
        body: {
          'jogo': widget.idJogo,
        },
        showErrorMsg: true,
        showSuccessMsg: true,
      );
    }
    if (response != null) {
      setState(() {
        if (confirmado == false) {
          widget.confirmados.add(
            {'usuario': userDataGlobal},
          );
          confirmado = true;
        } else {
          for (var i = 0; i < widget.confirmados.length; i++) {
            if (widget.confirmados[i]['usuario']['email'] ==
                userDataGlobal['email']) {
              widget.confirmados.removeAt(i);
            }
          }
          confirmado = false;
        }
      });
    }
  }
}
