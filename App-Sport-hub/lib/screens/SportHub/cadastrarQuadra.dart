import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CadastroQuadra extends StatefulWidget {
  Map dadosQuadra;
  bool isedit;

  CadastroQuadra({required this.dadosQuadra, this.isedit = false});
  @override
  State<CadastroQuadra> createState() => _CadastroQuadraState();
}

class _CadastroQuadraState extends State<CadastroQuadra> {
  TextEditingController _nomeQuadraController = TextEditingController();
  TextEditingController _enderecoQuadraController = TextEditingController();
  TextEditingController _estadoQuadraController = TextEditingController();
  TextEditingController _bairroQuadraController = TextEditingController();
  TextEditingController _complementoController = TextEditingController();

  List _valuesSelected = [];
  List _modalidades = [];
  bool _loadingModalidades = true;

  Future _loadDados() async {
    var response = await sendRequest(
      context,
      endPoint: 'modalidade/todos',
      method: 'GET',
    );
    if (response != null) {
      setState(() {
        _modalidades = response;
      });
    }
    setState(() {
      _loadingModalidades = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDados();

    if (widget.isedit) {
      _nomeQuadraController.text = widget.dadosQuadra['nome'];
      _enderecoQuadraController.text = widget.dadosQuadra['rua'];
      _estadoQuadraController.text = widget.dadosQuadra['estado'];
      _bairroQuadraController.text = widget.dadosQuadra['bairro'];
      if (widget.dadosQuadra['complemento'] != null)
        _complementoController.text = widget.dadosQuadra['complemento'];

      for (var i = 0; i < widget.dadosQuadra['modalidades'].length; i++) {
        _valuesSelected.add(widget.dadosQuadra['modalidades'][i]['idModalidade']
            ['idModalidade']);
      }
    } else {
      _enderecoQuadraController.text = widget.dadosQuadra['street'];
      _estadoQuadraController.text = widget.dadosQuadra['administrativeArea'];
      _bairroQuadraController.text = widget.dadosQuadra['subLocality'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            (widget.isedit == false) ? 'Cadastrar Quadra' : 'Atualizar Quadra'),
      ),
      body: Container(
        width: _size.width,
        height: _size.height,
        padding: EdgeInsets.symmetric(
            horizontal: _size.width * 0.05, vertical: _size.height * 0.03),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _size.height * 0.04),
                  child: InputText1(
                    titulo: 'Nome da Quadra',
                    acaoTeclado: TextInputAction.done,
                    controlador: _nomeQuadraController,
                    editable: (widget.isedit == false) ? true : false,
                    maximoCaracteres: 60,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _size.height * 0.05, bottom: _size.height * 0.01),
                  child: Text(
                    'Informações da quadra',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontePrincipal,
                    ),
                  ),
                ),
                Text(
                  'Por favor verifique se as informações estão corretas, caso não estejam, edite-as. Esta etapa é extremamente importante para a comunidade SportHub.',
                ),
                Container(
                  height: _size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InputText1(
                        titulo: 'Estado',
                        controlador: _estadoQuadraController,
                        editable: false,
                      ),
                      InputText1(
                        titulo: 'Bairro',
                        controlador: _bairroQuadraController,
                        editable: false,
                      ),
                      InputText1(
                        titulo: 'Endereço',
                        controlador: _enderecoQuadraController,
                        maximoCaracteres: 60,
                      ),
                      InputText1(
                        titulo: 'Complemento',
                        controlador: _complementoController,
                        textoAjuda: 'Ponto de referência',
                        maximoCaracteres: 60,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: _size.height * 0.02),
                  child: Text(
                    'Esportes disponíveis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontePrincipal,
                    ),
                  ),
                ),
                (_loadingModalidades == true)
                    ? SizedBox(
                        child: CircularProgressIndicator(
                          color: verdeClaro,
                        ),
                        //height: 200.0,
                        width: _size.width * 0.05,
                        height: _size.width * 0.05,
                      )
                    : Container(
                        height: _size.height * 0.2,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Wrap(
                              runSpacing: 20,
                              spacing: 10,
                              children: List<Widget>.generate(
                                _modalidades.length,
                                (int index) {
                                  return ChoiceChip(
                                      label: Text(
                                        '${_modalidades[index]['nome']}',
                                        style: TextStyle(
                                            fontFamily: fontePrincipal),
                                      ),
                                      selected: _valuesSelected.contains(
                                          _modalidades[index]['idModalidade']),
                                      selectedColor: verdeClaro,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            _valuesSelected.add(
                                                _modalidades[index]
                                                    ['idModalidade']);
                                          } else {
                                            _valuesSelected.remove(
                                                _modalidades[index]
                                                    ['idModalidade']);
                                          }
                                          print(_valuesSelected);
                                        });
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                Button1(
                  label: (widget.isedit == false)
                      ? 'Cadastrar Quadra'
                      : 'Atualizar Quadra',
                  funcao: _cadastrarQuadra,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _cadastrarQuadra() async {
    //print(_nomeQuadraController.text);
    //print(_enderecoQuadraController.text);
    //print(_estadoQuadraController.text);
    //print(_bairroQuadraController.text);

    if (_nomeQuadraController.text == '' ||
        !_enderecoQuadraController.text.contains(RegExp(r'[a-zA-Z0-9]')) ||
        _enderecoQuadraController.text == '' ||
        !_enderecoQuadraController.text.contains(RegExp(r'[a-zA-Z0-9]')) ||
        _estadoQuadraController.text == '' ||
        _bairroQuadraController.text == '') {
      showToast(context, texto: 'Preencha todos os campos', cor: Colors.red);
      return null;
    }
    if (_valuesSelected.length == 0) {
      //se não selecionou nenhuma modalidade
      showToast(context,
          texto: 'Selecione pelo menos uma modalidade',
          cor: Colors.red,
          duracao: 5);
      return null;
    }

    var response;
    if (widget.isedit == false) {
      response = await sendRequest(
        context,
        endPoint: 'localizacao/novo',
        method: 'POST',
        body: {
          'nome': _nomeQuadraController.text,
          'rua': _enderecoQuadraController.text,
          'estado': _estadoQuadraController.text,
          'bairro': _bairroQuadraController.text,
          'complemento': _complementoController.text,
          'latitude': widget.dadosQuadra['latitude'],
          'longitude': widget.dadosQuadra['longitude'],
          'modalidades': _valuesSelected,
        },
        showErrorMsg: true,
        showSuccessMsg: true,
      );
    } else {
      response = await sendRequest(
        context,
        endPoint: 'localizacao/editar',
        method: 'PUT',
        body: {
          'idLocalizacao': widget.dadosQuadra['idLocalizacao'],
          'nome': _nomeQuadraController.text,
          'rua': _enderecoQuadraController.text,
          'estado': _estadoQuadraController.text,
          'bairro': _bairroQuadraController.text,
          'complemento': _complementoController.text,
          'latitude': widget.dadosQuadra['latitude'],
          'longitude': widget.dadosQuadra['longitude'],
          'modalidades': _valuesSelected,
        },
        showErrorMsg: true,
        showSuccessMsg: true,
      );
    }

    if (response != null) {
      Navigator.pop(context, response['data']);
    }
  }
}
