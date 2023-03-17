from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from core.serializers import *
from django.views.decorators.csrf import csrf_exempt
import core.models as models
from core.views.funcoes import *
from core.views.const import *


@csrf_exempt
@api_view(['POST'])
def sexoCriar(request):
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

    #cria um sexo
    dados = request.data
    models.TB_Sexo.objects.create(
        nome = dados['nome']
    )
    return Response({'message':'Sexo criado com sucesso!'})


@api_view(['GET'])
def sexoVisualizarTodos(request):
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

    #visualiza todos os sexos
    sexo = models.TB_Sexo.objects.all().order_by('nome')
    sexoSerializer = SexoSerializer(sexo, many=True)
    return Response(sexoSerializer.data)


@api_view(['GET'])
def sexoVisualizar(request, idSexo):
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

    #visualiza um sexo
    sexo = models.TB_Sexo.objects.get(idSexo = idSexo)
    sexoSerializer = SexoSerializer(sexo)
    return Response(sexoSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def sexoEditar(request, idSexo):
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

    #edita um sexo
    dados = request.data
    sexo = models.TB_Sexo.objects.get(idSexo = idSexo)
    sexo.nome = dados['nome']
    sexo.save()
    return Response({'message':'Sexo editado com sucesso!'})


@csrf_exempt
@api_view(['DELETE'])
def sexoDeletar(request, idSexo):
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

    #deleta um sexo
    sexo = models.TB_Sexo.objects.get(idSexo = idSexo)
    sexo.delete()
    return Response({'message':'Sexo deletado com sucesso!'})
