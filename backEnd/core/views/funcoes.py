import datetime
from django.contrib.auth.models import User
from django.contrib.sessions.models import Session
import pytz


def verificarSessao(requisicao):
    print(requisicao.COOKIES)
    try:    
        idUser = int(requisicao.session.get('idUsuario'))
    except:
        return False, 'Sessão não encontrada'      
    try:
        user = User.objects.get(id = idUser)
        if user.is_active == False:
            return False, 'Usuário inativo'
        return True, user
    except:
        return False, 'Usuário inválido!'
        #caso queira testar sem fazer login no Postman, comentar a linha acima e descomentar a de baixo
        #return True, user


def removeAllSessions(idUser):
    for sessao in Session.objects.all():
        if sessao.get_decoded().get('idUsuario') == idUser:
            sessao.delete()



def horaAtualUTC():
    utc = pytz.UTC
    agora = datetime.datetime.now()
    agora = agora.astimezone(utc).strptime(agora.astimezone(utc).strftime('%Y-%m-%d %H:%M:%S'), '%Y-%m-%d %H:%M:%S')
    return agora

