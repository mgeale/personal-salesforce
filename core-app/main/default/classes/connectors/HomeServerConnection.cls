global class HomeServerConnection extends DataSource.Connection {
    global HomeServerConnection(DataSource.ConnectionParams connectionParams) {
    }

    override global List<DataSource.Table> sync() {
        List<DataSource.Column> columns = new List<DataSource.Column>{
            DataSource.Column.text('ExternalId', 255),
            DataSource.Column.text('Balance Name', 255),
            DataSource.Column.number('Balance', 18, 9),
            DataSource.Column.number('Balance AUD', 18, 2),
            DataSource.Column.lookup('Price Book', 'Pricebook2'),
            DataSource.Column.lookup('Product', 'Product2'),
            DataSource.Column.url('DisplayUrl')
        };

        return new List<DataSource.Table>{
            DataSource.Table.get('Balance', 'Title', columns)
        };
    }

    // override global DataSource.TableResult query(DataSource.QueryContext context) {}

    // global override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext context) {}

    // global override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext context) {}
}
