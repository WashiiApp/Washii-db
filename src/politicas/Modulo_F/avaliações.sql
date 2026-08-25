CREATE POLICY "Avaliações são públicas para leitura"
ON avaliacao
FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "Cliente insere a própria avaliação"
ON avaliacao
FOR INSERT
TO authenticated
WITH CHECK (
    id_cliente = auth.uid()
);

CREATE POLICY "Cliente atualiza a própria avaliação"
ON avaliacao
FOR UPDATE
TO authenticated
USING (
    id_cliente = auth.uid()
)
WITH CHECK (
    id_cliente = auth.uid()
);

CREATE POLICY "Cliente remove a própria avaliação"
ON avaliacao
FOR DELETE
TO authenticated
USING (
    id_cliente = auth.uid()
);