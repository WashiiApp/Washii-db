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


--agendamento_servico
--SELECT
CREATE POLICY "agendamento_servico_select"
ON agendamento_servico
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM servico s
    WHERE s.id = agendamento_servico.id_servico
      AND s.id_lavajato = auth.uid()
  )
);

-- INSERT
CREATE POLICY "agendamento_servico_insert"
ON agendamento_servico
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM servico s
    WHERE s.id = agendamento_servico.id_servico
      AND s.id_lavajato = auth.uid()
  )
);

-- UPDATE
CREATE POLICY "agendamento_servico_update"
ON agendamento_servico
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM servico s
    WHERE s.id = agendamento_servico.id_servico
      AND s.id_lavajato = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM servico s
    WHERE s.id = agendamento_servico.id_servico
      AND s.id_lavajato = auth.uid()
  )
);

CREATE POLICY "agendamento_servico_delete"
ON agendamento_servico
FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM agendamento a
    JOIN veiculo v ON v.id = a.id_veiculo
    WHERE a.id = agendamento_servico.id_agendamento
      AND v.id_cliente = auth.uid()
  )
  OR EXISTS (
    SELECT 1 FROM servico s
    WHERE s.id = agendamento_servico.id_servico
      AND s.id_lavajato = auth.uid()
  )
);

--notificacao 

--SELECT
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