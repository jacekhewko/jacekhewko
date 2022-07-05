output "arn" {
  value       = aws_ecr_repository.main.arn
  description = "Full ARN of the repository"
}

output "name" {
  value       = aws_ecr_repository.main.name
  description = "Name of the repository"
}

output "registry_id" {
  value       = aws_ecr_repository.main.registry_id
  description = "Registry ID where the repository was created"
}

output "repository_url" {
  value       = aws_ecr_repository.main.repository_url
  description = "URL of the repository"
}

