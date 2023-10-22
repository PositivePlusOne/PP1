import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { FlMetaJSON } from '../../dto/meta';

export namespace UnlinkDirectoryEntryAction {
    export async function unlinkDirectoryEntry(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'sourceProfile') || {};
        const directoryEntryData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'directoryEntries');
        
        if (!sourceProfileData || !directoryEntryData) {
            AdminQuickActionService.appendOutput(action, `No source profile or directory entry specified.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }
        
        const directoryEntryReference = directoryEntryData?.directoryEntries![0];
        const sourceReference = sourceProfileData.profiles![0];
        const [sourceProfileSnapshot, directoryEntrySnapshot] = await Promise.all([
            sourceReference.get(),
            directoryEntryReference.get(),
        ]);

        const sourceProfile = sourceProfileSnapshot.data();
        const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);

        const directoryEntry = directoryEntrySnapshot.data();
        const directoryEntryId = FlamelinkHelpers.getFlamelinkIdFromObject(directoryEntry);

        if (!sourceProfileId || !sourceProfile || !directoryEntryId || !directoryEntry) {
            AdminQuickActionService.appendOutput(action, `No source profile or directory entry found.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const profileMeta = sourceProfile._fl_meta_ as FlMetaJSON || {} as FlMetaJSON;
        const directoryEntryMeta = directoryEntry._fl_meta_ as FlMetaJSON || {} as FlMetaJSON;

        profileMeta.directoryEntryId = '';
        directoryEntryMeta.ownedBy = '';
        directoryEntryMeta.ownedAsOfDate = '';

        await Promise.all([
            sourceReference.update({ _fl_meta_: profileMeta }),
            directoryEntryReference.update({ _fl_meta_: directoryEntryMeta }),
        ]);

        AdminQuickActionService.appendOutput(action, `Successfully unlinked the directory entry ${directoryEntryId} from the profile ${sourceProfileId}.`);
        AdminQuickActionService.updateStatus(action, 'success');
    }
}