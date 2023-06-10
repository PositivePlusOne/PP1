/**
 * This interface represents a Flamelink converter.
 * @interface
 * @property {any} [key] the key.
 */
export interface FlamelinkConverter {
    [key: number]: any;
}

/**
 * This interface represents a Flamelink Firestore.
 * @interface
 * @property {string} {projectId} the project ID.
 */
export interface FlamelinkFirestore {
    projectId: string;
}

/**
 * This interface represents a Flamelink path.
 * @interface
 * @property {string[]} {segments} the segments.
 */
export interface FlamelinkPath {
    segments: string[];
}

/**
 * This interface represents a Flamelink reference.
 * @interface
 * @property {FlamelinkConverter} {_converter} the converter.
 * @property {FlamelinkFirestore} {_firestore} the Firestore.
 * @property {FlamelinkPath} {_path} the path.
 */
export type FlamelinkReference = {
    _converter: FlamelinkConverter;
    _firestore: FlamelinkFirestore;
    _path: FlamelinkPath;
}

/**
 * This function checks if an object is a Flamelink reference.
 * @param {any} obj the object to check.
 * @return {boolean} true if the object is a Flamelink reference, false otherwise.
 */
export function isFlamelinkReference(obj: any): obj is FlamelinkReference {
    return obj
        && typeof obj === 'object'
        && '_converter' in obj
        && '_firestore' in obj
        && '_path' in obj
        && typeof obj._firestore === 'object'
        && typeof obj._firestore.projectId === 'string'
        && typeof obj._path === 'object'
        && Array.isArray(obj._path.segments)
        && obj._path.segments.every((segment: any) => typeof segment === 'string');
}