import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/FutRua/sortear_equipes.dart';
import 'package:flutter/material.dart';
//import 'package:SportHub/Componets/globals.dart' as globals;
//import 'package:SportHub/Componets/globals.dart';

// ignore: must_be_immutable
class InsereClass extends StatefulWidget {
  List? confirmados;
  Map dadosJogo;
  InsereClass({this.confirmados, required this.dadosJogo});
  @override
  _InsereClassState createState() => _InsereClassState();
}

class _InsereClassState extends State<InsereClass> {
  List<TextEditingController> _jogador = [TextEditingController()];
  List _initialList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Inserir Jogadores'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'A ordem não importa caso vá sortear os jogadores.\nLembrando que é possivel adicionar novos jogadores posteriormente.',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: (widget.confirmados != null)
                    ? widget.confirmados!.length
                    : 0,
                itemBuilder: (context, index) {
                  String usuario =
                      "${widget.confirmados![index]['usuario']['nome']} #${widget.confirmados![index]['usuario']['idUsuario']}";
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(usuario),
                    checkColor: Colors.white,
                    activeColor: verdeClaro,
                    value: _initialList.contains(usuario),
                    onChanged: (bool? value) {
                      if (value == true) {
                        setState(() {
                          _initialList.add(usuario);
                        });
                      } else {
                        setState(() {
                          _initialList.remove(usuario);
                        });
                      }
                    },
                  );
                }),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: _jogador.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: _size.height * 0.01),
                  child: Stack(
                    children: [
                      InputText1(
                        titulo: 'Visitante ${index + 1}',
                        controlador: _jogador[index],
                        maximoCaracteres: 16,
                        icone: Icons.person,
                        funcao: () {
                          if (_jogador[index].text != '' ||
                              !_jogador[index]
                                  .text
                                  .contains(RegExp(r'[a-zA-Z0-9]'))) {
                            setState(() {
                              _jogador.add(TextEditingController());
                            });
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                      (_jogador.length > 1)
                          ? Positioned(
                              right: 25,
                              top: 5,
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _jogador.removeAt(index);
                                  });
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            ),
            OutlinedButton.icon(
              label: Text('Adicionar'),
              icon: Icon(Icons.add),
              style: OutlinedButton.styleFrom(
                primary: verde,
                side: BorderSide(color: verde),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                setState(() {
                  _jogador.add(TextEditingController());
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Button1(
                  label: 'Avançar',
                  funcao: _adicionarJogadores,
                )),
          ],
        ),
      ),
      //bottomNavigationBar: Container(
      //  child: AdWidget(
      //    ad: anuncio_banner.bannerAd!,
      //  ),
      //  width: anuncio_banner.bannerAd!.size.width.toDouble(),
      //  height: anuncio_banner.bannerAd!.size.height.toDouble(),
      //),
    );
  }

  void _adicionarJogadores() {
    //_playersList.clear();
    //globals.lista_players = [];
    List _playersList = [];

    //verificar se tem jogador com mesmo nome
    List verificar = [];

    int index = 0;
    for (var a in _jogador) {
      if (index != _jogador.length - 1) {
        if (a.text == '' || !a.text.contains(RegExp(r'[a-zA-Z0-9]'))) {
          showToast(context,
              texto: 'Preencha todos os campos', cor: Colors.red);
          return null;
        }
      }
      index++;
    }

    for (var a in _jogador) {
      if (verificar.contains(a.text)) {
        showToast(context, texto: 'Possui nomes duplicados', cor: Colors.red);
        return null;
      }
      verificar.add(a.text);
    }

    for (var a in _initialList) {
      _playersList.add(a);
    }
    for (var a in _jogador) {
      if (a.text != '' && a.text.contains(RegExp(r'[a-zA-Z0-9]'))) {
        _playersList.add(a.text);
      }
    }

    if (_playersList.length < 2) {
      showToast(context,
          texto: 'É necessário pelo menos 2 jogadores', cor: Colors.red);

      return null;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secAnimation) => SortearEquipes(
          dadosJogo: widget.dadosJogo,
          listPlayers: _playersList,
        ),
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
