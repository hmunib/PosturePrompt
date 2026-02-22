# PosturePrompt - Entra ID App Registration Script
# Requires Azure CLI. Run 'az login' before executing.

Write-Host "🛡️ Creating PosturePrompt App Registration..."
$appName = "PosturePrompt-ZeroTrust-Engine"

# 1. Create the Azure AD Application
$appId = az ad app create --display-name $appName --query appId -o tsv
Write-Host "✅ App Created! Client ID: $appId"

# 2. Get the Microsoft Graph Service Principal ID
$graphId = az ad sp list --query "[?appDisplayName=='Microsoft Graph'].appId | [0]" --all -o tsv

# 3. Dynamically fetch the Permission GUIDs for Application Permissions (App-Only access)
Write-Host "🔍 Fetching zero-trust permission requirements..."
$userReadAll = az ad sp show --id $graphId --query "appRoles[?value=='User.Read.All'].id | [0]" -o tsv
$groupReadAll = az ad sp show --id $graphId --query "appRoles[?value=='GroupMember.Read.All'].id | [0]" -o tsv
$deviceReadAll = az ad sp show --id $graphId --query "appRoles[?value=='Device.Read.All'].id | [0]" -o tsv
$policyReadAll = az ad sp show --id $graphId --query "appRoles[?value=='Policy.Read.All'].id | [0]" -o tsv

# 4. Assign the least-privilege permissions
Write-Host "🔐 Assigning Microsoft Graph API Permissions..."
az ad app permission add --id $appId --api $graphId --api-permissions "$userReadAll=Role" "$groupReadAll=Role" "$deviceReadAll=Role" "$policyReadAll=Role"

# 5. Create a Client Secret (Valid for 1 year)
Write-Host "🔑 Generating Client Secret..."
$secret = az ad app credential reset --id $appId --append --display-name "PosturePromptSecret" --query password -o tsv

# 6. Output the `.env` variables needed for your Python backend
$tenantId = az account show --query tenantId -o tsv

Write-Host "`n==========================================================="
Write-Host "🎉 SETUP COMPLETE! Copy these into your PosturePrompt .env:"
Write-Host "==========================================================="
Write-Host "AZURE_TENANT_ID=$tenantId"
Write-Host "AZURE_CLIENT_ID=$appId"
Write-Host "AZURE_CLIENT_SECRET=$secret"
Write-Host "===========================================================`n"
Write-Host "⚠️ IMPORTANT NEXT STEP:"
Write-Host "An administrator must now navigate to the Entra ID Portal -> App Registrations -> '$appName' -> API Permissions, and click 'Grant admin consent for Default Directory'."