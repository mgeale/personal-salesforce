global class HomeServerConnection extends DataSource.Connection {
    private String certificateName;
    private String endpoint;
    private String oauthToken;
    private String password;
    private DataSource.IdentityType principalType;
    private DataSource.AuthenticationProtocol protocol;
    private String username;

    global HomeServerConnection(DataSource.ConnectionParams connectionParams) {
        this.certificateName = connectionParams.certificateName;
        this.endpoint = connectionParams.endpoint;
        this.oauthToken = connectionParams.oauthToken;
        this.password = connectionParams.password;
        this.principalType = connectionParams.principalType;
        this.protocol = connectionParams.protocol;
        this.username = connectionParams.username;
    }

    override global DataSource.Table[] sync() {
        DataSource.Table[] tables = new List<DataSource.Table>{};
        // TODO: add sync()
        tables.add();

        return tables;
    }

    override global DataSource.TableResult query(
        DataSource.QueryContext context
    ) {
        List<Map<String, Object>> rows;
        try {
            // TODO: add callout
            rows = new List<Map<String, Object>>();
        } catch (Exception e) {
            Log.get().publish(e);
        }

        List<Map<String, Object>> q = DataSource.QueryUtils.process(
            context,
            rows
        ); // Not for production
        return DataSource.TableResult.get(context, q);
    }

    global override DataSource.UpsertResult[] upsertRows(
        DataSource.UpsertContext context
    ) {
        DataSource.UpsertResult[] results = new List<DataSource.UpsertResult>{};

        for (Map<String, Object> row : context.rows) {
            try {
                // TODO: add callout
                results.add();
            } catch (Exception e) {
                Log.get().publish(e);
            }
        }

        return results;
    }

    global override DataSource.DeleteResult[] deleteRows(
        DataSource.DeleteContext context
    ) {
        DataSource.DeleteResult[] results = new List<DataSource.DeleteResult>{};

        for (String externalId : context.externalIds) {
            try {
                // TODO: add callout
                results.add();
            } catch (Exception e) {
                Log.get().publish(e);
            }
        }

        return results;
    }
}
