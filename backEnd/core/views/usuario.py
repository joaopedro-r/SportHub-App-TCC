from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
import core.models as models
from core.serializers import *
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from core.views.funcoes import *
from core.views.const import *


@csrf_exempt
@api_view(['POST'])
def usuarioCriar(request):
    #verifica o método utilizado
    if request.method != 'POST':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)

    #cria um novo usuário
    dados = request.data
    usuario = models.TB_Usuario.objects.create(
        email = dados['email'],
        nome = dados['nome'],
        dataNascimento = dados['dataNascimento'],
        sexo = models.TB_Sexo.objects.get(idSexo = dados['sexo'])
    )
    for modalidade in dados['modalidades']:
        models.TB_EsporteFavorito.objects.create(
            usuario = usuario,
            modalidade = models.TB_Modalidade.objects.get(idModalidade = modalidade)
        )
    User.objects.create_user(dados['email'], dados['email'], dados['senha'])
    return Response({'message':'Usuário criado com sucesso!'})


@api_view(['GET'])
def usuarioVisualizarTodos(request):
    #verifica o método utilizado
    if request.method != 'GET':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    # #verifica a sessão
    # check, user = verificarSessao(request)
    # if check == False:
    #     return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    dados = request.data
    try:
            usuario = models.TB_Usuario.objects.all().order_by('nome')
            usuarioSerializer = UsuarioSerializer(usuario, many=True)
    except:
        #visualiza todos os usuários
        usuario = models.TB_Usuario.objects.all().order_by('nome')
        usuarioSerializer = UsuarioSerializer(usuario, many=True)
    return Response(usuarioSerializer.data)

@api_view(['GET'])
def visualizarControle(request):
    # verifica o método utilizado
    if request.method != 'GET':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)

    # verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    try:
        dados = request.data
        usuario = User.objects.all().order_by('first_name')
        usuarioSerializer = UsuarioAuthSerializer(usuario, many=True)
        for a in usuarioSerializer.data:
            if a['is_staff'] == False:
                tableUser = models.TB_Usuario.objects.get(email=a['email'])
                serializer = UsuarioSerializer(tableUser).data
                a['nome'] = serializer['nome']
                # pegar foto perfil
                a['fotoPerfil'] = serializer['fotoPerfil']
            else:
                a['nome'] = a['first_name']
                a['fotoPerfil'] = None
    except:
        #visualiza todos os usuários
        usuario = models.TB_Usuario.objects.all().order_by('nome')
        usuarioSerializer = UsuarioSerializer(usuario, many=True)
    return Response(usuarioSerializer.data)

@api_view(['PUT'])
@csrf_exempt
def usuarioAlterarStatus(request):
    #verifica o método utilizado
    if request.method != 'PUT':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #verifica se o usuário é administrador
    if user.is_staff == False:
        return Response({'message': 'Você não tem permissão para acessar'}, status=status.HTTP_401_UNAUTHORIZED)

    #altera o status do usuário
    dados = request.data
    usuario = User.objects.get(email = dados['email'])
    usuario.is_active = dados['status']
    usuario.save()
    return Response({'message':'Status alterado com sucesso!'})

@api_view(['GET'])
def usuarioVisualizar(request):
    #verifica o método utilizado
    if request.method != 'GET':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #visualiza um usuário
    usuario = models.TB_Usuario.objects.get(email = user.email)
    usuarioSerializer = UsuarioSerializer(usuario)
    return Response(usuarioSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def usuarioEditar(request, idUsuario):
    #verifica o método utilizado
    if request.method != 'PUT':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #edita um usuário
    dados = request.data
    usuario = models.TB_Usuario.objects.get(idUsuario = idUsuario)
    usuario.email = dados['email']
    usuario.nome = dados['nome']
    usuario.telefone = dados['telefone']
    usuario.dataNascimento = dados['dataNascimento']
    usuario.sexo = models.TB_Sexo.objects.get(idSexo = dados['sexo'])
    usuario.descricao = dados['descricao']
    usuario.fotoPerfil = dados['fotoPerfil']
    usuario.localizacaoAtual = models.TB_Localizacao.objects.get(idLocalizacao = dados['localizacaoAtual'])
    usuario.save()
    return Response({'message':'Usuário editado com sucesso!'})

@csrf_exempt
@api_view(['DELETE'])
def usuarioDeletar(request):
    #verifica o método utilizado
    if request.method != 'DELETE':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #deleta um usuário
    dados = request.data
    usuario = models.TB_Usuario.objects.get(idUsuario = dados['idUsuario'])
    user = User.objects.get(email = dados['email'])
    user.delete()
    usuario.delete()
    return Response({'message':'Usuário deletado com sucesso!'})

@api_view(['GET'])
def getGruposUser(request):

    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #visualiza os grupos de um usuário
    usuario = models.TB_Usuario.objects.get(email = user.email)
    gruposAcesso = models.TB_Acesso.objects.filter(usuario = usuario, aprovado = True)

    serializer = AcessoSerializer(gruposAcesso, many=True)
    return Response(serializer.data)

