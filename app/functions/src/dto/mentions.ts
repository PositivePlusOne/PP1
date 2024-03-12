/**
 * The JSON representation of an mention
 * @export
 * @interface MentionJSON
 * @property {number} [startIndex] The start index of the mention in the content
 * @property {number} [endIndex] The end index of the mention in the content
 * @property {string} [foreignKey] The foreign key of the (Usually the user ID)
 * @property {string} [schema] The schema of the foreign key (Usually the user schema)
 */
export interface MentionJSON {
  startIndex?: number;
  endIndex?: number;
  label?: string;
  foreignKey?: string;
  schema?: string;
}

/**
 * The mention object
 * @export
 * @class Mention
 * @implements {MentionJSON}
 * @property {number} [startIndex] The start index of the mention in the content
 * @property {number} [endIndex] The end index of the mention in the content
 * @property {string} [label] The label of the mention
 * @property {string} [foreignKey] The foreign key of the (Usually the user ID)
 * @property {string} [schema] The schema of the foreign key (Usually the user schema)
 */
export class Mention {
  public startIndex?: number;
  public endIndex?: number;
  public label?: string;
  public foreignKey?: string;
  public schema?: string;

  constructor(json?: MentionJSON) {
    if (json) {
      this.startIndex = json.startIndex;
      this.endIndex = json.endIndex;
      this.label = json.label;
      this.foreignKey = json.foreignKey;
      this.schema = json.schema;
    }
  }

  public toJSON(): MentionJSON {
    return {
      startIndex: this.startIndex,
      endIndex: this.endIndex,
      label: this.label,
      foreignKey: this.foreignKey,
      schema: this.schema,
    };
  }

  static FromJSONList(jsonList: MentionJSON[]): Mention[] {
    const list: Mention[] = [];
    if (jsonList) {
      jsonList.forEach((json) => {
        list.push(new Mention(json));
      });
    }

    return list;
  }
}
