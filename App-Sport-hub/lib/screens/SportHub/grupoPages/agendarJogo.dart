import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/Componets/globals.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:SportHub/screens/SportHub/selecionarLocal.dart';
import 'package:flutter/material.dart';

class AgendarJogo extends StatefulWidget {
  bool editMode;
  Map? dadosJogo;
  AgendarJogo({this.editMode = false, this.dadosJogo});
  @override
  State<AgendarJogo> createState() => _AgendarJogoState();
}

class _AgendarJogoState extends State<AgendarJogo> {
  bool _jogoPrivado = false;
  TimeOfDay _horaInicio = TimeOfDay.now();
  DateTime _dataInicio = DateTime.now();
  TextEditingController _nomeJogoController = TextEditingController();
  DateTime? _dataJogo;
  TimeOfDay? _horaJogo;
  String? dia;
  String? mes;
  String? ano;
  String? horario;
  String? minuto;
  Map? localizacao;

  bool _loading = false;
  @override
  void _loadDadosJogo() {
    print(widget.dadosJogo);
    _nomeJogoController.text = widget.dadosJogo!['nome'];

    widget.dadosJogo!['dataHora'] =
        DateTime.parse(widget.dadosJogo!['dataHora']).toLocal().toString();
    _dataJogo = DateTime.parse(widget.dadosJogo!['dataHora']);
    _horaJogo =
        TimeOfDay.fromDateTime(DateTime.parse(widget.dadosJogo!['dataHora']));

    dia = widget.dadosJogo!['dataHora'].toString().substring(8, 10);
    mes = widget.dadosJogo!['dataHora'].toString().substring(5, 7);
    ano = widget.dadosJogo!['dataHora'].toString().substring(0, 4);
    horario = widget.dadosJogo!['dataHora'].toString().substring(11, 13);
    minuto = widget.dadosJogo!['dataHora'].toString().substring(14, 16);
    //_horaJogo =
    //    TimeOfDay.fromDateTime(DateTime.parse(widget.dadosJogo!['data']));
    _jogoPrivado = widget.dadosJogo!['privado'];
    localizacao = widget.dadosJogo!['localizacao'];
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editMode == true) {
      _loadDadosJogo();
    }
  }

  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return (_loading == true)
        ? Scaffold(
            body: CarregarPagina(
              texto: (widget.editMode == false)
                  ? 'Agendando jogo'
                  : 'Atualizando jogo',
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text((widget.editMode == false)
                  ? 'Agendar ${dadosGrupoGlobal['modalidade']}'
                  : 'Editar ${dadosGrupoGlobal['modalidade']}'),
            ),
            body: Container(
              width: _size.width,
              height: _size.height,
              padding: EdgeInsets.symmetric(horizontal: _size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputText2(
                    label: 'Titulo jogo',
                    icone: Icons.abc,
                    lastInput: true,
                    controlador: _nomeJogoController,
                  ),
                  ButtonForm(
                    label: (_dataJogo == null || _horaJogo == null)
                        ? 'Data e hora'
                        : '$dia/$mes/$ano - $horario:$minuto',
                    icone: Icons.date_range,
                    funcao: selectDateTime,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _size.height * .03),
                    child: ButtonForm(
                      label: (localizacao == null)
                          ? 'Localização'
                          : '${localizacao!['nome']}, ${localizacao!['bairro']}',
                      icone: Icons.near_me,
                      showIconRight: true,
                      funcao: selectLocation,
                    ),
                  ),
                  CheckboxListTile(
                      title: Text('Jogo privado'),
                      checkColor: Colors.white,
                      activeColor: verdeClaro,
                      value: _jogoPrivado,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          _jogoPrivado = value!;
                        });
                      }),
                  Button1(
                    label: (widget.editMode == false) ? 'AGENDAR' : 'ATUALIZAR',
                    funcao: criarJogo,
                  )
                ],
              ),
            ),
          );
  }

  Future criarJogo() async {
    //remover keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
    });
    if (_nomeJogoController.text.isEmpty ||
        !_nomeJogoController.text.contains(RegExp(r'[a-zA-Z0-9]')) ||
        _dataJogo == null ||
        _horaJogo == null ||
        localizacao == null) {
      setState(() {
        _loading = false;
        showToast(context, texto: 'Preencha todos os campos', cor: Colors.red);
      });
      return null;
    }

    //converter _dataJogo e _horaJogo para dateTime
    DateTime dataHoraJogo = DateTime(_dataJogo!.year, _dataJogo!.month,
        _dataJogo!.day, _horaJogo!.hour, _horaJogo!.minute);
    var response;
    if (widget.editMode == false) {
      response = await sendRequest(
        this.context,
        endPoint: 'jogo/novo',
        method: 'POST',
        body: {
          'nome': _nomeJogoController.text,
          'grupo': dadosGrupoGlobal['idGrupo'],
          'idLocalizacao': localizacao!['idLocalizacao'],
          'privado': _jogoPrivado,
          'dataHora': dataHoraJogo.toUtc().toString(),
        },
        showErrorMsg: true,
        showSuccessMsg: true,
      );
    } else {
      response = await sendRequest(
        this.context,
        endPoint: 'jogo/editar',
        method: 'PUT',
        body: {
          'idJogo': widget.dadosJogo!['idJogo'],
          'nome': _nomeJogoController.text,
          'idLocalizacao': localizacao!['idLocalizacao'],
          'privado': _jogoPrivado,
          'dataHora': dataHoraJogo.toUtc().toString(),
        },
        showErrorMsg: true,
        showSuccessMsg: true,
      );
    }
    if (response != null) {
      if (widget.editMode == true) {
        Navigator.pop(this.context, response['data']);
      } else {
        Navigator.pop(this.context, response['idJogo']);
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  //funcao para mostrar uma caixa de dialogo com o calendario
  Future<void> selectDateTime() async {
    FocusScope.of(context).unfocus();
    //showTimePicker(context: context, initialTime: _horaInicio);
    var data = await showDatePicker(
      context: context,
      initialDate: _dataInicio,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      confirmText: 'Selecionar hora',
      cancelText: 'Cancelar',
      helpText: 'Selecione a data',
      //apos selecionar a data, pegar o horario
    );

    if (data != null) {
      var hora = await showTimePicker(
        context: context,
        initialTime: _horaInicio,
        confirmText: 'Selecionar',
        cancelText: 'Cancelar',
        hourLabelText: 'Hora',
        minuteLabelText: 'Minutos',
      );
      if (hora != null) {
        setState(() {
          _dataJogo = data;
          _horaJogo = hora;
          //verificar se a hora e a data é menor que a data atual
          DateTime dataHoraJogo = DateTime(_dataJogo!.year, _dataJogo!.month,
              _dataJogo!.day, _horaJogo!.hour, _horaJogo!.minute);
          if (dataHoraJogo.isBefore(DateTime.now())) {
            _dataJogo = null;
            _horaJogo = null;
            showToast(context, texto: 'Horario não permitido', cor: Colors.red);
            return;
          }

          if (_dataJogo!.day < 10) {
            dia = '0${_dataJogo!.day}';
          } else {
            dia = '${_dataJogo!.day}';
          }
          if (_dataJogo!.month < 10) {
            mes = '0${_dataJogo!.month}';
          } else {
            mes = '${_dataJogo!.month}';
          }
          if (_dataJogo!.year < 10) {
            ano = '0${_dataJogo!.year}';
          } else {
            ano = '${_dataJogo!.year}';
          }
          if (_horaJogo!.hour < 10) {
            horario = '0${_horaJogo!.hour}';
          } else {
            horario = '${_horaJogo!.hour}';
          }
          if (_horaJogo!.minute < 10) {
            minuto = '0${_horaJogo!.minute}';
          } else {
            minuto = '${_horaJogo!.minute}';
          }
        });
      }
    }
  }

  void selectLocation() {
    FocusScope.of(context).unfocus();
    if (_dataJogo == null || _horaJogo == null) {
      showToast(context,
          texto: 'Preencha a data e hora para selecionar um local',
          cor: Colors.red);

      return null;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => SelecionarLocal(),
      ),
    ).then((value) {
      setState(() {
        localizacao = value;
      });
    });
  }
}

class ButtonForm extends StatelessWidget {
  Function? funcao;
  String label;
  IconData? icone;
  bool showIconRight;
  ButtonForm(
      {this.funcao,
      required this.label,
      required this.icone,
      this.showIconRight = false});
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        if (funcao != null) {
          funcao!();
        }
      },
      child: Container(
        width: _size.width,
        padding: EdgeInsets.symmetric(
            vertical: _size.height * 0.03, horizontal: _size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cinza),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: _size.width * 0.03),
                    child: Icon(
                      icone,
                      color: cinza,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${label}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (showIconRight)
                ? Icon(
                    Icons.arrow_forward_ios,
                    color: cinza,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
