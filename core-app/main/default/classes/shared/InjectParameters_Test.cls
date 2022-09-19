@isTest
public class InjectParameters_Test {
    @isTest
    static void shouldInjectRecordIds() {
        Id accountId = ((Account) TestDataFactory.createSObject('Account')).id;

        InjectParameters testClass = new FakeTestClass();
        Set<ID> ids = new Set<ID>{ accountId };
        testClass.setRecordIds(ids);

        System.assertEquals(1, testClass.recordIds.size());
    }

    class FakeTestClass extends InjectParameters {
    }
}
