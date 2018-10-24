trigger Malkar_Trigger on obj (before insert, before update, after update, after insert) {

	if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_Malkar.renameHeletz(trigger.new);
        	GSTAR_TH_Malkar.populateSecondaryClassification(trigger.new, trigger.oldMap);
            GSTAR_TH_Malkar.updateMalkarLocation(trigger.new, trigger.oldMap);
            GSTAR_TH_Malkar.pretifyLastLocation(trigger.new);
            GSTAR_TH_Malkar.setLocationChanged(trigger.new, trigger.oldMap);
        	//GSTAR_TH_Malkar.populateMainClassification(trigger.new, trigger.oldMap);
        }
        else if (trigger.isInsert){
            GSTAR_TH_Malkar.renameHeletz(trigger.new);
        	GSTAR_TH_Malkar.populateSecondaryClassification(trigger.new);
            GSTAR_TH_Malkar.updateMalkarLocation(trigger.new, null);
            GSTAR_TH_Malkar.pretifyLastLocation(trigger.new);
        	//GSTAR_TH_Malkar.populateMainClassification(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){
        }
        else if (trigger.isInsert){
        }
    }

}