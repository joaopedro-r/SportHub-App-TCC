import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchMethod extends StatefulWidget {
  @override
  State<SearchMethod> createState() => _SearchMethodState();
}

class _SearchMethodState extends State<SearchMethod> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          controller: _controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Buscar...',
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }
}
