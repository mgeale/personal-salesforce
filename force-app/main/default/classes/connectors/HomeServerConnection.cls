global class HomeServerConnection extends DataSource.Connection {
  global HomeServerConnection(DataSource.ConnectionParams connectionParams) {
  }

  override global List<DataSource.Table> sync() {
    return new List<DataSource.Table>();
  }

  // override global DataSource.TableResult query(DataSource.QueryContext context) {}

  // global override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context) {}

  // global override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context) {}
}
