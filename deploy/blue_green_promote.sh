#!/bin/bash

# Ensure variables are set
if [ -z "$APP_NAME" ] || [ -z "$RESOURCE_GROUP" ]; then
  echo "Error: APP_NAME and RESOURCE_GROUP must be set."
  exit 1
fi

# Transfer all traffic to green deployment
traffic_response=$(az containerapp ingress traffic set \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --label-weight blue=0 green=100)

# Check for errors in the previous command
if [ $? -ne 0 ]; then
  echo "Error: Failed to transfer traffic to green deployment."
  exit 1
fi
# Get blue revision name
blue_revision=$(echo "$traffic_response" | jq -r '.[] | select(.label == "blue").revisionName')

# Get green revision name
green_revision=$(echo "$traffic_response" | jq -r '.[] | select(.label == "green").revisionName')

echo "Blue revision: $blue_revision"
echo "Green revision: $green_revision"

# Swap the tags
az containerapp revision label swap \
--source green \
--target blue \
--resource-group "$RESOURCE_GROUP" \
--name "$APP_NAME"

# Remove the green tag from old blue
az containerapp revision label remove \
--label green \
--resource-group "$RESOURCE_GROUP" \
--name "$APP_NAME"

# Deactivate old blue
az containerapp revision deactivate \
--revision "$blue_revision" \
--resource-group "$RESOURCE_GROUP" \
--name "$APP_NAME"
