import 'package:flutter/material.dart';

const urlLocal = 'http://10.0.2.2:8000';
const urlHeroku = 'https://sporthub-app.herokuapp.com';
const urlBasica = urlLocal;

var headersWebService = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'api-key': 'BgfUVkjyeVjF2DCh7VYSHqsf6ToOawTtDl0PJ63339d401321b'
};

const mensagemNoConnection =
    'Sem conexão, verifique se você está com acesso a internet';

const cinza = Color(0xFFFA8BBBF);
const azulEscuro = Color(0xFF0C0826);
const verdeEscuro = Color(0xFF1B4001);
const verde = Color(0xFF3B7302);
const verdeClaro = Color(0xFF95D904);

const azul = Color(0xFFF200d74);
const preto = Color(0xFFF000000);
const branco = Color(0xFFFFFFFFF);

const baseColor = Color(0xFFE0E0E0);
const highlightColor = Color(0xFFF5F5F5);

const fontePrincipal = 'Trebuchet MS';

const Map imagensCardsEsportes = {
  'futebol': [
    'assets/images/modelos/imagensEsportes/futebol1.jpg',
    'assets/images/modelos/imagensEsportes/futebol2.jpg',
    'assets/images/modelos/imagensEsportes/futebol3.jpg'
  ],
  'basquete': [
    'assets/images/modelos/imagensEsportes/basquete1.jpg',
    'assets/images/modelos/imagensEsportes/basquete2.jpg',
    'assets/images/modelos/imagensEsportes/basquete3.jpg'
  ],
  'handball': [
    'assets/images/modelos/imagensEsportes/handball1.jpg',
    'assets/images/modelos/imagensEsportes/handball2.jpg',
    'assets/images/modelos/imagensEsportes/handball3.jpg'
  ],
  'volei': [
    'assets/images/modelos/imagensEsportes/volei1.jpg',
    'assets/images/modelos/imagensEsportes/volei2.jpg',
    'assets/images/modelos/imagensEsportes/volei3.jpg'
  ],
  'gerais': [
    'assets/images/modelos/imagensEsportes/esportesGerais1.jpg',
    'assets/images/modelos/imagensEsportes/esportesGerais2.jpg',
    'assets/images/modelos/imagensEsportes/esportesGerais3.jpg'
  ],
};
