-- SELECT: usuário enxerga apenas o próprio registro
CREATE POLICY "usuario visualiza próprio perfil"
ON usuario
FOR SELECT
TO authenticated
USING (id = auth.uid());

-- INSERT: usuário cria apenas o registro correspondente ao seu próprio uid
CREATE POLICY "usuario altera próprio perfil"
ON usuario
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

-- UPDATE: usuário altera apenas o próprio registro
CREATE POLICY "usuario atualiza próprio perfil"
ON usuario
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());