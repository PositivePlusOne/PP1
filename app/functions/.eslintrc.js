module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: ["eslint:recommended", "plugin:import/errors", "plugin:import/warnings", "plugin:import/typescript", "google", "plugin:@typescript-eslint/recommended"],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["./tsconfig.json", "./tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: ["@typescript-eslint", "import"],
  rules: {
    "@typescript-eslint/no-namespace": "off",
    "@typescript-eslint/no-explicit-any": "off",
    "indent": 0,
    "quotes": 0,
    "eol-last": 0,
    "max-len": 0,
    "require-jsdoc": 0,
    "no-trailing-spaces": 0,
    "object-curly-spacing": 0,
    "linebreak-style": 0,
    "import/no-unresolved": 0,
    "valid-jsdoc": 0,
    "guard-for-in": 0,
    "no-case-declarations": 0,
    "operator-linebreak": 0,
    "arrow-parens": 0,
    "brace-style":"off",
    "key-spacing":"off",
    "spaced-comment":"off",
    "camelcase":"off",
    "space-before-function-paren":"off",
  },
};
