global class HomeServerConnection extends DataSource.Connection {
    global HomeServerConnection(DataSource.ConnectionParams connectionParams) {
    }

    override global DataSource.Table[] sync() {
        DataSource.Column[] columns = new List<DataSource.Column>{
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

    override global DataSource.TableResult query(
        DataSource.QueryContext context
    ) {
        List<Map<String, Object>> rows = HomeServerCalloutService.get(
            context.tableSelection
        );
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
                results.add(HomeServerCalloutService.create(row));
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
                results.add(HomeServerCalloutService.del(externalId));
            } catch (Exception e) {
                Log.get().publish(e);
            }
        }

        return results;
    }
}
