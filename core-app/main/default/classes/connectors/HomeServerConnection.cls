global class HomeServerConnection extends DataSource.Connection {
    global HomeServerConnection(DataSource.ConnectionParams connectionParams) {
    }

    override global List<DataSource.Table> sync() {
        List<DataSource.Table> tables = new List<DataSource.Table>();

        List<DataSource.Column> columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text('ExternalId', 255));
        columns.add(DataSource.Column.text('Balance Name', 255));
        columns.add(DataSource.Column.number('Balance', 18, 9));
        columns.add(DataSource.Column.number('Balance AUD', 18, 2));
        columns.add(DataSource.Column.lookup('Price Book', 'Pricebook2'));
        columns.add(DataSource.Column.lookup('Product', 'Product2'));
        columns.add(DataSource.Column.url('DisplayUrl'));
        tables.add(DataSource.Table.get('Balance', 'Title', columns));

        return tables;
    }

    // override global DataSource.TableResult query(DataSource.QueryContext context) {}

    // global override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context) {}

    // global override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context) {}
}
