public class GSTAR_Ctrl extends CTRL{
    public GSTAR_Ctrl (){}
    
    public static DateTime now = DateTime.now();
    public static String testSupportSimilarType = 'TestSupport';
    public static String onlyReportsCondition = ' AND RecordType.DeveloperName != \'gov_files_reg_certificate\' AND RecordType.DeveloperName != \'annual_takin_letter\'  ';
    public static String onlyAnnualTakinCondition = ' AND RecordType.DeveloperName = \'annual_takin_letter\'  AND  field >= \'' + String.valueOf(now.year()) + '\' ';
    public static String onlyRegCertificateCondition = ' AND RecordType.DeveloperName = \'gov_files_reg_certificate\'  ';
    
    public static String onlyGovSupportCondition = ' AND field = \'Gov Support\'  ';
    public static String onlyIfPersonalDonationsMinSumCondition = ' AND ( field != \'Personal\' OR (field = \'Personal\'  AND field >= 20000 ))  ';
    
    public static String onlyGovConnectionActiveCondition = ' AND field = true ';
    public static String onlyGovConnectionInactiveCondition = ' AND field = false ';
    
    public static String onlyReportTotalsGSTARCondition = ' AND field like \'Guidestar%\' ';
    
    public static String onlyReportedLast3Years = ' AND field = true ';
    public static String onlyNotReportedLast3Years = ' AND field != true ';
    
    public static String only20MillionTurnover = ' AND field >= 20000000 ';
    public static String onlyNot20MillionTurnover = ' AND field < 20000000 ';

    public static final String queryTypeSearch = 'search';
    public static final String queryTypeReport = 'report';
	
	
	@RemoteAction 
    public static map<String, Boolean> getMalkarInactiveMenu(String malkarNum){
    	map<String, Boolean> result = new map<String, Boolean>();
        if(!String.isEmpty(malkarNum)){
            List<obj> reports = GSTAR_DAL.getReportsApprovalsByMalkarNum(malkarNum, null, 1);
            List<obj> tmihots = GSTAR_DAL.getSupportsByMalkarNum(malkarNum, null, 1);
            List<obj> donations = GSTAR_DAL.getDonationsByMalkarNum(malkarNum, onlyIfPersonalDonationsMinSumCondition, 1);
            List<obj> govConnections = GSTAR_DAL.getGovConnectionsByMalkarNum(malkarNum, null, 1);
            
            Boolean isMalkarPeopleEmpty = checkMalkarPeopleEmpty(malkarNum);
            
            result.put(GSTAR_Utils.MalkarDocumentsPage, reports.isEmpty());
            result.put(GSTAR_Utils.MalkarGovsupportPage, tmihots.isEmpty());
            result.put(GSTAR_Utils.MalkarDonationsPage, donations.isEmpty());
            result.put(GSTAR_Utils.MalkarGovservicesPage, govConnections.isEmpty());
            result.put(GSTAR_Utils.MalkarPeoplePage, isMalkarPeopleEmpty);
            Utils.log(result);
        }       
        return result;
    }
	
	public static Boolean checkMalkarPeopleEmpty(String malkarNum){
        if(!String.isEmpty(malkarNum)){
            obj malkar = GSTAR_DAL.getMalkarByNum(malkarNum);
            List<field> wageEarners = GSTAR_DAL.getWageEarnersByMalkarNum(malkarNum, null, 1);
            if(String.isNotBlank(malkar.field) || String.isNotBlank(malkar.field) || !wageEarners.isEmpty()){
            	return false;
            }
        }
        return true;
    }
	
