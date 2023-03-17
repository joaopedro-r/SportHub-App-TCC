import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_krufdj5t.json',
              frameRate: FrameRate.max),
          Text(
            'Em breve você poderá ver seus jogos favoritos',
            style: TextStyle(fontSize: 30, fontFamily: fontePrincipal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
