controller_gen = ./bin/controller-gen
crds_out = charts/kubefox/crds

.PHONY: crds
crds:
	$(controller_gen) crd paths="../sdk-go/api/..." output:crd:artifacts:config=$(crds_out)
