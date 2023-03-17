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
def esporteFavoritoCriar(request):
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

    #cria um esporte favorito
    dados = request.data
    models.TB_EsporteFavorito.objects.create(
        usuario = models.TB_Usuario.objects.get(idUsuario = dados['usuario']),
        modalidade = models.TB_Modalidade.objects.get(idModalidade = dados['modalidade']),
    )
    return Response({'message':'Esporte favorito criado com sucesso!'})


@api_view(['GET'])
def esporteFavoritoVisualizarTodos(request):
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

    #visualiza todos os esportes favoritos de todos os usuários
    esporteFavorito = models.TB_EsporteFavorito.objects.all().order_by('usuario')
    esporteFavoritoSerializer = EsporteFavoritoSerializer(esporteFavorito, many=True)
    return Response(esporteFavoritoSerializer.data)


@api_view(['GET'])
def esporteFavoritoVisualizar(request, idEsporteFavorito):
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

    #visualiza os esportes favoritos do usuário
    esporteFavorito = models.TB_EsporteFavorito.objects.get(idEsporteFavorito = idEsporteFavorito)
    esporteFavoritoSerializer = EsporteFavoritoSerializer(esporteFavorito)
    return Response(esporteFavoritoSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def esporteFavoritoEditar(request, idEsporteFavorito):
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

    #edita os esportes favoritos do usuário
    dados = request.data
    esporteFavorito = models.TB_EsporteFavorito.objects.get(idEsporteFavorito = idEsporteFavorito)
    #esporteFavorito.usuario = models.TB_Usuario.objects.get(idUsuario = dados['usuario'])
    esporteFavorito.modalidade = models.TB_Modalidade.objects.get(idModalidade = dados['modalidade'])
    esporteFavorito.save()
    return Response({'message':'Esporte favorito editado com sucesso!'})


@csrf_exempt
@api_view(['DELETE'])
def esporteFavoritoDeletar(request, idEsporteFavorito):
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

    #deleta os esportes favoritos do usuário
    esporteFavorito = models.TB_EsporteFavorito.objects.get(idEsporteFavorito = idEsporteFavorito)
    esporteFavorito.delete()
    return Response({'message':'Esporte favorito deletado com sucesso!'})