path "kv/data/application/curl-bao/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/metadata/application/curl-bao/*" {
  capabilities = ["read", "list"]
}

path "kv/metadata/application" {
  capabilities = ["list"]
}

path "kv/metadata/application/*" {
  capabilities = ["list"]
}