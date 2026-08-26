CREATE POLICY "notificacao_select_scope"
ON notificacao
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = notificacao.id_agendamento
      AND s.id_lavajato = auth.uid()
  )
);

-- INSERT

CREATE POLICY "notificacao_insert"
ON notificacao
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = notificacao.id_agendamento
      AND s.id_lavajato = auth.uid()
  )
);

CREATE POLICY "notificacao_update"
ON notificacao
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = notificacao.id_agendamento
      AND s.id_lavajato = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = notificacao.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = notificacao.id_agendamento
      AND s.id_lavajato = auth.uid()
  )
);