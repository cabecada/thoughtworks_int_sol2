# thoughtworks_int_sol2

Prob:We want to automate the deployment of MediaWiki on Vagrant/VirtualBox/Docker, we'd like to see your code file.

Sol:
I made a puppet installation of mediawiki and mysql in the earlier solution https://github.com/cabecada/thoughtworksinterview.

This is experimental on the stuff i was recenty learning about using Nomad/Consul and Docker.

We setup a cluster that consists of Nomad backed by Consul.
Nomad - Orchestration.
Consul - Service Discovery.

We create a mediawiki Dockerfile.
Build an image.
Push to Docker Registry.
Create a Nomad job file.
Make it deploy 3 instances of mediawiki using a shared volume.
the local :80 ports on guest are exposed randomly on the hosts.
these SRV records can be queried by a dns query from Consul Servers.
Hence Application can load balance as dns queries are shuffled.
Any instance killed will be respawned by Nomad.

TODO: 
Vault for secrets.
a NFS mount for Nomad.
make local dns resolve consul dns queries so any application can resolve these services.
prometheus/graphite metrics on container health.
