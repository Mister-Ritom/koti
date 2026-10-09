# Release Checklist

## Android (Google Play)
- [ ] Run `flutter build appbundle --release`
- [ ] Update `version` and `versionCode` in `pubspec.yaml`
- [ ] Verify Data Safety declarations (App does NOT collect or share data)
- [ ] Upload to Internal Testing track
- [ ] Ensure all 3 required screenshots match the new UI

## iOS (App Store)
- [ ] Run `flutter build ipa --release`
- [ ] Update `Runner` build version in Xcode
- [ ] Check Privacy Manifest (N/A for offline-only, but verify standard Apple tracking requirements)
- [ ] Upload via Transporter or Xcode to App Store Connect
- [ ] Submit for TestFlight review

## General QA
- [ ] Test fresh install empty state
- [ ] Test importing backup data
- [ ] Test adding Expense and Income
- [ ] Verify light/dark theme toggles correctly
