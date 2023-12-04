az containerapp update --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --image $IMAGE_ID \
  --revision-suffix $GREEN_COMMIT  \

#give that revision a 'green' label
az containerapp revision label add \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --label green \
  --revision $APP_NAME--$GREEN_COMMIT

az containerapp ingress traffic set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --label-weight blue=80 green=20