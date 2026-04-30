# NeuroStudy — Project Structure

This is the canonical home for the NeuroStudy iOS/iPadOS app.

**Project location:** `~/Developer/NeuroStudy/`

---

## Folder Layout

```
NeuroStudy/
├── NeuroStudy.xcodeproj/       # Xcode project
├── Package.swift               # Swift Package Manager manifest
├── project.yml                 # XcodeGen project definition
├── Shared/                     # Shared app source code
├── NeuroStudyUITests/          # UI test targets
├── Legal/                      # Legal documents
├── docs/                       # Project documentation
│
├── scripts/
│   └── export-screenshots.sh   # Automates App Store screenshot capture
│
├── Builds/
│   ├── NeuroStudy.xcarchive    # Latest Xcode archive (regenerated via Product > Archive)
│   └── Export/                 # IPA export and distribution files
│       ├── NeuroStudy.ipa
│       ├── ExportOptions.plist
│       ├── DistributionSummary.plist
│       └── Packaging.log
│
└── AppStore-Assets/
    ├── AppStore-iPad-01.JPEG   # Final App Store screenshots (ready to upload)
    ├── AppStore-iPad-02.JPEG
    ├── AppStore-iPad-03.JPEG
    ├── AppStore-iPhone-01.PNG
    ├── AppStore-iPhone-02.PNG
    ├── AppStore-iPhone-03.PNG
    └── RawScreenshots/         # Raw simulator captures (xcresult bundles + device folders)
        ├── iPhone16ProMax/
        ├── iPhone16ProMax.xcresult
        ├── iPadPro11/
        ├── iPadPro11.xcresult
        ├── iPadPro13/
        ├── iPadPro13.xcresult
        └── UnknownSimulator/
```

---

## Notes for Claude / Cowork Sessions

- **Always open this project from** `~/Developer/NeuroStudy/`
- **Never save project files to the Desktop** — the Desktop is for temporary scratch only
- New builds go in `Builds/`, new screenshots go in `AppStore-Assets/`
- Run `scripts/export-screenshots.sh` to regenerate simulator screenshots
