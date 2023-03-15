@isTest
public class HomeServerConnection_Test {
    @isTest
    static void shouldSync() {
        HomeServerProvider provider = new HomeServerProvider();
        provider.getAuthenticationCapabilities();
        provider.getCapabilities();

        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        provider.getConnection(params);
        HomeServerConnection conn = new HomeServerConnection(params);

        DataSource.Table[] result = conn.sync();
        System.assert(result.size() > 0);
    }

    @isTest
    static void shouldQuery() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        params.endpoint = 'http://mockapi.com/query';
        HomeServerConnection conn = new HomeServerConnection(params);

        Test.setMock(HttpCalloutMock.class, new HomeServerCalloutServiceMock());

        DataSource.QueryContext ctx = createQueryContext();
        DataSource.TableResult result = conn.query(ctx);
        System.assert(result.success);
    }

    @isTest
    static void shouldUpsertRow() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        params.endpoint = 'http://mockapi.com/upsert';
        HomeServerConnection conn = new HomeServerConnection(params);

        Test.setMock(HttpCalloutMock.class, new HomeServerCalloutServiceMock());

        DataSource.UpsertContext ctx = new DataSource.UpsertContext();
        ctx.tableSelected = 'Balance';
        ctx.rows = new List<Map<String, Object>>();
        ctx.rows.add(new Map<String, Object>{});

        DataSource.UpsertResult[] result = conn.upsertRows(ctx);
        for (DataSource.UpsertResult r : result) {
            System.assert(r.success);
        }
    }

    @isTest
    static void shouldDeleteRow() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        params.endpoint = 'http://mockapi.com/delete';
        HomeServerConnection conn = new HomeServerConnection(params);

        Test.setMock(HttpCalloutMock.class, new HomeServerCalloutServiceMock());

        DataSource.DeleteContext ctx = new DataSource.DeleteContext();
        ctx.tableSelected = 'Balance';
        ctx.externalIds = new List<String>{ '5555' };
        DataSource.DeleteResult[] result = conn.deleteRows(ctx);
        for (DataSource.DeleteResult r : result) {
            System.assert(r.success);
        }
    }

    private static DataSource.QueryContext createQueryContext() {
        DataSource.QueryContext context = new DataSource.QueryContext();
        context.tableSelection = new DataSource.TableSelection();
        context.tableSelection.tableSelected = 'Balance';

        DataSource.ColumnSelection column = new DataSource.ColumnSelection();
        column.columnName = 'Name';
        context.tableSelection.columnsSelected = new List<DataSource.ColumnSelection>{
            column
        };

        context.tableSelection.order = new List<DataSource.Order>();
        DataSource.Order orderBy = new DataSource.Order();
        orderBy.columnName = 'Name';
        orderBy.direction = DataSource.OrderDirection.ASCENDING;
        context.tableSelection.order.add(orderBy);

        context.tableSelection.filter = new DataSource.Filter();
        context.tableSelection.filter.type = DataSource.FilterType.AND_;
        context.tableSelection.filter.subfilters = new List<DataSource.Filter>();

        DataSource.Filter f1 = new DataSource.Filter();
        f1.columnName = 'balance';
        f1.type = DataSource.FilterType.EQUALS;
        f1.columnValue = 1000.00;
        context.tableSelection.filter.subfilters.add(f1);

        DataSource.Filter level2 = new DataSource.Filter();
        level2.type = DataSource.FilterType.OR_;
        level2.subfilters = new List<DataSource.Filter>();

        DataSource.Filter f2 = new DataSource.Filter();
        f2.columnName = 'name';
        f2.type = DataSource.FilterType.EQUALS;
        f2.columnValue = 'BAL-0022';
        level2.subfilters.add(f2);

        DataSource.Filter f3 = new DataSource.Filter();
        f3.columnName = 'name';
        f3.type = DataSource.FilterType.EQUALS;
        f3.columnValue = 'BAL-0044';
        level2.subfilters.add(f3);
        context.tableSelection.filter.subfilters.add(level2);

        return context;
    }

    private class HomeServerCalloutServiceMock implements HttpCalloutMock {
        private final Map<String, Object> responseBodyQuery = new Map<String, Object>{
            'data' => new Map<String, Object>{
                'balances' => new List<Object>{
                    new Map<String, Object>{
                        'id' => 1,
                        'name' => 'BAL-5511',
                        'balance' => 1000,
                        'balanceaud' => 2000,
                        'pricebookid' => 123,
                        'productid' => 456,
                        'created' => '2023-01-08 12:00:00 +0000 UTC'
                    }
                }
            }
        };

        private final Map<String, Object> responseBodyUpsert = new Map<String, Object>{
            'data' => new Map<String, Object>{
                'insertBalances' => new List<String>{ '5555' }
            }
        };

        private final Map<String, Object> responseBodyDelete = new Map<String, Object>{
            'data' => new Map<String, Object>{
                'deleteBalances' => new List<String>{ '5555' }
            }
        };

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            if (request.getEndpoint().equals('http://mockapi.com/query')) {
                response.setBody(JSON.serialize(responseBodyQuery));
            } else if (
                request.getEndpoint().equals('http://mockapi.com/upsert')
            ) {
                response.setBody(JSON.serialize(responseBodyUpsert));
            } else if (
                request.getEndpoint().equals('http://mockapi.com/delete')
            ) {
                response.setBody(JSON.serialize(responseBodyDelete));
            }
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
}
