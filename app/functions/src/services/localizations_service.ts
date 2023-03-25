import * as functions from "firebase-functions";
import i18next from "i18next";
import { enTranslations } from "../locales/en";

export namespace LocalizationsService {
  let isLocalizationsServiceInitialized = false;

  /**
   * Verifies that the localizations service is initialized.
   */
  export async function verifyInitialized(): Promise<void> {
    functions.logger.info("Verifying localizations service is initialized");
    if (isLocalizationsServiceInitialized) {
      functions.logger.info("Localizations service is already initialized");
      return;
    }

    await i18next.init({
      lng: "en",
      compatibilityJSON: "v3",
      resources: {
        en: {
          translation: enTranslations,
        },
      },
    });

    isLocalizationsServiceInitialized = true;
  }

  /**
   * Changes the language of the localizations service to the language of the user profile.
   * @param {any} userProfile The user profile to change the language to.
   */
  export async function changeLanguageToProfile(
    userProfile: any
  ): Promise<void> {
    functions.logger.info(
      `Changing language to profile: ${userProfile.language}`
    );

    await verifyInitialized();

    //* Default to English if no language is set.
    let locale = userProfile.language;
    if (!locale) {
      locale = "en";
    }

    await i18next.changeLanguage(locale);
  }

  /**
   * Gets a localized string for the given key.
   * @param {string} key The key of the localized string to get.
   * @param {any} args The arguments to pass to the localized string.
   */
  export async function getLocalizedString(key: string, args = {}): Promise<string> {
    functions.logger.info(`Getting localized string for key: ${key}`);

    await verifyInitialized();
    const translation = i18next.t(key, args);

    functions.logger.info(
      `Localized string for key: ${key} is: ${translation}`
    );

    return translation;
  }
}
