public with sharing class CoinGeckoCalloutService extends RestClient implements CalloutService {
    public static Map<String, Coin> makeCallout(
        Map<String, List<Object>> params
    ) {
        HttpResponse response = makeApiCall(
            'CoinGecko',
            HttpVerb.GET,
            '/api/v3/simple/price?ids=' +
            String.join(params.get('externalIds'), ',') +
            '&vs_currencies=aud'
        );

        Map<String, Coin> responseMap = new Map<String, Coin>();
        switch on response.getStatusCode() {
            when 200 {
                responseMap = parse(response.getBody()).coins;
            }
            when else {
                Log logger = Log.get();
                logger.publish('Error: ' + response.getBody());
            }
        }

        return responseMap;
    }

    @testVisible
    private static Parser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new Parser(parser);
    }

    public class Parser {
        public Map<String, Coin> coins { get; set; }

        public Parser(JSONParser parser) {
            this.coins = new Map<String, Coin>();
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        this.coins.put(text, new Coin(parser));
                    }
                }
            }
        }
    }

    public class Coin {
        public Map<String, Double> currencies { get; set; }

        public Coin(JSONParser parser) {
            this.currencies = new Map<String, Double>();
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        this.currencies.put(text, parser.getDoubleValue());
                    }
                }
            }
        }
    }
}
