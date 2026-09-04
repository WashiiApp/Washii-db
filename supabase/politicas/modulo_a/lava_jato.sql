-- SELECT: qualquer usuário autenticado pode buscar estabelecimentos
CREATE POLICY "lava_jato_select_public"
ON lava_jato
FOR SELECT
TO authenticated
USING (true);

-- INSERT: apenas o lava jato pode criar seu estabelecimento
CREATE POLICY "lava_jato_insert"
ON lava_jato
FOR INSERT
TO authenticated
WITH CHECK (id_usuario = auth.uid());

-- UPDATE: apenas o lava jato pode editar seu estabelecimento
CREATE POLICY "lava_jato_update"
ON lava_jato
FOR UPDATE
TO authenticated
USING (id_usuario = auth.uid())
WITH CHECK (id_usuario = auth.uid());