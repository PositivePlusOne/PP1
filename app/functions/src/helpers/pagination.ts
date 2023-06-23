export type Pagination = {
  limit?: number;
  cursor?: string;
};

export type PaginationResult<T> = {
  data: T[];
  pagination: Pagination;
};
