module.exports.buildContent = (creator, schema, read, write) => {
  return {
    _fl_meta_: {
      createdBy: creator,
      schema: schema,
    },
    permissions: {
      read: read,
      write: write,
    },
  };
}