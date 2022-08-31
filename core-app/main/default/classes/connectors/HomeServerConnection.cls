global class HomeServerConnection extends DataSource.Connection {
    private String certificateName;
    private String endpoint;
    private String oauthToken;
    private String password;
    private DataSource.IdentityType principalType;
    private DataSource.AuthenticationProtocol protocol;
    private String username;

    public Map<String, ExternalDataSource> calloutServices { get; set; }

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

        for (ExternalDataSource source : calloutServices.values()) {
            tables.add(source.sync());
        }

        return tables;
    }

    override global DataSource.TableResult query(
        DataSource.QueryContext context
    ) {
        ExternalDataSource source = calloutServices.get(
            context.tableSelection.tableSelected
        );

        try {
            List<Map<String, Object>> rows = source.query(
                context.tableSelection
            );
            // List<Map<String, Object>> q = DataSource.QueryUtils.process(context, rows); // Not for production
            return DataSource.TableResult.get(context, rows);
        } catch (Exception e) {
            Log.get().publish(e);
            return DataSource.TableResult.error(e.getMessage());
        }
    }

    global override DataSource.UpsertResult[] upsertRows(
        DataSource.UpsertContext context
    ) {
        DataSource.UpsertResult[] results = new List<DataSource.UpsertResult>{};
        ExternalDataSource source = calloutServices.get(context.tableSelected);

        for (Map<String, Object> row : context.rows) {
            try {
                results.add(source.upsertRow(row));
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
        ExternalDataSource source = calloutServices.get(context.tableSelected);

        for (String externalId : context.externalIds) {
            try {
                results.add(source.deleteRow(externalId));
            } catch (Exception e) {
                Log.get().publish(e);
            }
        }

        return results;
    }
}
