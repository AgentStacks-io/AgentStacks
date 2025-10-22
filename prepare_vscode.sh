#!/usr/bin/env bash
# shellcheck disable=SC1091,2154

set -e

# Copy icon resources for the appropriate quality
if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  cp -rp src/insider/* vscode/ 2>/dev/null || true
else
  cp -rp src/stable/* vscode/ 2>/dev/null || true
fi

cp -f LICENSE vscode/LICENSE.txt

cd vscode || { echo "'vscode' dir not found"; exit 1; }

{ set +x; } 2>/dev/null

# {{{ product.json
cp product.json{,.bak}

setpath() {
  local jsonTmp
  { set +x; } 2>/dev/null
  jsonTmp=$( jq --arg 'value' "${3}" "setpath(path(.${2}); \$value)" "${1}.json" )
  echo "${jsonTmp}" > "${1}.json"
  set -x
}

setpath_json() {
  local jsonTmp
  { set +x; } 2>/dev/null
  jsonTmp=$( jq --argjson 'value' "${3}" "setpath(path(.${2}); \$value)" "${1}.json" )
  echo "${jsonTmp}" > "${1}.json"
  set -x
}

# Configure product.json with AgentStacks branding
setpath "product" "checksumFailMoreInfoUrl" "https://www.agentstacks.io/docs/checksum"
setpath "product" "documentationUrl" "https://www.agentstacks.io/docs"
setpath_json "product" "extensionsGallery" '{"serviceUrl": "https://open-vsx.org/vscode/gallery", "itemUrl": "https://open-vsx.org/vscode/item", "latestUrlTemplate": "https://open-vsx.org/vscode/gallery/{publisher}/{name}/latest", "controlUrl": "https://raw.githubusercontent.com/EclipseFdn/publish-extensions/refs/heads/master/extension-control/extensions.json"}'

setpath "product" "introductoryVideosUrl" "https://www.agentstacks.io/videos"
setpath "product" "keyboardShortcutsUrlLinux" "https://www.agentstacks.io/docs/shortcuts/linux"
setpath "product" "keyboardShortcutsUrlMac" "https://www.agentstacks.io/docs/shortcuts/mac"
setpath "product" "keyboardShortcutsUrlWin" "https://www.agentstacks.io/docs/shortcuts/windows"
setpath "product" "licenseUrl" "https://github.com/AgentStacks-io/vscode/blob/master/LICENSE"
setpath_json "product" "linkProtectionTrustedDomains" '["https://open-vsx.org", "https://www.agentstacks.io"]'
setpath "product" "releaseNotesUrl" "https://www.agentstacks.io/releases"
setpath "product" "reportIssueUrl" "https://github.com/AgentStacks-io/vscode/issues/new"
setpath "product" "requestFeatureUrl" "https://github.com/AgentStacks-io/vscode/discussions"
setpath "product" "tipsAndTricksUrl" "https://www.agentstacks.io/docs/tips"
setpath "product" "twitterUrl" "https://twitter.com/agentstacks"

if [[ "${DISABLE_UPDATE}" != "yes" ]]; then
  setpath "product" "updateUrl" "https://raw.githubusercontent.com/AgentStacks-io/versions/refs/heads/master"

  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    setpath "product" "downloadUrl" "https://github.com/AgentStacks-io/vscode/releases"
  else
    setpath "product" "downloadUrl" "https://github.com/AgentStacks-io/vscode/releases"
  fi
fi

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  setpath "product" "nameShort" "AgentStacks - Insiders"
  setpath "product" "nameLong" "AgentStacks - Insiders"
  setpath "product" "applicationName" "agentstacks-insiders"
  setpath "product" "dataFolderName" ".agentstacks-insiders"
  setpath "product" "linuxIconName" "agentstacks-insiders"
  setpath "product" "quality" "insider"
  setpath "product" "urlProtocol" "agentstacks-insiders"
  setpath "product" "serverApplicationName" "agentstacks-server-insiders"
  setpath "product" "serverDataFolderName" ".agentstacks-server-insiders"
  setpath "product" "darwinBundleIdentifier" "io.agentstacks.AgentStacksInsiders"
  setpath "product" "win32AppUserModelId" "AgentStacks.AgentStacksInsiders"
  setpath "product" "win32DirName" "AgentStacks Insiders"
  setpath "product" "win32MutexName" "agentstacksinsiders"
  setpath "product" "win32NameVersion" "AgentStacks Insiders"
  setpath "product" "win32RegValueName" "AgentStacksInsiders"
  setpath "product" "win32ShellNameShort" "AgentStacks Insiders"
  setpath "product" "win32AppId" "{{EF35BB36-FA7E-4BB9-B7DA-D1E09F2DA9C9}"
  setpath "product" "win32x64AppId" "{{B2E0DDB2-120E-4D34-9F7E-8C688FF839A2}"
  setpath "product" "win32arm64AppId" "{{44721278-64C6-4513-BC45-D48E07830599}"
  setpath "product" "win32UserAppId" "{{ED2E5618-3E7E-4888-BF3C-A6CCC84F586F}"
  setpath "product" "win32x64UserAppId" "{{20F79D0D-A9AC-4220-9A81-CE675FFB6B41}"
  setpath "product" "win32arm64UserAppId" "{{2E362F92-14EA-455A-9ABD-3E656BBBFE71}"
  setpath "product" "tunnelApplicationName" "agentstacks-insiders-tunnel"
  setpath "product" "win32TunnelServiceMutex" "agentstacksinsiders-tunnelservice"
  setpath "product" "win32TunnelMutex" "agentstacksinsiders-tunnel"
  setpath "product" "win32ContextMenu.x64.clsid" "90AAD229-85FD-43A3-B82D-8598A88829CF"
  setpath "product" "win32ContextMenu.arm64.clsid" "7544C31C-BDBF-4DDF-B15E-F73A46D6723D"
else
  setpath "product" "nameShort" "AgentStacks"
  setpath "product" "nameLong" "AgentStacks"
  setpath "product" "applicationName" "agentstacks"
  setpath "product" "linuxIconName" "agentstacks"
  setpath "product" "quality" "stable"
  setpath "product" "urlProtocol" "agentstacks"
  setpath "product" "serverApplicationName" "agentstacks-server"
  setpath "product" "serverDataFolderName" ".agentstacks-server"
  setpath "product" "darwinBundleIdentifier" "io.agentstacks"
  setpath "product" "win32AppUserModelId" "AgentStacks.AgentStacks"
  setpath "product" "win32DirName" "AgentStacks"
  setpath "product" "win32MutexName" "agentstacks"
  setpath "product" "win32NameVersion" "AgentStacks"
  setpath "product" "win32RegValueName" "AgentStacks"
  setpath "product" "win32ShellNameShort" "AgentStacks"
  setpath "product" "win32AppId" "{{763CBF88-25C6-4B10-952F-326AE657F16B}"
  setpath "product" "win32x64AppId" "{{88DA3577-054F-4CA1-8122-7D820494CFFB}"
  setpath "product" "win32arm64AppId" "{{67DEE444-3D04-4258-B92A-BC1F0FF2CAE4}"
  setpath "product" "win32UserAppId" "{{0FD05EB4-651E-4E78-A062-515204B47A3A}"
  setpath "product" "win32x64UserAppId" "{{2E1F05D1-C245-4562-81EE-28188DB6FD17}"
  setpath "product" "win32arm64UserAppId" "{{57FD70A5-1B8D-4875-9F40-C5553F094828}"
  setpath "product" "tunnelApplicationName" "agentstacks-tunnel"
  setpath "product" "win32TunnelServiceMutex" "agentstacks-tunnelservice"
  setpath "product" "win32TunnelMutex" "agentstacks-tunnel"
  setpath "product" "win32ContextMenu.x64.clsid" "D910D5E6-B277-4F4A-BDC5-759A34EEE25D"
  setpath "product" "win32ContextMenu.arm64.clsid" "4852FC55-4A84-4EA1-9C86-D53BE3DF83C0"
fi

setpath_json "product" "tunnelApplicationConfig" '{}'

# Merge with our custom product.json if it exists
if [[ -f "../product.json" ]]; then
  jsonTmp=$( jq -s '.[0] * .[1]' product.json ../product.json )
  echo "${jsonTmp}" > product.json && unset jsonTmp
fi

cat product.json
# }}}

# include common functions
. ../utils.sh

# {{{ apply patches

echo "APP_NAME=\"${APP_NAME}\""
echo "APP_NAME_LC=\"${APP_NAME_LC}\""
echo "BINARY_NAME=\"${BINARY_NAME}\""
echo "GH_REPO_PATH=\"${GH_REPO_PATH}\""
echo "ORG_NAME=\"${ORG_NAME}\""
echo "TUNNEL_APP_NAME=\"${TUNNEL_APP_NAME}\""

if [[ "${DISABLE_UPDATE}" == "yes" ]]; then
  if [[ -f "../patches/disable-update.patch.yet" ]]; then
    mv ../patches/disable-update.patch.yet ../patches/disable-update.patch
  fi
fi

# Apply core patches
for file in ../patches/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done

# Apply insider-specific patches
if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  for file in ../patches/insider/*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

# Apply OS-specific patches
if [[ -d "../patches/${OS_NAME}/" ]]; then
  for file in "../patches/${OS_NAME}/"*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}"
    fi
  done
fi

# Apply user-specific patches
for file in ../patches/user/*.patch; do
  if [[ -f "${file}" ]]; then
    apply_patch "${file}"
  fi
done
# }}}

set -x

# {{{ install dependencies
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

if [[ "${OS_NAME}" == "linux" ]]; then
  export VSCODE_SKIP_NODE_VERSION_CHECK=1

   if [[ "${npm_config_arch}" == "arm" ]]; then
    export npm_config_arm_version=7
  fi
elif [[ "${OS_NAME}" == "windows" ]]; then
  if [[ "${npm_config_arch}" == "arm" ]]; then
    export npm_config_arm_version=7
  fi
else
  if [[ "${CI_BUILD}" != "no" ]]; then
    clang++ --version
  fi
fi

mv .npmrc .npmrc.bak
cp ../npmrc .npmrc

for i in {1..5}; do # try 5 times
  if [[ "${CI_BUILD}" != "no" && "${OS_NAME}" == "osx" ]]; then
    CXX=clang++ npm ci --legacy-peer-deps && break
  else
    npm ci --legacy-peer-deps && break
  fi

  if [[ $i == 5 ]]; then
    echo "Npm install failed too many times" >&2
    exit 1
  fi
  echo "Npm install failed $i, trying again..."

  sleep $(( 15 * (i + 1)))
done

mv .npmrc.bak .npmrc
# }}}

# package.json
cp package.json{,.bak}

setpath "package" "version" "${RELEASE_VERSION%-insider}"

replace 's|Microsoft Corporation|AgentStacks|' package.json

cp resources/server/manifest.json{,.bak}

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  setpath "resources/server/manifest" "name" "AgentStacks - Insiders"
  setpath "resources/server/manifest" "short_name" "AgentStacks - Insiders"
else
  setpath "resources/server/manifest" "name" "AgentStacks"
  setpath "resources/server/manifest" "short_name" "AgentStacks"
fi

replace 's|Microsoft Corporation|AgentStacks|' build/lib/electron.js
replace 's|Microsoft Corporation|AgentStacks|' build/lib/electron.ts
replace 's|([0-9]) Microsoft|\1 AgentStacks|' build/lib/electron.js
replace 's|([0-9]) Microsoft|\1 AgentStacks|' build/lib/electron.ts

if [[ "${OS_NAME}" == "linux" ]]; then
  # microsoft adds their apt repo to sources
  # unless the app name is code-oss
  # as we are renaming the application to agentstacks
  # we need to edit a line in the post install template
  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    sed -i "s/code-oss/agentstacks-insiders/" resources/linux/debian/postinst.template
  else
    sed -i "s/code-oss/agentstacks/" resources/linux/debian/postinst.template
  fi

  # fix the packages metadata
  # code.appdata.xml
  sed -i 's|Visual Studio Code|AgentStacks|g' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://www.agentstacks.io/docs/installation|' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com/home/home-screenshot-linux-lg.png|https://www.agentstacks.io/img/agentstacks.png|' resources/linux/code.appdata.xml
  sed -i 's|https://code.visualstudio.com|https://www.agentstacks.io|' resources/linux/code.appdata.xml

  # control.template
  sed -i 's|Microsoft Corporation <vscode-linux@microsoft.com>|AgentStacks Team https://github.com/AgentStacks-io|'  resources/linux/debian/control.template
  sed -i 's|Visual Studio Code|AgentStacks|g' resources/linux/debian/control.template
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://www.agentstacks.io/docs/installation|' resources/linux/debian/control.template
  sed -i 's|https://code.visualstudio.com|https://www.agentstacks.io|' resources/linux/debian/control.template

  # code.spec.template
  sed -i 's|Microsoft Corporation|AgentStacks Team|' resources/linux/rpm/code.spec.template
  sed -i 's|Visual Studio Code Team <vscode-linux@microsoft.com>|AgentStacks Team https://github.com/AgentStacks-io|' resources/linux/rpm/code.spec.template
  sed -i 's|Visual Studio Code|AgentStacks|' resources/linux/rpm/code.spec.template
  sed -i 's|https://code.visualstudio.com/docs/setup/linux|https://www.agentstacks.io/docs/installation|' resources/linux/rpm/code.spec.template
  sed -i 's|https://code.visualstudio.com|https://www.agentstacks.io|' resources/linux/rpm/code.spec.template

  # snapcraft.yaml
  sed -i 's|Visual Studio Code|AgentStacks|'  resources/linux/rpm/code.spec.template
elif [[ "${OS_NAME}" == "windows" ]]; then
  # code.iss
  sed -i 's|https://code.visualstudio.com|https://www.agentstacks.io|' build/win32/code.iss
  sed -i 's|Microsoft Corporation|AgentStacks|' build/win32/code.iss
fi

cd ..
