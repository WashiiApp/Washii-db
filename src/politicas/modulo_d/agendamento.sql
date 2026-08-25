SELECT: cliente vê agendamentos dos seus veículos e o lava-jato vê os agendamentos para seus serviços
CREATE POLICY "agendamento_select"
ON agendamento
FOR SELECT
TO authenticated
USING (
  id_lava_jato = auth.uid()
  OR EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
);

INSERT: cliente cria apenas o agendamento para o próprio veículo
CREATE POLICY "agendamento_insert"
ON agendamento
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
);

UPDATE: O dono do veículo ou lava-jato dono do serviço podem atualizar
CREATE POLICY "agendamento_update"
ON agendamento
FOR UPDATE
TO authenticated
USING (
  id_lava_jato = auth.uid()
  OR EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
)
WITH CHECK (
  id_lava_jato = auth.uid()
  OR EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
);