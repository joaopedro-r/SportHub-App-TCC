import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(
            fontFamily: fontePrincipal,
          ),
        ),
      ),
      body: Center(
        child: Lottie.network(
            'https://assets7.lottiefiles.com/packages/lf20_zyu0ctqb.json',
            frameRate: FrameRate.max),
      ),
    );
  }
}
