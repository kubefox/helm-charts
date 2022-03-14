# KubeFox Deployment

## Tools

### Required

- [Helm v3](https://helm.sh/docs/intro/install/)
- [Helmfile](https://github.com/roboll/helmfile)
- [Helm Diff Plugin](https://github.com/databus23/helm-diff)

### Recommended

- [k9s](https://k9scli.io/)

## k3s

### Install

Ensure that `vm.max_map_count` is set to at least `262144`.

```bash
sudo sysctl vm.max_map_count
```

If the value is not high enough it can be set using this command.

```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

Next install the control node. Disabled services will be installed by charts present here. For more install details check out the [docs](https://rancher.com/docs/k3s/latest/en/).

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --disable local-storage" sh -
```

The kube config file to access the cluster can be found at `/etc/rancher/k3s/k3s.yaml`. You will also need the node token to setup additional nodes, this can be found at `/var/lib/rancher/k3s/server/node-token`.

```bash
# copy the contents to your ~/.kube/config to access the cluster
# be sure to update cluster server as needed
sudo cat /etc/rancher/k3s/k3s.yaml

# copy this token to add additional nodes, see commands below
sudo cat /var/lib/rancher/k3s/server/node-token
```

To add additional nodes use the following command.

```bash
# replace {{ cluster server }} with the control node's ip or hostname
export K3S_URL="https://{{ cluster server }}:6443"
# pas the node token copied from the control node above
export K3S_TOKEN="{{ node token }}"
curl -sfL https://get.k3s.io | sh -
```

## OpenSearch

### Index Management/Index policies

The setup of this will need to be automated but this policy can be added manually for dev to roll indexes.

```json
{
    "policy": {
        "description": "Deletes indexes after 1 day",
        "default_state": "active",
        "states": [
            {
                "name": "active",
                "actions": [],
                "transitions": [
                    {
                        "state_name": "delete",
                        "conditions": {
                            "min_index_age": "1d"
                        }
                    }
                ]
            },
            {
                "name": "delete",
                "actions": [
                    {
                        "delete": {}
                    }
                ],
                "transitions": []
            }
        ],
        "ism_template": [
            {
                "index_patterns": [
                    "kubefox-*",
                    "security-auditlog-*"
                ],
                "priority": 1
            }
        ]
    }
}
```

## Deploy

There are two environments that can be deployed, `default` and `ha`. The `default` environment deploys single replicas of all the services and is great for local testing. The `ha` environment is "highly available" and deploys 3 replicas for all the services. There is anti-affinity set so the k8s cluster will need at least 3 nodes to support the `ha` environment.

To deploy the `default` environment.

```bash
helmfile sync
```

To deploy the `ha` environment.

```bash
helmfile --environment ha sync
```

By default dependencies are updated each time `helmfile` runs, which can be a bit slow. To avoid this you can download the dependencies once with the command `helmfile deps` and then append the `--skip-deps` flag. Note, that if changes are made to the `kubefox` chart, `helmfile deps` will need to be run again.

Also, after the initial `sync` the command `apply` can be used to only deploy any differences.

```bash
helmfile deps
helmfile sync --skip-deps
# make some changes to values, etc.
helmfile apply --skip-deps
```

### Workstation Values

Often there are value overrides that are workstation specific and should not be committed to source control. These can be placed in the directory `/deploy/values/workstation/`. The `yaml` files follow the same naming pattern as those found in `/deploy/values/`.

As an example, to add a certificate issuer add the following to the file `/deploy/values/workstation/kubefox.yaml` updating things like email address and solvers as needed.

```yaml
certmanager:
  issuers:
    - name: letsencrypt
      spec:
        acme:
          email: support@xigxog.io
          server: https://acme-v02.api.letsencrypt.org/directory
          privateKeySecretRef:
            name: '{{ include "kubefox.fullname" . }}-letsencrypt-key'
          solvers:
            - dns01:
                cloudflare:
                  email: john.long@xigxog.io
                  apiTokenSecretRef:
                    name: cloudflare-token
                    key: api-token
```
