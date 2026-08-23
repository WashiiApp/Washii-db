-- Público para consulta por qualquer usuário (anon ou authenticated)
CREATE POLICY "Disponibilidade pública para leitura"
ON disponibilidade
FOR SELECT
TO anon, authenticated
USING (true);

-- Restrita exclusivamente ao lava-jato dono da agenda
CREATE POLICY "Lava-jato insere exclusivamente sua própria disponibilidade"
ON disponibilidade
FOR INSERT
TO authenticated
WITH CHECK (
    id_lavajato = auth.uid()
);

CREATE POLICY "Lava-jato atualiza exclusivamente sua própria disponibilidade"
ON disponibilidade
FOR UPDATE
TO authenticated
USING (
    id_lavajato = auth.uid()
)
WITH CHECK (
    id_lavajato = auth.uid()
);

CREATE POLICY "Lava-jato apaga exclusivamente sua própria disponibilidade"
ON disponibilidade
FOR DELETE
TO authenticated
USING (
    id_lavajato = auth.uid()
);