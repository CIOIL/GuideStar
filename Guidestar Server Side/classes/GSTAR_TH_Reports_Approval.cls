public class GSTAR_TH_Reports_Approval{
	
	/*public static void updateExtId(List<obj> newList){
		Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>(Utils_DAL.getRecordTypeInfo('obj'));
		for (obj ra : newList){
			ra.c = ra.c + '_' + recordTypeMap.get(ra.RecordTypeId).DeveloperName + '_' + Integer.valueOf(ra.c);
		}
	}*/
	
	public static void updateFields(List<obj> newList){
		Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>(Utils_DAL.getRecordTypeInfo('obj'));
		for (obj ra : newList){
			ra.c = ra.c + '_' + recordTypeMap.get(ra.RecordTypeId).DeveloperName + '_' + Integer.valueOf(ra.c);
			if(ra.c == true){
				ra.c = true;
			}
		}
	}

	public static void removeDuplicates(List<obj> newList){
		Set<string> mojIdSet = new Set<string>();
		for (obj ra : newList){
			if (ra.c != null){
				mojIdSet.add(ra.c);
			}
		}
		Set<string> fieldnames = new set<string>{'Id','c'};
		List<obj> preexisting = GSTAR_DAL.getReportsApprovalsByMojIdRepo(fieldnames, new List<string>(mojIdSet));
		if (preexisting.size() > 0){
			delete preexisting;
		}
	}

	public static void generateGUID(List<obj> newList, Map<Id, obj> oldMap){
		List<obj> modifiedList = new List<obj>();
		obj tempReport;
		for (obj ra : newList){
			tempReport = oldMap != null ? oldMap.get(ra.Id) : null;
			if (tempReport == null || String.isBlank(ra.c)){
				modifiedList.add(ra);
			}
		}
		generateGUID(modifiedList);
	}
	
	public static void generateGUID(List<obj> newList){
		for (obj ra : newList){
			ra.c = Utils.getGUID(ra.c);
			ra.c = '/vf_view_file?guid=' + ra.c;
		}
	}
	
	public static void updateParents(List<obj> newList, Map<Id, obj> oldMap){
		Map<Id, obj> parentMalkars = new Map<Id, obj>();
		List<String> fieldList = new List<String>{'RecordTypeId','c', 'c', 'c', 'c', 'c', 'c'};
		Set<obj> relevantRecords = findRelevantModifiedRecords(newList, oldMap, fieldList);
		for(obj report: relevantRecords){
			if(!parentMalkars.containsKey(report.c)){
				parentMalkars.put(report.c, new obj(Id = report.c, c = true));
			}
		}
		if(!parentMalkars.isEmpty()){
			try{
				update parentMalkars.values();	
			}
			catch(Exception e){
				Utils.sendEmailToAdmins('Error when update malkar parents GSTAR_TH_Reports_Approval ', e.getMessage());
			}
			
			try{
				//when the trigger was fired from a batch it is cannot working, but it is from the proces it is working
				Database.executeBatch(new GSTAR_BATCH_SetMalkarLatestReports(),10);	
			}
			catch(Exception e){
				Utils.sendEmailToAdmins('Error in GSTAR_BATCH_SetMalkarLatestReports', e.getMessage());
			}
		}
	}

	public static void setMalkarLatestReports(List<obj> malkars){
		Set<Id> malkarNums = Utils.getSetIDs(malkars); 
		List<obj> reports = GSTAR_DAL.getActiveReportsApprovalsByMalkarNums(malkarNums, null, 2000);
		Utils.log(reports);
		Map<String, List<obj>> reportsByMalkar = GSTAR_Utils.toMapList(reports, 'c');
		for(obj malkar: malkars){
			List<obj> malkarReports = reportsByMalkar.get(malkar.Id);
			if(malkarReports != null){
				Map<String, List<obj>> malkarReportsByRT = GSTAR_Utils.toMapList(malkarReports, 'RecordType.DeveloperName');
				setMalkarLastReport(malkarReportsByRT.get(GSTAR_Utils.annualFinancialRecortTypeDeveloperName), malkar, GSTAR_Utils.annualFinancialFieldName);
				setMalkarLastReport(malkarReportsByRT.get(GSTAR_Utils.annualDescriptiveRecortTypeDeveloperName), malkar, GSTAR_Utils.annualDescriptiveFieldName);
				setMalkarLastReport(malkarReportsByRT.get(GSTAR_Utils.annualSalaryRecortTypeDeveloperName), malkar, GSTAR_Utils.annualSalaryFieldName);
				setMalkarLastReport(malkarReportsByRT.get(GSTAR_Utils.annualTakinLetterRecortTypeDeveloperName), malkar, GSTAR_Utils.annualTakinLetterFieldName);
				setMalkarLastReport(malkarReportsByRT.get(GSTAR_Utils.annualRegCertRecortTypeDeveloperName), malkar, GSTAR_Utils.annualRegCertFieldName);
			}
			else{
				resetMalkarLastReportsFields(malkar);
			}
			malkar.c = false;
		}
	}
	
	public static void resetMalkarLastReportsFields(obj malkar){
		if(malkar != null){
			malkar.put(GSTAR_Utils.annualFinancialFieldName, null);
			malkar.put(GSTAR_Utils.annualDescriptiveFieldName, null);
			malkar.put(GSTAR_Utils.annualSalaryFieldName, null);
			malkar.put(GSTAR_Utils.annualTakinLetterFieldName, null);
			malkar.put(GSTAR_Utils.annualRegCertFieldName, null);
		}
	}
	
	public static void setMalkarLastReport(List<obj> malkarReports, obj malkar, String fieldName){
		obj max;
		if(malkarReports != null){
			for(obj report: malkarReports){
				if(max == null || max.c < report.c){
					max = report;
				}
			}
		}
		malkar.put(fieldName, max != null ? max.Id : null);
	}
	
	private static Set<obj> findRelevantModifiedRecords(List<obj> newList, Map<Id, obj> oldMap, List<String> relevantFields){
		Set<obj> retSet = new Set<obj>();
		obj tempReport;
		for (obj m : newList){
			tempReport = oldMap != null ? oldMap.get(m.Id) : null;
			for (String field : relevantFields){
				if ((tempReport == null && m.get(field) != null)  || (tempReport != null && m.get(field) != tempReport.get(field))){
					retSet.add(m);
				}
			}
		}
		return retSet;
	}
}