job "mediawiki" {
  datacenters = ["dc1"]
  type = "service"
  priority = 50

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "1s"
    max_parallel = 2
    min_healthy_time = "2s"
    healthy_deadline = "2m"
  }

  group "mediawiki" {
    count = 2
    restart {
      attempts = 2
      interval = "1m"
      delay = "10s"
      mode = "fail"
    }

    task "mediawiki" {
      driver = "docker"

      # need to setup nomad with volume exposed to use this
      # https://learn.hashicorp.com/nomad/stateful-workloads/host-volumes

      # volume "mediawiki" {
      #   type      = "host"
      #   read_only = false
      #   source    = "mediawiki"
      # }

      # volume_mount {
      #   volume      = "mediawiki"
      #   destination = "/var/www"
      #   read_only   = false
      # }

      config {
        image = "vijay"
        port_map {
          http = 80
        }
      }

      service {
        name = "${TASKGROUP}-service"
        tags = ["mediawiki", "urlprefix-/"]
        port = "http"
        check {
          name = "mediawiki"
          type = "http"
          interval = "10s"
          timeout = "3s"
          path = "/"
        }
      }

      resources {
        cpu = 100
        memory = 64 
        network {
          mbits = 100
          port "http" {}
        }
      }

      logs {
        max_files = 10
        max_file_size = 15
      }

      kill_timeout = "10s"
    }
  }
}
