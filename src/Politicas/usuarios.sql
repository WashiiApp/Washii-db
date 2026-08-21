CREATE POLICY "Usuário pode visualizar próprio registro"
ON usuario
FOR SELECT
TO authenticated
USING (id = auth.uid());

CREATE POLICY "Usuário pode inserir próprio registro"
ON usuario
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

CREATE POLICY "Usuário pode atualizar próprio registro"
ON usuario
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());