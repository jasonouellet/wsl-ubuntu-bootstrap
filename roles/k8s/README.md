# Role: k8s

Purpose: install Kubernetes and cloud-native CLI tooling.

* Feature flag: `enable_k8s` (default: yes)
* Optional feature flags: `k8s_enable_kubescape`, `k8s_enable_falcoctl`,
  `k8s_enable_cilium` (default: no)
* Tags: `k8s`
* Key vars: `k8s_kubectl_version`, `k8s_kubectl_apt_repo_url`,
  `k8s_helm_apt_repo_url`, `k8s_istio_version`, `k8s_calico_version`,
  `k8s_k9s_version`, `k8s_kubectx_version`, `k8s_argocd_version`,
  `k8s_kind_version`, `k8s_kustomize_version`

Usage:

* Run only this role: `ansible-playbook main.yml --tags k8s`
* Enable optional tools in `group_vars/custom.yml` and run with
    `ansible-playbook main.yml -i hosts -e @group_vars/custom.yml`
