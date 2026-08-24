--agendamento

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


--agendamento_servico

CREATE POLICY "agendamento_servico"
ON agendamento_servico
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    LEFT JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND (a.id_lava_jato = auth.uid() OR v.id_cliente = auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    LEFT JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND (a.id_lava_jato = auth.uid() OR v.id_cliente = auth.uid())
  )
);

--notificacao 

SELECT: apenas dono do veículo e o lava jato veem/recebem
CREATE POLICY "notificacao_select"
ON notificacao
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    LEFT JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND (a.id_lava_jato = auth.uid() OR v.id_cliente = auth.uid())
  )
);

INSERT: sistema/usuários podem criar notificação para o agendamento
CREATE POLICY "notificacao_insert"
ON notificacao
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    LEFT JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND (a.id_lava_jato = auth.uid() OR v.id_cliente = auth.uid())
  )
);

UPDATE: pode alterar o statu, marcar como "lida" apenas quem está envolvido no agendamento
CREATE POLICY "notificacao_update_scope"
ON notificacao
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    LEFT JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND (a.id_lava_jato = auth.uid() OR v.id_cliente = auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    LEFT JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND (a.id_lava_jato = auth.uid() OR v.id_cliente = auth.uid())
  )
);