public with sharing class HomeServerCalloutService extends RestClient {
    public static Map<String, Object> makeCallout(
        Map<String, Object[]> params
    ) {
    }

    private static List<Map<String, Object>> get(
        DataSource.TableSelection selection
    ) {
        HttpResponse response; // = RestClient.makeApiCall('HomeServer', RestClient.HttpVerb.POST);

        switch on response.getStatusCode() {
            when 200 {
                return new List<Map<String, Object>>();
            }
            when else {
                return new List<Map<String, Object>>();
            }
        }
    }

    private static DataSource.UpsertResult create(Map<String, Object> row) {
        HttpResponse response; // = RestClient.makeApiCall('HomeServer', RestClient.HttpVerb.POST);

        switch on response.getStatusCode() {
            when 200 {
                return DataSource.UpsertResult.success();
            }
            when else {
                return DataSource.UpsertResult.failure();
            }
        }
    }

    private static DataSource.DeleteContext del(String externalId) {
        HttpResponse response; // = RestClient.makeApiCall('HomeServer', RestClient.HttpVerb.POST);

        switch on response.getStatusCode() {
            when 200 {
                return DataSource.DeleteResult.success(externalId);
            }
            when else {
                return DataSource.DeleteResult.failure();
            }
        }
    }
}
