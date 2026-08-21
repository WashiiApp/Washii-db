REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM anon;

GRANT SELECT ON TABLE 
    lava_jato,
    servico,
    categoria_servico,
    categoria_veiculo,
    dias_semana,
    disponibilidade,
    categoria_veiculo_servico,
    avaliacao
TO anon;