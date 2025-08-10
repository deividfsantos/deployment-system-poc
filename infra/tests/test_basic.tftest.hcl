# Example test file for OpenTofu
resource "null_resource" "test" {
  provisioner "local-exec" {
    command = "echo 'Test passed'"
  }
}
