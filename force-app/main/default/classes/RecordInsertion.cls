public with sharing class RecordInsertion {
	@AuraEnabled
    public static void createChargeRecord(Id recordId){
        try{
            system.debug(recordId);
            
            if(recordId != null){
            	Contact con = [Select Id,name from Contact where Id=:recordId LIMIT 1];
                
                if(con == null){
                    throw new AuraHandledException('Charge creation failed, Contact couldn\'t find');
                }
                Charge__c charge = new Charge__c();
                charge.Contact_Id__c = con.Id;
                charge.Start_Time__c = Datetime.NOW();
                insert charge;
                
            }
        }catch(Exception ex){
            throw new AuraHandledException('Something failed in ApexController, Contact System Admin');
        }
    }
    @AuraEnabled
    public static void updateEndTime(Id recordId){
        try{
            system.debug(recordId);
            if(recordId != null){
                List<Charge__c> chargesList = new List<Charge__c>();
                for(Charge__c charge : [Select Id,name,End_Time__c from Charge__c where Contact_Id__c=:recordId and End_Time__c = null]){ 
                	charge.End_Time__c = Datetime.NOW();
                	chargesList.add(charge);
                
                }
                if(chargesList != null && chargesList.size() > 0){
                    update chargesList;
                }
            }
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}