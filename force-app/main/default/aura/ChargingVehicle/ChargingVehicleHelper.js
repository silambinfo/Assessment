({
	handleErrors : function(status,errors) {
        console.log(errors);
        // Configure error toast
        let toastParams = {
            title: "Error",
            message: "Unknown error", // Default error message
            type: "error"
        };
        // Pass the error message if any
        if (errors != null) {
            toastParams.message = errors;
        }
        if(status== 'SUCCESS'){
            toastParams.message = 'Success';
            toastParams.type = 'success';
            toastParams.title = 'success';
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
	}
})