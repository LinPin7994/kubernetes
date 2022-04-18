#!/bin/bash
ns=$1
result_file=${ns}.txt
kube_config="config"
function check_file_exist() {
    if [[ -f $1 ]];then
        rm -f $1
    fi;
}
function get_components_version() {
    for app in $(kubectl --kubeconfig /opt/config -n $1 get deploy --no-headers|awk '{print $1}');do
        app_name=$(kubectl --kubeconfig /opt/config -n $1 get deploy $app -o jsonpath='{..spec.containers[*].image}'|tr ' ' '\n'|cut -d: -f1|cut -d/ -f3)
        app_version=$(kubectl --kubeconfig /opt/config -n $1 get deploy $app -o jsonpath='{..spec.containers[*].image}'|tr ' ' '\n'|cut -d: -f2)
        set_labels "${1}" "${app_name}" "${app_version}"
        echo "${app_name}:${app_version}" >> $result_file
    done
}
function set_labels() {
    kubectl --kubeconfig /opt/config label ns $1 $2=$3 --overwrite
}
check_file_exist "${result_file}"
get_components_version "${ns}"