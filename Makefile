KUBECONFIG_YML ?= kubeconfig.yml
NAMESPACE ?= codezilla

SET_POD_NAME = $(eval POD_NAME = $(shell kubectl get pods \
		--kubeconfig=$(KUBECONFIG_YML) \
		--namespace=$(NAMESPACE) \
		-o jsonpath='{.items[?(@.metadata.labels.app == "codezilla")].metadata.name}' \
		| awk '{print $$1;}'))

$(KUBECONFIG_YML):
	@make --no-print-directory -C terraform kubeconfig > $(KUBECONFIG_YML)

get-pods: $(KUBECONFIG_YML)
	@kubectl --kubeconfig=$(KUBECONFIG_YML) --namespace=$(NAMESPACE) get pods

apply: $(KUBECONFIG_YML)
	@kubectl --kubeconfig $(KUBECONFIG_YML) --namespace $(NAMESPACE) apply -f k8s/deployment.yml

replace: $(KUBECONFIG_YML)
	@kubectl --kubeconfig $(KUBECONFIG_YML) --namespace $(NAMESPACE) replace -f k8s/deployment.yml

delete: $(KUBECONFIG_YML)
	@kubectl --kubeconfig $(KUBECONFIG_YML) --namespace $(NAMESPACE) delete deployment codezilla-deployment

remote: $(KUBECONFIG_YML)
	$(SET_POD_NAME)
	kubectl exec -it $(POD_NAME) --kubeconfig $(KUBECONFIG_YML) --namespace=codezilla -- bin/app remote

clean:
	@rm $(KUBECONFIG_YML)
