import { FieldPath, OrderByDirection, WhereFilterOp } from "firebase-admin/firestore";

export type QueryOptions = {
    schemaKey: string;
    orderBy?: Array<{
        fieldPath: string | FieldPath,
        directionStr?: OrderByDirection
    }>;
    limit?: number;
    startAfter? : string;
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