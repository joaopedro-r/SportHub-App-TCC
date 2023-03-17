from rest_framework import serializers
import core.models as models
from django.contrib.auth.models import User


class ModalidadeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.TB_Modalidade
        fields = ['idModalidade', 'nome','fotoModalidade']


#class LocalizacaoSerializer(serializers.ModelSerializer):
#    class Meta:
#        model = models.TB_Localizacao
#        fields = ['idLocalizacao', 'latitude', 'longitude']

class LocalizacaoModalidadeSerializer(serializers.ModelSerializer):
    idModalidade = ModalidadeSerializer(many=False, read_only=True)
    idLocalizacao = serializers.StringRelatedField(many=False, read_only=True)
    class Meta:
        model = models.TA_Localizacao_Modalidades
        fields = ['idLocalizacao', 'idModalidade']

class GrupoSerializerModalidade(serializers.ModelSerializer):
    modalidade = ModalidadeSerializer(many=False, read_only=True)
    class Meta:
        model = models.TB_Grupo
        fields = ['modalidade']

class JogoSimplesSerializer(serializers.ModelSerializer):
    grupo = GrupoSerializerModalidade()
    class Meta:
        model = models.TB_Jogo
        fields = ['idJogo', 'nome', 'dataHora', 'privado','grupo']
        

class LocalizacaoSerializer(serializers.ModelSerializer):
    modalidades = LocalizacaoModalidadeSerializer(many=True, read_only=True)
    jogos = JogoSimplesSerializer(many=True, read_only=True)
    

    class Meta:
        model = models.TB_Localizacao
        fields = ['idLocalizacao','nome','latitude', 'longitude','bairro','rua','estado','complemento','modalidades','jogos']


class SexoSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.TB_Sexo
        fields = ['idSexo', 'nome']

class EsporteFavoritoSerializer(serializers.ModelSerializer):
    usuario = serializers.StringRelatedField()
    modalidade = serializers.StringRelatedField()
    class Meta:
        model = models.TB_EsporteFavorito
        fields = ['idEsporteFavorito', 'usuario', 'modalidade']

class UsuarioSerializer(serializers.ModelSerializer):
    sexo = serializers.StringRelatedField()
    #grupos = GrupoSerializer(many=True)
    esportesFavoritos = EsporteFavoritoSerializer(many=True)
    class Meta:
        model = models.TB_Usuario
        fields = ['idUsuario', 'nome', 'email', 'telefone', 'dataNascimento', 'sexo', 'descricao', 'fotoPerfil', 'esportesFavoritos']

class UsuarioAuthSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['date_joined','email','first_name','username','is_active','is_staff','is_superuser']

class AcessoSerializerSimples(serializers.ModelSerializer):
    usuario = UsuarioSerializer()
    class Meta:
        model = models.TB_Acesso
        fields = ['usuario', 'aprovado']

class GrupoSerializer2(serializers.ModelSerializer):
    modalidade = ModalidadeSerializer()
    admin = UsuarioSerializer()
    class Meta:
        model = models.TB_Grupo
        fields = ['idGrupo', 'nome', 'modalidade','admin']

class ConfirmadoSerializer(serializers.ModelSerializer):
    jogo = serializers.StringRelatedField()
    usuario = UsuarioSerializer()
    class Meta:
        model = models.TB_Confirmado
        fields = ['idConfirmado', 'jogo', 'usuario']
    
class JogoSerializer(serializers.ModelSerializer):
    localizacao = LocalizacaoSerializer()
    grupo = GrupoSerializer2()
    confirmados = ConfirmadoSerializer(many=True)
    class Meta:
        model = models.TB_Jogo
        fields = ['idJogo', 'nome', 'localizacao', 'dataHora', 'grupo', 'privado', 'informacoes', 'confirmados']


class GrupoSerializer(serializers.ModelSerializer):
    modalidade = serializers.StringRelatedField()
    admin = UsuarioSerializer()
    membros = AcessoSerializerSimples(many=True)

    #ordenar jogos por data
    jogos = serializers.SerializerMethodField()
    def get_jogos(self, obj):
        jogos = models.TB_Jogo.objects.filter(grupo=obj).order_by('-dataHora')
        jogosSerializer = JogoSerializer(jogos, many=True)
        return jogosSerializer.data
        
    class Meta:
        model = models.TB_Grupo
        fields = ['idGrupo', 'nome', 'modalidade', 'descricao', 'admin', 'membros', 'jogos']


class AcessoSerializer(serializers.ModelSerializer):
    usuario = serializers.StringRelatedField()
    grupo = GrupoSerializer()
    class Meta:
        model = models.TB_Acesso
        fields = ['idAcesso', 'usuario', 'grupo', 'aprovado']
    




class LocalizacaoFavoritoSerializer(serializers.ModelSerializer):
    usuario = serializers.StringRelatedField()
    localizacao = LocalizacaoSerializer()
    class Meta:
        model = models.TB_LocalizacaoFavorito
        fields = ['idLocalizacaoFavorito', 'usuario', 'nome', 'localizacao']



