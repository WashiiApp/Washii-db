CREATE POLICY "telefone"
ON telefone
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuario_telefone ut
    WHERE ut.id_telefone = telefone.id
      AND ut.id_usuario = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM usuario_telefone ut
    WHERE ut.id_telefone = telefone.id
      AND ut.id_usuario = auth.uid()
  )
);