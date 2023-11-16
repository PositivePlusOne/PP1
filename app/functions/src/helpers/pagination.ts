export const DEFAULT_PAGINATION_WINDOW_SIZE = 25;

export type Pagination = {
  limit?: number;
  cursor?: string;
};

export type PaginationResult<T> = {
  data: T[];
  pagination: Pagination;
};
