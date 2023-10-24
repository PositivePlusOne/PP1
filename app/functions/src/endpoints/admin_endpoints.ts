import * as functions from 'firebase-functions';

import { SlackService } from '../services/slack_service';
import { FIREBASE_FUNCTION_INSTANCE_DATA } from '../constants/domain';

export namespace AdminEndpoints {
    export const performAdminAction = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onRequest(async (request, response) => {
        functions.logger.info("Performing admin action", { request });
        await SlackService.verifySigningSecret(request);

        const slackCommand = request.body.command;
        const slackText = request.body.text;
        const slackChannel = request.body.channel_name;

        const regex = /"([^"]+)"|(\S+)/g;
    
        const commandParts = [];
        let match;

        // Execute regex and push matches to the parts array
        while ((match = regex.exec(slackText))) {
            commandParts.push(match[1] ? match[1] : match[2]);
        }

        if (commandParts.length === 0) {
            await SlackService.postRawToChannel(slackChannel, "Please provide a command with valid arguments");
            response.status(200).send();
            return;
        }

        switch (slackCommand) {
            case '/create-profile':
                await SlackService.handleCreateProfileCommand(commandParts, slackChannel);
                break;
            default:
                await SlackService.postRawToChannel(slackChannel, `Unknown command: ${slackCommand}`);
                break;
        }

        response.status(200).send();
    });
}
