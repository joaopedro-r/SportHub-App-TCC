import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:SportHub/Componets/variaveisConst.dart';
import 'package:SportHub/screens/SportHub/GrupoPages/grupos.dart';
import 'package:SportHub/screens/SportHub/PerfilPages/perfil_page.dart';

import 'BuscaPages/busca_page.dart';
import 'FavoritosPages/favoritos_page.dart';
import 'HomePages/home_page.dart';

class PaginaInicialSporthub extends StatefulWidget {
  int? setIndex;

  PaginaInicialSporthub({this.setIndex});

  @override
  State<PaginaInicialSporthub> createState() => _PaginaInicialSporthubState();
}

class _PaginaInicialSporthubState extends State<PaginaInicialSporthub> {
  int _index = 1;
  @override
  void initState() {
    super.initState();
    if (widget.setIndex != null) {
      _index = widget.setIndex!;
    }
  }

  final screens = [
    //FavoritosPage(),
    //BuscaPage(),
    GrupoPage(),
    HomePage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final items = <Widget>[
      //  (_index == 0)
      //      ? Icon(Icons.favorite, size: 30, color: azulEscuro)
      //      : Icon(Icons.favorite_border, size: 30, color: azulEscuro),
      //  (_index == 1)
      //      ? Image.asset('assets/images/modelos/icones/favicon.ico',
      //          height: _size.height * .030, color: azulEscuro)
      //      : Image.asset('assets/images/modelos/icones/search.png',
      //          height: _size.height * .030, color: azulEscuro),
      (_index == 0)
          ? Icon(Icons.groups, size: 30, color: azulEscuro)
          : Icon(Icons.groups_outlined, size: 30, color: azulEscuro),
      (_index == 1)
          ? Icon(Icons.home, size: 30, color: azulEscuro)
          : Icon(Icons.home_outlined, size: 30, color: azulEscuro),
      (_index == 2)
          ? Icon(Icons.person, size: 30, color: azulEscuro)
          : Icon(Icons.person_outline_rounded, size: 30, color: azulEscuro),
    ];
    return Scaffold(
      //backgroundColor: cinza,
      extendBody: true,
      body: screens[_index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        height: _size.height * .08,
        animationDuration: const Duration(milliseconds: 600),
        items: items,
        index: _index,
        onTap: (index) => setState(
          () => this._index = index,
        ),
      ),
    );
  }
}
