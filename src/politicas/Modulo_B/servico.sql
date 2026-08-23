-- SELECT: público ve apenas servicos ativos (vitrine)
CREATE POLICY "Serviço ativo é publico para leitura"
ON servico
FOR SELECT
TO anon, authenticated
USING (ativo = true);

-- SELECT: lava-jato dono ve todo o proprio catalogo, inclusive inativos
CREATE POLICY "Lava-jato visualiza todo o próprio catálogo"
ON servico
FOR SELECT
TO authenticated
USING (id_lavajato = auth.uid());

-- INSERT: apenas o lava-jato dono cadastra serviço no próprio catálogo
CREATE POLICY "Lava-jato insere serviço no próprio catálogo"
ON servico
FOR INSERT
TO authenticated
WITH CHECK (id_lavajato = auth.uid());

-- UPDATE: apenas o lava-jato dono edita seu serviço
CREATE POLICY "Lava-jato atualiza serviço do próprio catálogo"
ON servico
FOR UPDATE
TO authenticated
USING (id_lavajato = auth.uid())
WITH CHECK (id_lavajato = auth.uid());