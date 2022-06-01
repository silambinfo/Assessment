/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* CalculateChargingCost Apex trigger - triggered when charge__c objects after updated and calculating
* charges for contacts records
* * ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Silambarasan Velu <silambinfo@gmail.com>
* @version        1.0
*/
trigger CalculateChargingCost on Charge__c (after update) {
    try{
        if(CalculateChargingCostHandler.runOnce()){
            CalculateChargingCostHandler.calculateCharges(Trigger.New,Trigger.oldMap);
        }
        
    }catch(MotorCarIncException ex){
        throw new MotorCarIncException('Mail001',ex.getMessage());
    }
    
}
