@isTest
public class HomeServerConnection_Test {
    @isTest
    static void shouldSync() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        HomeServerConnection conn = new HomeServerConnection(params);
        conn.calloutServices.clear();
        conn.calloutServices.put('Mock_Table', new MockCalloutService());

        DataSource.Table[] result = conn.sync();
        System.assertEquals(1, result.size());
    }

    @isTest
    static void shouldQuery() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        HomeServerConnection conn = new HomeServerConnection(params);
        conn.calloutServices.clear();
        conn.calloutServices.put('Mock_Table', new MockCalloutService());

        DataSource.QueryContext ctx = new DataSource.QueryContext();
        DataSource.TableResult result = conn.query(ctx);
        System.assert(result.success);
    }

    @isTest
    static void shouldUpsertRow() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        HomeServerConnection conn = new HomeServerConnection(params);
        conn.calloutServices.clear();
        conn.calloutServices.put('Mock_Table', new MockCalloutService());

        DataSource.UpsertContext ctx = new DataSource.UpsertContext();
        ctx.rows.add(new Map<String, Object>{});
        DataSource.UpsertResult[] result = conn.upsertRows(ctx);
        for (DataSource.UpsertResult r : result) {
            System.assert(r.success);
        }
    }

    @isTest
    static void shouldDeleteRow() {
        DataSource.ConnectionParams params = new DataSource.ConnectionParams();
        HomeServerConnection conn = new HomeServerConnection(params);
        conn.calloutServices.clear();
        conn.calloutServices.put('Mock_Table', new MockCalloutService());

        DataSource.DeleteContext ctx = new DataSource.DeleteContext();
        ctx.externalIds.add('id');
        DataSource.DeleteResult[] result = conn.deleteRows(ctx);
        for (DataSource.DeleteResult r : result) {
            System.assert(r.success);
        }
    }

    class MockCalloutService implements ExternalDataSource {
        public DataSource.Table sync() {
            return new DataSource.Table();
        }

        public List<Map<String, Object>> query(
            DataSource.TableSelection tableSelection
        ) {
            return new List<Map<String, Object>>();
        }

        public DataSource.UpsertResult upsertRow(Map<String, Object> row) {
            return DataSource.UpsertResult.success('id');
        }

        public DataSource.DeleteResult deleteRow(String externalId) {
            return DataSource.DeleteResult.success('id');
        }
    }
}
