@isTest
public class CoinGeckoParserTest {
  @isTest
  public static void shouldParseResponse() {
    String response = '{"ethereum":{"aud":6178.0},"avalanche-2":{"aud":94.07},"maker":{"aud":3930.0},"usd-coin":{"aud":1.35},"tether":{"aud":1.35},"0x":{"aud":1.7},"augur":{"aud":34.03},"dai":{"aud":1.35},"cdai":{"aud":0.02921444},"compound-usd-coin":{"aud":0.03002133}}';

    Test.startTest();
    CoinGeckoParser result = CoinGeckoParser.parse(response);
    Test.stopTest();

    CoinGeckoParser.Coin ethereum = result.coins.get('ethereum');
    Double ethereumAUDprice = ethereum.currencies.get('aud');
    System.assertEquals(6178.0, ethereumAUDprice);

    CoinGeckoParser.Coin avalanche = result.coins.get('avalanche-2');
    Double avalancheAUDprice = avalanche.currencies.get('aud');
    System.assertEquals(94.07, avalancheAUDprice);
  }
}
