from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from core.serializers import *
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from core.views.funcoes import *
from core.views.const import *


@csrf_exempt
@api_view(['POST'])
def loginUserEmail(request):
    #verifica o método utilizado
    if request.method != 'POST':
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)

    #verifica a api-key e a sessão
    chave = request.headers.get('api-key')
    sessao = request.COOKIES.get('sessionid')
    if chave == key:
        dados = request.data
        usuario = None

        #verifica se o usuario já está logado
        if sessao != None:
            try:
                usuario = User.objects.get(id = int(request.session.get('idUsuario')))
                request.session.flush()
            except:
                pass

        #verifica se o usuário não está logado
        if usuario == None:
            usuario = authenticate(username=dados['email'], password=dados['senha'])

        #verifica se a sessão iniciada é válida
        if usuario is not None:  
            request.session['idUsuario'] = usuario.id
            if usuario.is_staff == True:
                serializer = UsuarioAuthSerializer(usuario)
            else:
                usuario = models.TB_Usuario.objects.get(email = usuario.email)
                serializer = UsuarioSerializer(usuario)

            return Response({'message': 'Login realizado com sucesso!','data':serializer.data}, status=status.HTTP_202_ACCEPTED)
        else:
            return Response({'message':'E-mail e/ou senha incorretos!'}, status=status.HTTP_404_NOT_FOUND)
    else:
        return Response({'message': errorMsg}, status=status.HTTP_401_UNAUTHORIZED)


@csrf_exempt
@api_view(['POST'])
def logoutUser(request):
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

    #remove a sessão (para deslogar todos os dispositivos)
    dados = request.data
    try:
        if dados['removeAllSessions'] == True:
            removeAllSessions(request.session['idUsuario'])
    except:
        pass

    #realiza o logout do usuário
    request.session.flush()     
    resposta = Response({'message':'Logout realizado com sucesso!'}, status=status.HTTP_202_ACCEPTED)
    return resposta
    
@api_view(['GET'])
def checkEmailExists(request, email):
    #verifica a api-key
    chave = request.headers.get('api-key')
    if chave != key:
        return Response(errorMsg, status=status.HTTP_401_UNAUTHORIZED)

    #verifica se o e-mail já existe
    try:
        User.objects.get(email=email)
        return Response({'message': 'E-mail já cadastrado!'}, status=status.HTTP_404_NOT_FOUND)
    except:
        return Response({'message': 'E-mail disponível!'})
