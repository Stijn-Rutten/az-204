ACR_NAME='psdemoacrstn'
RG_NAME='psdemo-rg'

# Create Resource group
az group create \
    --name $RG_NAME \
    --location westeurope

# Create Azure Container Registry
az acr create \
    --resource-group $RG_NAME \
    --name $ACR_NAME \
    --sku Standard

# Login to Azure Container Registry
az acr login --name $ACR_NAME

# Get the login server which is used in the image tag
ACR_LOGINSERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
echo $ACR_LOGINSERVER

# Tag the container image using the login server. This doesnt push it to ACR
IMAGENAME='webappimage:v1'
ACR_IMAGENAME=$ACR_LOGINSERVER/$IMAGENAME

docker tag $IMAGENAME $ACR_IMAGENAME
docker image ls $ACR_IMAGENAME

# Push the iamge to ACR
docker push $ACR_IMAGENAME

# Get  a listing of the repositories and images in our ACR
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository webappimage --output table

######
# ACR Tasks
######
ACR_TASK_IMAGENAME='webappimage:v1-acr-task'
az acr build --image $ACR_TASK_IMAGENAME --registry $ACR_NAME .

# Check both images are there
az acr repository show-tags --name $ACR_NAME --repository webappimage --output table
