# Positive +1: Backend TypeScript Deployment to Production

## Deployment Overview
- **Deployment Date:** `2024-01-24`
- **Deployment Time:** `16:50`
- **Version:** `3.40`

## Pre-Deployment Checklist
- [x] Code review completed
- [?] Unit and integration tests passed
- [?] Performance tests completed
- [x] Security checks passed
- [x] Documentation updated

## Person Responsible
- **Name:** `Dev and QA Team`
- **Contact:** `support@positiveplusone.com`

## Backup Strategy
- **Backup Time:** `19 Jan 2024, 17:21:24`
- **Backup Location:** `positiveplusone-production.appspot.com/backups`
- [x] Verify backup integrity

## Manual DevOps Jobs
1. **Pre-Deployment Job**
   - Precheck of GetStream configuration [x]
   - Precheck of Firebase Extensions [x]
   - Precheck of Environment Variables [x]
   - Precheck of running local Firebase environment [x]
   - Flamelink CMS schemas updated [x]

2. **Deployment Job**
   - Deployment started at 17:33 on the 19th of January, 2024

3. **Post-Deployment Verification**
   - Description: _Steps to verify successful deployment_
   - Verification Checklist:
     - [x] Application running without errors
     - [x] API endpoints returning expected responses
     - [x] Database connectivity confirmed
     - [x] Redis connectivity confirmed

## Rollback Plan
- **Rollback Trigger:**
   - On application failing smoke test
- **Rollback Steps:**
   - Redeployment of previous tag and schema drop on flamelink.

## Additional Notes
- Point in time disaster recovery enabled for production environment
- Secrets compared against staging
- DB Index validity checked
- Error shown on Flamelink production UI with schema payment allowance? vanished on reload

## Sign-off
- **Deployed By:** `Ryan Dixon`
