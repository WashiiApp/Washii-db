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