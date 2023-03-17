from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
import core.models as models
from core.serializers import *
from django.views.decorators.csrf import csrf_exempt
from core.views.funcoes import *
from core.views.const import *


@csrf_exempt
@api_view(['POST'])
def grupoCriar(request):
    #verifica o método utilizado
    if request.method != 'POST':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #cria um grupo de uma modalidade
    dados = request.data
    grupo = models.TB_Grupo.objects.create(
        nome = dados['nome'],
        modalidade = models.TB_Modalidade.objects.get(idModalidade = dados['modalidade']),
        admin = models.TB_Usuario.objects.get(email = user.email)
    )
    models.TB_Acesso.objects.create(
        usuario = models.TB_Usuario.objects.get(email = user.email),
        grupo = grupo,
        aprovado = True,
    )
    return Response({'message':'Grupo criado com sucesso!', 'idGrupo':grupo.idGrupo})


@api_view(['GET'])
def grupoVisualizarTodos(request):
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

    #visualiza todos os grupos de todos os usuários
    grupo = models.TB_Grupo.objects.all().order_by('modalidade')
    grupoSerializer = GrupoSerializer(grupo, many=True)
    dados = grupoSerializer.data
    for grupo in dados:
        listaDelete = []
        for membro in grupo['membros']:
            if membro['aprovado'] == False:
                listaDelete.append(membro)
        for membro in listaDelete:
            grupo['membros'].remove(membro)
    return Response(dados)


@api_view(['GET'])
def grupoVisualizarPendentes(request, idGrupo):
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

    #visualiza os membros pendentes de aceitação no grupo
    grupo = models.TB_Grupo.objects.get(idGrupo = idGrupo)
    grupoSerializer = GrupoSerializer(grupo)
    dados = grupoSerializer.data
    listaDelete = []
    for membro in dados['membros']:
        if membro['aprovado'] == True:
            listaDelete.append(membro)
    for membro in listaDelete:
        dados['membros'].remove(membro)
    return Response(dados)


@api_view(['GET'])
def grupoVisualizar(request, idGrupo):
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

    #visualiza um grupo
    grupo = models.TB_Grupo.objects.get(idGrupo = idGrupo)
    grupoSerializer = GrupoSerializer(grupo)
    dados = grupoSerializer.data
    #listaDelete = []
    #for membro in dados['membros']:
    #    if membro['aprovado'] == False:
    #        listaDelete.append(membro)
    #for membro in listaDelete:
    #    dados['membros'].remove(membro)
    return Response(dados)


@csrf_exempt
@api_view(['PUT'])
def grupoEditar(request, idGrupo):
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

    #edita um grupo
    dados = request.data
    grupo = models.TB_Grupo.objects.get(idGrupo = idGrupo)
    grupo.nome = dados['nome']
    grupo.modalidade = models.TB_Modalidade.objects.get(idModalidade = dados['modalidade'])
    grupo.admin = models.TB_Usuario.objects.get(idUsuario = dados['admin'])
    grupo.descricao = dados['descricao']
    grupo.save()
    return Response({'message':'Grupo editado com sucesso!'})


@csrf_exempt
@api_view(['DELETE'])
def grupoDeletar(request, idGrupo):
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

    #deleta um grupo
    grupo = models.TB_Grupo.objects.get(idGrupo = idGrupo)
    grupo.delete()
    return Response({'message':'Grupo deletado com sucesso!'})

@csrf_exempt
@api_view(['PUT'])
def grupoSair(request):
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

    #sai de um grupo
    dados = request.data
    usuario = models.TB_Usuario.objects.get(email = user.email)
    grupo = models.TB_Grupo.objects.get(idGrupo = dados['idGrupo'])
    

    if grupo.admin == usuario:
        grupo.delete()
        return Response({'message':'Grupo deletado com sucesso!'})
    else:
        acesso = models.TB_Acesso.objects.get(usuario = usuario, grupo=grupo)
        acesso.delete()
    
    return Response({'message':'Você não está no grupo!'})