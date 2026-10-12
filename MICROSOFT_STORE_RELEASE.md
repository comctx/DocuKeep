# DocuKeep — Microsoft Store release preparation

Target price: **US $4.99, one-time purchase** (select the closest available $4.99 tier in Partner Center).
Target category: Productivity.
Distribution: Windows 10/11 app via a packaged Progressive Web App (PWA), pending final suitability/testing review.

## Source verified (October 12, 2026)
- Root web app: `index.html`
- PWA manifest: `manifest.webmanifest`
- Offline service worker: `sw.js`
- App icons: `icons/icon-192.png`, `icons/icon-512.png`
- The root `index.html` now links the manifest and registers the existing service worker over HTTPS.
- The separate native iOS project in `DocuKeep/` has not been modified.

## Store listing draft
**Name:** DocuKeep

**Short description:** Keep important documents organized in a PIN-protected vault on your device.

**Description:**
DocuKeep helps you keep important documents together and easy to find. Add pages from your camera or import photos and PDF files, organize documents, search your collection, and export multi-page PDFs when needed. A PIN protects the local document vault, and encrypted backups provide a way to preserve or move your files.

**Feature highlights:**
- PIN-protected local document vault
- Document photographs and file/PDF import
- Multi-page documents with editing and page controls
- Search and document organization
- PDF export
- Encrypted backup and restore

Do not claim the application has undergone an independent security audit. Do not claim biometric PIN recovery on Windows; Face ID is tied to the separate iOS native bridge.

## Required before submitting
1. Confirm the production HTTPS web URL is online and the updated `index.html` is deployed.
2. Open the production URL in desktop Microsoft Edge on Windows and verify the app installs as a PWA.
3. Open https://www.pwabuilder.com and analyze the production URL. Resolve any report-card errors.
4. Test the *Windows* version with **sample documents only**: create/unlock PIN, save/import PDF or image, scan with camera if present, export PDF, encrypted backup, restore, search, and offline reopen. Check permissions and closing/reopening the app.
5. Test whether Windows users are shown iPhone-only scanner or Face ID language; revise Windows-specific wording and affordances before release.
6. Confirm the account has the Windows & Xbox developer program, reserve the app name in Partner Center and copy the Package ID, Publisher ID, Publisher display name from Product identity.
7. Use PWABuilder's Windows `Generate Package` flow with those **exact** identity values, then download and test the package on Windows before uploading it.
8. In the Microsoft Store submission, select the $4.99 base price (or matching tier). Add descriptions, screenshots, app icons, categories, age rating, privacy-policy information as applicable, and the generated app package.
9. Check Microsoft Partner Center payout/tax status before submitting a *paid* app; current payment profile assignment has been unreliable and is not marked resolved.

## Important commercial consideration
A hosted PWA generally remains accessible through its regular website even when the Store listing costs $4.99. A Microsoft Store purchase price **does not automatically prevent visitors to the GitHub Pages URL from using DocuKeep for free**. Before selling, choose whether this is acceptable or whether to use a distribution/licensing architecture that restricts free use. **Do not assume the PWA package itself enforces a paid license inside the web application.**

## Privacy/security review
Documents are sensitive. Before publication, confirm the current code's local storage, encryption, backup, browser data-clearing behavior, third-party scripts (including PDF.js from a CDN), and privacy disclosures. Do not upload actual private documents in screenshots or test files.

## Useful official documentation
- Microsoft Store PWA process: https://learn.microsoft.com/en-us/microsoft-edge/progressive-web-apps/how-to/microsoft-store
- Microsoft PWA pricing: https://learn.microsoft.com/en-us/windows/apps/publish/publish-your-app/pwa/price-and-availability
- Windows packaging tool: https://www.pwabuilder.com
