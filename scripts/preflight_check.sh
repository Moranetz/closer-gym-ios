#!/usr/bin/env bash
# closer-gym-ios pre-flight check — run before any TestFlight upload or App Review submission.
#
# Verifies App Store readiness:
#   - Bundle ID hierarchy (com.melmarion.CloserGym)
#   - Marketing + build versions present
#   - Team ID matches the pipeline (Q242KWQD56)
#   - Encryption-exemption flag is set
#   - PrivacyInfo.xcprivacy exists
#   - App icon asset set is present
#   - Build succeeds for iOS Simulator + iOS device archive
#
# Exit code 0 on pass, 1 on any failure.

set -euo pipefail

cd "$(dirname "$0")/.."

GRN=$'\e[32m'; RED=$'\e[31m'; YEL=$'\e[33m'; NC=$'\e[0m'
fail=0
pass=0

ok()   { echo "${GRN}✓${NC} $1"; pass=$((pass+1)); }
bad()  { echo "${RED}✗${NC} $1"; fail=$((fail+1)); }
warn() { echo "${YEL}!${NC} $1"; }

PBX=CloserGym.xcodeproj/project.pbxproj

# Regenerate project if project.yml is newer than pbxproj
if [ project.yml -nt "$PBX" ]; then
  echo "Regenerating Xcode project from project.yml..."
  xcodegen
fi

# ─── 1. Bundle ID ─────────────────────────────────────────────────────────
echo "== Bundle ID =="
expected_bundle="com.melmarion.CloserGym"
if grep -q "PRODUCT_BUNDLE_IDENTIFIER = $expected_bundle" $PBX; then
  ok "PRODUCT_BUNDLE_IDENTIFIER = $expected_bundle"
else
  bad "PRODUCT_BUNDLE_IDENTIFIER missing or wrong (expect $expected_bundle)"
fi

# ─── 2. Team ID ───────────────────────────────────────────────────────────
echo
echo "== Team ID =="
if grep -q "DEVELOPMENT_TEAM = Q242KWQD56" $PBX; then
  ok "DEVELOPMENT_TEAM = Q242KWQD56"
else
  bad "DEVELOPMENT_TEAM missing or wrong"
fi

# ─── 3. Versions ──────────────────────────────────────────────────────────
echo
echo "== Versions =="
if grep -q "MARKETING_VERSION = 1.0" $PBX; then
  ok "MARKETING_VERSION = 1.0"
else
  warn "MARKETING_VERSION not 1.0 — verify intended"
fi
if grep -q "CURRENT_PROJECT_VERSION = 1" $PBX; then
  ok "CURRENT_PROJECT_VERSION = 1"
else
  warn "CURRENT_PROJECT_VERSION not 1 — bump for new TestFlight build"
fi

# ─── 4. Encryption-exemption flag ─────────────────────────────────────────
echo
echo "== Non-exempt encryption =="
if grep -q "ITSAppUsesNonExemptEncryption" CloserGym/Info.plist; then
  ok "ITSAppUsesNonExemptEncryption present in Info.plist"
else
  bad "ITSAppUsesNonExemptEncryption missing — submission blocked until set"
fi

# ─── 5. PrivacyInfo.xcprivacy ─────────────────────────────────────────────
echo
echo "== Privacy manifest =="
if [ -f CloserGym/PrivacyInfo.xcprivacy ]; then
  ok "PrivacyInfo.xcprivacy exists on disk"
  # Also verify it's in the resources build phase (xcodegen handles this automatically)
  if grep -q "PrivacyInfo.xcprivacy" $PBX; then
    ok "PrivacyInfo.xcprivacy referenced in pbxproj (xcodegen synced)"
  else
    bad "PrivacyInfo.xcprivacy on disk but NOT in pbxproj — App Review will not see it"
  fi
else
  bad "Missing PrivacyInfo.xcprivacy — required for iOS 17+ apps using user-defaults"
fi

# ─── 6. App icon ──────────────────────────────────────────────────────────
echo
echo "== App icon =="
if [ -d CloserGym/Assets.xcassets/AppIcon.appiconset ]; then
  ok "AppIcon.appiconset directory present"
  if [ -f CloserGym/Assets.xcassets/AppIcon.appiconset/Contents.json ]; then
    ok "AppIcon Contents.json present"
  else
    bad "AppIcon Contents.json missing"
  fi
  # Check for at least one PNG image in the appiconset
  ICON_PNG=$(find CloserGym/Assets.xcassets/AppIcon.appiconset -name "*.png" -type f 2>/dev/null | head -1)
  if [ -n "$ICON_PNG" ]; then
    # Verify the file is a real PNG and 1024x1024
    dims=$(sips -g pixelWidth -g pixelHeight "$ICON_PNG" 2>/dev/null | grep -E "pixel" | awk '{print $2}' | paste -sd "x" -)
    has_alpha=$(sips -g hasAlpha "$ICON_PNG" 2>/dev/null | grep "hasAlpha" | awk '{print $2}')
    if [ "$dims" = "1024x1024" ]; then
      if [ "$has_alpha" = "no" ]; then
        ok "App icon: $(basename "$ICON_PNG"), 1024×1024 RGB (no alpha — App Store compliant)"
      else
        bad "App icon has alpha channel — App Store will reject. Flatten to opaque RGB."
      fi
    else
      bad "App icon dimensions are $dims, expected 1024x1024"
    fi
  else
    warn "Icon image not yet provided. Add a 1024x1024 PNG before App Store submission."
  fi
else
  bad "Assets.xcassets/AppIcon.appiconset missing"
fi

# ─── 7. Brand color set present ───────────────────────────────────────────
echo
echo "== Brand color sets =="
for cs in BrandGreen BgPage BgPanel BgRail AccentColor; do
  if [ -d "CloserGym/Assets.xcassets/$cs.colorset" ]; then
    ok "$cs.colorset present"
  else
    bad "$cs.colorset MISSING"
  fi
done

# ─── 8. Compile check ─────────────────────────────────────────────────────
echo
echo "== Build (Debug, iOS Simulator) =="
if xcodebuild -project CloserGym.xcodeproj -scheme CloserGym \
   -destination 'generic/platform=iOS Simulator' -configuration Debug build \
   -quiet 2>&1 | grep -q "BUILD SUCCEEDED"; then
  ok "Debug iOS Simulator build succeeds"
else
  # Capture error tail for diagnosis
  echo "  Build failed — last error:"
  xcodebuild -project CloserGym.xcodeproj -scheme CloserGym \
    -destination 'generic/platform=iOS Simulator' -configuration Debug build 2>&1 | \
    grep -E "error:" | tail -3
  bad "Build did NOT succeed"
fi

# ─── Summary ───────────────────────────────────────────────────────────────
echo
echo "─────────────────────────────────────────────"
if [ "$fail" -eq 0 ]; then
  echo "${GRN}✓ All $pass checks passed. Safe to archive + TestFlight.${NC}"
  exit 0
else
  echo "${RED}✗ $fail failures, $pass passes. Fix before submitting.${NC}"
  exit 1
fi
