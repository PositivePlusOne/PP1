export namespace StreamHelpers {
    export const paginationTokenRegex = /&id_lt=(.+?)&/;

    export function extractPaginationToken(url: string): string {
      const match = paginationTokenRegex.exec(url);
      if (match) {
        return match[1];
      } else {
        return "";
      }
    }
}