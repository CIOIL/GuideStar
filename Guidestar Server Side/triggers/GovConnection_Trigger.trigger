trigger GovConnection_Trigger on obj (before insert, before update, after update, after insert) {

	if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_GovConnection.checkSmallerAmount(trigger.new, trigger.oldMap);
        	//GSTAR_TH_GovConnection.populateAmountPaid(trigger.new, trigger.oldMap);
        }
        else if (trigger.isInsert){
        	//GSTAR_TH_GovConnection.populateAmountPaid(trigger.new, null);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){

        }
        else if (trigger.isInsert){

        }
    }
}