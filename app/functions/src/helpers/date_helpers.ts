export namespace DateHelpers {
  /**
   * Used for formatting dates, will take a number and pad to 2 in length.
   * @param {number} num The number to pad
   * @return {string} The number padded to 2 in length.
   */
  export function padTo2Digits(num: number): string {
    return num.toString().padStart(2, "0");
  }

  /**
   * Formats a date to YYYY-MM-DD.
   * This is used for Occasion Genius and passing in events to the database.
   * @param {Date} date The date to format.
   * @return {string} The formatted date string.
   */
  export function formatDate(date: Date): string {
    return [date.getFullYear(), padTo2Digits(date.getMonth() + 1), padTo2Digits(date.getDay() + 1)].join("-");
  }
}
