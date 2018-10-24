trigger Reports_ApprovalTrigger on obj (before update, before insert, after update, after insert) {
	if (trigger.isBefore){
		if (trigger.isUpdate){
			GSTAR_TH_Reports_Approval.updateFields(trigger.new);
			GSTAR_TH_Reports_Approval.generateGUID(trigger.new, trigger.oldMap);
		}
		else if (trigger.isInsert){
			GSTAR_TH_Reports_Approval.removeDuplicates(trigger.new);
			GSTAR_TH_Reports_Approval.updateFields(trigger.new);
			GSTAR_TH_Reports_Approval.generateGUID(trigger.new);
		}
	}
	else if (trigger.isAfter){
		if (trigger.isUpdate){
			GSTAR_TH_Reports_Approval.updateParents(trigger.new, trigger.oldMap);
			//GSTAR_TH_Reports_Approval.unlinkNonActiveReportsToParentMalkar(trigger.new);
			//GSTAR_TH_Reports_Approval.linkToParentMalkar(trigger.new);
		}
		else if (trigger.isInsert){
			GSTAR_TH_Reports_Approval.updateParents(trigger.new, null);
			//GSTAR_TH_Reports_Approval.unlinkNonActiveReportsToParentMalkar(trigger.new);
			//GSTAR_TH_Reports_Approval.linkToParentMalkar(trigger.new);
		}
	}
}