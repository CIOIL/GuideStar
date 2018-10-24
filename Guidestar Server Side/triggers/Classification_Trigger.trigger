trigger Classification_Trigger on obj (after insert, after update, before insert, before update) {
	if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_Classification.updateExtId(trigger.new);
            GSTAR_TH_Classification.updateSecondaryClassification(trigger.new, trigger.oldMap);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Classification.updateExtId(trigger.new);
            GSTAR_TH_Classification.updateSecondaryClassification(trigger.new, null);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        	GSTAR_TH_Classification.updateParents(trigger.new, trigger.oldMap);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Classification.updateParents(trigger.new, null);
        }
    }
    
}