import api from "api";

export namespace MixpanelService {
  export const mixpanelApiDocPath = "@mixpaneldevdocs/v3.26#9ex4re2zlo8xss8z";
  export const mixpanelApi = api(mixpanelApiDocPath);

  // export async function fetchMixpanelData(event: string, fromDate: string, toDate: string, filters?: { [key: string]: string }) {
  //     const mixpanelApiSecret = process.env.MIXPANEL_API_SECRET;
  //     const mixpanelProjectId = process.env.MIXPANEL_PROJECT_ID;
  //     if (!mixpanelApiSecret || !mixpanelProjectId) {
  //         throw new Error(`No Mixpanel API secret specified`);
  //     }

  //     // mixpanelApi.auth(`Basic ${Buffer.from(mixpanelApiSecret).toString('base64')}`);

  //     // TODO: Add these analytics closer to launch, we can most in the DB for now to emulate.
  //     return {};
  // }
}
