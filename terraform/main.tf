// main.tf

provider "aws" {
  region = var.region
}

# 기존 보안 그룹 데이터 소스
data "aws_security_group" "existing_sg" {
  id = var.existing_security_group_id
}


# 사용자 데이터 스크립트 생성
locals {
  user_data = <<-EOF
              #!/bin/bash
              # 시스템 업데이트
              sudo apt update && sudo apt upgrade -y

              # Git 설치
              sudo apt install -y git

              # Docker 설치
              sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt update
              sudo apt install -y docker-ce docker-ce-cli containerd.io

              # Docker Compose 설치
              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose

              # Git 레포지토리 클론
              cd /home/ubuntu
              git clone "${var.git_repository_url}"
              cd web3-wallet-test-suite

              # 함수: .env 파일 생성
              create_env_file() {
                local file_path="$1"
                echo "${join("\n", [for key, value in var.env_variables : "${key}=${value}"])}" > "$file_path"
                echo "Created new .env file at $file_path"
              }

              # dapp-playwright에 .env 파일 생성
              create_env_file "/home/ubuntu/web3-wallet-test-suite/dapp-playwright/.env"

              # dapp-playwright/docker에 .env 파일 생성
              create_env_file "/home/ubuntu/web3-wallet-test-suite/dapp-playwright/docker/.env"

              # Docker 컨테이너 실행
              cd /home/ubuntu/web3-wallet-test-suite/dapp-playwright/docker/
              sudo docker-compose up -d
              EOF
}

# 스팟 인스턴스 모듈 호출
module "regular_instance" {
  source = "./modules/instance/regular"

  ami                = var.ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  availability_zone  = var.availability_zone
  security_group_id  = data.aws_security_group.existing_sg.id
  user_data          = local.user_data
}

# 인스턴스 스케줄러 모듈 호출
module "instance_scheduler" {
  source      = "./modules/instance_scheduler"
  instance_id = module.regular_instance.instance_id
  region      = var.region
}

# 출력 설정
output "instance_id" {
  value = module.regular_instance.instance_id
}

output "lambda_function_arn" {
  value = module.instance_scheduler.lambda_function_arn
}

output "scheduler_rule_arn" {
  value = module.instance_scheduler.scheduler_rule_arn
}