-- consulta pública
create policy "Leitura pública de categoria veiculo servico"
on categoria_veiculo_servico
for SELECT
to anon, authenticated
using (true);

-- apenas lava-jato podem gerenciar seus dados
create policy "Lava-jato insere apenas suas associações"
on categoria_veiculo_servico
for INSERT
to authenticated
with check (
    id_servico in (
        select id from servico where id_lavajato = auth.uid()
    )
);

create policy "Lava-jato atualiza apenas suas associações"
on categoria_veiculo_servico
for update
to authenticated
using(
    id_servico in (
        select id from servico where id_lavajato = auth.uid()
    )
)
with check(
    id_servico in (
        select id from servico where id_lavajato = auth.uid()
    )
);

create policy "Lava-jato deleta apenas suas associações"
on categoria_veiculo_servico
for delete
to authenticated
using(
    id_servico in (
        select id from servico where id_lavajato = auth.uid()
    )
);