import { createElement } from 'lwc';
import LineChart from 'c/lineChart';
import { loadScript } from 'lightning/platformResourceLoader';
import getBalances from '@salesforce/apex/BalanceController.getBalanceHistoryForProduct';

const LOAD_SCRIPT_ERROR = {
    body: { message: 'An internal server error has occurred' },
    ok: false,
    status: 400,
    statusText: 'Bad Request'
};

jest.mock(
    '@salesforce/apex/BalanceController.getBalanceHistoryForProduct',
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

let mockScriptSuccess;

jest.mock(
    'lightning/platformResourceLoader',
    () => {
        return {
            loadScript() {
                return new Promise((resolve, reject) => {
                    if (!mockScriptSuccess) {
                        reject(LOAD_SCRIPT_ERROR);
                    } else {
                        global.moment = require('./../../staticrescources/chartJs');
                        resolve();
                    }
                });
            }
        };
    },
    { virtual: true }
);

const GET_PRODUCTS = require('./data/getProducts.json');

describe('c-line-chart', () => {
    beforeEach(() => {
        mockScriptSuccess = true;
    });

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    async function flushPromises() {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        return new Promise((resolve) => setTimeout(resolve, 0));
    }

    it('contains a canvas element for ChartJs', () => {
        const element = createElement('c-line-chart', {
            is: LineChart
        });
        document.body.appendChild(element);

        const domEl = element.shadowRoot.querySelector('div.chart');
        expect(domEl).not.toBeNull();
    });

    it('loads the ChartJS javascript and css static resources', () => {
        const CHARTJS_JS = 'chartJs';

        const element = createElement('c-line-chart', {
            is: LineChart
        });
        document.body.appendChild(element);

        expect(loadScript.mock.calls.length).toBe(1);
        expect(loadScript.mock.calls[0][1]).toEqual(CHARTJS_JS);
    });

    it('loads products', async () => {
        const element = createElement('c-line-chart', {
            is: LineChart
        });
        document.body.appendChild(element);

        await flushPromises();
        getBalances.emit(GET_PRODUCTS);
        return expect(null).not.toBeNull();
    });

    it('shows the error panel element on static resource load error', async () => {
        mockScriptSuccess = false;

        const element = createElement('c-line-chart', {
            is: LineChart
        });
        document.body.appendChild(element);

        await flushPromises();

        const errorPanelEl = element.shadowRoot.querySelector('c-error-panel');
        return expect(errorPanelEl).not.toBeNull();
    });

    it('is accessible when library is loaded', async () => {
        const element = createElement('c-line-chart', {
            is: LineChart
        });

        document.body.appendChild(element);

        await expect(element).toBeAccessible();
    });

    it('is accessible when there is an error loading library', async () => {
        mockScriptSuccess = false;

        const element = createElement('c-line-chart', {
            is: LineChart
        });

        document.body.appendChild(element);

        await expect(element).toBeAccessible();
    });
});
