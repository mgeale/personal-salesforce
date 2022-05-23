public class CoinGeckoParser {
  public Map<String, Coin> coins { get; set; }

  public CoinGeckoParser(JSONParser parser) {
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

  public static CoinGeckoParser parse(String json) {
    System.JSONParser parser = System.JSON.createParser(json);
    return new CoinGeckoParser(parser);
  }
}