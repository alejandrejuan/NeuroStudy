#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# export-screenshots.sh
# Extracts App Store screenshot attachments from the most recent NeuroStudy
# .xcresult bundle in Xcode's DerivedData and saves them as standalone PNGs.
#
# Usage:
#   ./export-screenshots.sh                    # auto-find latest .xcresult
#   ./export-screenshots.sh /path/to/test.xcresult  # use a specific bundle
#
# Output:  ~/Desktop/Screenshots/NeuroStudy/<SimulatorName>/
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

APP_NAME="NeuroStudy"
OUTPUT_ROOT="$HOME/Desktop/Screenshots/NeuroStudy"
DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"

# ── 1. Locate the .xcresult bundle ───────────────────────────────────────────

if [ "${1-}" != "" ]; then
    XCRESULT="$1"
    echo "📦 Using provided bundle:"
    echo "   $XCRESULT"
else
    echo "🔍 Searching DerivedData for most recent $APP_NAME test results..."
    XCRESULT=$(
        find "$DERIVED_DATA" \
             -maxdepth 6 \
             -type d \
             -name "*.xcresult" \
             -path "*${APP_NAME}*" \
             2>/dev/null \
        | while read -r p; do
              # emit modification-time + path so we can sort numerically
              echo "$(stat -f '%m' "$p") $p"
          done \
        | sort -n -r \
        | head -1 \
        | awk '{ $1=""; print }' \
        | sed 's/^ //'
    )

    if [ -z "$XCRESULT" ]; then
        echo ""
        echo "❌  No .xcresult bundle found for '$APP_NAME' in:"
        echo "    $DERIVED_DATA"
        echo ""
        echo "    Make sure you have run the ScreenshotTests target in Xcode"
        echo "    (Product ▶ Test, or ⌘U) before running this script."
        exit 1
    fi
    echo "✅ Found: $(basename "$XCRESULT")"
    echo "   $XCRESULT"
fi

echo ""

# ── 2. Read simulator / destination name from the result metadata ─────────────

echo "📱 Reading run destination..."
SIM_NAME=$(python3 - "$XCRESULT" <<'PYEOF'
import subprocess, json, sys

path = sys.argv[1]
raw = subprocess.run(
    ["xcrun", "xcresulttool", "get", "--format", "json", "--path", path],
    capture_output=True, text=True
).stdout

try:
    data = json.loads(raw)
    for action in data.get("actions", {}).get("_values", []):
        dest = action.get("runDestination", {})
        name = dest.get("displayName", {}).get("_value", "")
        if name:
            print(name)
            sys.exit(0)
except Exception:
    pass

print("UnknownSimulator")
PYEOF
)

echo "   Simulator: $SIM_NAME"
SIM_DIR="$OUTPUT_ROOT/$SIM_NAME"
mkdir -p "$SIM_DIR"

# ── 3. Walk the result JSON and export every keepAlways PNG attachment ─────────

echo ""
echo "📤 Extracting screenshots..."
echo ""

EXPORT_SUMMARY=$(python3 - "$XCRESULT" "$SIM_DIR" <<'PYEOF'
import subprocess, json, sys, os

XCRESULT = sys.argv[1]
SIM_DIR  = sys.argv[2]
exported = []
errors   = []

# ── Fetch the full result tree as JSON ────────────────────────────────────────
def xcresult_json(extra_args=None):
    cmd = ["xcrun", "xcresulttool", "get",
           "--format", "json",
           "--path", XCRESULT]
    if extra_args:
        cmd += extra_args
    r = subprocess.run(cmd, capture_output=True, text=True)
    try:
        return json.loads(r.stdout)
    except json.JSONDecodeError:
        return {}

# ── Export a single attachment payload to disk ────────────────────────────────
def export_payload(payload_id, dest_path):
    r = subprocess.run(
        ["xcrun", "xcresulttool", "get",
         "--path", XCRESULT,
         "--id",   payload_id],
        capture_output=True
    )
    if r.returncode == 0 and r.stdout:
        with open(dest_path, "wb") as f:
            f.write(r.stdout)
        return True
    return False

# ── Recursively walk the JSON tree to collect attachments ────────────────────
def walk(node, counter=[0]):
    if isinstance(node, dict):
        node_type = node.get("_type", {}).get("_name", "")

        if node_type == "ActionTestAttachment":
            name     = node.get("name",     {}).get("_value", f"screenshot_{counter[0]}")
            lifetime = node.get("lifetime", {}).get("_value", "")
            uti      = node.get("uniformTypeIdentifier", {}).get("_value", "")
            payload  = node.get("payloadRef", {}).get("id", {}).get("_value", "")

            # Only export PNG screenshots marked keepAlways
            is_png  = "png" in uti.lower() or "image" in uti.lower()
            is_keep = lifetime == "keepAlways"

            if payload and is_png and is_keep:
                safe_name = name.replace("/", "-").replace(" ", "_")
                if not safe_name.lower().endswith(".png"):
                    safe_name += ".png"
                dest = os.path.join(SIM_DIR, safe_name)
                if export_payload(payload, dest):
                    exported.append(safe_name)
                    counter[0] += 1
                else:
                    errors.append(f"Failed: {name} (id={payload})")

        for val in node.values():
            walk(val, counter)

    elif isinstance(node, list):
        for item in node:
            walk(item, counter)

root = xcresult_json()
walk(root)

# ── Print results ─────────────────────────────────────────────────────────────
for f in exported:
    print(f"  ✓  {f}")
for e in errors:
    print(f"  ✗  {e}")
print(f"EXPORTED:{len(exported)}")
print(f"ERRORS:{len(errors)}")
PYEOF
)

# ── 4. Print summary ──────────────────────────────────────────────────────────

FILE_LINES=$(echo "$EXPORT_SUMMARY" | grep -E "^  [✓✗]" || true)
N_EXPORTED=$(echo "$EXPORT_SUMMARY" | grep "^EXPORTED:" | cut -d: -f2)
N_ERRORS=$(echo  "$EXPORT_SUMMARY" | grep "^ERRORS:"   | cut -d: -f2)

echo "$FILE_LINES"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Bundle:      $(basename "$XCRESULT")"
echo "  Simulator:   $SIM_NAME"
echo "  Output:      $SIM_DIR"
echo "  Exported:    ${N_EXPORTED:-0} screenshot(s)"
if [ "${N_ERRORS:-0}" -gt 0 ]; then
echo "  Errors:      $N_ERRORS"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "${N_EXPORTED:-0}" -gt 0 ]; then
    echo ""
    echo "✅  Done!  Opening output folder..."
    open "$SIM_DIR"
else
    echo ""
    echo "⚠️   No screenshots were exported."
    echo ""
    echo "    Possible reasons:"
    echo "    • The test run failed before taking any screenshots"
    echo "    • The .xcresult is from a different test target"
    echo "    • xcresulttool could not read the payload IDs"
    echo ""
    echo "    Tip: You can inspect the bundle manually in Xcode:"
    echo "    Product ▶ Show Build Folder in Finder, then navigate to Logs/Test/"
fi
