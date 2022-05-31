trigger CalculateChargingCost on Charge__c (after update) {
    try{
        if(CalculateChargingCostHandler.runOnce()){
            CalculateChargingCostHandler.calculateCharges(Trigger.New,Trigger.oldMap);
        }
        
    }catch(MotorCarIncException ex){
        throw new MotorCarIncException('Mail001',ex.getMessage());
    }
    
}