export namespace NumberHelpers {
  /**
   * Safely parses a float from a string. Returns null if the string cannot be parsed.
   * @param {string} value The string to parse.
   * @return {number | null} The parsed float or null if the string cannot be parsed.
   */
  export function safelyParseFloat(value: string): number | null {
    const parsedValue = parseFloat(value);
    if (isNaN(parsedValue)) {
      return null;
    }
    return parsedValue;
  }
}
