import { createElement } from 'lwc';
import LineChart from 'c/lineChart';
import { loadScript } from 'lightning/platformResourceLoader';
import getBalances from '@salesforce/apex/BalanceController.getBalanceHistoryForProduct';

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

    it('loads the ChartJS javascript', () => {
        const CHARTJS_JS = 'chartJs';

        const element = createElement('c-line-chart', {
            is: LineChart
        });
        document.body.appendChild(element);

        expect(loadScript.mock.calls.length).toBe(1);
        expect(loadScript.mock.calls[0][1]).toEqual(CHARTJS_JS);
    });

    it('shows the error panel element on product data load error', async () => {
        const element = createElement('c-line-chart', {
            is: LineChart
        });
        document.body.appendChild(element);

        getBalances.error();
        await flushPromises();

        const errorPanelEl = element.shadowRoot.querySelector('c-error-panel');
        return expect(errorPanelEl).not.toBeNull();
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
