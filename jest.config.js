const { jestConfig } = require("@salesforce/sfdx-lwc-jest/config");
const setupFilesAfterEnv = jestConfig.setupFilesAfterEnv || [];
module.exports = {
  ...jestConfig,
  moduleNameMapper: {
    "^@salesforce/apex$": "<rootDir>/core-app/tests/jest-mocks/apex",
    "^@salesforce/schema$": "<rootDir>/core-app/tests/jest-mocks/schema",
    "^lightning/navigation$":
      "<rootDir>/core-app/tests/jest-mocks/lightning/navigation",
    "^lightning/platformShowToastEvent$":
      "<rootDir>/core-app/tests/jest-mocks/lightning/platformShowToastEvent",
    "^lightning/uiRecordApi$":
      "<rootDir>/core-app/tests/jest-mocks/lightning/uiRecordApi",
    "^lightning/messageService$":
      "<rootDir>/core-app/tests/jest-mocks/lightning/messageService",
    "^lightning/actions$":
      "<rootDir>/core-app/tests/jest-mocks/lightning/actions"
  },
  setupFiles: ["jest-canvas-mock"],
  setupFilesAfterEnv,
  testTimeout: 10000
};
