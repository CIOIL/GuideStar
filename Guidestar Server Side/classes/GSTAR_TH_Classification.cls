public class GSTAR_TH_Classification {
    
    public static final String MalkarParentFieldName = 'obj';
    
    public static void updateExtId(List<obj> newList){
        Map<Id, obj> malkarMap = GSTAR_DAL.getMalkarParentMap(Utils.getSetIDs(newList, MalkarParentFieldName));
        for (obj cla : newlist){
            cla.field = getExtIdPrefix(cla) + malkarMap.get(cla.obj).field;
        }
    }
    
    public static void updateSecondaryClassification(List<obj> newList, Map<Id, obj> oldMap){
        Map<String, > classificationsMetaMap = getMappedHekdeshClassifications(GSTAR_DAL.getHekdeshClassifications()); 
        List<string> fieldList = new List<string>{'field', 'field', 'field'};
		List<obj> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldList);
        for (obj cla : relevantRecords){
            String key = getExtIdPrefix(cla);
             hc = classificationsMetaMap.get(key);
            if(hc != null){
            	Set<String> tags = new Set<String>();
            	if(String.isNotBlank(hc.field)){
            		tags = (Set<String>) JSON.deserialize(hc.field, Set<String>.class);
            	}
            	tags.Add(hc.field);
            	cla.field = JSON.serialize(tags);
            	cla.field = hc.field;
            	cla.field = hc.field;
            	cla.field = hc.field;
            	cla.field = hc.field;
            }
            else{
            	cla.field = null;
            	cla.field = null;
            	cla.field = null;
            	cla.field = null;
            	cla.field = null;
            }
        }
    }
    
    public static void updateParents(List<obj> newList, Map<Id, obj> oldMap){
    	List<string> fieldList = new List<string>{'field', 'field', 'field', 'field'};
		List<obj> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldList);
		Utils.log(relevantRecords.size());
    	Map<String, List<SObject>> newListByMalkar = Utils.toMapList(relevantRecords, MalkarParentFieldName);
    	Map<Id, obj> malkarMap = GSTAR_DAL.getMalkarParentMap(Utils.getSetIDs(relevantRecords, MalkarParentFieldName), new Set<String>{'field'});
    	
    	List<obj> malkarsToUpdate = new List<obj>();
    	for(String malkarId : newListByMalkar.keySet()){
    		List<SObject> sameParent = newListByMalkar.get(malkarId);
    		Set<String> secondaryClassNumbers = new Set<String>();
    		for(SObject obj: sameParent){
    			String valueClassifications = (String) obj.get('field');
    			if(String.isNotBlank(valueClassifications)){
    				secondaryClassNumbers.AddAll((Set<String>) JSON.deserialize(valueClassifications, Set<String>.class));
    			}
    		}
    		utils.log(secondaryClassNumbers);
    		if(!secondaryClassNumbers.isEmpty()){
    			obj malkar = malkarMap.get(malkarId);
    			utils.log(malkar);
    			system.debug(malkar.field);
	    		if(malkar != null && String.isNotBlank(malkar.field) ){
	    			if(malkar.field.startsWith('[')){
	    				Set<String> mySet = (Set<String>) JSON.deserialize(malkar.field, Set<String>.class);
	    				secondaryClassNumbers.AddAll(mySet);
	    			}
	    			else{
	    				secondaryClassNumbers.Add(malkar.field);
	    			}
	    		}
	    		String classSerialized = JSON.serialize(secondaryClassNumbers);
	    		if(malkar.field != classSerialized){
	    			malkar.field = classSerialized;
	    			malkarsToUpdate.Add(malkar);
	    		}
    		}
    	}
    	
    	if(!malkarsToUpdate.isEmpty()){
			update malkarsToUpdate;    
			utils.log(malkarsToUpdate);
    	}
    }
    
    private static String getExtIdPrefix(obj cla){
    	String result = 'C';
    	if(cla != null){
    		result += cla.field != null ? cla.field : '_';
    		result += cla.field != null ? cla.field : '_';
    		result += cla.field != null ? cla.field : '';
    	}
    	result += '_';
    	return result;
    }
    
    private static String getHekdeshClassificationMetaKey( cla){
    	String result = 'C';
    	if(cla != null){
    		result += cla.field != null ? cla.field : '_';
    		result += cla.field != null ? cla.field : '_';
    		result += cla.field != null ? cla.field : '';
    	}
    	result += '_';
    	return result;
    }
    
    private static Map<String, > getMappedHekdeshClassifications(List<> classificationsMeta){
    	Map<String, > classificationsMetaMap = new Map<String, >();
    	if(classificationsMeta != null && !classificationsMeta.isEmpty()){
    		for( hc : classificationsMeta){
    			String key = getHekdeshClassificationMetaKey(hc);
    			classificationsMetaMap.put(key, hc);
    		}
    	}
    	return classificationsMetaMap;
    }
    
    private static List<obj> findRelevantModifiedRecords(List<obj> newList, Map<Id, obj> oldMap, List<String> relevantFields){
		Set<obj> retSet = new Set<obj>();
		obj tempGovConnection;
		for (obj govCon : newList){
			tempGovConnection = oldMap != null ? oldMap.get(govCon.Id) : null;
			for (String field : relevantFields){
				if ((tempGovConnection == null && govCon.get(field) != null)  || (tempGovConnection != null && govCon.get(field) != tempGovConnection.get(field))){
					retSet.add(govCon);
				}
			}
		}
		return new List<obj>(retSet);
	}
}