DOCUKEEP — iOS / TESTFLIGHT BUILD v1

App name: DocuKeep
Bundle ID: com.donaldreckman.docukeep
Version: 1.0.0
Minimum iOS: 15.0

WHAT THIS PACKAGE IS
This repository package contains BOTH:
1. The existing DocuKeep v13 web/PWA files at the repository root (so GitHub Pages can stay live).
2. A native iPhone/iPad Xcode project for CodeMagic/TestFlight.

NATIVE iOS IMPROVEMENTS
- Bundles DocuKeep inside the iPhone app instead of depending on the GitHub Pages site.
- Native iOS share sheet for generated PDFs and encrypted .docukeep backup files.
- Camera permission description for photographing documents.
- Photo-library permission description for choosing document photos.
- Native launch screen and App Store icon set.
- Privacy cover when the app goes into the background/app switcher.
- JavaScript alert/confirm/PIN prompt support in WKWebView.
- Existing encrypted IndexedDB storage remains local inside the app's WKWebView data store.
- Web-only “Install DocuKeep” card and service worker are removed from the native copy.

CODEMAGIC
The included codemagic.yaml is set up for:
- App Store distribution signing
- Bundle ID com.donaldreckman.docukeep
- automatic build-number increment from CodeMagic BUILD_NUMBER
- IPA build
- automatic TestFlight upload

IMPORTANT BEFORE THE FIRST SUCCESSFUL TESTFLIGHT BUILD
1. Apple Developer/App Store Connect must have the bundle identifier com.donaldreckman.docukeep available.
2. Create the DocuKeep app record in App Store Connect using that exact bundle ID.
3. In CodeMagic, connect the same App Store Connect API integration used for your other iOS apps.
4. The codemagic.yaml assumes that integration is named “Codemagic”. If your integration has a different name, choose/rename it in CodeMagic or change that one line.

TEST FIRST
Use harmless sample documents in the first TestFlight build. Confirm:
- Create/unlock PIN
- Add document by camera
- Choose document from Photos
- Search/open/edit/rotate/reorder pages
- Save and share PDF
- Export and restore encrypted backup
- Change PIN
- Background lock/privacy cover

SECURITY NOTE
This is a meaningful native wrapper around the encrypted DocuKeep web application, but it has not undergone an independent security audit. Do not market it as audited or guaranteed secure.
