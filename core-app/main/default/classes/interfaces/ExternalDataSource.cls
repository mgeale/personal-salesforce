public interface ExternalDataSource {
    DataSource.Table sync();
    List<Map<String, Object>> query(DataSource.TableSelection tableSelection);
    DataSource.UpsertResult upsertRow(Map<String, Object> row);
    DataSource.DeleteResult deleteRow(String externalId);
}
