global class HomeServerProvider extends DataSource.Provider {
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        return new List<DataSource.AuthenticationCapability>{
            DataSource.AuthenticationCapability.BASIC
        };
    }

    override global List<DataSource.Capability> getCapabilities() {
        return new List<DataSource.Capability>{
            DataSource.Capability.ROW_QUERY,
            DataSource.Capability.ROW_CREATE,
            DataSource.Capability.ROW_UPDATE,
            DataSource.Capability.ROW_DELETE,
            DataSource.Capability.QUERY_PAGINATION_SERVER_DRIVEN,
            DataSource.Capability.QUERY_TOTAL_SIZE,
            DataSource.Capability.REQUIRE_ENDPOINT,
            DataSource.Capability.REQUIRE_HTTPS
        };
    }

    override global DataSource.Connection getConnection(
        DataSource.ConnectionParams connectionParams
    ) {
        return new HomeServerConnection(connectionParams);
    }
}
