export namespace FlamelinkHelpers {
    export function getFlamelinkIdFromObject(object: any): string {
        return object._fl_meta_.fl_id;
    }
}