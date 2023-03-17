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
def modalidadeCriar(request):
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

    #cria uma modalidade
    dados = request.data
    models.TB_Modalidade.objects.create(
        nome = dados['nome']
    )
    return Response({'message':'Modalidade criada com sucesso!'})


@api_view(['GET'])
def modalidadeVisualizarTodos(request):
    #verifica o método utilizado
    if request.method != 'GET':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    #check, user = verificarSessao(request)
    #if check == False:
    #    return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    #visualiza todas as modalidades
    modalidade = models.TB_Modalidade.objects.all().order_by('nome')
    modalidadeSerializer = ModalidadeSerializer(modalidade, many=True)
    return Response(modalidadeSerializer.data)


@api_view(['GET'])
def modalidadeVisualizar(request, idModalidade):
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

    #visualiza uma modalidade
    modalidade = models.TB_Modalidade.objects.get(idModalidade = idModalidade)
    modalidadeSerializer = ModalidadeSerializer(modalidade)
    return Response(modalidadeSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def modalidadeEditar(request, idModalidade):
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

    #edita uma modalidade
    dados = request.data
    modalidade = models.TB_Modalidade.objects.get(idModalidade = idModalidade)
    modalidade.nome = dados['nome']
    modalidade.save()
    return Response({'message':'Modalidade editada com sucesso!'})


@csrf_exempt
@api_view(['DELETE'])
def modalidadeDeletar(request, idModalidade):
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

    #deleta uma modalidade
    modalidade = models.TB_Modalidade.objects.get(idModalidade = idModalidade)
    modalidade.delete()
    return Response({'message':'Modalidade deletada com sucesso!'})