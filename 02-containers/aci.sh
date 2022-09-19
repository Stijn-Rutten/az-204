RG_NAME='psdemo-rg'
ACR_NAME='psdemoacrstn'

ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)
ACR_LOGINSERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)

echo SCOPES: $ACR_REGISTRY_ID

SP_NAME=acr-service-principal
SP_PASSWD=$(MSYS_NO_PATHCONV=1 az ad sp create-for-rbac \
    --name http://$ACR_NAME-pull \
    --scopes $ACR_REGISTRY_ID \
    --role acrpull \
    --query password \
    --output tsv)

SP_APPID=$(MSYS_NO_PATHCONV=1 az ad sp show \
    --id http://$ACR_NAME-pull \
    --query appId \
    --output tsv )

az container create \
    --reosurce-group $RG_NAME \
    --name psdemo-webapp-cli \
    --dns-name-label psdemo-webapp-cli-stn \
    --ports 80 \
    --image $ACR_LOGINSERVER/webappimage:v1 \
    --registry-login-server $ACR_LOGINSERVER \
    --regsitry-username $SP_APPID \
    --registry-password $SP_PASSWD

az container show --reosurce-group psdemo-rg --name psdemo-webapp-cli

URL=$(az container show --resource-group psdemo-rg --name psdemo-webapp-cli --query ipAddress.fqdn | tr -d ''')
echo $URL
curl $URL