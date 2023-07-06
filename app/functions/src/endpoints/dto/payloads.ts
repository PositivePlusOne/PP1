export type EndpointRequest = {
    sender: string;
    cursor: string;
    limit: number;
    data: Record<string, any>;
};

export type EndpointResponse = {
    data: Record<string, any>;
    cursor: string;
    limit: number;
};