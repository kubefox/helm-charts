# Setup

## Index Management/Index policies

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
