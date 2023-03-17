import 'package:SportHub/models/models.dart';
import 'package:flutter/material.dart';

class ListaMembros extends StatefulWidget {
  List _dadosMembros;
  bool viewAdm;
  Map admin;
  ListaMembros(
    this._dadosMembros, {
    this.viewAdm = false,
    required this.admin,
  });
  @override
  State<ListaMembros> createState() => _ListaMembrosState();
}

class _ListaMembrosState extends State<ListaMembros> {
  @override
  Widget build(BuildContext context) {
    List membros = [];
    List admin = [];
    for (var membro in widget._dadosMembros) {
      if (membro['aprovado'] == true) {
        membros.add(membro);
        print(membros);
        print(admin);
      }
    }

    return ListView.builder(
        itemCount: membros.length,
        itemBuilder: (context, index) {
          return CardMembros(
              nome: membros[index]['usuario']['nome'],
              apelido: membros[index]['usuario']['nome'],
              foto: membros[index]['usuario']['fotoPerfil'],
              idUsuarioBD: membros[index]['usuario']['idUsuario'],
              viewAdm: widget.viewAdm,
              isAdmin: (widget.admin['email'] ==
                  membros[index]['usuario']['email']));
        });
  }
}
