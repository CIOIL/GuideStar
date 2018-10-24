trigger MalkarCity_Trigger on objr (before insert, before update, after update, after insert, after delete) {
	if (trigger.isBefore){ 
        if (trigger.isUpdate){
        	GSTAR_TH_MalkarCity.creatExternalId(trigger.new);
        }
        else if (trigger.isInsert){
        	GSTAR_TH_MalkarCity.creatExternalId(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        	GSTAR_TH_MalkarCity.updateMalkarDistricts(trigger.new);
        }
        else if (trigger.isInsert){
        	GSTAR_TH_MalkarCity.updateMalkarDistricts(trigger.new);
        }
        else if (trigger.isDelete){
        	GSTAR_TH_MalkarCity.updateMalkarDistricts(trigger.old);
        }
    }
}