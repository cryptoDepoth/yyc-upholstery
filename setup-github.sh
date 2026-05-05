#!/usr/bin/env bash
set -euo pipefail

# GitHub repo configuration
REPO_NAME="yyc-upholstery"
OWNER="cryptoDepoth"
DESCRIPTION="YYC Upholstery — Calgary SEO automation, community pages, blog posts, GBP CSV"
VISIBILITY="public"

# GitHub API
API_URL="https://api.github.com"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

# Check token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GITHUB_TOKEN not found. Set it in your environment."
    echo "Create token at: https://github.com/settings/tokens"
    exit 1
fi

# Create repo
echo " Creating repository: ${REPO_NAME}..."
RESPONSE=$(curl -s -X POST "${API_URL}/user/repos" \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json" \
    -d "{
        \"name\": \"${REPO_NAME}\",
        \"description\": \"${DESCRIPTION}\",
        \"private\": false,
        \"auto_init\": true,
        \"gitignore_template\": \"macos\"
    }")

if echo "$RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
    echo "❌ Error creating repo:"
    echo "$RESPONSE" | jq -r '.message'
    exit 1
fi

REPO_URL=$(echo "$RESPONSE" | jq -r '.html_url')
echo "✅ Repository created: ${REPO_URL}"

# Add remote and push
git remote add origin "${REPO_URL}.git"
git branch -M main
git push -u origin main --force

echo "✅ Pushed to GitHub"
echo "🔗 ${REPO_URL}"
