public with sharing class CoinGeckoCalloutService extends RestClient implements PricesCalloutService {
    public static Map<String, Double> get(
        String[] externalIds,
        String[] currencies
    ) {
        HttpResponse response = makeApiCall(
            'CoinGecko',
            HttpVerb.GET,
            String.format(
                '/api/v3/simple/price?ids={0}&vs_currencies={1}',
                new List<Object>{
                    String.join(externalIds, ','),
                    String.join(currencies, ',')
                }
            )
        );

        Map<String, Double> responseMap = new Map<String, Double>();
        switch on response.getStatusCode() {
            when 200 {
                Parser p = parse(response.getBody());
                for (String key : p.coins.keySet()) {
                    Double price = p.coins.get(key).currencies.get('aud');
                    responseMap.put(key, price);
                }
            }
            when else {
                Log.get()
                    .publish(
                        String.format(
                            'CoinGeckoCalloutService.makeCallout {0} {1}',
                            new List<Object>{
                                response.getStatusCode(),
                                response.getBody()
                            }
                        )
                    );
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
