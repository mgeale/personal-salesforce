import { createElement } from 'lwc';
import ProductHome from 'c/productHome';
import getProductList from '@salesforce/apex/ProductController.getProductList';

const mockGetProductList = require('./data/getProductList.json');

jest.mock(
    '@salesforce/apex/ProductController.getProductList',
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

describe('c-product-home', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    async function flushPromises() {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        return new Promise((resolve) => setTimeout(resolve, 0));
    }

    it('get product list data', async () => {
        const element = createElement('c-product-home', {
            is: ProductHome
        });
        document.body.appendChild(element);

        getProductList.emit(mockGetProductList);
        await flushPromises();

        const lightningCardEls =
            element.shadowRoot.querySelectorAll('lightning-card');
        expect(lightningCardEls.length).toBe(2);
    });

    it('shows the error panel element on product data load error', async () => {
        const element = createElement('c-product-home', {
            is: ProductHome
        });
        document.body.appendChild(element);

        getProductList.error();
        await flushPromises();

        const errorPanelEl = element.shadowRoot.querySelector('c-error-panel');
        return expect(errorPanelEl).not.toBeNull();
    });

    it('is accessible when data is returned', async () => {
        const element = createElement('c-product-home', {
            is: ProductHome
        });
        document.body.appendChild(element);

        getProductList.emit(mockGetProductList);
        await flushPromises();

        await expect(element).toBeAccessible();
    });

    it('is accessible when error is returned', async () => {
        const element = createElement('c-product-home', {
            is: ProductHome
        });
        document.body.appendChild(element);

        getProductList.error();
        await flushPromises();

        await expect(element).toBeAccessible();
    });
});
