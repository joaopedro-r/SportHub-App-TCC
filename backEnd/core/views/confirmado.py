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
def confirmadoCriar(request):
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

    #cria uma confirmação de participação em um jogo
    dados = request.data

    try:
        models.TB_Confirmado.objects.get(
        usuario = models.TB_Usuario.objects.get(email = user.email),
        jogo = models.TB_Jogo.objects.get(idJogo = dados['jogo']),
        )
        return Response({'message':'Você já confirmou presença neste jogo!'}, status=status.HTTP_400_BAD_REQUEST)
    except:
        confirmado = models.TB_Confirmado.objects.create(
            usuario = models.TB_Usuario.objects.get(email = user.email),
            jogo = models.TB_Jogo.objects.get(idJogo = dados['jogo'])
        )
        return Response({'message':'Confirmado'})

    


@api_view(['GET'])
def confirmadoVisualizarTodos(request):
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

    #visualiza todas as confirmações de participação em um jogo
    confirmado = models.TB_Confirmado.objects.all().order_by('jogo', 'usuario')
    confirmadoSerializer = ConfirmadoSerializer(confirmado, many=True)
    return Response(confirmadoSerializer.data)


@api_view(['GET'])
def confirmadoVisualizar(request, idConfirmado):
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

    #visualiza uma confirmação de participação em um jogo
    confirmado = models.TB_Confirmado.objects.get(idConfirmado = idConfirmado)
    confirmadoSerializer = ConfirmadoSerializer(confirmado)
    return Response(confirmadoSerializer.data)


@csrf_exempt
@api_view(['DELETE'])
def confirmadoDeletar(request):
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

    dados = request.data

    #deleta uma confirmação de participação em um jogo
    try:
        confirmado = models.TB_Confirmado.objects.get(
        usuario = models.TB_Usuario.objects.get(email = user.email),
        jogo = models.TB_Jogo.objects.get(idJogo = dados['jogo']),
        )
    except:
        return Response({'message':'Você não confirmou presença neste jogo!'}, status=status.HTTP_400_BAD_REQUEST)

    confirmado.delete()
    return Response({'message':'Confirmação deletada'})