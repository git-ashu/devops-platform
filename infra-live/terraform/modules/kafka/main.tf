resource "aws_security_group" "kafka_sg" {
  name        = "enterprise-kafka-sg"
  description = "Kafka access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Kafka"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "kafka" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.kafka_sg.id]

  key_name = var.key_name

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

docker run -d \
--name kafka \
-p 9092:9092 \
-e KAFKA_NODE_ID=1 \
-e KAFKA_PROCESS_ROLES=broker,controller \
-e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093 \
-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://$PRIVATE_IP:9092 \
-e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
-e KAFKA_CONTROLLER_QUORUM_VOTERS=1@$PRIVATE_IP:9093 \
-e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
-e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
-e CLUSTER_ID=$(uuidgen | tr -d '-') \
confluentinc/cp-kafka:7.6.0
EOF

  tags = {
    Name = "enterprise-kafka"
  }
}