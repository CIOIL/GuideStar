public class GSTAR_TH_AdditionalData{

	public static void createExternalIdField(List<obj> newlist){
		Set<String> fieldNames = new Set<String>{'Id','field'};
        Set<Id> idSet = new Set<Id>();
        for (obj ad : newlist){
            idSet.add(ad.obj);
        }
        Map<Id, obj> malkarMap = new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, idSet)); 
        for (obj ad : newlist){
            ad.field = malkarMap.get(ad.obj).field + '_' + ad.field;
        }
	}

	public static void linkToParentMalkar(List<obj> newlist){
		Decimal currentYear = Date.today().year();
		List<obj> relevantRecords = new List<obj>();
		for (obj ad : newlist){
			if (ad.field){
				relevantRecords.add(ad);
			}
		}
		if (relevantRecords.size() == 0){
			return;
		}
        Map<Id, obj> additionalDataSortedByMalkar = new Map<Id, obj>();
        Map<Object, SObject> retMap = Utils.sortSObjects(relevantRecords, 'field', 'obj');
        for (Object obj : retMap.keySet()){
            additionalDataSortedByMalkar.put((Id)obj, (obj)retMap.get(obj));
        }
        Set<string> fieldNames = new Set<string>{'Id', 'field', 'field.field'};
        List<obj> toUpdate = new List<obj>();
        Map<Id, obj> parentMap = new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, additionalDataSortedByMalkar.keySet()));
        for (obj ad : additionalDataSortedByMalkar.values()){
            obj parentMalkar = parentMap.get(ad.obj);
            if(parentMalkar != null && ad.field != null){
            	if (parentMalkar.field == null || parentMalkar.field.field < ad.field){
                    if (Integer.valueOf(ad.field) <= currentYear && ad.field == true){
                        parentMalkar.field = ad.Id;
                        toUpdate.add(parentMalkar);
                    }
                } 	   
            }
        }
        if (toUpdate.size() > 0){
            update toUpdate;
        }
	}

	public static void updateParentMalkarClass(List<obj> newlist, Map<Id, obj> oldMap){
        List<string> fieldNames = new List<string>{
        	'field', 'field', 'field', 'field'
        };
        List<obj> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldNames);
        if (relevantRecords.size() > 0){
			Set<Id> parentIds = new Set<Id>();
			for (obj ad : relevantRecords){
				parentIds.add(ad.obj);
			}
			Set<string> malkarFieldNames = new Set<string>{
	        	'Id', 'field', 'field', 'field',
	        	'field', 'field', 'field', 'field',
	        	'field', 'field', 'field', 'field',
	        	'field', 'field', 'field', 'field', 'field'
	        };
	        List<obj> parentList = GSTAR_DAL.getMalkarsByIds(malkarFieldNames, parentIds);
	        GSTAR_TH_Malkar.populateSecondaryClassification(parentList);
	        update parentList;
		}
	}

	public static void setClassificationFields(List<obj> newList, Map<Id, obj> oldMap){
		List<string> fieldNames = new List<string>{
        	'field', 'field', 'field', 'field'
        };
		//List<obj> relevantRecords = findRelevantModifiedRecords(newList, oldMap, fieldNames);
		if (newList.size() > 0){
			Map<string, string> classMapPrim = getClassificationMap(true);
			Map<string, string> classMapSec = getClassificationMap(false);
			for (obj ad : newList){
				checkAndUpdateToNewCodes(ad);
				if (String.isNotBlank(ad.field) && classMapSec.containsKey(ad.field)){
					ad.field = classMapSec.get(ad.field);
				}
				else{
					ad.field = '';
				}
				if (String.isNotBlank(ad.field) && classMapPrim.containsKey(ad.field)){
					ad.field = classMapPrim.get(ad.field);
				}
				else{
					ad.field = '';
				}
			}
		}
	}
	
	private static void checkAndUpdateToNewCodes(obj ad){
		if(ad != null && String.isNotBlank(ad.field)){
			if(ad.field == '2111'){
				ad.field = '211';
			}
			else if(ad.field == '2101'){
				ad.field = '211';
			}
			else if(ad.field == '7101'){
				ad.field = '71011';
			}
		}
	}

	private static List<obj> findRelevantModifiedRecords(List<obj> newList, Map<Id, obj> oldMap, List<String> relevantFields){
		Set<obj> retSet = new Set<obj>();
		obj tempAD;
		for (obj ad : newList){
			tempAD = oldMap != null ? oldMap.get(ad.Id) : null;
			for (String field : relevantFields){
				if ((tempAD == null && ad.get(field) != null)  || (tempAD != null && ad.get(field) != tempAD.get(field))){
					retSet.add(ad);
				}
			}
		}
		return new List<obj>(retSet);
	}

	private static Map<string, string> getClassificationMap(boolean isPrim){
		Map<string, string> retMap = new Map<string, string>();
		Map<string, field> settingsMap = field.getAll();
		for (field setting : settingsMap.values()){
			if(isPrim){
				retMap.put(setting.field, setting.field);
			}
			else{
				retMap.put(setting.field, setting.field);
			}
		}
		return retMap;
	}
}