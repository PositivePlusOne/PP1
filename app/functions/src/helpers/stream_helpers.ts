export namespace StreamHelpers {
  export const paginationTokenRegex = /&id_lt=(.+?)&/;

  export function getCurrentTimestamp() {
    return getTimestampForDate(new Date());
  }

  export function getTimestampForDate(date: Date) {
    return `${date.getFullYear()}-` +
      `${String(date.getMonth() + 1).padStart(2, '0')}-` +
      `${String(date.getDate()).padStart(2, '0')}T` +
      `${String(date.getHours()).padStart(2, '0')}:` +
      `${String(date.getMinutes()).padStart(2, '0')}:` +
      `${String(date.getSeconds()).padStart(2, '0')}.` +
      `${String(date.getMilliseconds()).padStart(3, '0')}`;
  }

  export function extractPaginationToken(url: string): string {
    const match = paginationTokenRegex.exec(url);
    if (match) {
      return match[1];
    } else {
      return "";
    }
  }
}