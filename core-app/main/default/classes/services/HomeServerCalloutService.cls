public with sharing class HomeServerCalloutService {
    private String endpoint;
    private String username;
    private String password;
    private Map<String, GraphQLHomeServerConfig__mdt> config = GraphQLHomeServerConfig__mdt.getAll();

    public HomeServerCalloutService(
        String endpoint,
        String username,
        String password
    ) {
        this.endpoint = endpoint;
        this.username = username;
        this.password = password;
    }

    public class Filter {
        public String field;
        public String kind;
        public String value;
        public Filter[] subfilters;
    }

    public class OrderBy {
        public String field;
        public String direction;
    }

    public List<Map<String, Object>> query(
        String table,
        String[] columns,
        Filter filters,
        OrderBy orderBy
    ) {
        GraphQLNode node = new GraphQLNode(
            this.config.get(table).Get_Method__c,
            columns
        );

        GraphQLQueryNode query = new GraphQLQueryNode(
            new List<GraphQLNode>{ node }
        );

        GraphQLRequest request = query.buildRequest();
        request.withHeader(
            'Authorization',
            'Basic ' +
            EncodingUtil.base64Encode(
                Blob.valueOf(this.username + ':' + this.password)
            )
        );

        if (filters != null) {
            node.withArgument('where', '$where');
            query.withVariable(
                'where',
                this.config.get(table).Filter_Data_Type__c
            );
            request.withVariable('where', filters);
        }
        if (orderBy != null) {
            node.withArgument('orderBy', '$orderBy');
            query.withVariable(
                'orderBy',
                this.config.get(table).Sort_Data_Type__c
            );
            request.withVariable('orderBy', orderBy);
        }

        GraphQLHttpClient client = new GraphQLHttpClient(this.endpoint);
        GraphQLResponse response = client.send(request);

        List<Map<String, Object>> records = new List<Map<String, Object>>();
        if (response.hasErrors()) {
            Log.get().publish(response.getErrors().toString());
            throw new HomeServerCalloutException(
                response.getErrors().toString()
            );
        } else {
            for (
                Object bal : (Object[]) response.getDataNode(
                    this.config.get(table).Get_Method__c
                )
            ) {
                Map<String, Object> balRow = (Map<String, Object>) bal;
                records.add(balRow);
            }
            return records;
        }
    }

    public String[] insertRows(String table, List<Map<String, Object>> rows) {
        return upsertRows(
            this.config.get(table).Insert_Method__c,
            this.config.get(table).Insert_Input_Type__c,
            rows
        );
    }

    public String[] updateRows(String table, List<Map<String, Object>> rows) {
        return upsertRows(
            this.config.get(table).Update_Method__c,
            this.config.get(table).Update_Input_Type__c,
            rows
        );
    }

    public String[] upsertRows(
        String nodeName,
        String inputType,
        List<Map<String, Object>> rows
    ) {
        GraphQLNode node = new GraphQLNode(nodeName);
        GraphQLMutationNode mutation = new GraphQLMutationNode(node);

        GraphQLRequest request = mutation.buildRequest();
        request.withHeader(
            'Authorization',
            'Basic ' +
            EncodingUtil.base64Encode(
                Blob.valueOf(this.username + ':' + this.password)
            )
        );

        node.withArgument('input', '$input');
        mutation.withVariable('input', inputType);
        request.withVariable('input', rows);

        GraphQLHttpClient client = new GraphQLHttpClient(this.endpoint);
        GraphQLResponse response = client.send(request);

        if (response.hasErrors()) {
            Log.get().publish(response.getErrors().toString());
            throw new HomeServerCalloutException(
                response.getErrors().toString()
            );
        } else {
            return (List<String>) response.getDataNodeAs(
                nodeName,
                List<String>.class
            );
        }
    }

    public String[] deleteRows(String table, String[] externalIds) {
        GraphQLNode node = new GraphQLNode(
            this.config.get(table).Delete_Method__c
        );

        GraphQLMutationNode mutation = new GraphQLMutationNode(node);

        GraphQLRequest request = mutation.buildRequest();
        request.withHeader(
            'Authorization',
            'Basic ' +
            EncodingUtil.base64Encode(
                Blob.valueOf(this.username + ':' + this.password)
            )
        );

        node.withArgument('ids', '$ids');
        mutation.withVariable('ids', '[String!]');
        request.withVariable('ids', externalIds);

        GraphQLHttpClient client = new GraphQLHttpClient(this.endpoint);
        GraphQLResponse response = client.send(request);

        if (response.hasErrors()) {
            Log.get().publish(response.getErrors().toString());
            throw new HomeServerCalloutException(
                response.getErrors().toString()
            );
        } else {
            return (List<String>) response.getDataNodeAs(
                this.config.get(table).Delete_Method__c,
                List<String>.class
            );
        }
    }

    public class HomeServerCalloutException extends Exception {
    }
}
