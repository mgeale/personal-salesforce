@isTest
public class CoinGeckoCalloutService_Test {
    static final String CALLOUT_RESPONSE = '{"ethereum":{"aud":6178.0},"avalanche-2":{"aud":94.07},"maker":{"aud":3930.0},"usd-coin":{"aud":1.35},"tether":{"aud":1.35},"0x":{"aud":1.7},"augur":{"aud":34.03},"dai":{"aud":1.35},"cdai":{"aud":0.02921444},"compound-usd-coin":{"aud":0.03002133}}';

    @isTest
    public static void shouldParseResponse() {
        Test.startTest();
        CoinGeckoCalloutService.Parser result = CoinGeckoCalloutService.parse(
            CALLOUT_RESPONSE
        );
        Test.stopTest();

        CoinGeckoCalloutService.Coin ethereum = result.coins.get('ethereum');
        Double ethereumAUDprice = ethereum.currencies.get('aud');
        System.assertEquals(6178.0, ethereumAUDprice);

        CoinGeckoCalloutService.Coin avalanche = result.coins.get(
            'avalanche-2'
        );
        Double avalancheAUDprice = avalanche.currencies.get('aud');
        System.assertEquals(94.07, avalancheAUDprice);
    }

    @isTest
    public static void shouldMakeCallout() {
        MockHttpCalloutResponse mock = new MockHttpCalloutResponse(
            200,
            CALLOUT_RESPONSE,
            null
        );
        Test.setMock(HttpCalloutMock.class, mock);

        Map<String, Decimal> result = CoinGeckoCalloutService.get(
            new List<String>{ 'ethereum' },
            new List<String>{ 'aud' }
        );

        System.assertEquals(10, result.size());
        System.assertEquals(6178.0, result.get('ethereum'));
        System.assertEquals(94.07, result.get('avalanche-2'));
        System.assertEquals(1.35, result.get('usd-coin'));
        System.assertEquals(0.02921444, result.get('cdai'));
        System.assertEquals(1.7, result.get('0x'));
    }
}
