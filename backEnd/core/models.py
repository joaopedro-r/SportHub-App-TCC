from django.db import models


class TB_Modalidade(models.Model):
    idModalidade = models.BigAutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    grupo = models.BooleanField(default=True)
    pontuacao = models.IntegerField(default='1')
    fotoModalidade = models.ImageField(upload_to='iconsModalidades', null=True, blank=True)

    class Meta:
        db_table = 'TB_Modalidade'

    def __str__(self):
        return f'{self.nome}'


class TB_Localizacao(models.Model):
    idLocalizacao = models.BigAutoField(primary_key=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    nome = models.CharField(max_length=100)
    rua = models.CharField(max_length=100)
    bairro = models.CharField(max_length=100)
    estado = models.CharField(max_length=100)
    complemento = models.CharField(max_length=100, null=True, blank=True)

    class Meta:
        db_table = 'TB_Localizacao'

    def __str__(self):
        return f'{self.nome}'

class TA_Localizacao_Modalidades(models.Model):
    idLocalizacao = models.ForeignKey(TB_Localizacao, related_name='modalidades', on_delete=models.CASCADE)
    idModalidade = models.ForeignKey(TB_Modalidade, on_delete=models.CASCADE)

    class Meta:
        db_table = 'TA_Localizacao_Modalidades'

    def __str__(self):
        return f'{self.idLocalizacao}'
    

class TB_Sexo(models.Model):
    idSexo = models.BigAutoField(primary_key=True)
    nome = models.CharField(max_length=20)

    class Meta:
        db_table = 'TB_Sexo'

    def __str__(self):
        return f'{self.nome}'


class TB_Usuario(models.Model):
    idUsuario = models.BigAutoField(primary_key=True)
    email = models.EmailField(unique=True)
    nome = models.CharField(max_length=100)
    telefone = models.CharField(unique=True, max_length=15, null=True, blank=True)
    dataNascimento = models.DateField()
    sexo = models.ForeignKey(TB_Sexo, null=True, on_delete=models.SET_NULL)
    descricao = models.TextField(null=True, blank=True)
    fotoPerfil = models.ImageField(upload_to='usuarios', null=True, blank=True)

    class Meta: 
        db_table = 'TB_Usuario'

    def __str__(self):
        return f'{self.nome}'


class TB_Grupo(models.Model):
    idGrupo = models.BigAutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    modalidade = models.ForeignKey(TB_Modalidade, null=True, on_delete=models.SET_NULL)
    descricao = models.TextField(null=True, blank=True)
    admin = models.ForeignKey(TB_Usuario, null=True, on_delete=models.SET_NULL)

    class Meta: 
        db_table = 'TB_Grupo'

    def __str__(self):
        return f'{self.nome}'


class TB_Acesso(models.Model):
    idAcesso = models.BigAutoField(primary_key=True)
    usuario = models.ForeignKey(TB_Usuario, on_delete=models.CASCADE)
    grupo = models.ForeignKey(TB_Grupo, related_name='membros', on_delete=models.CASCADE)
    aprovado = models.BooleanField(default=False)

    class Meta:
        db_table = 'TB_Acesso'

    def __str__(self):
        return f'{self.usuario}'


class TB_EsporteFavorito(models.Model):
    idEsporteFavorito = models.BigAutoField(primary_key=True)
    usuario = models.ForeignKey(TB_Usuario, related_name='esportesFavoritos', on_delete=models.CASCADE)
    modalidade = models.ForeignKey(TB_Modalidade, on_delete=models.CASCADE)

    class Meta:
        db_table = 'TB_EsporteFavorito'
    
    def __str__(self):
        return f'{self.modalidade}'


class TB_LocalizacaoFavorito(models.Model):
    idLocalizacaoFavorito = models.BigAutoField(primary_key=True)
    usuario = models.ForeignKey(TB_Usuario, on_delete=models.CASCADE)
    localizacao = models.ForeignKey(TB_Localizacao, on_delete=models.CASCADE)
    nome = models.CharField(max_length=100)

    class Meta:
        db_table = 'TB_LocalizacaoFavorito'

    def __str__(self):
        return f'{self.nome}'


class TB_Jogo(models.Model):
    idJogo = models.BigAutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    localizacao = models.ForeignKey(TB_Localizacao, related_name='jogos', on_delete=models.CASCADE)
    dataHora = models.DateTimeField()
    grupo = models.ForeignKey(TB_Grupo, on_delete=models.CASCADE, related_name='jogos')
    privado = models.BooleanField(default=False)
    informacoes = models.TextField(null=True, blank=True)

    class Meta:
        db_table = 'TB_Jogo'

    def __str__(self):
        return f'{self.nome}'


class TB_Confirmado(models.Model):
    idConfirmado = models.BigAutoField(primary_key=True)
    usuario = models.ForeignKey(TB_Usuario, on_delete=models.CASCADE)
    jogo = models.ForeignKey(TB_Jogo, on_delete=models.CASCADE, related_name='confirmados')

    class Meta:
        db_table = 'TB_Confirmado'

    def __str__(self):
        return f'{self.usuario}'