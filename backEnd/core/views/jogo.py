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
def jogoCriar(request):
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

    #cria um jogo (partida) dentro de um grupo
    dados = request.data

 
    loc = models.TB_Localizacao.objects.get(idLocalizacao = dados['idLocalizacao'])
    
    horaAgora = horaAtualUTC()
    #converter dados['dataHora'] para datetime
    dataHora = datetime.datetime.strptime(dados['dataHora'], '%Y-%m-%d %H:%M:%S.%fZ')

    if dataHora < horaAgora:
        return Response({'message':'Horario não permitido'}, status=status.HTTP_400_BAD_REQUEST)


    jogo = models.TB_Jogo.objects.create(
        nome = dados['nome'],
        localizacao = loc,
        grupo = models.TB_Grupo.objects.get(idGrupo = dados['grupo']),
        dataHora = dados['dataHora'],
        privado = dados['privado'],
    )
    return Response({'message':'Jogo criado com sucesso!', 'idJogo':jogo.idJogo})

@api_view(['GET'])
def jogoProximosAll(request):    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)
    
    dataAgora = horaAtualUTC()

    #visualiza os proximos jogos publicos
    jogo = models.TB_Jogo.objects.filter(
        #privado = False,
        dataHora__gt = dataAgora,
        dataHora__lt = dataAgora + datetime.timedelta(days=7),

    ).order_by('-dataHora')

    if jogo == None:
        return Response({'message':'Nenhum jogo encontrado'}, status=status.HTTP_404_NOT_FOUND)
    return Response(JogoSerializer(jogo, many=True).data)

@api_view(['GET'])
def jogosProximos(request):    
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)
    
    #verifica a sessão
    check, user = verificarSessao(request)
    if check == False:
        return Response({'message': user}, status=status.HTTP_401_UNAUTHORIZED)
    
    dataAgora = horaAtualUTC()

    usuario = models.TB_Usuario.objects.get(email = user.email)
    jogosList= []

    acessos = models.TB_Acesso.objects.filter(
        usuario = usuario,
        aprovado = True,
    )
    
    for acesso in acessos:
        grupo =  acesso.grupo
        jogos = models.TB_Jogo.objects.filter(
        grupo = grupo,
        #data entre agora e 7 dias
        dataHora__gt = dataAgora,
        dataHora__lt = dataAgora + datetime.timedelta(days=7),
        ).order_by('dataHora')

        jogosList += jogos
    
    confirmado = models.TB_Confirmado.objects.filter(
        usuario = usuario,
    )
   
    

    for conf in confirmado:   
        horaJogo = conf.jogo.dataHora
        #converter para strftime
        horaJogo = horaJogo.strftime('%Y-%m-%d %H:%M:%S')
        #convreter para strptime
        horaJogo = datetime.datetime.strptime(horaJogo, '%Y-%m-%d %H:%M:%S')  
        if horaJogo > dataAgora:
            jogosList.append(conf.jogo)
    
    serializerJogo = JogoSerializer(jogosList, many=True)
    dadosJogos = serializerJogo.data

    dadosFinal = []
    #remover duplicados
    for jogo in dadosJogos:
        if jogo not in dadosFinal:
            dadosFinal.append(jogo)


    return Response(dadosFinal)

    
    

@api_view(['GET'])
def jogoVisualizarTodos(request):
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

    #visualiza todos os jogos de todos os grupos
    jogo = models.TB_Jogo.objects.all()
    jogoSerializer = JogoSerializer(jogo, many=True)
    return Response(jogoSerializer.data)


@api_view(['GET'])
def jogoVisualizar(request, idJogo):
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

    #visualiza um jogo de um grupo
    jogo = models.TB_Jogo.objects.get(idJogo = idJogo)
    jogoSerializer = JogoSerializer(jogo)
    return Response(jogoSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def jogoEditar(request):
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

    #edita um jogo de um grupo
    dados = request.data
    jogo = models.TB_Jogo.objects.get(idJogo = dados['idJogo'])
    usuario = models.TB_Usuario.objects.get(email = user.email)
    if jogo.grupo.admin != usuario:
        return Response({'message':'Você não é o administrador do grupo!'}, status=status.HTTP_401_UNAUTHORIZED)
        
    jogo.nome = dados['nome']
    jogo.localizacao = models.TB_Localizacao.objects.get(idLocalizacao = dados['idLocalizacao'])
    jogo.dataHora = dados['dataHora']
    jogo.privado = dados['privado']
    jogo.save()

    serializerJogo = JogoSerializer(jogo)
    return Response({'message':'Jogo editado com sucesso!','data':serializerJogo.data})


@csrf_exempt
@api_view(['DELETE'])
def jogoDeletar(request):
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
    

    #delete um jogo de um grupo
    dados = request.data
    jogo = models.TB_Jogo.objects.get(idJogo = dados['idJogo'])
    usuario = models.TB_Usuario.objects.get(email = user.email)
    if jogo.grupo.admin != usuario:
        return Response({'message':'Você não é o administrador do grupo!'}, status=status.HTTP_401_UNAUTHORIZED)

    jogo.delete()
    return Response({'message':'Jogo deletado com sucesso!'})

@csrf_exempt
@api_view(['PUT'])
def addDoc(request):
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
        

    #adiciona um documento a um jogo
    dados = request.data
    jogo = models.TB_Jogo.objects.get(idJogo = dados['idJogo'])
    usuario = models.TB_Usuario.objects.get(email = user.email)

    if jogo.grupo.admin != usuario:
        return Response({'message':'Você não é o administrador do grupo'}, status=status.HTTP_401_UNAUTHORIZED)
    #print(dados['informacoes'])

    jogo.informacoes = dados['informacoes']
    jogo.save()

    return Response({'message':'Jogo configurado com sucesso!'})


@csrf_exempt
@api_view(['PUT'])
def clearDoc(request):
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
        

    #adiciona um documento a um jogo
    dados = request.data
    jogo = models.TB_Jogo.objects.get(idJogo = dados['idJogo'])
    usuario = models.TB_Usuario.objects.get(email = user.email)

    if jogo.grupo.admin != usuario:
        return Response({'message':'Você não é o administrador do grupo'}, status=status.HTTP_401_UNAUTHORIZED)
    #print(dados['informacoes'])

    jogo.informacoes = None
    jogo.save()

    return Response({'message':'Jogo configurado com sucesso!'})