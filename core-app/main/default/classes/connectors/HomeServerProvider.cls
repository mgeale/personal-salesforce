global class HomeServerProvider extends DataSource.Provider {
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        List<DataSource.AuthenticationCapability> capabilities = new List<DataSource.AuthenticationCapability>();
        capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
        capabilities.add(DataSource.AuthenticationCapability.BASIC);
        capabilities.add(DataSource.AuthenticationCapability.CERTIFICATE);
        capabilities.add(DataSource.AuthenticationCapability.OAUTH);
        return capabilities;
    }

    override global List<DataSource.Capability> getCapabilities() {
        List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.ROW_CREATE);
        capabilities.add(DataSource.Capability.ROW_UPDATE);
        capabilities.add(DataSource.Capability.ROW_DELETE);

        capabilities.add(DataSource.Capability.QUERY_PAGINATION_SERVER_DRIVEN);
        capabilities.add(DataSource.Capability.QUERY_TOTAL_SIZE);
        capabilities.add(DataSource.Capability.REQUIRE_ENDPOINT);
        capabilities.add(DataSource.Capability.REQUIRE_HTTPS);

        return capabilities;
    }

    override global DataSource.Connection getConnection(
        DataSource.ConnectionParams connectionParams
    ) {
        return new HomeServerConnection(connectionParams);
    }
}
