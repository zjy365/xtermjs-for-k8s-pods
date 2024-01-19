# Temporary alias if using K8s instead of kubectlP
[ -z "$(which kubectl)" ] && alias kubectl="kubectl"

# Define namespace/project name
KUBERNETES_NAMESPACE=xtermjs

# Create namespace
kubectl create ns $KUBERNETES_NAMESPACE

# Creates service account and assigns needs permissions
kubectl apply -n $KUBERNETES_NAMESPACE -f k8s/service-account.yml

# Create test Alpine deployment
kubectl apply -n $KUBERNETES_NAMESPACE -f k8s/alpine-deployment.yml

TOKEN_NAME=$(kubectl get secrets -n $KUBERNETES_NAMESPACE | grep terminal-account-token | head -n 1 | cut -d " " -f1)
KUBERNETES_SERVICE_ACCOUNT_TOKEN=$(kubectl describe secret $TOKEN_NAME -n $KUBERNETES_NAMESPACE | grep -o -E "ey.+")

# Get list of pods
kubectl get pods -n $KUBERNETES_NAMESPACE

# Create .env file and update API host
cp sample.env .env

# Append required config
cat <<EOF >> .env
KUBERNETES_NAMESPACE=$KUBERNETES_NAMESPACE
KUBERNETES_SERVICE_ACCOUNT_TOKEN=$KUBERNETES_SERVICE_ACCOUNT_TOKEN
EOF