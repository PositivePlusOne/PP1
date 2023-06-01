import * as functions from "firebase-functions";
import { t, changeLanguage, init } from "i18next";

import { enTranslations } from "../locales/en";
import { HivStatusDto } from "../dto/hiv_status_dto";
import { GenderListDto } from "../dto/gender_list_dto";

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

    await init({
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
   * Gets the default interests for the given locale.
   * @param {string} locale The locale to get the default interests for.
   * @return {Map<string, string>} The default interests for the given locale.
   */
  export async function getDefaultInterests(locale: string): Promise<Map<string, string>> {
    functions.logger.info(`Getting default interests for locale: ${locale}`);

    await verifyInitialized();

    const interestsObject = t("interests", { returnObjects: true });
    const interestsMap = new Map<string, string>(Object.entries(interestsObject));

    functions.logger.info(`Default interests for locale: ${locale} are: ${JSON.stringify(interestsMap)}`);

    return interestsMap;
  }

  /**
   * Gets the default genders for the given locale.
   * @param {string} locale The locale to get the default genders for.
   * @return {Map<string, string>} The default genders for the given locale.
   */
  export async function getDefaultGenders(locale: string): Promise<GenderListDto> {
    functions.logger.info(`Getting default interests for locale: ${locale}`);

    await verifyInitialized();

    const genders = t("genders", { returnObjects: true });

    functions.logger.info(`Default genders for locale: ${locale} are: ${JSON.stringify(genders)}`);

    return Object.entries(genders).map(([value, label]) => ({
      value: value,
      label: label,
    }));
  }

  /**
   * Gets the default hiv statuses for the given locale.
   * @param {string} locale The locale to get the default hiv statuses for.
   * @return {HivStatusDto} The default hiv statuses for the given locale.
   */
  export async function getDefaultHivStatuses(locale: string): Promise<HivStatusDto[]> {
    functions.logger.info(`Getting default interests for locale: ${locale}`);

    await verifyInitialized();

    const hivStatus = t("hivStatus", { returnObjects: true });

    functions.logger.info(`Default hivStatus for locale: ${locale} are: ${JSON.stringify(hivStatus)}`);

    return Object.entries(hivStatus).map(([key, value]) => ({
      value: key,
      label: value.label,
      children: Object.entries(value.children as Record<string, string>).map(([key, value]) => ({
        label: value,
        value: key,
      })),
    }));
  }

  /**
   * Changes the language of the localizations service to the language of the user profile.
   * @param {any} userProfile The user profile to change the language to.
   */
  export async function changeLanguageToProfile(userProfile: any): Promise<void> {
    functions.logger.info(`Changing language to profile: ${userProfile.language}`);

    await verifyInitialized();

    //* Default to English if no language is set.
    let locale = userProfile.language;
    if (!locale) {
      locale = "en";
    }

    await changeLanguage(locale);
  }

  /**
   * Gets a localized string for the given key.
   * @param {string} key The key of the localized string to get.
   * @param {any} args The arguments to pass to the localized string.
   */
  export async function getLocalizedString(key: string, args = {}): Promise<string> {
    functions.logger.info(`Getting localized string for key: ${key}`);

    await verifyInitialized();
    const translation = t(key, args);

    functions.logger.info(`Localized string for key: ${key} is: ${translation}`);

    return translation;
  }
}
