@isTest
public class DailyInterestFlow_Test {
    private static final Date DAY_ONE = Date.newInstance(2022, 1, 1);
    private static final Date DAY_TWO = Date.newInstance(2022, 1, 2);
    private static final Date DAY_THREE = Date.newInstance(2022, 1, 3);
    private static final Date DAY_FOUR = Date.newInstance(2022, 1, 4);
    private static final Date DAY_FIVE = Date.newInstance(2022, 1, 5);

    @TestSetup
    static void makeData() {
        TestDataFactory.createSObject(
            'Interest_Rate__c',
            new Map<String, Object>{
                'Per_Annum__c' => 2.34,
                'Start_Date__c' => DAY_ONE
            }
        );

        TestDataFactory.createSObject(
            'Interest_Rate__c',
            new Map<String, Object>{
                'Per_Annum__c' => 2.84,
                'Start_Date__c' => DAY_THREE
            }
        );

        TestDataFactory.createSObject(
            'Interest_Rate__c',
            new Map<String, Object>{
                'Per_Annum__c' => 3.24,
                'Start_Date__c' => DAY_FIVE
            }
        );

        TestDataFactory.createSObject(
            'Mortgage_Transaction__c',
            new Map<String, Object>{
                'Amount__c' => 615000,
                'Type__c' => 'Withdrawal',
                'Date__c' => DAY_ONE
            }
        );

        TestDataFactory.createSObject(
            'Mortgage_Transaction__c',
            new Map<String, Object>{
                'Amount__c' => 39.43,
                'Type__c' => 'Interest',
                'Date__c' => DAY_ONE
            }
        );

        TestDataFactory.createSObject(
            'Mortgage_Transaction__c',
            new Map<String, Object>{
                'Amount__c' => 39.43,
                'Type__c' => 'Repayment',
                'Date__c' => DAY_ONE
            }
        );
    }

    @isTest
    static void shouldCreateDailyInterestOnDay2() {
        Map<String, Object> inputs = new Map<String, Object>();
        Flow.Interview.Create_Daily_Interest_Transaction dailyInterestFlow = new Flow.Interview.Create_Daily_Interest_Transaction(
            inputs
        );

        Test.startTest();
        dailyInterestFlow.start();
        Test.stopTest();

        System.assertEquals(DAY_TWO, dailyInterestFlow.getVariableValue('Day'));
        System.assertEquals(
            2.34,
            dailyInterestFlow.getVariableValue('InterestRate')
        );
        System.assertEquals(
            39.43,
            dailyInterestFlow.getVariableValue('InterestAmount')
        );
        System.assertEquals(
            615000,
            dailyInterestFlow.getVariableValue('Balance')
        );
    }

    @isTest
    static void shouldCreateDailyInterestOnDay3() {
        createDay3TestData();

        Map<String, Object> inputs = new Map<String, Object>();
        Flow.Interview.Create_Daily_Interest_Transaction dailyInterestFlow = new Flow.Interview.Create_Daily_Interest_Transaction(
            inputs
        );

        dailyInterestFlow.start();

        System.assertEquals(
            DAY_THREE,
            dailyInterestFlow.getVariableValue('Day')
        );
        System.assertEquals(
            2.84,
            dailyInterestFlow.getVariableValue('InterestRate')
        );
        System.assertEquals(
            47.86,
            dailyInterestFlow.getVariableValue('InterestAmount')
        );
    }

    @isTest
    static void shouldCreateDailyInterestOnDay4() {
        createDay3TestData();
        createDay4TestData();

        Map<String, Object> inputs = new Map<String, Object>();
        Flow.Interview.Create_Daily_Interest_Transaction dailyInterestFlow = new Flow.Interview.Create_Daily_Interest_Transaction(
            inputs
        );

        dailyInterestFlow.start();

        System.assertEquals(
            DAY_FOUR,
            dailyInterestFlow.getVariableValue('Day')
        );
        System.assertEquals(
            2.84,
            dailyInterestFlow.getVariableValue('InterestRate')
        );
        System.assertEquals(
            47.86,
            dailyInterestFlow.getVariableValue('InterestAmount')
        );
    }

    @isTest
    static void shouldCreateDailyInterestOnDay5() {
        createDay3TestData();
        createDay4TestData();
        createDay5TestData();

        Map<String, Object> inputs = new Map<String, Object>();
        Flow.Interview.Create_Daily_Interest_Transaction dailyInterestFlow = new Flow.Interview.Create_Daily_Interest_Transaction(
            inputs
        );

        dailyInterestFlow.start();

        System.assertEquals(
            DAY_FIVE,
            dailyInterestFlow.getVariableValue('Day')
        );
        System.assertEquals(
            3.24,
            dailyInterestFlow.getVariableValue('InterestRate')
        );
        System.assertEquals(
            54.6,
            dailyInterestFlow.getVariableValue('InterestAmount')
        );
    }

    private static void createDay3TestData() {
        TestDataFactory.createSObject(
            'Mortgage_Transaction__c',
            new Map<String, Object>{
                'Amount__c' => 39.43,
                'Type__c' => 'Interest',
                'Date__c' => DAY_TWO
            }
        );
    }

    private static void createDay4TestData() {
        TestDataFactory.createSObject(
            'Mortgage_Transaction__c',
            new Map<String, Object>{
                'Amount__c' => 39.43,
                'Type__c' => 'Interest',
                'Date__c' => DAY_THREE
            }
        );
    }

    private static void createDay5TestData() {
        TestDataFactory.createSObject(
            'Mortgage_Transaction__c',
            new Map<String, Object>{
                'Amount__c' => 47.86,
                'Type__c' => 'Interest',
                'Date__c' => DAY_FOUR
            }
        );
    }
}
