KUBECONFIG_YML ?= kubeconfig.yml
NAMESPACE ?= codezilla

$(KUBECONFIG_YML):
	@make -C terraform kubeconfig > $(KUBECONFIG_YML)

get-pods: $(KUBECONFIG_YML)
	@kubectl --kubeconfig=$(KUBECONFIG_YML) --namespace=$(NAMESPACE) get pods

get-pod: $(KUBECONFIG_YML)
	@kubectl get pods \
		--kubeconfig=$(KUBECONFIG_YML) \
		--namespace=$(NAMESPACE) \
		-o jsonpath='{.items[?(@.metadata.labels.app == "codezilla")].metadata.name}' \
		| awk '{print $$1;}'

apply: $(KUBECONFIG_YML)
	@kubectl --kubeconfig $(KUBECONFIG_YML) --namespace $(NAMESPACE) apply -f k8s/deployment.yml

replace: $(KUBECONFIG_YML)
	@kubectl --kubeconfig $(KUBECONFIG_YML) --namespace $(NAMESPACE) replace -f k8s/deployment.yml

delete: $(KUBECONFIG_YML)
	@kubectl --kubeconfig $(KUBECONFIG_YML) --namespace $(NAMESPACE) delete deployment codezilla-deployment

clean:
	@rm $(KUBECONFIG_YML)
