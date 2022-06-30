# KubeFox Helm Charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```bash
helm repo add kubefox https://kubefox.github.io/helm-charts
helm repo update
```

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages.  You can then run `helm search repo kubefox` to see the charts.

To install the `<chart-name>` chart:

```bash
helm install my-<chart-name> kubefox/<chart-name>
```

To uninstall the chart:

```bash
helm delete my-<chart-name>
```

## Deployment

For example deployment setup see the README in the `deploy` directory.

## CRDs

This project includes tools used to generate KubeFox Kubernetes CRDs from the [KubeFox Kit SDK for Go](https://github.com/kubefox/sdk-go) project. When changes are made to the models run `make crds` to update the CRD YAMLs in the KubeFox Helm chart. The YAMLs are outputted to `charts/kubefox/crds`.
