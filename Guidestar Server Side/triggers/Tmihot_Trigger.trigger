trigger Tmihot_Trigger on obj (after insert, after update, before insert, before update) {
    
    if (trigger.isBefore){ 
        if (trigger.isUpdate){
			GSTAR_TH_Tmihot.setAge(trigger.new);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Tmihot.setAge(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        }
        else if (trigger.isInsert){
        }
    }
}