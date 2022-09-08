az group create \
    --name "psdemo-rg" \
    --location "westeurope"

az vm create \
    --resource-group "psdemo-rg" \
    --name "psdemo-win-cli" \
    --image "win2019datacenter" \
    --admin-username "demoadmin" \
    --admin-password "password1234!"