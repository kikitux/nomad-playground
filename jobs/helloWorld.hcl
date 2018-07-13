job "helloWorld" {
    datacenters = ["dc1"]
    type        = "service"
    group "example" {
      count = 1
      task "example" {
        driver = "raw_exec"
        config {
            command = "/usr/local/bin/http-echo"
            args = ["-listen", ":${NOMAD_PORT_http}", "-text", "hello World"]
        }
        resources {
          cpu    = 20
          memory = 60
          network {
            port "http" {}
          }
        }


        service {
          name = "helloWorld-${NOMAD_PORT_http}"
          port = "http"
        }
      }
    }
}
