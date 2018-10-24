trigger ReportWageEarner_Trigger on obj (after insert, after update, before insert, before update) {
    
    if (trigger.isBefore){ 
        if (trigger.isUpdate){
        	GSTAR_TH_ReportWageEarner.createExternalIdField(trigger.new);
        }
        else if (trigger.isInsert){
        	GSTAR_TH_ReportWageEarner.createExternalIdField(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        	GSTAR_TH_ReportWageEarner.linkToParentMalkar(trigger.new);
        }
        else if (trigger.isInsert){
        	GSTAR_TH_ReportWageEarner.linkToParentMalkar(trigger.new);
        }
    }
}