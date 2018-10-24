trigger JSError_Trigger on obj (before insert, before update, after update, after insert) {
	if (trigger.isBefore){ 
        if (trigger.isUpdate){
        	TH_JS_Error.populateMessage(trigger.new);
        }
        else if (trigger.isInsert){
        	TH_JS_Error.populateMessage(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        }
        else if (trigger.isInsert){
        }
    }
}