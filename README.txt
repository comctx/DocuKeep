DocuKeep v13 - Complete Upgrade Package

UPLOAD ALL OF THESE ITEMS TO THE ROOT OF THE DOCUKEEP GITHUB REPOSITORY:

index.html
manifest.webmanifest
sw.js
icons/
  icon-180.png
  icon-192.png
  icon-512.png

IMPORTANT
- The installable-app features work from the HTTPS GitHub Pages address.
- Opening index.html directly from Windows is only a preview and cannot fully install the PWA.
- Existing DocuKeep browser data remains in IndexedDB for the same GitHub Pages origin.

NEW IN v13
1. One-tap Scan Clean Up while adding pages
   - gentle document contrast/brightness cleanup
   - cautious automatic edge trimming when a clear document boundary is detected
   - Undo button before saving
2. Change PIN
   - verifies current PIN
   - safely re-encrypts the entire live vault with the new PIN
   - all-or-nothing IndexedDB transaction
3. Backup Reminder
   - appears only when documents exist and no recent encrypted backup is recorded
   - hides after a successful backup
4. First-Run Walkthrough
   - 3 short screens: Add, Vault, Backup
   - shown once for a new empty vault
   - existing users with documents are not interrupted

INCLUDED FROM v12
- Installable PWA
- app icon and splash screen
- real multi-page PDF generation
- actual PDF file sharing where supported
- PDF download fallback

SECURITY / RELIABILITY FEATURES RETAINED
- AES-GCM encrypted document records
- PIN-derived key
- safe backup/restore verification
- crash-safe pending writes
- duplicate-page detection
- thumbnail cache
- automatic/background locking
- failed-PIN slowdown
- storage monitoring/persistence request
- trash/restore
- edit/rotate/reorder/delete individual pages
