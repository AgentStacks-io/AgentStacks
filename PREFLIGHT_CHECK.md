# Pre-Flight Check for Full Build

## ✅ Prerequisites Installed
- Node.js v24.10.0 ✓
- npm 11.6.0 ✓
- Git ✓
- jq ✓
- rsvg-convert ✓
- ImageMagick (convert) ✓
- libicns (icns2png, png2icns) ✓
- icoutils (icotool) ✓

## ✅ Icon Generation Complete
- macOS icons: 30 `.icns` files generated
- Linux icons: PNG, SVG, XPM generated
- Windows icons: 30+ `.ico` and `.bmp` files generated
- Server icons: favicon.ico, code-192.png, code-512.png
- Workbench media: code-icon.svg and letterpress variants

## ✅ Build Infrastructure Ready
- [`build-agentstacks.sh`](build-agentstacks.sh:1) - Main orchestrator
- [`build.sh`](build.sh:1) - Core build (with verbose output)
- [`get_repo.sh`](get_repo.sh:1) - VS Code source fetcher
- [`prepare_vscode.sh`](prepare_vscode.sh:1) - Branding preparation
- [`utils.sh`](utils.sh:1) - Common utilities
- [`version.sh`](version.sh:1) - Version configuration

## ✅ Branding Configuration
- App Name: AgentStacks
- Binary Name: agentstacks
- Organization: asio
- GitHub: AgentStacks-io
- Website: https://www.agentstacks.io

## ✅ Patches Ready
- [`patches/brand.patch`](patches/brand.patch:1) - VS Code → AgentStacks replacements
- Additional VSCodium patches available for features

## ⚠️ Before Running Full Build

### Expected Build Time
- **30-45 minutes** for initial build
- ~10GB disk space needed
- 8GB+ RAM recommended

### What Will Happen
1. VS Code source will be cloned from Microsoft (if not already present)
2. Branding patches will be applied
3. npm dependencies will be installed (~5-10 minutes)
4. TypeScript/JavaScript compilation (~20-30 minutes)
5. Platform-specific packaging
6. Output: `AgentStacks-darwin-arm64/` directory

### Commands Available

**Full Build (verbose)**:
```bash
./build-agentstacks.sh --verbose
```

**Or with explicit settings**:
```bash
export VERBOSE=yes
./build-agentstacks.sh
```

### During Build Watch For
- npm install progress
- Patch application messages
- Compilation warnings (some are normal)
- Error messages (build will stop if critical)

### If Build Asks for Password
This might happen for:
- Sudo operations (shouldn't need this)
- Keychain access (can usually skip)
- Just press Enter or type your password if prompted

## 🎯 Ready to Build!

The build script has `set -ex` enabled which means:
- `-e`: Exit immediately if any command fails
- `-x`: Print each command before executing (verbose!)

You'll see every command as it runs. The output will be detailed.

### Start Build Command:
```bash
./build-agentstacks.sh --verbose
```

### Or Standard (Still Shows Progress):
```bash
./build-agentstacks.sh
```

---

## What Comes After Build

Once build completes successfully:

1. **Test the Application**
   - Navigate to `AgentStacks-darwin-arm64/`
   - Open `AgentStacks.app`
   - Verify branding, icon, functionality

2. **Check Branding**
   - Application name in menu bar
   - About dialog
   - Icon in dock
   - Extension marketplace

3. **If Everything Works**
   - Commit the changes
   - Set up CI/CD for automated builds
   - Create release process

4. **If Issues Found**
   - Create patches to fix them
   - Put in `patches/user/`
   - Rebuild

---

Ready when you are!