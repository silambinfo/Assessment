({
    getButtonValue:function(component,event,helper){
        var checkCmp = component.find("chkbox").get("v.value");
        component.set("v.chkboxvalue",checkCmp);
        console.log(checkCmp);
        if(checkCmp == true){
            var action=component.get('c.createChargeRecord');
            var recordId = component.get('v.recordId');
            console.log(recordId);
            console.log('recordId');
            action.setParams({ "recordId" :recordId });
            action.setCallback(this, function(response) {
            var state = response.getState();
                console.log(state);
            if (state === "SUCCESS") {
                helper.handleErrors('SUCCESS','Charge record created');
            }else{
                var errors = response.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                 errors[0].message);
                        helper.handleErrors('faild',errors[0].message);
                    }
                }
                component.find("chkbox").set("v.value", false);
            }
            });
            $A.enqueueAction(action)
        }
        else if(checkCmp == false){
            var action=component.get('c.updateEndTime');
            var recordId = component.get('v.recordId');
            action.setParams({ recordId :recordId });
            action.setCallback(this, function(response) {
            var state = response.getState();
                console.log(state);
            if (state === "SUCCESS") {
                helper.handleErrors('SUCCESS','Charges calculated');
            }else{
                var errors = response.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                 errors[0].message);
                        helper.handleErrors('faild',errors[0].message);
                    }
                }
                //component.find("chkbox").set("v.value", false);
            }
            });
            $A.enqueueAction(action)
        }
    }
})