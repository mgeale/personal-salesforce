global class HomeServerConnection extends DataSource.Connection {
    private HomeServerCalloutService calloutService;

    global HomeServerConnection(DataSource.ConnectionParams connectionParams) {
        this.calloutService = new HomeServerCalloutService(
            connectionParams.endpoint,
            connectionParams.username,
            connectionParams.password
        );
    }

    override global DataSource.TableResult query(
        DataSource.QueryContext context
    ) {
        String[] columns = new List<String>{};
        for (
            DataSource.ColumnSelection c : context.tableSelection.columnsSelected
        ) {
            columns.add(c.columnName);
        }

        HomeServerCalloutService.Filter filters = context.tableSelection.filter !=
            null
            ? createFilters(context.tableSelection.filter)
            : null;

        HomeServerCalloutService.OrderBy orderBy = null;
        if (context.tableSelection.order.size() > 0) {
            orderBy = new HomeServerCalloutService.OrderBy();
            orderBy.field = context.tableSelection.order[0].columnName;
            orderBy.direction = context.tableSelection.order[0]
                    .direction.name() == 'ASCENDING'
                ? 'ASC'
                : 'DESC';
            // DataSource.OrderDirection.ASCENDING
        }

        try {
            List<Map<String, Object>> rows = this.calloutService.query(
                context.tableSelection.tableSelected,
                columns,
                filters,
                orderBy
            );
            return DataSource.TableResult.get(context, rows);
        } catch (Exception e) {
            return DataSource.TableResult.error(e.getMessage());
        }
    }

    global override DataSource.UpsertResult[] upsertRows(
        DataSource.UpsertContext context
    ) {
        List<Map<String, Object>> insertRows = new List<Map<String, Object>>();
        List<Map<String, Object>> updateRows = new List<Map<String, Object>>();

        for (Map<String, Object> row : context.rows) {
            if (row.get('ExternalId') != null) {
                updateRows.add(row);
            } else {
                insertRows.add(row);
            }
        }

        try {
            if (updateRows.size() > 0) {
                this.calloutService.updateRows(
                    context.tableSelected,
                    context.rows
                );
            }
            if (insertRows.size() > 0) {
                this.calloutService.insertRows(
                    context.tableSelected,
                    context.rows
                );
            }

            DataSource.UpsertResult[] results = new List<DataSource.UpsertResult>{};
            for (Map<String, Object> row : context.rows) {
                results.add(
                    DataSource.UpsertResult.success(
                        (String) row.get('ExternalId')
                    )
                );
            }
            return results;
        } catch (Exception e) {
            DataSource.UpsertResult[] results = new List<DataSource.UpsertResult>{};
            for (Map<String, Object> row : context.rows) {
                results.add(
                    DataSource.UpsertResult.failure(
                        (String) row.get('ExternalId'),
                        e.getMessage()
                    )
                );
            }
            return results;
        }
    }

    global override DataSource.DeleteResult[] deleteRows(
        DataSource.DeleteContext context
    ) {
        try {
            String[] externalIds = this.calloutService.deleteRows(
                context.tableSelected,
                context.externalIds
            );
            DataSource.DeleteResult[] results = new List<DataSource.DeleteResult>{};
            for (String id : externalIds) {
                results.add(DataSource.DeleteResult.success(id));
            }
            return results;
        } catch (Exception e) {
            DataSource.DeleteResult[] results = new List<DataSource.DeleteResult>{};
            for (String id : context.externalIds) {
                results.add(
                    DataSource.DeleteResult.failure(id, e.getMessage())
                );
            }
            return results;
        }
    }

    override global DataSource.Table[] sync() {
        DataSource.Column[] columnsBalance = new List<DataSource.Column>{
            DataSource.Column.text('ExternalId', 255),
            DataSource.Column.text('Name', 255),
            DataSource.Column.number('Balance', 18, 2),
            DataSource.Column.number('BalanceAUD', 18, 2),
            DataSource.Column.lookup('PriceBook', 'Pricebook2'),
            DataSource.Column.lookup('Product', 'Product2'),
            DataSource.Column.url('DisplayUrl')
        };

        DataSource.Column[] columnsTransaction = new List<DataSource.Column>{
            DataSource.Column.text('ExternalId', 255),
            DataSource.Column.text('Name', 255),
            DataSource.Column.number('Amount', 18, 2),
            DataSource.Column.text('Date', 255),
            DataSource.Column.text('Type', 255),
            DataSource.Column.url('DisplayUrl')
        };

        DataSource.Table[] tables = new List<DataSource.Table>{};
        tables.add(DataSource.Table.get('Balance', 'Name', columnsBalance));
        tables.add(
            DataSource.Table.get('Transaction', 'Name', columnsTransaction)
        );
        return tables;
    }

    private HomeServerCalloutService.Filter createFilters(
        DataSource.Filter filter
    ) {
        HomeServerCalloutService.Filter args = new HomeServerCalloutService.Filter();
        if (filter.subfilters != null && filter.subfilters.size() > 0) {
            HomeServerCalloutService.Filter[] argsSubfilter = new List<HomeServerCalloutService.Filter>{};
            for (DataSource.Filter f : filter.subfilters) {
                argsSubfilter.add(createFilters(f));
            }
            args.subfilters = argsSubfilter;
            args.kind = String.valueOf(filter.type);
        } else {
            args.field = filter.columnName;
            args.kind = String.valueOf(filter.type);
            args.value = String.valueOf(filter.columnValue);
        }
        return args;
    }
}
