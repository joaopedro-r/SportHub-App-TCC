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
def localizacaoFavoritoCriar(request):
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

    #cria uma localização favorita
    dados = request.data
    models.TB_LocalizacaoFavorito.objects.create(
        usuario = models.TB_Usuario.objects.get(idUsuario = dados['usuario']),
        localizacao = models.TB_Localizacao.objects.get(idLocalizacao = dados['localizacao']),
        nome = dados['nome']
    )
    return Response({'message':'Localização favorita criada com sucesso!'})


@api_view(['GET'])
def localizacaoFavoritoVisualizarTodos(request):
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

    #visualiza todas as localizações favoritas
    localizacaoFavorito = models.TB_LocalizacaoFavorito.objects.all().order_by('usuario')
    localizacaoFavoritoSerializer = LocalizacaoFavoritoSerializer(localizacaoFavorito, many=True)
    return Response(localizacaoFavoritoSerializer.data)


@api_view(['GET'])
def localizacaoFavoritoVisualizar(request, idLocalizacaoFavorito):
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

    #visualiza uma localização favorita
    localizacaoFavorito = models.TB_LocalizacaoFavorito.objects.get(idLocalizacaoFavorito = idLocalizacaoFavorito)
    localizacaoFavoritoSerializer = LocalizacaoFavoritoSerializer(localizacaoFavorito)
    return Response(localizacaoFavoritoSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def localizacaoFavoritoEditar(request, idLocalizacaoFavorito):
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

    #edita uma localização favorita
    dados = request.data
    localizacaoFavorito = models.TB_LocalizacaoFavorito.objects.get(idLocalizacaoFavorito = idLocalizacaoFavorito)
    localizacaoFavorito.localizacao = models.TB_Localizacao.objects.get(idLocalizacao = dados['localizacao'])
    localizacaoFavorito.nome = dados['nome']
    localizacaoFavorito.save()
    return Response({'message':'Localização favorita editada com sucesso!'})


@csrf_exempt
@api_view(['DELETE'])
def localizacaoFavoritoDeletar(request, idLocalizacaoFavorito):
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

    #deleta uma localização favorita
    localizacaoFavorito = models.TB_LocalizacaoFavorito.objects.get(idLocalizacaoFavorito = idLocalizacaoFavorito)
    localizacaoFavorito.delete()
    return Response({'message':'Localização favorita deletada com sucesso!'})