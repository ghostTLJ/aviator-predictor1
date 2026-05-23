# Azure Deployment Guide - Aviator Predictor

## Prerequisites

- Azure Account (free trial available at https://azure.microsoft.com/en-us/free/)
- Azure CLI installed ([Install Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- GitHub repository access
- Git installed

---

## Step-by-Step Azure Deployment

### Step 1: Install Azure CLI

**macOS:**
```bash
brew install azure-cli
```

**Windows (PowerShell):**
```powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile WebInstaller.msi; msiexec /i WebInstaller.msi
```

**Linux:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Step 2: Run Automated Setup

Make the setup script executable and run it:

```bash
chmod +x AZURE-SETUP.sh
./AZURE-SETUP.sh
```

The script will:
- ✅ Authenticate with Azure
- ✅ Create a Resource Group
- ✅ Create an App Service Plan
- ✅ Create 3 Web Apps (Backend, Frontend, ML Service)
- ✅ Download publish profiles
- ✅ Configure app settings

### Step 3: Add GitHub Secrets

1. Go to your GitHub repository: https://github.com/ghostTLJ/aviator-predictor1
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add:

#### Secret 1: AZURE_BACKEND_PUBLISH_PROFILE

```bash
cat ./azure-profiles/backend-profile.xml
```

Copy the entire contents and paste as the secret value.

#### Secret 2: AZURE_FRONTEND_PUBLISH_PROFILE

```bash
cat ./azure-profiles/frontend-profile.xml
```

Copy the entire contents and paste as the secret value.

#### Secret 3: AZURE_ML_PUBLISH_PROFILE

```bash
cat ./azure-profiles/ml-profile.xml
```

Copy the entire contents and paste as the secret value.

### Step 4: Deploy

Once secrets are added, simply push to main:

```bash
git add .
git commit -m 'Deploy to Azure'
git push origin main
```

The GitHub Actions workflow will automatically:
- Build your applications
- Deploy to Azure
- Monitor for errors

### Step 5: Access Your Application

After deployment completes:

- **Frontend**: https://aviator-frontend.azurewebsites.net
- **Backend API**: https://aviator-backend.azurewebsites.net
- **ML Service**: https://aviator-ml-service.azurewebsites.net
- **Backend Health**: https://aviator-backend.azurewebsites.net/health
- **ML Health**: https://aviator-ml-service.azurewebsites.net/health

---

## Manual Setup (If Preferred)

If you don't want to use the automated script:

### 1. Login to Azure

```bash
az login
```

### 2. Create Resource Group

```bash
az group create \
  --name aviator-rg \
  --location eastus
```

### 3. Create App Service Plan

```bash
az appservice plan create \
  --name aviator-plan \
  --resource-group aviator-rg \
  --is-linux \
  --sku B1
```

### 4. Create Web Apps

**Backend:**
```bash
az webapp create \
  --name aviator-backend \
  --resource-group aviator-rg \
  --plan aviator-plan \
  --runtime "NODE|18-lts"
```

**Frontend:**
```bash
az webapp create \
  --name aviator-frontend \
  --resource-group aviator-rg \
  --plan aviator-plan \
  --runtime "NODE|18-lts"
```

**ML Service:**
```bash
az webapp create \
  --name aviator-ml-service \
  --resource-group aviator-rg \
  --plan aviator-plan \
  --runtime "PYTHON|3.11"
```

### 5. Download Publish Profiles

```bash
az webapp deployment publish-profile \
  --name aviator-backend \
  --resource-group aviator-rg \
  --xml > backend-profile.xml

az webapp deployment publish-profile \
  --name aviator-frontend \
  --resource-group aviator-rg \
  --xml > frontend-profile.xml

az webapp deployment publish-profile \
  --name aviator-ml-service \
  --resource-group aviator-rg \
  --xml > ml-profile.xml
```

### 6. Add Profiles to GitHub Secrets

Following the same process as Step 3 above.

---

## Monitoring & Logs

### View Deployment Status

```bash
# View backend logs
az webapp log tail --name aviator-backend --resource-group aviator-rg

# View frontend logs
az webapp log tail --name aviator-frontend --resource-group aviator-rg

# View ML service logs
az webapp log tail --name aviator-ml-service --resource-group aviator-rg
```

### Check App Status

```bash
# Backend
curl https://aviator-backend.azurewebsites.net/health

# ML Service
curl https://aviator-ml-service.azurewebsites.net/health
```

---

## Cost Estimation

**B1 App Service Plan:**
- ~$12.50/month per app
- 3 apps = ~$37.50/month
- First 12 months: Free tier available

---

## Troubleshooting

### Deployment Failed

1. Check GitHub Actions logs:
   - Go to **Actions** tab → Recent workflow → View logs

2. Check Azure logs:
   ```bash
   az webapp log tail --name aviator-backend --resource-group aviator-rg
   ```

3. Common issues:
   - **Secrets not set**: Verify all 3 secrets are added
   - **App name taken**: Azure app names must be globally unique
   - **Port conflict**: Ensure ports 5000, 5001, 3000 are configured

### Application Won't Start

1. Check runtime compatibility:
   ```bash
   az webapp show --name aviator-backend --resource-group aviator-rg
   ```

2. Verify environment variables are set

3. Check application logs for errors

---

## References

- [Deploying Node.js to Azure App Service](https://docs.github.com/en/actions/how-tos/deploy/deploy-to-third-party-platforms/nodejs-to-azure-app-service)
- [Deploying Python to Azure App Service](https://docs.github.com/en/actions/how-tos/deploy/deploy-to-third-party-platforms/python-to-azure-app-service)
- [Azure App Service Documentation](https://docs.microsoft.com/azure/app-service/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)

---

## Next Steps

1. ✅ Complete the setup steps above
2. 🔍 Monitor deployment in GitHub Actions
3. 📊 Test endpoints in production
4. 🔧 Configure custom domain (optional)
5. 🔒 Setup SSL certificate (optional)

