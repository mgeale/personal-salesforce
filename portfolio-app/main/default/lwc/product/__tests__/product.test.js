import { createElement } from 'lwc';
import Product from 'c/product';
import { getRecord } from 'lightning/uiRecordApi';
import { subscribe, MessageContext, publish } from 'lightning/messageService';
import PRODUCT_SELECTED_CHANNEL from '@salesforce/messageChannel/Product_Selected__c';

const mockGetRecord = require('./data/getRecord.json');

describe('c-product', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    async function flushPromises() {
        return Promise.resolve();
    }

    it('registers the LMS subscriber during the component lifecycle', () => {
        const element = createElement('c-product', {
            is: Product
        });
        document.body.appendChild(element);

        expect(subscribe).toHaveBeenCalled();
        expect(subscribe.mock.calls[0][1]).toBe(PRODUCT_SELECTED_CHANNEL);
    });

    it('invokes getRecord with the published message payload value', async () => {
        const element = createElement('c-product', {
            is: Product
        });
        document.body.appendChild(element);

        const messagePayload = { recordId: '001' };
        publish(MessageContext, PRODUCT_SELECTED_CHANNEL, messagePayload);

        await flushPromises();

        const { recordId } = getRecord.getLastConfig();
        expect(recordId).toEqual(messagePayload.recordId);
    });

    describe('getRecord @wire data', () => {
        it('renders product details', async () => {
            const element = createElement('c-product', {
                is: Product
            });
            document.body.appendChild(element);

            getRecord.emit(mockGetRecord);

            await flushPromises();

            const spanEl = element.shadowRoot.querySelector('span');
            expect(spanEl.textContent).toBe('Ethereum');
        });
    });

    it('is line chart accessible', async () => {
        const element = createElement('c-product', {
            is: Product
        });
        document.body.appendChild(element);

        getRecord.emit(mockGetRecord);

        await flushPromises();

        const lineChartEl = element.shadowRoot.querySelector('c-line-chart');
        await expect(lineChartEl).toBeAccessible();
    });

    it('is transaction table accessible', async () => {
        const element = createElement('c-product', {
            is: Product
        });
        document.body.appendChild(element);

        getRecord.emit(mockGetRecord);

        await flushPromises();

        const tableEl = element.shadowRoot.querySelector('c-transaction-table');
        await expect(tableEl).toBeAccessible();
    });
});
