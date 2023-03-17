import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter/material.dart';

class AjudaPage extends StatefulWidget {
  const AjudaPage({Key? key}) : super(key: key);

  @override
  State<AjudaPage> createState() => _AjudaPageState();
}

class _AjudaPageState extends State<AjudaPage> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prêmio projeto destaque',
          style: TextStyle(
            fontFamily: fontePrincipal,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: _size.height * .15, bottom: _size.height * 0.05),
              child: Text(
                'Vote SportHub como projeto destaque:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontePrincipal,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              height: _size.height * 0.4,
              child: Image(
                image: AssetImage('assets/images/qrcode.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
