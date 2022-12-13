public with sharing class BalanceCalloutService extends RestClient implements ExternalDataSource {
    @SuppressWarnings('PMD.EmptyStatementBlock')
    public BalanceCalloutService() {
    }

    public List<Map<String, Object>> query(
        DataSource.TableSelection selection
    ) {
        HttpResponse response; // = RestClient.makeApiCall('HomeServer', RestClient.HttpVerb.POST);

        switch on response.getStatusCode() {
            when 200 {
                return new List<Map<String, Object>>();
            }
            when else {
                return new List<Map<String, Object>>();
            }
        }
    }

    public DataSource.UpsertResult upsertRow(Map<String, Object> row) {
        HttpResponse response; // = RestClient.makeApiCall('HomeServer', RestClient.HttpVerb.POST);

        switch on response.getStatusCode() {
            when 200 {
                return DataSource.UpsertResult.success('id');
            }
            when else {
                return DataSource.UpsertResult.failure(
                    'id',
                    response.getBody()
                );
            }
        }
    }

    public DataSource.DeleteResult deleteRow(String externalId) {
        HttpResponse response; // = RestClient.makeApiCall('HomeServer', RestClient.HttpVerb.POST);

        switch on response.getStatusCode() {
            when 200 {
                return DataSource.DeleteResult.success(externalId);
            }
            when else {
                return DataSource.DeleteResult.failure(
                    'id',
                    response.getBody()
                );
            }
        }
    }

    public static DataSource.Table sync() {
        DataSource.Column[] columns = new List<DataSource.Column>{
            DataSource.Column.text('ExternalId', 255),
            DataSource.Column.text('Balance Name', 255),
            DataSource.Column.number('Balance', 18, 9),
            DataSource.Column.number('Balance AUD', 18, 2),
            DataSource.Column.lookup('Price Book', 'Pricebook2'),
            DataSource.Column.lookup('Product', 'Product2'),
            DataSource.Column.url('DisplayUrl')
        };

        return DataSource.Table.get('Balance', 'Title', columns);
    }
}
