import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({Key? key}) : super(key: key);

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificações',
          style: TextStyle(
            fontFamily: fontePrincipal,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child: Lottie.network(
                  'https://assets3.lottiefiles.com/packages/lf20_heejrebm.json'),
            ),
            Text(
              'Sem notificações por aqui...',
              style: TextStyle(
                fontFamily: fontePrincipal,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
