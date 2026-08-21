REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM authenticated;

GRANT SELECT ON TABLE
    categoria_servico
    categoria_veiculo
    dias_semana
TO authenticated;

GRANT SELECT, UPDATE, INSERT ON TABLE 
    usuario
    cliente
    lava_jato
    servico
    disponibilidade
    veiculo
    agendamento
    notificacao
TO authenticated;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE 
    agendamento_servico
    telefone
    telefone_usuario
    avaliacao
    categoria_veiculo_servico
TO authenticated;