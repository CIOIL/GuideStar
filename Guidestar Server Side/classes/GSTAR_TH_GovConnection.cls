public class GSTAR_TH_GovConnection{

	public static void checkSmallerAmount(List<obj> newList, Map<Id, obj> oldMap){
		List<string> fieldList = new List<string>{'c'};
		List<obj> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldList);
		for (obj gc : relevantRecords){
			if (oldMap.get(gc.Id) !=null && gc.c < oldMap.get(gc.Id).c){
				gc.c = true;
			}
		}
	}

	//public static void populateAmountPaid(List<obj> newList, Map<Id, obj> oldMap){
	//	List<string> fieldList = new List<string>{'c', 'c'};
	//	List<obj> relevantRecords = findRelevantModifiedRecords(newlist, oldMap, fieldList);
	//	if (relevantRecords.size() > 0){
	//		for (obj govCon : relevantRecords){
	//			Decimal total;
	//			if (govCon.Id != null && oldMap.containsKey(govCon.Id)){
	//				total = oldMap.get(govCon.Id).c != null ? oldMap.get(govCon.Id).c : 0.0;
	//			}
	//			else{
	//				total = govCon.c != null ? govCon.c : 0.0;
	//			}
	//			Decimal subTotal = govCon.c != null ? govCon.c : 0.0;
	//			govCon.c = total + subTotal;
	//			govCon.c = null;
	//		}
	//	}
	//}

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