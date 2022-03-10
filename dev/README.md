# KubeFox Development

## k3s

### Install

Disabled services will be configured by charts present here.

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --disable local-storage" sh -
```

## OpenSearch

Ensure that `vm.max_map_count` is set to at least `262144`.

```ssh
sudo sysctl vm.max_map_count
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Index Management/Index policies

The setup of this will need to be automated but this policy can be added manually for dev to roll indexes.

```json
{
    "policy": {
        "policy_id": "active_delete_workflow",
        "description": "Deletes indexes after 3 days",
        "last_updated_time": 1644464172104,
        "schema_version": 12,
        "error_notification": null,
        "default_state": "active",
        "states": [
            {
                "name": "active",
                "actions": [],
                "transitions": [
                    {
                        "state_name": "delete",
                        "conditions": {
                            "min_index_age": "3d"
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
                    "logstash-*",
                    "metricbeat-*",
                    "security-auditlog-*"
                ],
                "priority": 1,
                "last_updated_time": 1644443706774
            }
        ]
    }
}
```
