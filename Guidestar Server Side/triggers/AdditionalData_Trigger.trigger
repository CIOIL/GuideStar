trigger AdditionalData_Trigger on obj (before insert, before update, after update, after insert) {

	if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_AdditionalData.setClassificationFields(trigger.new, trigger.oldMap);
        	GSTAR_TH_AdditionalData.createExternalIdField(trigger.new);
        }
        else if (trigger.isInsert){
            GSTAR_TH_AdditionalData.setClassificationFields(trigger.new, null);
        	GSTAR_TH_AdditionalData.createExternalIdField(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        	GSTAR_TH_AdditionalData.linkToParentMalkar(trigger.new);
            GSTAR_TH_AdditionalData.updateParentMalkarClass(trigger.new, trigger.oldMap);
        }
        else if (trigger.isInsert){
        	GSTAR_TH_AdditionalData.linkToParentMalkar(trigger.new);
            GSTAR_TH_AdditionalData.updateParentMalkarClass(trigger.new, null);
        }
    }
    
}