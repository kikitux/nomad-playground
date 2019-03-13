# nomad-playground
nomad-playground

Simple vagrant project that creates 2 dc, 1 server, 1 client for consul, nomad, vault.

## how to use

```
git clone https://github.com/kikitux/nomad-playground
cd nomad-playground
vagrant up
```

Vault root token is `changeme`

Then you can reach the services at

consul http://localhost:8500

nomad http://localhost:4646

vault http://localhost:8200
