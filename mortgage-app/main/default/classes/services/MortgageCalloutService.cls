public with sharing class MortgageCalloutService extends RestClient implements ExternalDataSource {
    public MortgageCalloutService() {
        super('HomeServer');
    }

    @SuppressWarnings('PMD.FieldNamingConventions')
    private class Balance {
        public Integer ID;
        public String Name;
        public Double Balance;
        public Double BalanceAUD;
        public Integer PricebookID;
        public Integer ProductID;
        public String Created;
    }

    public static String serialize(Balance bal) {
        return (String) System.JSON.serialize(bal);
    }

    public static Balance deserialize(String json) {
        return (Balance) System.JSON.deserialize(json, Balance.class);
    }

    public List<Map<String, Object>> query(
        DataSource.TableSelection selection
    ) {
        HttpResponse response = get('/balances');

        List<Map<String, Object>> rows = new List<Map<String, Object>>();

        switch on response.getStatusCode() {
            when 200 {
                Balance[] balances = new List<Balance>{}; //deserialize(response.getBody());
                for (Balance bal : balances) {
                    Map<String, Object> row = new Map<String, Object>();
                    row.put('ExternalId', bal.ID);
                    row.put('Name', bal.Name);
                    row.put('Balance', bal.Balance);
                    row.put('BalanceAUD', bal.BalanceAUD);
                    row.put('PricebookID', bal.PricebookID);
                    row.put('ProductID', bal.ProductID);
                    row.put('Created', bal.Created);
                    row.put('DisplayUrl', null);
                    rows.add(row);
                }
            }
            when else {
                // throw new Exception();
            }
        }

        return rows;
    }

    public DataSource.UpsertResult upsertRow(Map<String, Object> row) {
        HttpResponse response = post('/balance/create', 'body');
        // HttpResponse response = put('/balance/', body);

        switch on response.getStatusCode() {
            when 200, 201, 204 {
                return DataSource.UpsertResult.success('id');
            }
            when 400, 404 {
                return DataSource.UpsertResult.failure(
                    'id',
                    response.getBody()
                );
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
        HttpResponse response = del('/balance/' + externalId);

        switch on response.getStatusCode() {
            when 204 {
                return DataSource.DeleteResult.success(externalId);
            }
            when 404 {
                return DataSource.DeleteResult.failure(
                    externalId,
                    response.getBody()
                );
            }
            when else {
                return DataSource.DeleteResult.failure(
                    externalId,
                    response.getBody()
                );
            }
        }
    }

    public static DataSource.Table sync() {
        DataSource.Column[] columns = new List<DataSource.Column>{
            DataSource.Column.text('ExternalId', 255),
            DataSource.Column.text('Name', 255),
            DataSource.Column.number('Amount', 18, 9),
            DataSource.Column.text('Date', 255),
            DataSource.Column.text('Type', 255),
            DataSource.Column.url('DisplayUrl')
        };

        return DataSource.Table.get('MortgageTransaction', 'Title', columns);
    }
}
