const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');
const setupFilesAfterEnv = jestConfig.setupFilesAfterEnv || [];
module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^@salesforce/apex$': '<rootDir>/force-app/tests/jest-mocks/apex',
        '^@salesforce/schema$': '<rootDir>/force-app/tests/jest-mocks/schema',
        '^lightning/navigation$':
            '<rootDir>/force-app/tests/jest-mocks/lightning/navigation',
        '^lightning/platformShowToastEvent$':
            '<rootDir>/force-app/tests/jest-mocks/lightning/platformShowToastEvent',
        '^lightning/uiRecordApi$':
            '<rootDir>/force-app/tests/jest-mocks/lightning/uiRecordApi',
        '^lightning/messageService$':
            '<rootDir>/force-app/tests/jest-mocks/lightning/messageService',
        '^lightning/actions$':
            '<rootDir>/force-app/tests/jest-mocks/lightning/actions'
    },
    setupFiles: ['jest-canvas-mock'],
    setupFilesAfterEnv,
    testTimeout: 10000
};
