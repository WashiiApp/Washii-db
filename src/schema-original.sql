CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE usuarios (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL, 
    senha VARCHAR(255) NOT NULL,
    foto_perfil TEXT,
    tipo_usuario VARCHAR(50) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

    CONSTRAINT chk_tipo_usuario CHECK (tipo_usuario IN ('cliente', 'lava_jato'))
);

CREATE TABLE clientes (
    usuario_id UUID PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    sobrenome VARCHAR(255) NOT NULL,
  
    CONSTRAINT fk_clientes_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE lava_jatos (
    usuario_id UUID PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL, 
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL,
    capacidade_simultanea INT NOT NULL DEFAULT 1,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cep VARCHAR(8) NOT NULL,
    coordenadas GEOMETRY(Point, 4326) NOT NULL,
  
    CONSTRAINT fk_lavajatos_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT chk_capacidade_simultanea CHECK (capacidade_simultanea > 0)
);

CREATE TABLE usuario_telefones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL,
    ddd VARCHAR(2) NOT NULL,
    numero VARCHAR(9) NOT NULL,
  
    CONSTRAINT fk_telefones_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE categorias_veiculo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE veiculos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    categoria_veiculo_id UUID NOT NULL,
    placa VARCHAR(7) NOT NULL, 
    marca VARCHAR(100) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    cor VARCHAR(50) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT true,
  
    CONSTRAINT fk_veiculos_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(usuario_id),
    CONSTRAINT fk_veiculos_categoria FOREIGN KEY (categoria_veiculo_id) REFERENCES categorias_veiculo(id)
);

CREATE TABLE categorias_servico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE servicos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lava_jato_id UUID NOT NULL,
    categoria_servico_id UUID NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    ativo BOOLEAN NOT NULL DEFAULT true, 
  
    CONSTRAINT fk_servicos_lavajato FOREIGN KEY (lava_jato_id) REFERENCES lava_jatos(usuario_id),
    CONSTRAINT fk_servicos_categoria FOREIGN KEY (categoria_servico_id) REFERENCES categorias_servico(id)
);

CREATE TABLE categorias_veiculo_servicos (
    servico_id UUID NOT NULL,
    categoria_veiculo_id UUID NOT NULL,
    preco NUMERIC(10, 2) NOT NULL,
    duracao INTERVAL NOT NULL,
  
    PRIMARY KEY (servico_id, categoria_veiculo_id),
    CONSTRAINT fk_customizacao_servico FOREIGN KEY (servico_id) REFERENCES servicos(id),
    CONSTRAINT fk_customizacao_categoria FOREIGN KEY (categoria_veiculo_id) REFERENCES categorias_veiculo(id)
);

CREATE TABLE dias_semana (
    id INT PRIMARY KEY,
    nome VARCHAR(20) NOT NULL UNIQUE,
    nome_curto CHAR(3) NOT NULL UNIQUE
);

CREATE TABLE disponibilidades (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lava_jato_id UUID NOT NULL,
    dia_semana_id INT NOT NULL, 
    hora_abertura TIME NOT NULL,
    hora_fechamento TIME NOT NULL,
  
    CONSTRAINT fk_disponibilidade_lavajato FOREIGN KEY (lava_jato_id) REFERENCES lava_jatos(usuario_id),
    CONSTRAINT fk_dia_semana FOREIGN KEY (dia_semana_id) REFERENCES dias_semana(id),
    CONSTRAINT uq_lavajato_dia UNIQUE (lava_jato_id, dia_semana_id),
    CONSTRAINT chk_horario_coerente CHECK (hora_fechamento > hora_abertura)
);

CREATE TABLE status_agendamento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE agendamentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    veiculo_id UUID NOT NULL,
    status_id UUID NOT NULL, 
    data DATE NOT NULL,
    hora TIME NOT NULL,
    preco_total NUMERIC(10, 2) NOT NULL,
    duracao_total INTERVAL NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  
    CONSTRAINT fk_agendamentos_veiculo FOREIGN KEY (veiculo_id) REFERENCES veiculos(id),
    CONSTRAINT fk_agendamentos_status FOREIGN KEY (status_id) REFERENCES status_agendamento(id)
);

CREATE TABLE agendamento_servicos (
    agendamento_id UUID NOT NULL,
    servico_id UUID NOT NULL,
  
    PRIMARY KEY (agendamento_id, servico_id),
    CONSTRAINT fk_agendamentoservico_agendamento FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id),
    CONSTRAINT fk_agendamentoservico_servico FOREIGN KEY (servico_id) REFERENCES servicos(id)
);

CREATE TABLE tipos_remetente (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE notificacoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agendamento_id UUID NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    lida BOOLEAN NOT NULL DEFAULT false,
    remetente_tipo_id UUID NOT NULL,
  
    CONSTRAINT fk_notificacoes_agendamento FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id),
    CONSTRAINT fk_notificacoes_remetente FOREIGN KEY (remetente_tipo_id) REFERENCES tipos_remetente(id)
);