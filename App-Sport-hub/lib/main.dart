import 'package:SportHub/Componets/functions.dart';
import 'package:SportHub/screens/SportHub/pagina_inicial_sporthub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/screens/SportHub/LoginPages/loginPage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(InicialClass());
}

class InicialClass extends StatefulWidget {
  @override
  State<InicialClass> createState() => _InicialClassState();
}

class _InicialClassState extends State<InicialClass> {
  bool _directLogin = false;
  bool initLoading = true;

  readSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var session = prefs.getString('sessionid');
    if (session != null) {
      setState(() {
        headersWebService['Cookie'] = session;
      });
    }
  }

  Future _checkUser() async {
    await readSession();
    var logar = await sendRequest(
      this.context,
      endPoint: 'autenticacao/login',
      body: {'email': '', 'senha': ''},
      method: 'POST',
      loginMethod: true,
    );
    if (logar != null) {
      setState(() {
        _directLogin = true;
        initLoading = false;
      });
    } else {
      setState(() {
        initLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'SportHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: azulEscuro,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarColor: azulEscuro,
            ),
            foregroundColor: Colors.white,
            backgroundColor: azulEscuro,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: verdeClaro,
            foregroundColor: Colors.black,
          ),

          //muda cor do glow do scroll
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: azulEscuro)),
      home: (initLoading == true)
          ? Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: azulEscuro,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 200,
                        image: AssetImage('assets/images/LogoSportHub.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(
                          color: verdeClaro,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : (_directLogin == false)
              ? LoginPage()
              : PaginaInicialSporthub(),
    );
  }
}
