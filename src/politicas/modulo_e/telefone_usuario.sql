CREATE POLICY "telefone_usuario"
ON telefone_usuario
FOR ALL
TO authenticated
USING (id_usuario = auth.uid())
WITH CHECK (id_usuario = auth.uid());