    @RemoteAction
    public static User getUserInfo(){
    	if(!UserInfo.getUserType().containsIgnoreCase('guest')){
    		User user = GSTAR_DAL.getUserInfo(UserInfo.getUserId());
	    	//GSTAR_Utils.UserWrapped userWrapped = new GSTAR_Utils.UserWrapped(GSTAR_DAL.getUserInfo(UserInfo.getUserId()));
	    	return user; 
    	}
    	return new User();
    }

    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarById(String malkarId){
        if(!String.isEmpty(malkarId)){
            obj malkar = GSTAR_DAL.getMalkarById(malkarId);
            return new GSTAR_Utils.MalkarResult(true, null, malkar);
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarDetails(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
            obj malkar = GSTAR_DAL.getMalkarByNum(malkarNum);
            if(malkar != null){
            	GSTAR_Utils.GSTAR_Malkar_Full fullMalkar = new GSTAR_Utils.GSTAR_Malkar_Full(malkar, lang);
	            fullMalkar.InactiveMenu = getMalkarInactiveMenu(malkarNum);
	            fullMalkar.InactiveMenu.put(GSTAR_Utils.MalkarContactPage, malkar.field == null);
	            fullMalkar.InactiveMenu.put(GSTAR_Utils.MalkarVolunteeringPage, malkar.field == false);
	            
	            return new GSTAR_Utils.MalkarResult(true, null, fullMalkar);
            }
            else{
            	return new GSTAR_Utils.MalkarResult(false, 'not found', null);
            }
            
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarReportsApproval(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
        	obj malkar = GSTAR_DAL.getMalkarByNum(malkarNum);
            List<obj> reports = GSTAR_DAL.getReportsApprovalsByMalkarNum(malkarNum, onlyReportsCondition);
            List<obj> annualTakins = GSTAR_DAL.getReportsApprovalsByMalkarNum(malkarNum, onlyAnnualTakinCondition);
            List<obj> regCertifications = GSTAR_DAL.getReportsApprovalsByMalkarNum(malkarNum, onlyRegCertificateCondition);
            List<GSTAR_Utils.ReportResult> wageEarnersByYear = GSTAR_Utils.getReportResult(GSTAR_DAL.getWageEarnersByYearByMalkarNum(malkarNum, null)); 
            
            List<field> greenDocs = GSTAR_DAL.getGreenDocumentsByMalkarNum(malkarNum, null, 3);
             
            obj regCert;
            if(!regCertifications.isEmpty()){
            	regCert = regCertifications[0];
            }
            map<String, GSTAR_Utils.TableByYear> tbyMap = GSTAR_Utils.getTableByYear(reports, wageEarnersByYear, malkarNum);
            return new GSTAR_Utils.MalkarResult(true, null, new GSTAR_Utils.ReportsData(tbyMap.values(), GSTAR_Utils.getDataByYear(annualTakins, malkar.field ? Label.Approval_Submission_Documents : null), GSTAR_Utils.getDataByYear(greenDocs), GSTAR_Utils.getDataByYear(regCert)));
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarGovSupport(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
            //List<obj> tmihots = GSTAR_DAL.getSupportsByMalkarNum(malkarNum, onlyGovSupportCondition);
            List<obj> tmihots = GSTAR_DAL.getSupportsByMalkarNum(malkarNum, null);
            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(tmihots).values());
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarSupport(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
            List<obj> tmihots = GSTAR_DAL.getSupportsByMalkarNum(malkarNum, null);
            List<obj> govSupports = getTmihotByType(tmihots, new Set<String>{GSTAR_Utils.TmihotEstatesType, GSTAR_Utils.TmihotGovSupportType});
            List<obj> nationalInsuranceSupports = getTmihotByType(tmihots, new Set<String>{GSTAR_Utils.TmihotNationalInsuranceType});
            return new GSTAR_Utils.MalkarResult(true, null, new GSTAR_Utils.TmihotsData(GSTAR_Utils.getTableByYear(govSupports).values() , GSTAR_Utils.getTableByYear(nationalInsuranceSupports).values()));
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    public static List<obj> getTmihotByType(List<obj> tmihots, Set<String> types){
    	if(tmihots == null || tmihots.isEmpty()){
    		return tmihots;
    	}
    	List<obj> result = new List<obj>();
    	for(obj t : tmihots){
    		if(types.contains(t.field)){
    			result.add(t);
    		}
    	}
    	return result;
    }
        
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarGovServices(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
            List<obj> govConnectionsActive = GSTAR_DAL.getGovConnectionsByMalkarNum(malkarNum, onlyGovConnectionActiveCondition);
            List<obj> govConnectionsInactive = GSTAR_DAL.getGovConnectionsByMalkarNum(malkarNum, onlyGovConnectionInactiveCondition);
            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(govConnectionsActive, govConnectionsInactive));
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarDonations(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
            List<obj> donations = GSTAR_DAL.getDonationsByMalkarNum(malkarNum, onlyIfPersonalDonationsMinSumCondition);
            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(donations).values());
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
        
        
        
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarPeople(String malkarNum, String recaptchaToken){    
    	if(String.isNotBlank(recaptchaToken)){
    		boolean isVerified = Utils_HttpRequests.verifyRecaptcha(recaptchaToken);
    		if(isVerified){
    			String lang = null;
    			if(!String.isEmpty(malkarNum)){
    				String lastAddData = GSTAR_DAL.getLastAdditionalDataByMalkarNum(malkarNum);
    				String condition = lastAddData != null ? ' AND obj = \''+ lastAddData + '\'' : null;
		            List<obj> peoples = GSTAR_DAL.getPeoplesByMalkarNum(malkarNum, condition);
		            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(peoples));
		        }
    		}
    	}	
        return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarConnected(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
        	//need to send a condition to the function in order to filter only from the last additional data
        	String lastAddData = GSTAR_DAL.getLastAdditionalDataByMalkarNum(malkarNum);
        	if(String.isNotBlank(lastAddData)){
        		List<obj> malkarsByContact = GSTAR_DAL.getConnectedByContactsMalkarNum(malkarNum, lastAddData);
            	List<obj> malkarsFrom = GSTAR_DAL.getConnectedFromMalkarNum(malkarNum, lastAddData);
            	List<obj> malkarsTo = GSTAR_DAL.getConnectedToMalkarNum(malkarNum, lastAddData);
            	utils.log(GSTAR_Utils.getTableByYear(malkarsByContact, malkarsFrom, malkarsTo));
            	return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(malkarsByContact, malkarsFrom, malkarsTo));
        	}
        	else{
        		return new GSTAR_Utils.MalkarResult(true, null, new map<String, object>());
        	}
        	/*
            List<obj> malkarsByContact = GSTAR_DAL.getConnectedByContactsMalkarNum(malkarNum);
            List<obj> malkarsFrom = GSTAR_DAL.getConnectedFromMalkarNum(malkarNum);
            List<obj> malkarsTo = GSTAR_DAL.getConnectedToMalkarNum(malkarNum);
            utils.log(GSTAR_Utils.getTableByYear(malkarsByContact, malkarsFrom, malkarsTo));
            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(malkarsByContact, malkarsFrom, malkarsTo));
            */
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getMalkarWageEarners(String malkarNum){
    	String lang = null;
        if(!String.isEmpty(malkarNum)){
            List<field> wageEarners = GSTAR_DAL.getWageEarnersByMalkarNum(malkarNum, null);
            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(wageEarners).values());
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getReportTotals(){
    	String lang = null;
        List<obj> reportTotals = GSTAR_DAL.getReportTotals(onlyReportTotalsGSTARCondition);
        return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getTableByYear(reportTotals));
    }
    
    @RemoteAction 
    public static GSTAR_Utils.MalkarResult getChartDataDistrict(String tchumPeilutMainNum){
    	String lang = null;
        if(!String.isEmpty(tchumPeilutMainNum)){
            String queryStr = 'Select count(Id) Sum, max(field.field) Label from objr ';
            queryStr += ' group by field.field, objr.field';
            queryStr += ' HAVING objr.field = \'' + tchumPeilutMainNum + '\'';
            queryStr += ' order by count(Id) desc';
            return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getReportResult(queryStr));
        }
        else{
            return new GSTAR_Utils.MalkarResult(false, 'parameter not valid', null);
        }
    }
    
    @RemoteAction 
    @readonly
    public static GSTAR_Utils.MalkarResult getHomeChartMainClassifications(){
		String queryStr = 'Select count(Id) Sum, max(field) Label from obj ';
	    queryStr += ' group by field , field , field ';
	    queryStr += ' HAVING field = true AND field = \'עמותה\' '; // and  field  != \'\'
	    queryStr += ' order by count(Id) desc';
	    return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getReportResult(queryStr));
    }
    
    @RemoteAction 
    @readonly
    public static GSTAR_Utils.MalkarResult getHomeChartDistricts(){
		String queryStr = 'Select count(Id) Sum, max(field.field) Label from objr ';
	    queryStr += ' group by field.field ';
	    queryStr += ' order by count(Id) desc';
	    return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getReportResult(queryStr));
    }
    
    @RemoteAction 
    @readonly
    public static GSTAR_Utils.MalkarResult getHomeChartTmihot(){
		String queryStr = 'Select sum(field) Sum, field Label from obj ';
	    queryStr += ' group by field, field, field ';
	    queryStr += ' HAVING field = \'Gov Support\' AND field = true ';
	    queryStr += ' order by sum(field) desc';
	    return new GSTAR_Utils.MalkarResult(true, null, GSTAR_Utils.getReportResult(queryStr));
    }
    
    @RemoteAction 
    @readonly
    public static List<GSTAR_Utils.TestSupport> getAllTestSupports(){
		List<field> testSupports = GSTAR_DAL.getAllTestSupports();
	    return GSTAR_Utils.createTestSupportList(testSupports);
    }
    
    @RemoteAction
    public static GSTAR_Utils.TestSupport getTestSupportById(String testSupportId){
    	if(String.isNotBlank(testSupportId)){
    		try{
    			testSupportId = EncodingUtil.base64Decode(testSupportId).toString();
    		}catch(Exception e){return null;}
    		
    		List<field> ts = GSTAR_DAL.getTestSupportById(testSupportId);
    		if(!ts.isEmpty()){
    			GSTAR_Utils.TestSupport tsWrapped = new GSTAR_Utils.TestSupport(ts[0]);
    			if(String.isNotBlank(ts[0].field)){
    				String moreConditionClause = ' AND Id != \'' + ts[0].Id + '\' ';
    				List<field> linkedTestSupport = GSTAR_DAL.getTestSupportsByGovName(ts[0].field, moreConditionClause);
    				if(!linkedTestSupport.isEmpty()){
						tsWrapped.LinkedTests = Utils.getListLabelValue(linkedTestSupport, 'field', 'Id');
						for(Utils.LabelValue lv : tsWrapped.LinkedTests){
							lv.value = EncodingUtil.base64Encode(Blob.valueOf((String) lv.value));
						}    					
    				}
    			} 
    			return tsWrapped;
    		}
    		return null;
    	}
		return null;
    }
    
    @RemoteAction 
    public static GSTAR_Utils.CaseWrapper submitCase(GSTAR_Utils.CaseWrapper caseWrapped, String recaptchaToken){
    	Case newCase = caseWrapped.getCase();
    	upsert newCase;
    	caseWrapped.Id = newCase.Id;
    	return caseWrapped;
    }
    
    @RemoteAction 
    public static Map<String, List<object>> searchMalkarsAC(String searchWord){
        Map<String, List<object>> result = new Map<String, List<object>>();
        if(searchWord != null){
        	searchWord = Utils.removeAllUnexpectedCharacters(searchWord.trim());
        	if(searchWord.length() > 1){
		        List<obj> malkars = GSTAR_Utils.getRelevantMalkars(GSTAR_Utils.numOfResultAutoCompleteMalkars, searchWord, GSTAR_Utils.neededFieldsAutoCompleteMalkars, only20MillionTurnover);
		        utils.log(malkars);
		        utils.log(malkars.size());
		        if(malkars.size() < GSTAR_Utils.numOfResultAutoCompleteMalkars){
		        	malkars.addAll(GSTAR_Utils.getRelevantMalkars(GSTAR_Utils.numOfResultAutoCompleteMalkars - malkars.size(), searchWord, GSTAR_Utils.neededFieldsAutoCompleteMalkars, onlyNot20MillionTurnover));
		        	utils.log(malkars.size());
		        }
		        List<field> testSupports = GSTAR_Utils.getRelevantTestSupports(searchWord);
		        
		        if(!malkars.isEmpty()){
		        	//result.put(Label.AutoComplete_Malkars, GSTAR_Utils.getRelevantLabelValues(malkars, searchWord));
		        	result.put('', GSTAR_Utils.getRelevantLabelValues(malkars, searchWord));
		        }
		        
		        List<> similar = Utils_DAL.getSimilarWords(testSupportSimilarType, searchWord);
		        if(!similar.isEmpty() || !testSupports.isEmpty()){
		        	result.put(Label.AutoComplete_TestSupports, new List<Utils.LabelValue>());
		        	utils.log(result);
		        	if(!testSupports.isEmpty()){
		        		result.put(Label.AutoComplete_TestSupports, GSTAR_Utils.getRelevantLabelValues(testSupports, searchWord));
		        		utils.log(result);
			        }
			        if(!similar.isEmpty()){
			        	result.get(Label.AutoComplete_TestSupports).Add(new Utils.LabelValue(Label.AutoComplete_ToTestSupport, '/' + GSTAR_Utils.TestSupportsPageApp));
			        	utils.log(result);
			        }
		        }
        	}
        }        
        return result;
    }
    
    @RemoteAction 
    public static Map<String, List<object>> searchTestSupportsOnlyAC(String searchWord){
        Map<String, List<object>> result = new Map<String, List<object>>();
        if(searchWord != null){
        	searchWord = searchWord.trim();
        	if(searchWord.length() > 1){
		        List<field> testSupports = GSTAR_Utils.getRelevantTestSupports(searchWord);
		        if(!testSupports.isEmpty()){
	        		result.put(Label.AutoComplete_TestSupports, GSTAR_Utils.getRelevantLabelValues(testSupports, searchWord));
	        		utils.log(result);
		        }
        	}
        }
        //go to the malkar search page
        result.put('', new List<Utils.LabelValue>{ new Utils.LabelValue(Label.AutoComplete_ToMalkarSearchPage, new List<object>{'/', GSTAR_Utils.MalkarSearchPageApp, searchWord}) });
        return result;
    }
    
    @RemoteAction  
    @readonly
    public static object getSeachMalkarCount(GSTAR_Utils.FilterWrapper filterObject, GSTAR_Utils.SortWrapper sortObj){
    	try{
    		if(filterObject != null){
    			utils.log(filterObject);
	    		if(String.isNotBlank(filterObject.Search)){
	    			filterObject.Search = Utils.removeAllUnexpectedCharacters(filterObject.Search.trim());
	    			filterObject.pageNumber = 0;
	    			List<obj> malkars = GSTAR_DAL.searchMalkarsByChunk(null, null, null, null, filterObject, 2000, ' Id ');
	    			if(malkars.size() == 2000){
	    				GSTAR_Utils.insertGSTARLog(JSON.serialize(filterObject), Label.Search_2000_Result);
		    			return Label.Search_2000_Result;
		    		}
		    		else{
		    			Integer malkarsCount = malkars.size();
		    			/*if(sortObj != null && String.isEmpty(sortObj.apiName)){
		    				Integer selectedByName = GSTAR_DAL.selectMalkarsByChunk(sortObj.apiName, null, sortObj.sortDesc, null, filterObject, 10).size();
		    				Integer findByName = GSTAR_DAL.searchMalkarsByName(filterObject).size();
		    				if(selectedByName > 0 && selectedByName > findByName){
		    					malkarsCount = malkarsCount + (selectedByName - findByName);
		    				} 
		    			}*/
		    			GSTAR_Utils.insertGSTARLog(JSON.serialize(filterObject), malkarsCount);
		    			return malkarsCount.format();
		    		}
	    		}
	    		else if((filterObject.Turnover != null && !filterObject.Turnover.isEmpty()) || (filterObject.Employees != null && !filterObject.Employees.isEmpty())){
	    			List<obj> malkars = GSTAR_DAL.selectMalkarsByChunk(null, null, null, null, filterObject, null, ' Id ');
	    			GSTAR_Utils.insertGSTARLog(JSON.serialize(filterObject), malkars.size());
	    			return malkars.size().format();
	    		}
	    		else{
	    			Integer malkarsCount = GSTAR_DAL.getMalkarCount(filterObject);
	    			GSTAR_Utils.insertGSTARLog(JSON.serialize(filterObject), malkarsCount);
	    			return malkarsCount.format();
	    		}
    		}
    		else{
    			return '-';
    		}
    	}
    	catch(Exception e){
    		GSTAR_Utils.insertGSTARLog(JSON.serialize(filterObject), 'error');
    		return '-';	
    	}
    }

    @RemoteAction
    public static ApiResult getMalkarsForReport(GSTAR_Utils.FilterWrapper filterObject, GSTAR_Utils.SortWrapper sortObj){
        return searchMalkarsByQueryType(filterObject, sortObj, queryTypeReport);
    }

    public static ApiResult searchMalkarsByQueryType(GSTAR_Utils.FilterWrapper filterObject, GSTAR_Utils.SortWrapper sortObj, string queryType){
        string fieldsWithoutIdName;
        if (queryType == queryTypeSearch){
            fieldsWithoutIdName = GSTAR_DAL.getMalkarFieldsWithoutIdName();
        }
        else if (queryType == queryTypeReport){
            fieldsWithoutIdName = GSTAR_DAL.getMalkarReportFieldsWithoutIdName();
        }
        Integer searchNumOfResult = 30;
        Boolean isLast = false;
        
        Utils.log(filterObject);
        if(sortObj != null && String.isNotBlank(sortObj.apiName)){
            Utils.formatToDateTimeIfNeeded(sortObj.value, 'obj', sortObj.apiName);            
        }
        Set<obj> malkars = new Set<obj>();
        if(filterObject != null && String.isNotBlank(filterObject.Search)){
            filterObject.Search = Utils.removeAllUnexpectedCharacters(filterObject.Search.trim());
        }
        
        if(filterObject != null){
            if(String.isNotBlank(filterObject.Search) && String.isBlank(sortObj.apiName) && filterObject.isSearchByNameFinished != 'true'){
                //Utils.log('page = ' + filterObject.pageNumber);
                if(filterObject.isSearchByNameFinished != 'less20Million'){
                    //Utils.log('from more than 20 milllion');
                    malkars.AddAll(GSTAR_Utils.getRelevantMalkars(searchNumOfResult, filterObject.pageNumber, filterObject.Search,
                                 fieldsWithoutIdName, onlyReportedLast3Years + only20MillionTurnover + GSTAR_DAL.getNewConditionClause(filterObject) ));
                }
                if(malkars.size() < searchNumOfResult){
                    //the first time the filter is less20Million, init pageNumber
                    if(filterObject.isSearchByNameFinished != 'less20Million'){
                        filterObject.isSearchByNameFinished = 'less20Million';
                        filterObject.pageNumber = null; 
                        //Utils.log('isSearchByNameFinished = less20Million');   
                    }
                    //Utils.log('from less than 20 milllion');
                    malkars.AddAll(GSTAR_Utils.getRelevantMalkars(searchNumOfResult, filterObject.pageNumber, filterObject.Search,
                                 fieldsWithoutIdName, onlyReportedLast3Years + onlyNot20MillionTurnover + GSTAR_DAL.getNewConditionClause(filterObject) ));
                }
                
                Integer countOfResultsByName = filterObject.pageNumber != null ? searchNumOfResult * (filterObject.pageNumber + 1 ) : 0;
                if(malkars.size() < searchNumOfResult || countOfResultsByName >= 2000){
                    //add just once chunck of 5 items,  malkars with expected search word, and after that the search continue over the chuncks          
                    malkars.AddAll(GSTAR_Utils.getRelevantMalkars(5, filterObject.Search, fieldsWithoutIdName, onlyNotReportedLast3Years + GSTAR_DAL.getNewConditionClause(filterObject) ));
                    filterObject.isSearchByNameFinished = 'true';
                    filterObject.pageNumber = null; 
                    //Utils.log('isSearchByNameFinished = true');         
                }
            }
            if(malkars.size() < searchNumOfResult){
                //Utils.log('searchByName && page = ' + filterObject.pageNumber);
                List<obj> malkarsResult = GSTAR_DAL.getMalkarsByChunk(sortObj.apiName, sortObj.value, sortObj.sortDesc, sortObj.lastId, filterObject, GSTAR_DAL.CHUNK_SIZE, 'Id, Name, ' + fieldsWithoutIdName);
                malkars.AddAll(malkarsResult);
                isLast = malkarsResult.size() < GSTAR_DAL.CHUNK_SIZE;
            }
        }
        
        filterObject.pageNumber = filterObject.pageNumber != null ? (filterObject.pageNumber + 1) : 1 ;
        Utils.log(malkars.size());
        //Utils.log(filterObject);
        Object result;
        if (queryType == queryTypeSearch){
            result = GSTAR_Malkar.createMalkarList(malkars, null);
        }
        else if (queryType == queryTypeReport){
            result = GSTAR_Utils.createMalkarReportList(malkars, null);
        }
        return new GSTAR_Utils.MalkarSearchResult(true, null, isLast, result, filterObject);
    }
    
    @RemoteAction 
    public static ApiResult searchMalkars(GSTAR_Utils.FilterWrapper filterObject, GSTAR_Utils.SortWrapper sortObj){
    	return searchMalkarsByQueryType(filterObject, sortObj, queryTypeSearch);
    }

    @RemoteAction
    public static ApiResult getMalkarsReportColumns(){
        Map<string, string> results = new Map<string, string>();
        List<> columns = GSTAR_DAL.getReportColumns('obj', 'Hebrew');
        for ( column : columns){
            results.put(column.MasterLabel, column.field);
        }
        return new ApiResult(true, null, results);
    }

    @RemoteAction
    public static ApiResult getCustomGlobalSettings(){
        Map<string, string> results = new Map<string, string>();
        Map<string, obj> settings = obj.getAll();
        if (settings.get('Google_maps_publicKey') != null && settings.get('Google_maps_publicKey').get('field') != null){
            results.put('Google_maps_publicKey', (string)settings.get('Google_maps_publicKey').get('field'));
        }
        else{
            results.put('Google_maps_publicKey', null);
        }
        if (settings.get('Google_recaptcha_publicKey') != null && settings.get('Google_recaptcha_publicKey').get('field') != null){
            results.put('Google_recaptcha_publicKey', (string)settings.get('Google_recaptcha_publicKey').get('field'));
        }
        else{
            results.put('Google_recaptcha_publicKey', null);
        }
        if (settings.get('MaxReportSize') != null && settings.get('MaxReportSize').get('field') != null){
            results.put('MaxReportSize', (string)settings.get('MaxReportSize').get('field'));
        }
        else{
             results.put('MaxReportSize', null);
        }
        return new ApiResult(true, null, results);
    }
}