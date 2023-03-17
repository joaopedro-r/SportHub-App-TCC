import 'dart:math';

import 'package:SportHub/Componets/functions.dart';

late Jogo jogoGlobal;

class Jogo {
  int idJogo;
  String modalidade;
  String nome;
  int numeroJogadoresPorTime;
  List eventos = [];
  List excluidos = [];
  List jogadores = [];

  Jogo({
    required this.nome,
    required this.numeroJogadoresPorTime,
    required this.idJogo,
    required this.modalidade,
  });

  Future limparPlayers(context) async {
    await sendRequest(
      context,
      endPoint: 'jogo/clearDoc',
      method: 'PUT',
      body: {
        'idJogo': idJogo,
      },
    );
  }

  void addPlayer(String nome) {
    jogadores.add(Players(nome: nome));
  }

  void addPlayerLoaded(json) {
    jogadores.add(Players.fromJson(json));
  }

  void addExcluido(String nome) {
    excluidos.add(Players(nome: nome));
  }

  void addExcluidoLoaded(json) {
    excluidos.add(Players.fromJson(json));
  }

  void excluiPlayer(int pos) {
    excluidos.add(jogadores[pos]);
    jogadores.removeAt(pos);

    if (pos < numeroJogadoresPorTime) {
      int proximaIndex = (numeroJogadoresPorTime * 2) - 1;

      jogadores.insert(numeroJogadoresPorTime - 1, jogadores[proximaIndex]);
      jogadores.removeAt(proximaIndex + 1);
    }
  }

  void substituirPlayer(int pos) {
    //coloar o jogador em ultimo na lista de jogadores
    jogadores.add(jogadores[pos]);
    jogadores.removeAt(pos);
    int proximaIndex = (numeroJogadoresPorTime * 2) - 1;

    if (pos < numeroJogadoresPorTime) {
      jogadores.insert(0, jogadores[proximaIndex]);
    } else {
      jogadores.insert(numeroJogadoresPorTime, jogadores[proximaIndex]);
    }

    jogadores.removeAt(proximaIndex + 1);
  }

  List encerrarJogo(int golsA, int golsB) {
    String ganhador;
    bool empate = false;
    if (golsA == golsB) {
      empate = true;
      //sortear 0 ou 1
      int sorteio = Random().nextInt(2);
      if (sorteio == 0) {
        ganhador = 'A';
      } else {
        ganhador = 'B';
      }
    } else if (golsA > golsB) {
      ganhador = 'A';
    } else {
      ganhador = 'B';
    }

    if (ganhador == 'A') {
      for (var i = 0; i < numeroJogadoresPorTime; i++) {
        if (empate == true) {
          jogadores[i].empates++;
        } else {
          jogadores[i].vitorias++;
        }

        jogadores[i].partidas++;
      }

      for (var i = numeroJogadoresPorTime;
          i < numeroJogadoresPorTime * 2;
          i++) {
        if (empate == true) {
          jogadores[numeroJogadoresPorTime].empates++;
        } else {
          jogadores[numeroJogadoresPorTime].derrotas++;
        }

        jogadores[numeroJogadoresPorTime].partidas++;
        jogadores.add(jogadores[numeroJogadoresPorTime]);
        jogadores.removeAt(numeroJogadoresPorTime);
      }
    } else if (ganhador == 'B') {
      for (var i = numeroJogadoresPorTime;
          i < numeroJogadoresPorTime * 2;
          i++) {
        if (empate == true) {
          jogadores[i].empates++;
        } else {
          jogadores[i].vitorias++;
        }

        jogadores[i].partidas++;
      }

      for (var i = 0; i < numeroJogadoresPorTime; i++) {
        if (empate == true) {
          jogadores[0].empates++;
        } else {
          jogadores[0].derrotas++;
        }

        jogadores[0].partidas++;
        jogadores.add(jogadores[0]);
        jogadores.removeAt(0);
      }
    }

    eventos = [];
    return [ganhador, empate];
  }

  void sortListPlayers() {
    jogadores.shuffle();
  }

  void clearJogo() {
    jogadores = [];
    eventos = [];
    excluidos = [];
    numeroJogadoresPorTime = 0;
  }

  List listPlayers() {
    List jsonList = [];
    for (var a in jogadores) {
      jsonList.add(a.jsonPlayer());
    }

    return jsonList;
  }

  List excluidosList() {
    List jsonList = [];
    for (var a in excluidos) {
      jsonList.add(a.jsonPlayer());
    }
    return jsonList;
  }

  Map jsonJogo() {
    Map json = {
      'nome': nome,
      'numeroJogadoresPorTime': numeroJogadoresPorTime,
      'excluidos': excluidosList(),
      'jogadores': listPlayers(),
    };
    return json;
  }

  Future saveJogo(context) async {
    Map bodyRequest = {
      'idJogo': idJogo,
      'informacoes': jsonJogo(),
    };

    await sendRequest(
      context,
      endPoint: 'jogo/addDoc',
      method: 'PUT',
      body: bodyRequest,
    );
  }
}

class Players {
  String nome;
  int pontos;
  int partidas;
  int vitorias;
  int derrotas;
  int empates;

  Players({
    required this.nome,
    this.pontos = 0,
    this.partidas = 0,
    this.vitorias = 0,
    this.derrotas = 0,
    this.empates = 0,
  });

  factory Players.fromJson(Map json) {
    return Players(
      nome: json['nome'],
      pontos: json['pontos'],
      partidas: json['partidas'],
      vitorias: json['vitorias'],
      derrotas: json['derrotas'],
      empates: json['empates'],
    );
  }

  Map jsonPlayer() {
    Map json = {
      'nome': nome,
      'pontos': pontos,
      'partidas': partidas,
      'vitorias': vitorias,
      'derrotas': derrotas,
      'empates': empates,
    };
    return json;
  }
}
