trigger Organization_Green_InfoTrigger on obj (before update, before insert, after update, after insert) {

	if (trigger.isBefore){
		if (trigger.isUpdate){

		}
		else if (trigger.isInsert){
			
		}
	}
	else if (trigger.isAfter){
		if (trigger.isUpdate){
			GSTAR_TH_Organization_Green_Info.linkToParentMalkar(trigger.new);
		}
		else if (trigger.isInsert){
			GSTAR_TH_Organization_Green_Info.linkToParentMalkar(trigger.new);
		}
	}
}