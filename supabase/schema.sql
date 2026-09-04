create extension if not exists postgis;

create table usuario (
  id           uuid primary key references auth.users(id),
  email        varchar(254) not null unique,
  foto_perfil  bytea, -- <-Gerencia o arquivo em binário em até um 1MB.  
  ativo        boolean not null default true,
  tipo_usuario varchar(15) not null,
  estado       varchar(2) not null, -- <- Guarda apenas a sigla do estado
  cidade       varchar(100) not null, 
  -- dados de auditoria
  created_at   timestamptz not null default now(), -- <- armazena a data e hora de criação do registro
  updated_at   timestamptz, -- <- armazena a data e hora da última atualização do registro

  constraint check_tamanho_foto check (octet_length(foto_perfil) <= 1048576), --<-restringe arquivo maiores de 1M byte
  constraint check_tipo_usuario check (tipo_usuario in ('LAVA_JATO', 'CLIENTE'))
);

create table lava_jato (
  id_usuario        uuid primary key references usuario(id),
  razao_social      varchar(200) not null,
  nome_fantasia     varchar(150) not null,
  fluxo_simultaneo  int not null default 1,
  cnpj              varchar(18) not null unique,
  numero            varchar(10) not null,
  logradouro        varchar(150) not null,
  bairro            varchar(100) not null,
  cep               varchar(9) not null, -- <- Padrao: 00000-000
  coordenadas       geometry(Point, 4326) not null,

  constraint check_fluxo_simultaneo check (fluxo_simultaneo > 0)
);

create table cliente (
  id_usuario     uuid primary key references usuario(id),
  cpf            varchar(11) unique,
  sobrenome      varchar(100) not null,
  primeiro_nome  varchar(100) not null
);

create table categoria_servico (
  id         uuid primary key default gen_random_uuid(),
  nome       varchar(100) not null,
  -- dados de auditoria
  created_at timestamptz not null default now()
);

create table categoria_veiculo (
  id         uuid primary key default gen_random_uuid(),
  nome       varchar(50) not null,
  -- dados de auditoria
  created_at timestamptz not null default now()
);

create table servico (
  id                     uuid primary key default gen_random_uuid(),
  id_lavajato            uuid references lava_jato(id_usuario),
  id_categoria_servico   uuid references categoria_servico(id),
  nome                   varchar(100) not null,
  descricao              text not null, -- <- Campo sem limite de tamanho(text) 
  ativo                  boolean not null default true,
  
  created_at             timestamptz not null default now(),
  updated_at             timestamptz,

  unique (id_lavajato, nome) -- <- Permite que o mesmo nome do serviço seja inserido em diferentes lava-jatos
  -- dados de auditoria
);

create table dias_semana (
  id          uuid primary key default gen_random_uuid(),
  nome        varchar(10) not null,
  nome_curto  varchar(3) not null,  -- <- nome_curto = seg, ter, qua, qui, sex, sab, dom
 -- dados de auditoria
  created_at  timestamptz not null default now()
);

create table disponibilidade (
  id             uuid primary key default gen_random_uuid(),
  id_lavajato    uuid references lava_jato(id_usuario),
  id_dias_semana uuid references dias_semana(id),
  hr_inicio      time not null,
  hr_termino     time not null,
  -- dados de auditoria
  created_at     timestamptz not null default now(),
  updated_at     timestamptz
);

create table veiculo (
  id                     uuid primary key default gen_random_uuid(),
  id_cliente             uuid references cliente(id_usuario),
  id_categoria_veiculo   uuid references categoria_veiculo(id),
  cor                    varchar(30) not null,
  ativo                  boolean not null default true,
  placa                  varchar(8) not null unique,
  marca                  varchar(50) not null,
  modelo                 varchar(100) not null,
  -- dados de auditoria
  created_at             timestamptz not null default now(),
  updated_at             timestamptz
);

create table agendamento (
  id                  uuid primary key default gen_random_uuid(),
  id_veiculo          uuid references veiculo(id),
  data                date not null,
  hora                time not null,
  preco_total         numeric(10,2) not null,
  duracao_total       time not null,
  status_agendamento  varchar(20) not null, -- <-(agendado, concluído ou cancelado) 
  -- dados de auditoria
  created_at          timestamptz not null default now(),
  updated_at          timestamptz,

  constraint check_status_agendamento check(status_agendamento in ('AGENDADO', 'CANCELADO', 'CONCLUIDO'))
);

create table notificacao (
  id              uuid primary key default gen_random_uuid(),
  id_agendamento  uuid references agendamento(id),
  mensagem        text not null,-- <- Campo sem limite de tamanho(text)
  titulo          varchar(100),
  data            date not null,
  hora            time not null,
  lida            boolean not null default false,
  tipo_remetente  varchar(15) not null,
  -- dados de auditoria
  created_at      timestamptz not null default now(),
  updated_at      timestamptz,

  constraint check_tipo_remetente check(tipo_remetente in ('LAVA_JATO', 'CLIENTE')) 
);

create table agendamento_servico (
  id              uuid primary key default gen_random_uuid(),
  id_agendamento  uuid references agendamento(id) not null,
  id_servico      uuid references servico(id) not null,
 -- dados de auditoria
  created_at      timestamptz not null default now(),

  unique (id_agendamento, id_servico) -- <- Impede que o mesmo servico seja     vinculado 2  vezes ao mesmo agendamento;
);

create table categoria_veiculo_servico (
  id                    uuid primary key default gen_random_uuid(),
  id_categoria_veiculo  uuid references categoria_veiculo(id) not null,
  id_servico            uuid references servico(id) not null,
  duracao               time not null,
  preco                 numeric(10,2) not null,
 -- dados de auditoria
  created_at            timestamptz not null default now(),
  updated_at            timestamptz, 

  unique (id_categoria_veiculo, id_servico) -- <- Impede que o mesmo servico seja vinculado 2 vezes ao mesmo id_categoria_veiculo
);

create table telefone (
  id           uuid primary key default gen_random_uuid(),
  numero       varchar(9) not null,
  ddd          varchar(2) not null,
  -- dados de auditoria
  created_at   timestamptz not null default now(),
  updated_at   timestamptz,

  unique(ddd, numero)
);

create table usuario_telefone (
  id           uuid primary key default gen_random_uuid(),
  id_usuario   uuid references usuario(id) not null,
  id_telefone  uuid references telefone(id) not null,
 -- dados de auditoria
  created_at   timestamptz not null default now(),

  unique (id_usuario, id_telefone) -- <- impede que o mesmo telefone seja cadastrado a um mesmo usuário 
);

create table avaliacao (
  id                  uuid primary key default gen_random_uuid(),
  id_cliente          uuid references cliente(id_usuario),
  id_servico          uuid references servico(id),
  comentario          text,-- <- Campo sem limite de tamanho
  data                date,
  nivel_satisfacao    int check (nivel_satisfacao between 1 and 5),
  -- dados de auditoria
  created_at          timestamptz not null default now(),
  updated_at          timestamptz,

  unique(id_cliente, id_servico) -- <- Permite que o mesmo cliente avalie o mesmo serviço apenas uma vez
);