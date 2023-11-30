# Positive +1: Backend TypeScript Deployment to Production

## Deployment Overview
- **Deployment Date:** `30-11-2023`
- **Deployment Time:** `HH:MM`
- **Version:** `1.0.1`

## Pre-Deployment Checklist
- [x] Code review completed
- [x] Unit and integration tests passed
N/A for now as this will be covered in a hardening sprint.

- [x] Performance tests completed
N/A for now as this will be covered in a hardening sprint.

- [x] Security checks passed
Noted during investigation archiveChat needs some work. Tickets to be created and refined in the next deployments

- [x] Documentation updated

## Person Responsible
- **Name:** `Ryan Dixon`
- **Role:** `CTO`
- **Contact:** `ryan.dixon@positiveplusone.com`

## Backup Strategy
- **Backup Time:** `2023-11-30 22:57`
- **Backup Location:** `https://console.cloud.google.com/firestore/databases/-default-/import-export?authuser=1&hl=en&project=positiveplusone-production`
- [x] Verify backup integrity

## Manual DevOps Jobs
1. **Pre-Deployment Job**
   - Precheck of GetStream configuration [x]
   - Precheck of Firebase Extensions [x]
   - Precheck of Environment Variables [x]

2. **Deployment Job**

3. **Post-Deployment Verification**
   - Verification Checklist:
     - [ ] Application running without errors
     - [ ] API endpoints returning expected responses
     - [ ] Database connectivity confirmed
     - [ ] Redis connectivity confirmed

## Rollback Plan
- Handled via Google Cloud Console disaster recovery configuration

## Additional Notes

## Sign-off
- **Deployed By:** `_______________`
- **Date:** `_______________`
