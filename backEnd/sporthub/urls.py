"""sporthub URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path
from core.views import acesso, autenticacao, confirmado , esporteFavorito , grupo, jogo, localizacao, localizacaoFavorito, modalidade, sexo, usuario
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin', admin.site.urls),

    path('modalidade/novo', modalidade.modalidadeCriar),
    path('modalidade/todos', modalidade.modalidadeVisualizarTodos),
    path('modalidade/ver/<idModalidade>', modalidade.modalidadeVisualizar),
    path('modalidade/editar/<idModalidade>', modalidade.modalidadeEditar),
    path('modalidade/deletar/<idModalidade>', modalidade.modalidadeDeletar),
    
    path('sexo/novo', sexo.sexoCriar),
    path('sexo/todos', sexo.sexoVisualizarTodos),
    path('sexo/ver/<idSexo>', sexo.sexoVisualizar),
    path('sexo/editar/<idSexo>', sexo.sexoEditar),
    path('sexo/deletar/<idSexo>', sexo.sexoDeletar),

    path('usuario/novo', usuario.usuarioCriar),
    path('usuario/todos', usuario.usuarioVisualizarTodos),
    path('usuario/controle/todos', usuario.visualizarControle),
    path('usuario/ver', usuario.usuarioVisualizar),
    path('usuario/editar/<idUsuario>', usuario.usuarioEditar),
    path('usuario/deletar/<idUsuario>', usuario.usuarioDeletar),
    path('usuario/alterarStatus', usuario.usuarioAlterarStatus),
    path('usuario/getGrupos', usuario.getGruposUser),

    path('autenticacao/login', autenticacao.loginUserEmail),
    path('autenticacao/logout', autenticacao.logoutUser),
    path('autenticacao/verificarEmail/<email>', autenticacao.checkEmailExists),

    path('esportefavorito/novo', esporteFavorito.esporteFavoritoCriar),
    path('esportefavorito/todos', esporteFavorito.esporteFavoritoVisualizarTodos),
    path('esportefavorito/ver/<idEsporteFavorito>', esporteFavorito.esporteFavoritoVisualizar),
    path('esportefavorito/editar/<idEsporteFavorito>', esporteFavorito.esporteFavoritoEditar),
    path('esportefavorito/deletar/<idEsporteFavorito>', esporteFavorito.esporteFavoritoDeletar),

    path('grupo/novo', grupo.grupoCriar),
    path('grupo/todos', grupo.grupoVisualizarTodos),
    path('grupo/ver/<idGrupo>', grupo.grupoVisualizar),
    path('grupo/pendente/<idGrupo>', grupo.grupoVisualizarPendentes),
    path('grupo/editar/<idGrupo>', grupo.grupoEditar),
    path('grupo/deletar/<idGrupo>', grupo.grupoDeletar),
    path('grupo/sair', grupo.grupoSair),

    path('jogo/novo', jogo.jogoCriar),
    path('jogo/todos/proximos', jogo.jogoProximosAll),
    path('jogo/proximos', jogo.jogosProximos),
    path('jogo/addDoc', jogo.addDoc),
    path('jogo/clearDoc', jogo.clearDoc),
    path('jogo/todos', jogo.jogoVisualizarTodos),
    path('jogo/ver/<idJogo>', jogo.jogoVisualizar), 
    path('jogo/editar', jogo.jogoEditar),
    path('jogo/deletar', jogo.jogoDeletar), 

    path('acesso/novo', acesso.acessoCriar),
    path('acesso/todos', acesso.acessoVisualizarTodos),
    path('acesso/ver/<idAcesso>', acesso.acessoVisualizar),
    path('acesso/editar', acesso.acessoEditar),
    path('acesso/deletar', acesso.acessoDeletar),

    path('confirmado/novo', confirmado.confirmadoCriar),
    path('confirmado/todos', confirmado.confirmadoVisualizarTodos),
    path('confirmado/ver/<idConfirmado>', confirmado.confirmadoVisualizar),
    path('confirmado/deletar', confirmado.confirmadoDeletar),

    path('localizacao/novo', localizacao.localizacaoCriar),
    path('localizacao/todos', localizacao.localizacaoVisualizarTodos),
    path('localizacao/ver/<latitude>/<longitude>', localizacao.localizacaoVisualizar),
    path('localizacao/buscar/<idLocalizacao>', localizacao.buscarLocalizacaoPorId),
    path('localizacao/editar', localizacao.localizacaoEditar),
    path('localizacao/editarControle', localizacao.localizacaoEditarControle),
    path('localizacao/deletar/<idLocalizacao>', localizacao.localizacaoDeletar),

    path('localizacaofavorito/novo', localizacaoFavorito.localizacaoFavoritoCriar),
    path('localizacaofavorito/todos', localizacaoFavorito.localizacaoFavoritoVisualizarTodos),
    path('localizacaofavorito/ver/<idLocalizacaoFavorito>', localizacaoFavorito.localizacaoFavoritoVisualizar),
    path('localizacaofavorito/editar/<idLocalizacaoFavorito>', localizacaoFavorito.localizacaoFavoritoEditar),
    path('localizacaofavorito/deletar/<idLocalizacaoFavorito>', localizacaoFavorito.localizacaoFavoritoDeletar)

]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
