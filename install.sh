if [ -z $TEKTON_DEMO_NS ]
then
export TEKTON_DEMO_NS=tekton-pipelines
fi
if [ -z $TEKTON_DEMO_SA ]
then 
export TEKTON_DEMO_SA=tekton-dashboard
fi

RELEASES=https://storage.googleapis.com/tekton-releases
TEKTON=$RELEASES/latest/release.yaml
DASH=$RELEASES/dashboard/latest/openshift-tekton-dashboard-release-readonly.yaml

YAML=$(mktemp)
curl -s $TEKTON | \
     sed "s/tekton-pipelines/$TEKTON_DEMO_NS/g" | \
     sed "s/tekton-dashboard/$TEKTON_DEMO_SA/g" | 
     sed "s/@sha.*\"]/\"]/" |
     sed "s/@sha.*\"/\"/" |
     sed "s/@sha.*//"> $YAML

kubectl apply -f $YAML -n $TEKTON_DEMO_NS

curl -s $DASH | \
     sed "s/tekton-pipelines/$TEKTON_DEMO_NS/g" | \
     sed "s/tekton-dashboard/$TEKTON_DEMO_SA/g" | \
     sed "s/@sha.*//"> $YAML

kubectl apply -f $YAML -n $TEKTON_DEMO_NS
kubectl apply -f pipelines -n $TEKTON_DEMO_NS

echo "Tekton Easy Demo Installed "
echo "sh all  - runs all the example pipelines"
