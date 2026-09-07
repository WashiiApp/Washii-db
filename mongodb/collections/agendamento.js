/*
 * Modelo conceitual - Collection: agendamento
 */
const agendamentoModel = {
  _id: "ObjectId",

  data: "Date",
  hora: "String",
  preco_total: "Double",
  duracao_total: "Int32",
  status_agendamento: "String",

  veiculo: {
    id_veiculo: "String",
    placa: "String",
    marca: "String",
    modelo: "String",
    cor: "String",
    categoria_veiculo: {
      id: "String",
      nome: "String"
    }
  },

  cliente: {
    id_cliente: "String",
    nome: "String",
    sobrenome: "String",
    email: "String",
    telefones: [
      {
        ddd: "String",
        numero: "String"
      }
    ]
  },

  lava_jato: {
    id_lavajato: "String",
    nome_fantasia: "String",
    endereco: {
      logradouro: "String",
      numero: "String",
      bairro: "String",
      cep: "String"
    },
    coordenadas: {
      type: "String",       // "Point" (GeoJSON)
      coordinates: ["Double"] // [longitude, latitude]
    }
  },

  servicos: [
    {
      id_servico: "String",
      nome: "String",
      categoria_servico: "String",
      preco: "Double",
      duracao: "Int32"
    }
  ],

  created_at: "Date",
  updated_at: "Date"
};

module.exports = agendamentoModel;