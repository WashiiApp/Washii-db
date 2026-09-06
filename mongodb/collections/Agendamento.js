/**
 * Collection: agendamento
 * Documentos embutidos: veiculo, cliente, lava_jato, servicos[]
 * (substitui joins e a tabela de junção agendamento_servico)
 */

db.createCollection("agendamento", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [
        "data",
        "hora",
        "preco_total",
        "duracao_total",
        "status_agendamento",
        "veiculo",
        "cliente",
        "lava_jato",
        "servicos"
      ],
      properties: {
        data: {
          bsonType: "date",
          description: "Data do agendamento"
        },
        hora: {
          bsonType: "string",
          description: "Horário no formato HH:mm"
        },
        preco_total: {
          bsonType: "number",
          minimum: 0
        },
        duracao_total: {
          bsonType: "int",
          minimum: 1,
          description: "Duração total em minutos"
        },
        status_agendamento: {
          enum: ["AGENDADO", "CANCELADO", "CONCLUIDO"]
        },
        veiculo: {
          bsonType: "object",
          required: ["id_veiculo", "placa", "marca", "modelo"],
          properties: {
            id_veiculo: { bsonType: "string" },
            placa: { bsonType: "string" },
            marca: { bsonType: "string" },
            modelo: { bsonType: "string" },
            cor: { bsonType: "string" },
            categoria_veiculo: {
              bsonType: "object",
              properties: {
                id: { bsonType: "string" },
                nome: { bsonType: "string" }
              }
            }
          }
        },
        cliente: {
          bsonType: "object",
          required: ["id_cliente", "nome", "sobrenome"],
          properties: {
            id_cliente: { bsonType: "string" },
            nome: { bsonType: "string" },
            sobrenome: { bsonType: "string" },
            email: { bsonType: "string" },
            telefones: {
              bsonType: "array",
              items: {
                bsonType: "object",
                properties: {
                  ddd: { bsonType: "string" },
                  numero: { bsonType: "string" }
                }
              }
            }
          }
        },
        lava_jato: {
          bsonType: "object",
          required: ["id_lavajato", "nome_fantasia"],
          properties: {
            id_lavajato: { bsonType: "string" },
            nome_fantasia: { bsonType: "string" },
            endereco: {
              bsonType: "object",
              properties: {
                logradouro: { bsonType: "string" },
                numero: { bsonType: "string" },
                bairro: { bsonType: "string" },
                cep: { bsonType: "string" }
              }
            },
            coordenadas: {
              bsonType: "object",
              required: ["type", "coordinates"],
              properties: {
                type: { enum: ["Point"] },
                coordinates: {
                  bsonType: "array",
                  minItems: 2,
                  maxItems: 2
                }
              }
            }
          }
        },
        servicos: {
          bsonType: "array",
          minItems: 1,
          items: {
            bsonType: "object",
            required: ["id_servico", "nome", "preco", "duracao"],
            properties: {
              id_servico: { bsonType: "string" },
              nome: { bsonType: "string" },
              categoria_servico: { bsonType: "string" },
              preco: { bsonType: "number", minimum: 0 },
              duracao: { bsonType: "int", minimum: 1 }
            }
          }
        },
        created_at: { bsonType: "date" },
        updated_at: { bsonType: ["date", "null"] }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});

// Índices recomendados
db.agendamento.createIndex({ "cliente.id_cliente": 1, data: -1 });
db.agendamento.createIndex({ "lava_jato.id_lavajato": 1, data: -1 });
db.agendamento.createIndex({ "lava_jato.coordenadas": "2dsphere" });
db.agendamento.createIndex({ status_agendamento: 1 });