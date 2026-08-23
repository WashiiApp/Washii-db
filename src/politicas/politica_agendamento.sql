CREATE POLICY "Envolvidos visualizam agendamentos"
ON agendamento
FOR SELECT
TO authenticated
USING (
  -- O cliente autenticado é o dono do veículo do agendamento
  id_veiculo IN (
    select id from veiculo where id_cliente = auth.uid()
  )
  OR
  -- O lava-jato autenticado possui algum serviço vinculado a este agendamento
  id IN (
    select ag.id from agendamento ag
    join agendamento_servico ags on ags.id_agendamento = ag.id
    join servico s on s.id = ags.id_servico
    where s.id_lavajato = auth.uid()
  )
);

-- Cliente que cria agendamentos para seu(s) veículo(s)
CREATE POLICY "Cliente cria agendamento para seus veículos"
ON agendamento
FOR INSERT
TO authenticated
WITH CHECK (
  id_veiculo IN (
    select id from veiculo where id_cliente = auth.uid()
  )
);

-- Clientes e Lava-jatos podem atualizar o agendamento
CREATE POLICY "Envolvidos atualizam agendamentos"
ON agendamento
FOR UPDATE
TO authenticated
USING (
  id_veiculo IN (
    select id from veiculo where id_cliente = auth.uid()
  )
  OR
  id IN (
    select ag.id from agendamento ag
    join agendamento_servico ags on ags.id_agendamento = ag.id
    join servico s on s.id = ags.id_servico
    where s.id_lavajato = auth.uid()
  )
)
WITH CHECK (
  -- Garante que após a alteração, a linha continua pertencendo ao escopo correto
  id_veiculo IN (
    select id from veiculo where id_cliente = auth.uid()
  )
  OR
  id IN (
    select ag.id from agendamento ag
    join agendamento_servico ags on ags.id_agendamento = ag.id
    join servico s on s.id = ags.id_servico
    where s.id_lavajato = auth.uid()
  )
);