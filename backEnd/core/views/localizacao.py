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
def localizacaoCriar(request):
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

    #cria uma localização
    dados = request.data
    if dados['complemento'] == '':
        dados['complemento'] = None
    localizacao = models.TB_Localizacao.objects.create(
        latitude = dados['latitude'],
        longitude = dados['longitude'],
        nome = dados['nome'],
        bairro = dados['bairro'],
        rua = dados['rua'],
        estado = dados['estado'],
        complemento = dados['complemento'],
    )

    for modalidade in dados['modalidades']:
        modalidades = models.TA_Localizacao_Modalidades.objects.create(
            idLocalizacao = localizacao,
            idModalidade = models.TB_Modalidade.objects.get(idModalidade = modalidade)
        )
    serializersLoc = LocalizacaoSerializer(localizacao)
    return Response({'message':'Localização criada com sucesso!', 'data':serializersLoc.data})


@api_view(['GET'])
def localizacaoVisualizarTodos(request):
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

    #visualiza todas as localizações
    localizacao = models.TB_Localizacao.objects.all().order_by('idLocalizacao')
    localizacaoSerializer = LocalizacaoSerializer(localizacao, many=True)

    #para cada localizacao pegar os jogos que vao ocorrer depois de hoje
    horaAgora = horaAtualUTC()
    for loc in localizacaoSerializer.data:
        for jogo in loc['jogos']:
            #converter jogo['dataHora'] para datetime
            dataHora = datetime.datetime.strptime(jogo['dataHora'], '%Y-%m-%dT%H:%M:%SZ')
            if dataHora < horaAgora:
                loc['jogos'].remove(jogo)
    
   
    return Response(localizacaoSerializer.data)


@api_view(['GET'])
def localizacaoVisualizar(request, latitude, longitude):
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


     #pegar a latitude e longitude + um raio de 100 metros
    latitude = float(latitude)
    longitude = float(longitude)
    raio = 0.001 #100 metros
    latMin = latitude - raio
    latMax = latitude + raio
    longMin = longitude - raio
    longMax = longitude + raio

    #pegar as localizacoes que estão dentro do raio
    loc = models.TB_Localizacao.objects.filter(latitude__range=(latMin, latMax), longitude__range=(longMin, longMax))
    if (len(loc)==0):
        return Response({'message': 'Não há quadras cadastradas nessa localização'}, status=status.HTTP_400_BAD_REQUEST)
    else:
        locSerializer = LocalizacaoSerializer(loc, many=True)
        return Response(locSerializer.data)


@api_view(['GET'])
def buscarLocalizacaoPorId(request, idLocalizacao):
    # verifica o método utilizado
    if request.method != 'GET':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)

    # verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)

    # verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)

    # visualiza uma localizacao
    localizacao = models.TB_Localizacao.objects.get(idLocalizacao=idLocalizacao)
    localizacaoSerializer = LocalizacaoSerializer(localizacao)
    return Response(localizacaoSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def localizacaoEditar(request):
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

    #edita uma localização
    dados = request.data
    if dados['complemento'] == '':
        dados['complemento'] = None

    localizacao = models.TB_Localizacao.objects.get(idLocalizacao = dados['idLocalizacao'])
    localizacao.latitude = dados['latitude']
    localizacao.longitude = dados['longitude']
    localizacao.nome = dados['nome']
    localizacao.bairro = dados['bairro']
    localizacao.rua = dados['rua']
    localizacao.estado = dados['estado']
    localizacao.complemento = dados['complemento']

    modalidades = models.TA_Localizacao_Modalidades.objects.filter(idLocalizacao = localizacao)
    for modalidade in modalidades:
        modalidade.delete()
    
    for modalidade in dados['modalidades']:
        modalidades = models.TA_Localizacao_Modalidades.objects.create(
        idLocalizacao = localizacao,
        idModalidade = models.TB_Modalidade.objects.get(idModalidade = modalidade)
    )
    localizacao.save()

    serializer = LocalizacaoSerializer(localizacao)

    return Response({'message':'Localização editada com sucesso!', 'data':serializer.data})

@csrf_exempt
@api_view(['PUT'])
def localizacaoEditarControle(request):
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

    #edita uma localização
    dados = request.data
    if dados['complemento'] == '':
        dados['complemento'] = None

    localizacao = models.TB_Localizacao.objects.get(idLocalizacao = dados['idLocalizacao'])
    localizacao.nome = dados['nome']
    localizacao.rua = dados['rua']
    localizacao.complemento = dados['complemento']
    localizacao.save()

    serializer = LocalizacaoSerializer(localizacao)

    return Response({'message':'Localização editada com sucesso!', 'data':serializer.data})



@csrf_exempt
@api_view(['DELETE'])
def localizacaoDeletar(request, idLocalizacao):
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

    #deleta uma localização
    localizacao = models.TB_Localizacao.objects.get(idLocalizacao = idLocalizacao)
    localizacao.delete()
    return Response({'message':'Localização deletada com sucesso!'})