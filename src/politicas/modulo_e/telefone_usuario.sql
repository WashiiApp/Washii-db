CREATE POLICY "usuario_telefone"
ON usuario_telefone
FOR ALL
TO authenticated
USING (id_usuario = auth.uid())
WITH CHECK (id_usuario = auth.uid());