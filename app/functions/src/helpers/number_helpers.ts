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

  export function isPerfectSquare(number: number): boolean {
    const sqrt = Math.sqrt(number);
    return sqrt % 1 === 0;
  }

  export function isFibbonacci(number: number): boolean {
    return isPerfectSquare(5 * number * number + 4) || isPerfectSquare(5 * number * number - 4);
  }
}
