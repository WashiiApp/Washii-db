--telefone_usuario

CREATE POLICY "telefone_usuario"
ON telefone_usuario
FOR ALL
TO authenticated
USING (id_usuario = auth.uid())
WITH CHECK (id_usuario = auth.uid());

--telefone

CREATE POLICY "telefone"
ON telefone
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM telefone_usuario tu
    WHERE tu.id_telefone = telefone.id
      AND tu.id_usuario = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM telefone_usuario tu
    WHERE tu.id_telefone = telefone.id
      AND tu.id_usuario = auth.uid()
  )
);