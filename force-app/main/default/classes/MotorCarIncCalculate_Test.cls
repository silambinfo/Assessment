@isTest
public class MotorCarIncCalculate_Test {
    @testSetup static void setup() {
        // Create common test Contacts
        List<Contact> testConts = new List<Contact>();
        for(Integer i=0;i<20;i++) {
            testConts.add(new Contact(LastName = 'TestCont'+i,Email='test@mail.com'+i,Card_Value__c=50));
        }
        insert testConts;        
    }
    
    @isTest
    public static void testCreateChargeRecord(){
        Contact con = [Select Id,name from Contact where LastName = 'TestCont0' LIMIT 1];
        test.startTest();
        RecordInsertion.createChargeRecord(con.Id);
        Test.stopTest();
        Charge__c charge = [Select id,Start_Time__c from Charge__c where Contact_Id__c=:con.Id and End_Time__c=null LIMIT 1];
        System.assertEquals(true, charge.Start_Time__c != null, 'Charge record not created');
    }
    @isTest
    public static void testCreateChargeRecordFail(){
        test.startTest();
        try{
            Id i='0035x000016OoN0AAK';
            RecordInsertion.createChargeRecord(i);
        }catch(Exception ex){
            system.debug(ex.getMessage());
            System.assertEquals(true, ex.getTypeName()=='System.AuraHandledException');
        }
        
        Test.stopTest();
        
    }
    @isTest
    public static void testUpdateEndTime(){
        Contact con = [Select Id,name from Contact where LastName = 'TestCont0' LIMIT 1];
        RecordInsertion.createChargeRecord(con.Id);
        Charge__c charge = [Select id,Start_Time__c from Charge__c where Contact_Id__c=:con.Id and End_Time__c=null LIMIT 1];
        test.startTest();
        RecordInsertion.updateEndTime(con.Id);
        Test.stopTest();
        Charge__c chargeResult = [Select id,End_Time__c from Charge__c where Contact_Id__c=:con.Id LIMIT 1];
        System.assertEquals(true, chargeResult.End_Time__c != null, 'Charge record not created');
    }
    @isTest
    public static void testUpdateEndTimeFailure(){
        Contact con = new Contact(LastName = 'TestContEndT');
        insert con; 
        RecordInsertion.createChargeRecord(con.Id);
        Charge__c charge = [Select id,Start_Time__c from Charge__c where Contact_Id__c=:con.Id and End_Time__c=null LIMIT 1];
        test.startTest();
        try{
            RecordInsertion.updateEndTime(con.Id);
        }catch(Exception ex){
            system.debug(ex.getMessage());
            System.assertEquals(true, ex.getTypeName()=='System.AuraHandledException');
        }
        Test.stopTest();
    }
}