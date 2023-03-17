import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformacoesWidget extends StatefulWidget {
  Map dadosJogo;

  InformacoesWidget({required this.dadosJogo});

  @override
  State<InformacoesWidget> createState() => _InformacoesWidgetState();
}

class _InformacoesWidgetState extends State<InformacoesWidget> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    //converter data e hora para datetime
    DateTime data = DateTime.parse(widget.dadosJogo['dataHora']).toLocal();
    //consertar 0 antes de horas e minutos
    String hora = data.hour.toString().padLeft(2, '0');
    String minuto = data.minute.toString().padLeft(2, '0');
    String horaString = hora + ':' + minuto;

    //consertar 0 antes de dia e mes
    String dia = data.day.toString().padLeft(2, '0');
    String mes = data.month.toString().padLeft(2, '0');
    String dataString = dia + '/' + mes + '/' + data.year.toString();

    String horaData = dataString + ' às ' + horaString + ' horas';

    //formatar local

    return Column(
      children: [
        Container(
          width: _size.width,
          padding: EdgeInsets.symmetric(horizontal: _size.width * 0.05),
          child: Padding(
            padding: EdgeInsets.only(top: _size.height * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    fieldJogo(
                      dado: widget.dadosJogo['nome'],
                      label: 'NOME',
                    ),
                    fieldJogo(
                      dado:
                          widget.dadosJogo['privado'] == false ? 'Não' : 'Sim',
                      label: 'PRIVADO',
                    ),
                  ],
                ),
                Row(
                  children: [
                    fieldJogo(
                      dado: horaData,
                      label: 'DATA E HORA',
                    ),
                    fieldJogo(
                      dado: (widget.dadosJogo['localizacao']['complemento'] !=
                              null)
                          ? '${widget.dadosJogo['localizacao']['complemento']} - ${widget.dadosJogo['localizacao']['estado']} - ${widget.dadosJogo['localizacao']['bairro']} - ${widget.dadosJogo['localizacao']['rua']}'
                          : '${widget.dadosJogo['localizacao']['estado']} - ${widget.dadosJogo['localizacao']['bairro']} - ${widget.dadosJogo['localizacao']['rua']}',
                      label: 'LOCAL',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Mapa(
            inicialLatitude: widget.dadosJogo['localizacao']['latitude'],
            inicialLongitude: widget.dadosJogo['localizacao']['longitude'],
          ),
        )
      ],
    );
  }
}

class fieldJogo extends StatelessWidget {
  String label;
  String dado;
  String? dado2;
  fieldJogo({required this.dado, required this.label, this.dado2});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: _size.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontePrincipal,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: _size.height * 0.005),
              child: Text(
                dado,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontePrincipal,
                  color: verde,
                ),
              ),
            ),
            (dado2 != null)
                ? Text(
                    dado2!,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: fontePrincipal,
                      color: verde,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
