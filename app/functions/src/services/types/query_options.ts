import { WhereFilterOp } from "firebase-admin/firestore";

export type QueryOptions = {
    schemaKey: string;
    orderBy?: string;
    limit?: number;
    startAfter?: any;
    where?: Array<{
        fieldPath: string;
        op: WhereFilterOp;
        value: any;
    }>;
};

export type UpdateOptions<T> = {
    schemaKey: string;
    where?: Array<{
        fieldPath: string;
        op: WhereFilterOp;
        value: any;
    }>;
    dataChanges: Record<keyof T, any>;
};