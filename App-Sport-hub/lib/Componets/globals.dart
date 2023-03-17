var userDataGlobal = {};
var dadosGrupoGlobal = {};

UserCadastro usuarioCadastro = UserCadastro();

class UserCadastro {
  String email = '';
  String senha = '';
  String nome = '';
  String dataNascimento = '';
  int sexo = -1;
  List modalidades = [];

  Map createJson() {
    Map json = {
      'email': email,
      'senha': senha,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'sexo': sexo,
      'modalidades': modalidades
    };
    return json;
  }
}
