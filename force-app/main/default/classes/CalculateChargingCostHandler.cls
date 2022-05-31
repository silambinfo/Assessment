public with sharing class CalculateChargingCostHandler {
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public static void calculateCharges(List<Charge__c> newCharges,Map<Id,Charge__c> oldChargesMap){
        try{
            Set<Id> contactId = new Set<Id>();
            List<Contact> contactList = new List<Contact>();
            Map<Id,Charge__c> chargeContactMap = new Map<Id,Charge__c>();
            List<Contact> updateContactList = new List<Contact>();
            for(Charge__c charge : newCharges){
                Charge__c oldTime = oldChargesMap.get(charge.Id);
                if(oldTime.End_Time__c == null && charge.End_Time__c != null){
                    contactId.add(charge.Contact_Id__c);
                    chargeContactMap.put(charge.Contact_Id__c, charge);
                }
            }
            if(contactId.size() > 0){
                contactList = [select id,Card_Value__c,Last_Used__c,Total_Usage_Hours__c,Email from
                               Contact where Id =: contactId];
                Map<Id,Contact> contacMap = new Map<Id,Contact>();
                for(Charge__c chargeObj : newCharges){
                    for(Contact contact:contactList){
                        if(chargeObj.Contact_Id__c == contact.Id){
                            if(contact.Card_Value__c == null || contact.Email == null){
                                throw new MotorCarIncException('MissingField001','Missing field, Card Value and Email required');
                            }
                            if(contacMap.containsKey(contact.Id) == false){
                                contacMap.put(contact.Id, contact);
                            }else{
                                contact = contacMap.get(contact.id);
                            }
                            contact.Card_Value__c = contact.Card_Value__c - chargeObj.Cost__c;
                            contact.Last_Used__c = System.now();
                        }
                    }
                }
                updateContactList.addAll(contacMap.values());
            }
            if(updateContactList.size() > 0){
                update updateContactList;
                SendAmountDueDetails.sendEmail(updateContactList);
            }
        }catch(MotorCarIncException ex){
            throw new MotorCarIncException('Mail001',ex.getMessage());
        }
        catch(Exception ex){
            throw new MotorCarIncException('TriggerFailed','Something failed in ApexTrigger, Contact System Admin');        
        }
    }
}