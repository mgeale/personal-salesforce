import { createElement } from 'lwc';
import ProductList from 'c/productList';
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

describe('c-product-list', () => {
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
            is: ProductList
        });
        document.body.appendChild(element);

        getProductList.emit(mockGetProductList);
        await flushPromises();

        const treeEl = element.shadowRoot.querySelector('lightning-tree');
        expect(treeEl).not.toBeNull();
    });

    it('shows the error panel element on product data load error', async () => {
        const element = createElement('c-product-list', {
            is: ProductList
        });
        document.body.appendChild(element);

        getProductList.error();
        await flushPromises();

        const errorPanelEl = element.shadowRoot.querySelector('c-error-panel');
        return expect(errorPanelEl).not.toBeNull();
    });

    it('is accessible when data is returned', async () => {
        const element = createElement('c-product-list', {
            is: ProductList
        });
        document.body.appendChild(element);

        getProductList.emit(mockGetProductList);
        await flushPromises();

        await expect(element).toBeAccessible();
    });

    it('is accessible when error is returned', async () => {
        const element = createElement('c-product-list', {
            is: ProductList
        });
        document.body.appendChild(element);

        getProductList.error();
        await flushPromises();

        await expect(element).toBeAccessible();
    });
});
