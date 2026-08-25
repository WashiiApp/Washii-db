-- SELECT: apenas dono do veículo e o lava jato veem/recebem
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

-- INSERT: sistema/usuários podem criar notificação para o agendamento
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

-- UPDATE: pode alterar o statu, marcar como "lida" apenas quem está envolvido no agendamento
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