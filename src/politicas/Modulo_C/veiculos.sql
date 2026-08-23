-- SELECT: cliente vê apenas os próprios veículos
CREATE POLICY "Cliente visualiza próprios veículos"
ON veiculo
FOR SELECT
TO authenticated
USING (id_cliente = auth.uid());
 
-- INSERT: cliente cadastra veículo sob a própria titularidade
CREATE POLICY "Cliente cadastra veículo próprio"
ON veiculo
FOR INSERT
TO authenticated
WITH CHECK (id_cliente = auth.uid());
 
-- UPDATE: cliente edita apenas os próprios veículos
CREATE POLICY "Cliente atualiza veículo próprio"
ON veiculo
FOR UPDATE
TO authenticated
USING (id_cliente = auth.uid())
WITH CHECK (id_cliente = auth.uid());