KUBECONFIG ?= kubeconfig.yml
NAMESPACE ?= codezilla

$(KUBECONFIG):
	@make -C terraform kubeconfig > $(KUBECONFIG)

describe-pods: $(KUBECONFIG)
	@kubectl --kubeconfig=$(KUBECONFIG) --namespace=$(NAMESPACE) describe pods

apply: $(KUBECONFIG)
	@kubectl --kubeconfig $(KUBECONFIG) --namespace $(NAMESPACE) apply -f k8s/deployment.yml

replace: $(KUBECONFIG)
	@kubectl --kubeconfig $(KUBECONFIG) --namespace $(NAMESPACE) replace -f k8s/deployment.yml

delete: $(KUBECONFIG)
	@kubectl --kubeconfig $(KUBECONFIG) --namespace $(NAMESPACE) delete deployment codezilla-deployment

clean:
	@rm $(KUBECONFIG)
