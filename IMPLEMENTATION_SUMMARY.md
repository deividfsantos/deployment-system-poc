# Checklist de Implementação do Desafio DevOps Kata

## Estrutura e Requisitos
- [ ] Dois namespaces no Kubernetes (`infra` e `apps`) criados via OpenTofu
- [ ] Jenkins instalado via Helm no namespace `infra`
- [ ] Prometheus e Grafana instalados via Helm no namespace `infra`
- [ ] Aplicação implantada via Helm no namespace `apps`
- [ ] Jenkins pipeline executando testes automatizados da aplicação
- [ ] Jenkins pipeline falha se os testes da aplicação falharem
- [ ] Jenkins pipeline faz deploy da aplicação via Helm
- [ ] OpenTofu com testes automatizados (tofu test ou Terratest)
- [ ] Aplicação expõe métricas Prometheus (`/metrics`)
- [ ] Prometheus configurado para coletar métricas da aplicação
- [ ] Dashboards do Grafana mostrando dados úteis da aplicação e infraestrutura
- [ ] Dashboards importados automaticamente no Grafana
- [ ] Documentação clara no README.md sobre como subir, testar e acessar tudo

## Observações
- Marque cada item conforme for implementado.
- Use este checklist para garantir que todos os requisitos do desafio sejam cumpridos.
