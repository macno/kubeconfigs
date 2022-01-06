# kubeconfigs

As soon as you start managing multiple [cloud native](https://www.cncf.io) projects, maybe involving several [kubernetes](https://kubernetes.io/) clusters each, you'll face the problem on how to handle kubeconfig files.   

*kubeconfigs* if an opinionated tool that helps you solving this kind of a headache.

it uses a predefined directory structure where each project has its own directory which contains all the clusters config in separate yaml files.

i.e. this is a snippet of mine tree:

```
projects
├── ak
│   ├── prod.yaml
│   └── test.yaml
├── ff3d
│   ├── h2h.yaml
│   └── rekeep.yaml
└── lt
    ├── dev-a-ch.yaml
    ├── dev-a-es.yaml
    ├── dev-a-de.yaml
    ├── prod-a-ch.yaml
    ├── prod-a-de.yaml
    ├── prod-b-ch.yaml
    ├── prod-b-de.yaml
    ├── prod-c-ch.yaml
    ├── prod-c-de.yaml
    ├── test-a-ch.yaml
    └── test-b-ch.yaml
```

With kubeconfigs you're able to work with different clusters/namespaces at the same time in different terminals without interferences. (anyone switched context in one terminal and then messed up the cluster switching back to previous one being sure to still pointing to the right cluster ? just me? ok...)


## install

Just clone this repo (or download the tarball you find under `releases`) wherever you like.  

You can take advantage of the `install.sh` script to add the `kc` alias to your `.*rc` file or you can do it by yourself.

`alias kc=". /path/to/kubeconfigs/kubeconfigs"` (please note the double `kubeconfigs`: the first one is the directory, while the last one is the actual script)

Of course you're free to use the alias you like the most.

## usage

Once you created a project dir under `/path/to/kubeconfigs/projects` and moved your kubeconfigs yaml inside, you can switch between clusters simply executing:

```
╭─macno@jalapeno ~  (⎈ |N/A:default)
╰─➤  kc ak test
╭─macno@jalapeno ~  (⎈ |ak-test:default)
╰─➤  kubectl get pods
No resources found in default namespace.
╭─macno@jalapeno ~  (⎈ |ak-test:default)
╰─➤
```

you can optionally pass a `namespace` as third argument:

```
╭─macno@jalapeno ~  (⎈ |ak-test:default)
╰─➤  kc ak test kube-system
╭─macno@jalapeno ~  (⎈ |ak-test:kube-system)
╰─➤  kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
cilium-45b68                        1/1     Running   0          44d
cilium-lrz25                        1/1     Running   0          44d
cilium-operator-7fd9d7b9dc-sszbf    1/1     Running   0          72d
coredns-57877dc48d-mtgh6            1/1     Running   0          72d
coredns-57877dc48d-xvp2q            1/1     Running   0          72d
csi-do-node-l24c5                   2/2     Running   0          72d
csi-do-node-nb7b5                   2/2     Running   0          72d
do-node-agent-msjwq                 1/1     Running   0          72d
do-node-agent-qm9jk                 1/1     Running   0          72d
kube-proxy-9ksk4                    1/1     Running   0          72d
kube-proxy-fwsmw                    1/1     Running   0          72d
metrics-server-6d55ff964d-gpdrb     1/1     Running   0          72d
traefik-authkeys-557d9c9dbd-f7zmj   1/1     Running   0          9d
traefik-theo-749684f5cc-r7trg       1/1     Running   0          9d
╭─macno@jalapeno ~  (⎈ |ak-test:kube-system)
╰─➤
```

## under the hood

Every time you run `kc` a file is created under `/path/to/kubeconfigs/config` with a name that includes project-cluster-namespace and set the env `KUBECONFIG` value to such file.

```
╭─macno@jalapeno ~  (⎈ |N/A:default)
╰─➤  echo $KUBECONFIG

╭─macno@jalapeno ~  (⎈ |N/A:default)
╰─➤  kc ak prod kube-system
╭─macno@jalapeno ~  (⎈ |AK-PROD:kube-system)
╰─➤  echo $KUBECONFIG
/Users/macno/Projects/fluidware/kubeconfigs/configs/ak_prod_kube-system.yml
╭─macno@jalapeno ~  (⎈ |AK-PROD:kube-system)
╰─➤
```
