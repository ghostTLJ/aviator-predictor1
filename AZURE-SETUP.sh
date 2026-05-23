#!/bin/bash

# Aviator Predictor - Azure Deployment Complete Setup
# This script automates the entire Azure deployment process

set -e

echo "☁️  Aviator Predictor - Azure Complete Deployment"
echo "================================================"
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RESOURCE_GROUP="aviator-rg"
RESOURCE_GROUP_LOCATION="eastus"
APP_SERVICE_PLAN="aviator-plan"
BACKEND_APP="aviator-backend"
FRONTEND_APP="aviator-frontend"
ML_APP="aviator-ml-service"
SKU="B1"

echo -e "${BLUE}Checking prerequisites...${NC}"
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not installed"
    echo "Install from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

echo -e "${GREEN}✅ Azure CLI found${NC}"
echo ""

# Step 1: Login
echo -e "${BLUE}Step 1: Authenticating with Azure...${NC}"
az login
echo ""

# Get subscription
echo -e "${BLUE}Selecting subscription...${NC}"
SUBSCRIPTION=$(az account show --query id -o tsv)
echo -e "${GREEN}✅ Using subscription: $SUBSCRIPTION${NC}"
echo ""

# Step 2: Create Resource Group
echo -e "${BLUE}Step 2: Creating Resource Group...${NC}"
echo "Creating resource group: $RESOURCE_GROUP"
az group create \
  --name $RESOURCE_GROUP \
  --location $RESOURCE_GROUP_LOCATION
echo -e "${GREEN}✅ Resource group created${NC}"
echo ""

# Step 3: Create App Service Plan
echo -e "${BLUE}Step 3: Creating App Service Plan...${NC}"
echo "Creating plan: $APP_SERVICE_PLAN (SKU: $SKU)"
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --is-linux \
  --sku $SKU
echo -e "${GREEN}✅ App Service Plan created${NC}"
echo ""

# Step 4: Create Backend Web App
echo -e "${BLUE}Step 4: Creating Backend Web App (Node.js)...${NC}"
echo "Creating web app: $BACKEND_APP"
az webapp create \
  --name $BACKEND_APP \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --runtime "NODE|18-lts"
echo -e "${GREEN}✅ Backend app created${NC}"
echo ""

# Step 5: Create Frontend Web App
echo -e "${BLUE}Step 5: Creating Frontend Web App (Node.js)...${NC}"
echo "Creating web app: $FRONTEND_APP"
az webapp create \
  --name $FRONTEND_APP \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --runtime "NODE|18-lts"
echo -e "${GREEN}✅ Frontend app created${NC}"
echo ""

# Step 6: Create ML Service Web App
echo -e "${BLUE}Step 6: Creating ML Service Web App (Python)...${NC}"
echo "Creating web app: $ML_APP"
az webapp create \
  --name $ML_APP \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --runtime "PYTHON|3.11"
echo -e "${GREEN}✅ ML Service app created${NC}"
echo ""

# Step 7: Download publish profiles
echo -e "${BLUE}Step 7: Downloading publish profiles...${NC}"
mkdir -p ./azure-profiles

echo "Downloading backend publish profile..."
az webapp deployment publish-profile \
  --name $BACKEND_APP \
  --resource-group $RESOURCE_GROUP \
  --xml > ./azure-profiles/backend-profile.xml
echo -e "${GREEN}✅ Backend profile downloaded${NC}"

echo "Downloading frontend publish profile..."
az webapp deployment publish-profile \
  --name $FRONTEND_APP \
  --resource-group $RESOURCE_GROUP \
  --xml > ./azure-profiles/frontend-profile.xml
echo -e "${GREEN}✅ Frontend profile downloaded${NC}"

echo "Downloading ML service publish profile..."
az webapp deployment publish-profile \
  --name $ML_APP \
  --resource-group $RESOURCE_GROUP \
  --xml > ./azure-profiles/ml-profile.xml
echo -e "${GREEN}✅ ML Service profile downloaded${NC}"
echo ""

# Step 8: Configure app settings
echo -e "${BLUE}Step 8: Configuring app settings...${NC}"

echo "Configuring backend..."
az webapp config appsettings set \
  --name $BACKEND_APP \
  --resource-group $RESOURCE_GROUP \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=1 \
             ML_SERVICE_URL=https://${ML_APP}.azurewebsites.net \
             NODE_ENV=production

echo "Configuring frontend..."
az webapp config appsettings set \
  --name $FRONTEND_APP \
  --resource-group $RESOURCE_GROUP \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=1 \
             NODE_ENV=production

echo "Configuring ML service..."
az webapp config appsettings set \
  --name $ML_APP \
  --resource-group $RESOURCE_GROUP \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=1 \
             PORT=8000

echo -e "${GREEN}✅ App settings configured${NC}"
echo ""

# Step 9: Display next steps
echo -e "${YELLOW}================================================${NC}"
echo -e "${GREEN}✅ Azure deployment setup complete!${NC}"
echo -e "${YELLOW}================================================${NC}"
echo ""
echo -e "${BLUE}📊 NEXT STEPS:${NC}"
echo ""
echo "1. Add GitHub Secrets:"
echo "   Go to: https://github.com/ghostTLJ/aviator-predictor1/settings/secrets/actions"
echo ""
echo "   Add these secrets with the following values:"
echo ""
echo -e "   ${YELLOW}AZURE_BACKEND_PUBLISH_PROFILE:${NC}"
echo "   (Contents of ./azure-profiles/backend-profile.xml)"
echo ""
echo -e "   ${YELLOW}AZURE_FRONTEND_PUBLISH_PROFILE:${NC}"
echo "   (Contents of ./azure-profiles/frontend-profile.xml)"
echo ""
echo -e "   ${YELLOW}AZURE_ML_PUBLISH_PROFILE:${NC}"
echo "   (Contents of ./azure-profiles/ml-profile.xml)"
echo ""
echo "2. Copy publish profiles:"
echo "   cat ./azure-profiles/backend-profile.xml"
echo "   cat ./azure-profiles/frontend-profile.xml"
echo "   cat ./azure-profiles/ml-profile.xml"
echo ""
echo "3. After adding secrets, push to main branch:"
echo "   git add ."
echo "   git commit -m 'Add Azure deployment configuration'"
echo "   git push origin main"
echo ""
echo -e "${BLUE}Deployment URLs:${NC}"
echo "   Backend:  https://${BACKEND_APP}.azurewebsites.net"
echo "   Frontend: https://${FRONTEND_APP}.azurewebsites.net"
echo "   ML Service: https://${ML_APP}.azurewebsites.net"
echo ""
echo -e "${YELLOW}================================================${NC}"
