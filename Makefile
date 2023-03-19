KUBECONFIG ?= kubeconfig.yml
NAMESPACE ?= codezilla

$(KUBECONFIG):
	@make -C terraform kubeconfig > $(KUBECONFIG)

desccribe-pods: $(KUBECONFIG)
	@kubectl --kubeconfig=$(KUBECONFIG) --namespace=$(NAMESPACE) desccribe pods
