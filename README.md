# 🗄️ Terraform AWS RDS Database

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.31-FF9900?logo=amazonaws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

> **FIAP — Pós Tech · Tech Challenge — Fase 03 · ToggleMaster**
>
> Módulo Terraform para provisionamento de instâncias **Amazon RDS** com Security Groups, Subnet Groups e monitoramento.

---

## 📋 Descrição

Módulo reutilizável que provisiona instâncias RDS com boas práticas:

- **Multi-engine**: PostgreSQL, MySQL e outros engines suportados
- **Subnet Groups** automáticos para deploy em subnets privadas
- **Security Groups** configuráveis com regras de ingress/egress
- **Encryption at Rest** com criptografia de storage
- **Managed Passwords** via AWS Secrets Manager
- **Monitoramento** com CloudWatch (opcional)
- **Multi-AZ** para alta disponibilidade (opcional)

---

## 📦 Recursos Criados

| Recurso | Descrição |
|---------|-----------|
| `aws_db_instance` | Instância RDS |
| `aws_db_subnet_group` | Subnet group para subnets privadas |
| `aws_security_group` | Security group com regras configuráveis |
| `aws_security_group_rule` | Regras de ingress/egress |

---

## 🚀 Uso

```hcl
module "rds" {
  source = "github.com/brianmonteiro54/terraform-aws-rds-database//modules/rds?ref=<commit-sha>"

  db_identifier = "auth-service"
  environment   = "production"

  engine         = "postgres"
  engine_version = "18.1"
  instance_class = "db.t3.micro"
  db_name        = "authdb"
  username       = "postgres"

  manage_master_user_password = true

  subnet_ids            = module.vpc.private_subnet_ids
  create_security_group = true
  vpc_id                = module.vpc.vpc_id

  security_group_ingress_rules = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.eks_workers.id
      description              = "Allow PostgreSQL from EKS workers"
    }
  ]

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true
}
```

---

## 🔐 Segurança

- **Senhas**: Gerenciadas pelo AWS Secrets Manager (`manage_master_user_password = true`)
- **Encryption**: Storage criptografado com `storage_encrypted = true`
- **Network**: Deploy em subnets privadas, acesso apenas via Security Groups
- **Acesso**: Regras de SG restritas (apenas EKS workers acessam porta 5432)

---

## 📁 Estrutura

```
terraform-aws-rds-database/
├── modules/
│   └── rds/
│       ├── main.tf
│       ├── subnet_group.tf
│       ├── security_groups.tf
│       ├── monitoring.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── locals.tf
│       ├── data.tf
│       └── provider.tf
├── .github/workflows/
│   └── terraform-ci.yml
└── LICENSE
```
## 📄 Licença

[MIT License](LICENSE)
