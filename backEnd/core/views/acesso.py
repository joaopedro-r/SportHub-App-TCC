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
def acessoCriar(request):
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

    #cria um pedido de acesso a um grupo
    dados = request.data
    usuario = models.TB_Usuario.objects.get(email = user.email)

    try:
        grupo = models.TB_Grupo.objects.get(idGrupo = dados['grupo'])
        meusAcessos = models.TB_Acesso.objects.filter(usuario = usuario, grupo = grupo)
        if len(meusAcessos) > 0:
            print(meusAcessos[0].usuario, meusAcessos[0].grupo, meusAcessos[0].aprovado) 
            if meusAcessos[0].aprovado == True:
                if dados['convite'] == True:
                    return Response({'message':'Este jogador é membro deste grupo!'}, status=status.HTTP_400_BAD_REQUEST)
                else:
                    return Response({'message':'Você já pertence a este grupo!'}, status=status.HTTP_400_BAD_REQUEST)
            else:
                return Response({'message':'Você já solicitou acesso a este grupo!'}, status=status.HTTP_400_BAD_REQUEST)
                
    except:
        return Response({'message':'Grupo não encontrado'}, status=status.HTTP_404_NOT_FOUND)

    aprovado = False
    if dados['convite'] == True:
        aprovado = True
    
    models.TB_Acesso.objects.create(
        usuario = usuario,
        grupo = grupo,
        aprovado = aprovado,
    )

    if dados['convite'] == True:
        return Response({'message':'Jogador inserido com sucesso!'})
    else:
        return Response({'message':'Pedido de acesso enviado com sucesso!'})
   
   


@api_view(['GET'])
def acessoVisualizarTodos(request):
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

    #visualiza todos os acessos de todos os grupos
    acesso = models.TB_Acesso.objects.all().order_by('aprovado', 'grupo', 'usuario')
    acessoSerializer = AcessoSerializer(acesso, many=True)
    return Response(acessoSerializer.data)


@api_view(['GET'])
def acessoVisualizar(request, idAcesso):
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

    #visualiza um acesso
    acesso = models.TB_Acesso.objects.get(idAcesso = idAcesso)
    acessoSerializer = AcessoSerializer(acesso)
    return Response(acessoSerializer.data)


@csrf_exempt
@api_view(['PUT'])
def acessoEditar(request):
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

    #edita um acesso (para permitir que usuário acesse um grupo)
    dados = request.data
    
    myuser = models.TB_Usuario.objects.get(email = user.email)
    grupo = models.TB_Grupo.objects.get(idGrupo = dados['grupo'])
    if grupo.admin != myuser:
        return Response({'message':'Você não é o administrador deste grupo!'}, status=status.HTTP_401_UNAUTHORIZED)

    try:
        usuarioToAprove = models.TB_Usuario.objects.get(email = dados['email'])
        acesso = models.TB_Acesso.objects.get(usuario = usuarioToAprove, grupo = grupo, aprovado = False)
    except:
        return Response({'message':'Pedido não encontrado'}, status=status.HTTP_404_NOT_FOUND)
    acesso.aprovado = True
    acesso.save()
    return Response({'message':'Usuario aprovado'})


@csrf_exempt
@api_view(['DELETE'])
def acessoDeletar(request):
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
    
    myuser = models.TB_Usuario.objects.get(email = user.email)
    grupo = models.TB_Grupo.objects.get(idGrupo = dados['grupo'])
    if grupo.admin != myuser:
        return Response({'message':'Você não é o administrador deste grupo!'}, status=status.HTTP_401_UNAUTHORIZED)

    try:
        usuarioToDelete = models.TB_Usuario.objects.get(email = dados['email'])
        acesso = models.TB_Acesso.objects.get(usuario = usuarioToDelete, grupo = grupo)
    except:
        return Response({'message':'Acesso não encontrado'}, status=status.HTTP_404_NOT_FOUND)


    acesso.delete()
    return Response({'message':'Jogador deletado'})