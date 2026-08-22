-- SELECT: cliente vê apenas o próprio perfil
CREATE POLICY "cliente visualiza próprio perfil"
ON cliente
FOR SELECT
TO authenticated
USING (id = auth.uid());

-- INSERT: cliente cria o próprio perfil de cliente
CREATE POLICY "cliente altera próprio perfil"
ON cliente
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

-- UPDATE: cliente edita aepnas o próprio perfil
CREATE POLICY "cliente atualiza p´róprio perfil"
ON cliente
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());
