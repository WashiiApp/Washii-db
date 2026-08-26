--Agendamento
-- SELECT
CREATE POLICY "agendamento_select"
ON agendamento
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = agendamento.id
      AND s.id_lavajato = auth.uid()
  )
);

-- INSERT 
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

-- UPDATE
CREATE POLICY "agendamento_update"
ON agendamento
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = agendamento.id
      AND s.id_lavajato = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM veiculo v
    WHERE v.id = agendamento.id_veiculo
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM agendamento_servico ags
    JOIN servico s ON s.id = ags.id_servico
    WHERE ags.id_agendamento = agendamento.id
      AND s.id_lavajato = auth.uid()
  )
);