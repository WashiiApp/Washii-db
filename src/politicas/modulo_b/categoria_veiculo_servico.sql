-- SELECT: público para consulta de preços e durações
CREATE POLICY "Preços e durações são públicos para leitura"
ON categoria_veiculo_servico
FOR SELECT
TO anon, authenticated
USING (true);

-- INSERT: apenas o lava-jato dono do serviço associado cria o vínculo de preço
CREATE POLICY "Lava-jato associa preço ao próprio serviço"
ON categoria_veiculo_servico
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM servico s
        WHERE s.id = id_servico
          AND s.id_lavajato = auth.uid()
    )
);

-- UPDATE: apenas o lava-jato dono do serviço associado edita o vínculo
CREATE POLICY "Lava-jato atualiza preço do próprio serviço"
ON categoria_veiculo_servico
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM servico s
        WHERE s.id = id_servico
          AND s.id_lavajato = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM servico s
        WHERE s.id = id_servico
          AND s.id_lavajato = auth.uid()
    )
);

-- DELETE: apenas o lava-jato dono do serviço associado remove o vínculo
CREATE POLICY "Lava-jato remove preço do próprio serviço"
ON categoria_veiculo_servico
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM servico s
        WHERE s.id = id_servico
          AND s.id_lavajato = auth.uid()
    )
);
