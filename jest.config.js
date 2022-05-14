const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');
const setupFilesAfterEnv = jestConfig.setupFilesAfterEnv || [];
module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^@salesforce/apex$': '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/apex',
        '^@salesforce/schema$': '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/schema',
        '^lightning/navigation$':
            '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/lightning/navigation',
        '^lightning/platformShowToastEvent$':
            '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/lightning/platformShowToastEvent',
        '^lightning/uiRecordApi$':
            '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/lightning/uiRecordApi',
        '^lightning/messageService$':
            '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/lightning/messageService',
        '^lightning/actions$':
            '<rootDir>/force-app/main/default/lwc/__tests__/jest-mocks/lightning/actions'
    },
    setupFiles: ['jest-canvas-mock'],
    setupFilesAfterEnv,
    testTimeout: 10000
};
