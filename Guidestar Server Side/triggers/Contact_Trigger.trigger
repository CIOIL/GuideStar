trigger Contact_Trigger on Contact (before insert, before update, after update, after insert) {

	if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_Contact.populateEmailListField(trigger.new, trigger.oldMap);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Contact.populateEmailListField(trigger.new, null);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){

        }
        else if (trigger.isInsert){

        }
    }
}