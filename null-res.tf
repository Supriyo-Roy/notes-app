
resource "null_resource" "cluster" {
    depends_on = [
        aws_instance.web]
triggers = {
    id = "time())"
  }
      // file provisioner will take the file from local and deploy to the remote server  
    provisioner "file" {
      source = "script.sh"
      destination = "/tmp/script.sh"
      connection {
      agent       = "false"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${tls_private_key.private_key.private_key_pem}"
      host        = "${aws_instance.web.public_ip}"
    }
    }
    provisioner "file" {
      source = "proxy"
      destination = "/tmp/proxy" 
      connection {
      agent       = "false"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${tls_private_key.private_key.private_key_pem}"
      host        = "${aws_instance.web.public_ip}"
    }   
    }  
    //remote exec resource help to execute scripts etc on our remote machine
    provisioner "remote-exec" {
    connection {
      agent       = "false"
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${tls_private_key.private_key.private_key_pem}"
      host        = "${aws_instance.web.public_ip}"
    }
    
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"     
        ]

}

}
