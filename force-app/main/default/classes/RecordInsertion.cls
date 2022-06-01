/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* RecordInsertion.cls Aura Apex controller to handle when charging toggled in UI
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Silambarasan Velu <silambinfo@gmail.com>
* @version        1.0
*/
	
public with sharing class RecordInsertion {
	/**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * createChargeRecord aura method creating charging records for contacts when charging checkbox made 
  * Active in Contact record details page UI
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    recordId    Type ID - contact record ID
  * @return   void - nothing
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
	@AuraEnabled
    public static void createChargeRecord(Id recordId){
        try{
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
/**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * updateEndTime aura method called when UI charging checkbox toggled to Inactive, updates 
  * charge records for the passed contact Id
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    recordId    Type ID - contact record ID
  * @return   void - nothing
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    @AuraEnabled
    public static void updateEndTime(Id recordId){
        try{
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
