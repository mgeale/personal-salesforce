@isTest
public class MockHttpCalloutResponse implements HttpCalloutMock {
    private Integer statusCode; // setStatusCode Example : 200
    private String responseBody; // JSON Response
    private Map<String, String> responseHeaders; // header. Example : 'Content-Type', 'application/JSON'

    private String requestBody;
    private String requestMethod;
    private Map<String, String> requestHeaders = new Map<String, String>();
    private Map<String, String> expectedRequestHeaders = new Map<String, String>();

    public MockHttpCalloutResponse(
        Integer statusCode,
        String responseBody,
        Map<String, String> responseHeaders
    ) {
        this.statusCode = statusCode;
        this.responseBody = responseBody;
        this.responseHeaders = responseHeaders;
    }

    public HTTPResponse respond(HTTPRequest req) {
        //capture request
        this.requestMethod = req.getMethod();
        this.requestBody = req.getBody();
        for (String expectedHeader : expectedRequestHeaders.keySet()) {
            String val = req.getHeader(expectedHeader);
            if (val != null) {
                requestHeaders.put(expectedHeader, val);
            }
        }

        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(responseBody);
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                res.setHeader(key, responseHeaders.get(key));
            }
        }
        return res;
    }

    public void setExpectedRequestHeaders(
        Map<String, String> expectedRequestHeaders
    ) {
        this.expectedRequestHeaders = expectedRequestHeaders;
    }

    public void verifyRequest(
        String expectedRequestBody,
        String expectedRequestMethod
    ) {
        System.assertEquals(expectedRequestMethod, requestMethod);
        System.assertEquals(expectedRequestBody, requestBody);
        for (String expectedHeader : expectedRequestHeaders.keySet()) {
            System.assert(requestHeaders.containsKey(expectedHeader));
        }
    }
}
