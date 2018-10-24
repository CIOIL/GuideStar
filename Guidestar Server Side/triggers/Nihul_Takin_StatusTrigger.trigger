trigger Nihul_Takin_StatusTrigger on obj (before insert, before update, after update, after insert) {
    
    if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_Nihul_Takin_Status.createExternalIdField(trigger.new);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Nihul_Takin_Status.createExternalIdField(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
            GSTAR_TH_Nihul_Takin_Status.linkToParentMalkar(trigger.new);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Nihul_Takin_Status.linkToParentMalkar(trigger.new);
        }
    }
}