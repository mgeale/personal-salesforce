import { LightningElement, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import getBalances from '@salesforce/apex/BalanceController.getBalanceHistoryForProduct';
import chartjs from '@salesforce/resourceUrl/chartJs';

const dateFormat = { year: 'numeric', month: 'long', day: 'numeric' };

export default class LineChart extends LightningElement {
    @api productId;

    error;
    chart;
    balances;

    chartjsInitialized = false;

    @wire(getBalances, { productId: '$productId' })
    apexBalances({ error, data }) {
        if (error) {
            //TODO:
        } else if (data) {
            this.balances = data.map((item) => {
                return {
                    date: item.CreatedDate,
                    balanceAUD: item.BalanceAUD__c
                };
            });
            this.chart.data = {
                datasets: [
                    {
                        data: this.balances.map((b) => b.balanceAUD),
                        label: 'AUD Balance',
                        borderColor: 'rgb(75, 192, 192)'
                    }
                ],
                labels: this.balances.map((b) =>
                    new Date(b.date).toLocaleDateString('en-AU', dateFormat)
                )
            };
            this.chart.update();
        } else {
            //TODO:
        }
    }

    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, chartjs)
            .then(() => {
                const canvas = document.createElement('canvas');
                this.template.querySelector('div.chart').appendChild(canvas);
                const ctx = canvas.getContext('2d');
                this.chart = new window.Chart(ctx, {
                    type: 'line',
                    data: {},
                    options: {
                        responsive: false
                    }
                });
            })
            .catch((error) => {
                this.error = error;
            });
    }
}
