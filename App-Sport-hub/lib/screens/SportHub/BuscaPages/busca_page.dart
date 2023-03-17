import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class BuscaPage extends StatelessWidget {
  const BuscaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_wso9kgdi.json',
                frameRate: FrameRate.max),
            Text(
              'Em breve você poderá buscar jogos públicos mais rapidamente',
              style: TextStyle(fontSize: 30, fontFamily: fontePrincipal),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
