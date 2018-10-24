public class GSTAR_Utils { 
	
	public static final String PersonalDonationType = 'Personal';
	public static final String ForeignEntityDonationType = 'Foreign Entity';
	public static final String MalkarPeopleCommitteeMemberType = 'Committee Member';
	public static final String MalkarCityActivityType = 'Activity';
	public static final String OnlyLastAdditionalActivities =  ' AND ( c != \'' + MalkarCityActivityType + '\' OR ( c = \'' + MalkarCityActivityType + '\' AND c = true)) ';
	public static final String GreenDocumentsTermsType = 'Terms';
	public static final String TmihotEstatesType = 'Estates';
	public static final String TmihotGovSupportType = 'Gov Support';
	public static final String TmihotNationalInsuranceType = 'National_Insurance';
	
	public static final String MalkarPageApp = 'organization';
	public static final String TestSupportsPageApp = 'test-support';
	public static final String MalkarSearchPageApp = 'search-malkars';
	public static final String GlobalPageApp = 'page';
	public static final String ContactPageApp = 'contact';
	public static final String HomePageApp = 'home';
    
    public static final String MalkarInfoPage = 'info';
	public static final String MalkarDocumentsPage = 'documents';
	public static final String MalkarGovsupportPage = 'govsupport';
	public static final String MalkarGovservicesPage = 'govservices';
	public static final String MalkarDonationsPage = 'donations';
	public static final String MalkarPeoplePage = 'people';
	public static final String MalkarContactPage = 'contact';
	public static final String MalkarConnectedPage = 'connected';
	public static final String MalkarWageearnersPage = 'wageearners';
	public static final String MalkarVolunteeringPage = 'volunteering';
    
	public static final String annualFinancialRecortTypeDeveloperName = 'annual_financial';
	public static final String annualDescriptiveRecortTypeDeveloperName = 'annual_descriptive';
	public static final String annualSalaryRecortTypeDeveloperName = 'annual_salary';
	public static final String annualTakinLetterRecortTypeDeveloperName = 'annual_takin_letter';
	public static final String annualRegCertRecortTypeDeveloperName = 'gov_files_reg_certificate';

	public static final String annualFinancialFieldName = 'c';
	public static final String annualDescriptiveFieldName = 'c';
	public static final String annualSalaryFieldName = 'c';
	public static final String annualTakinLetterFieldName = 'c';
	public static final String annualRegCertFieldName = 'c';
	public static final String HeletzPicklistValue = 'חל"צ';
	public static final String MalkarPicklistValue = 'עמותה';
	public static final String HekdeshPicklistValue = 'הקדש';
	
	public static final Integer numOfResultAutoCompleteMalkars = 8;
	public static final String neededFieldsAutoCompleteMalkars = 'c';
    
    public class MalkarResult extends ApiResult{
        
        public MalkarResult(Boolean success, String errorMsg, Object data) {
            super(success, errorMsg, data);
        }
        public MalkarResult(Boolean success, String errorMsg, Boolean isLast, Object data) {
            super(success, errorMsg, isLast, data);
        }
    }
    
    public class MalkarSearchResult extends ApiResult{
        public MalkarSearchResult(Boolean success, String errorMsg, Boolean isLast, Object data, FilterWrapper myFilter){
            super(success, errorMsg, isLast, data); 
            this.filter = myFilter;
        }
        public FilterWrapper filter;
    }
    
    public virtual class ConfigField{
    	public String apiName;
    	public String label;
    	public String tooltip;
    	
    	public ConfigField(String apiName, String label, String tooltip){
    		this.apiName = apiName;
    		this.label = label;
    		this.tooltip = tooltip;
    	}
    }
    public class ConfigSort extends ConfigField{
    	public String name;
    	
    	public ConfigSort(String apiName, String label, String tooltip, String name){
    		super(apiName, label, tooltip);
    		this.name = name;
    	}
    }
    public class ConfigSlider extends ConfigField{
    	public Decimal min;
    	public Decimal max;
    	public List<Utils.LabelValue> labelValues;
    	
    	public ConfigSlider(String apiName, String label, String tooltip, Decimal min, Decimal max){
    		super(apiName, label, tooltip);
    		this.min = min;
    		this.max = max;
    	}
    	
    	public ConfigSlider(String apiName, String label, String tooltip, List<Utils.LabelValue> labelValues){
    		super(apiName, label, tooltip);
    		this.labelValues = labelValues;
    	}
    }
    public class ConfigDropdown extends ConfigField{
    	public List<Utils.LabelValue> options;
    	
    	public ConfigDropdown(String apiName, String label, String tooltip, List<Utils.LabelValue> options){
    		super(apiName, label, tooltip);
    		this.options = options;
    	}
    	public ConfigDropdown(String apiName, String label, String tooltip, Set<Utils.LabelValue> options){
    		super(apiName, label, tooltip);
    		this.options = new List<Utils.LabelValue>(options);
    	}
    }
    public class ConfigAutoComplete extends ConfigField{
    	public String functionFullName;
    	public String functionReverseFullName;
    	
    	public ConfigAutoComplete(String apiName, String label, String tooltip, String functionFullName, String functionReverseFullName){
    		super(apiName, label, tooltip);
    		this.functionFullName = functionFullName;
    		this.functionReverseFullName = functionReverseFullName;
    	}
    }
    
    public class FilterWrapper{
    	public String Search; //c
    	public Integer pageNumber;
    	public boolean CurrentNihulTakinActive;//c
    	public boolean Approval46;//c
    	public boolean Reported_Last_3_Years;//c
    	public boolean ADMN_GovSupportSum;//c
    	public boolean ADMN_Gov_Connection_Sum;//c
    	public boolean ADMN_Foreign_Entity_Donation_Sum; //c
    	public List<Decimal> Turnover;// c - c
    	public List<Decimal> Employees; //c - c
    	public List<String> Sug_Hitagdut;//c
    	public List<String> CLSS_Main_Classification_Num;//c
    	public List<String> CLSS_Secondary_Classification_Num; //c
    	public String MalkarLocation; //c
    	public String isSearchByNameFinished;
    	
    	public boolean isEmpty(){
    		return String.isBlank(this.Search) && this.CurrentNihulTakinActive != true && this.Approval46 != true && this.Reported_Last_3_Years != true && 
    				this.ADMN_GovSupportSum != true && this.ADMN_Gov_Connection_Sum != true && this.ADMN_Foreign_Entity_Donation_Sum != true && 
    				(this.Turnover == null || this.Turnover.isEmpty()) && (this.Employees == null || this.Employees.isEmpty()) && 
    				(this.Sug_Hitagdut == null || this.Sug_Hitagdut.isEmpty()) &&
    				(this.CLSS_Main_Classification_Num == null || this.CLSS_Main_Classification_Num.isEmpty()) && 
    				(this.CLSS_Secondary_Classification_Num == null || this.CLSS_Secondary_Classification_Num.isEmpty()) && 
    				String.isBlank(this.MalkarLocation) && String.isBlank(this.isSearchByNameFinished) ;
    	}
    }
    
    public class SortWrapper{
    	public String apiName;
    	public boolean sortDesc;
    	public object value;
    	public Id lastId;
    }
    
    public class CaseWrapper{
    	public String Id;
    	public String name;
    	public String phone;
    	public String email;
    	public String subject;
    	public String body;
    	
    	public Case getCase(){
    		Case newCase = new Case(SuppliedName = this.name,
		    						SuppliedPhone = this.phone,
		    						SuppliedEmail = this.email,
		    						Type = this.subject,
		    						Description = this.body);
			if(String.isNotBlank(this.Id)){
				newCase.Id = this.Id;
			}
			return newCase;
    	}
    }
    
    public class GSTAR_Malkar_Full extends GSTAR_Malkar{
    	public String isStatusActiveText {get; set;}
    	public Boolean isApprovedAsExperiencePlace {get; set;}
		public Decimal employees {get; set;}
		public Decimal volunteers {get; set;}
		public Integer govSupportSum {get; set;}
        public Decimal govSupportLastYear {get;set;}
        public Integer nationalInsuranceSum {get; set;}
        public Decimal nationalInsuranceLastYear {get;set;}
		public Integer govConnectionSum {get; set;}
        public Decimal govConnectionLastYear {get;set;}
		public String addressStreet {get; set;}
		public String addressHouseNum {get; set;}
		public String addressZipCode {get; set;}
		public String phoneNumber {get; set;}
		public String lastAddDataYear {get; set;}
		public String emailMalkar  {get; set;}
		public String tchumPeilutMain {get;set;}
		public String tchumPeilutMainNum {get;set;}
		public string machoz {get;set;}
		public Datetime lastModifiedDate {get; set;}
		public String logoUrl{get;set;}
		public String founderNames {get;set;} 
		
		public Decimal lat {get;set;}
		public Decimal lng {get;set;}
		public String geolocationDescription {get;set;}
		
		public List<Utils.CityGeolocation> malkarCities {get;set;}
		/*
		public String faxNumber {get; set;}
		public Set<String> phoneNumbers {get; set;}
		
		public String youtubeUrl{get;set;}
		public String facebookUrl{get;set;}
		public String websiteUrl{get;set;}
		public String volunteeringUrl{get;set;}
		public String donationUrl{get;set;}
		*/
		public map<String, Boolean> InactiveMenu {set; get;}
		
		public GreenInfo greenInfo {get;set;}
    	
    	public GSTAR_Malkar_Full(obj malkar, string lang){
    		super(malkar, lang);
    		this.isStatusActiveText = malkar.c;
    		this.isApprovedAsExperiencePlace = malkar.c;
			this.employees = malkar.r != null ? malkar.r.c : null;
			this.volunteers = malkar.r != null ? malkar.r.c : null;
			this.govSupportSum = Integer.valueOf(malkar.c);
            this.govSupportLastYear = malkar.c != null ? malkar.c : null;
            
            this.nationalInsuranceSum = Integer.valueOf(malkar.c);
            this.nationalInsuranceLastYear = malkar.c != null ? malkar.c : null;
            
			this.govConnectionSum = Integer.valueOf(malkar.c);
            this.govConnectionLastYear = malkar.c != null ? malkar.c.Year() : null;
			this.addressStreet = malkar.c;
			this.addressHouseNum = malkar.c;
			this.addressZipCode = malkar.c;
			this.phoneNumber = malkar.c;
			this.lastAddDataYear = malkar.c;
			this.emailMalkar = malkar.c;
			this.tchumPeilutMain = malkar.c;//String.isNotBlank(malkar.c) ? (List<String>)JSON.deserialize(malkar.c, List<String>.class) : null;
			this.tchumPeilutMainNum = malkar.c;
			this.machoz = malkar.c;
			this.lastModifiedDate = malkar.lastModifiedDate;
			if (String.isBlank(malkar.c)){
	            this.logoUrl = null;
	        }
	        else{
	        	this.logoUrl = malkar.c.replace('http://', '');
	        	this.logoUrl = (Site.getbaseUrl()!=''? Site.getbaseUrl()  : url.getSalesforceBaseUrl().toExternalForm() ) + '/' + this.logoUrl;
	            //this.logoUrl = (Site.getbaseUrl()!=''? Site.getbaseUrl() : url.getSalesforceBaseUrl().toExternalForm() +'/apex')+malkar.c;
	        }
	        this.founderNames = malkar.c;
			
			this.lat = malkar.s;
			this.lng = malkar.s;
			
			if(!malkar.r.isEmpty()){
				this.malkarCities = new List<Utils.CityGeolocation>();
				for(objr malkarCity : malkar.r){
					if(malkarCity.c != MalkarCityActivityType || 
						(malkarCity.c == MalkarCityActivityType && malkarCity.obj == malkar.c)){
						//if it is the same city, if it is an activity type then take the description but if not (it is an address type) then if the geolocation of the malkar is null fill it
						if(malkarCity.r.c == malkar.c){
							if(malkarCity.c == MalkarCityActivityType){
								this.geolocationDescription = malkarCity.c;
							}
							else if(this.lat == null || this.lng == null){
								this.lat = malkarCity.r.s;
								this.lng = malkarCity.r.s;
							}
						}
						else{
							malkarCities.Add(new Utils.CityGeolocation(malkarCity.r.s, malkarCity.r.s, malkarCity.c));
						}
					}
				}
				
				if((this.lat == null || this.lng == null) && !this.malkarCities.isEmpty()){
					this.lat = this.malkarCities[0].lat;
					this.lng = this.malkarCities[0].lng;
					this.malkarCities.remove(0);
				}
			}
			this.greenInfo = new GreenInfo(malkar.r, malkar);
			/*
			this.faxNumber = malkar.r != null && malkar.r.c != null ? malkar.r.c : malkar.c;
			this.PhoneNumbers = new Set<String>();
			this.PhoneNumbers.Add(malkar.c);
			this.PhoneNumbers.Add(malkar.c);
			if(malkar.r != null){
				this.PhoneNumbers.Add(malkar.r.c);
				this.PhoneNumbers.Add(malkar.r.c);
			}
			this.PhoneNumbers.remove(null);
			
			this.youtubeUrl = malkar.r != null ? malkar.r.c : null;
			this.facebookUrl = malkar.r != null ? malkar.r.c : null;
			this.websiteUrl = malkar.r != null ? malkar.r.c : null;
			this.volunteeringUrl = malkar.r != null ? malkar.r.c : null;
			this.donationUrl = malkar.r != null ? malkar.r.c : null;
			*/
    	}
    }

    public class Malkar_Report{
		public string Id {get;set;} //Id
		public string Name {get;set;} //Name
		public string regNum {get;set;} //c
		public string sugHitagdut {get;set;} //c
		public Decimal orgYearFounded {get;set;} //c
		public string orgGoal {get;set;} //c
		public string lastGovCertLinkURL {get; set;} //r.c
		public string tchumPeilutMain {get;set;} //c
		public string tchumPeilutSecondary {get;set;} //c
		public string lastNihulReportLinkURL {get; set;} //r.c
		public Boolean hasReports {get;set;} //c
		public Boolean hasProperManagement {get;set;} //c
		public string lastNihulTakinYear {get; set;} //c
		public Boolean hasGovConnection {get; set;} //c
		public Boolean hasTmihot {get; set;} //c
		public Boolean hasForeignDonation {get; set;} //c
		public string lastFinancialReportYear {get; set;} //c;
		public string lastDescriptiveReportYear {get; set;}//c
		public string lastDescriptiveReportLinkURL {get; set;} //r.c
		public string last5SalaryReportYear {get; set;} //c
		public Integer turnover {get;set;} //r.c
		public String lastAddDataYear {get; set;} //c
		public Decimal employees {get; set;} //r.c
		public Decimal volunteers {get; set;} //r.c
		public string machoz {get;set;} //c
		public string activityLocLastYr {get; set;} //c
		public string city {get;set;} //c
    	public String addressStreet {get; set;} //c
    	public String lastFinancialReportLinkURL {get; set;} //r.c

    	public Malkar_Report(obj malkar, string lang){
    		setName(malkar, lang);
    		this.Id = malkar.Id;
	        this.regNum = malkar.c;
	        this.sugHitagdut = malkar.c;
	        this.orgYearFounded = malkar.c;
	        this.orgGoal = malkar.c;
	        this.lastGovCertLinkURL = malkar.r != null ? malkar.r.c : null;
	        this.tchumPeilutMain = malkar.c;
	        if(String.isNotBlank(malkar.c)){
	        	Set<String> tempSet;
		        if(malkar.c.startsWith('[')){
					tempSet = (Set<String>) JSON.deserialize(malkar.c, Set<String>.class);
				}
				else{
					tempSet = new Set<String>{ malkar.c };
				}
				this.tchumPeilutSecondary = String.join(new List<String>(tempSet), ', ');
	        }
	        this.lastNihulReportLinkURL = malkar.r != null ? malkar.r.c : null;
	        this.lastFinancialReportLinkURL = malkar.r != null ? malkar.r.c : null;
	        this.hasReports = malkar.c ? true : false;
	        this.hasProperManagement = malkar.c; 
	        this.lastNihulTakinYear = malkar.c;
	        this.hasGovConnection = malkar.c ? true : false;
	        this.hasTmihot = malkar.c ? true : false;
	        this.hasForeignDonation = malkar.c;
	        this.lastFinancialReportYear = malkar.c;
	        this.lastDescriptiveReportYear = malkar.c;
	        this.lastDescriptiveReportLinkURL = malkar.r != null ? malkar.r.c : null;
	        this.last5SalaryReportYear = malkar.c; 
	        if(malkar.r != null){
				obj minTurnover = obj.getInstance('GSTAR_MinTurnover');
				if(minTurnover != null && String.isNotBlank(minTurnover.field)){
					Integer minTurnoverInt = Integer.valueOf(minTurnover.field);
					this.turnover = malkar.r.c >= minTurnoverInt ? Integer.valueOf(malkar.r.c) : null;
				}
				else{
					this.turnover = Integer.valueOf(malkar.r.c);
				}
			}
			this.lastAddDataYear = malkar.c;
			this.employees = malkar.r != null ? malkar.r.c : null;
			this.volunteers = malkar.r != null ? malkar.r.c : null;
			this.machoz = malkar.c;
			this.activityLocLastYr = malkar.c;
			this.city = malkar.c;
			this.addressStreet = malkar.c;
    	}

    	public void setName(obj malkar, string lang){
	        if (lang == 'iw' && String.isNotBlank(malkar.c)){
	            this.Name = malkar.c;
	        }
	        else if (lang == 'en_US' && String.isNotBlank(malkar.c) && malkar.c != '-'){
	            this.Name = malkar.c;
	        }
	        else if (lang == 'ar' && String.isNotBlank(malkar.c) && malkar.c != '-'){
	            this.Name = malkar.c;
	        }
	        else if (String.isNotBlank(malkar.c)){
	            this.Name = malkar.c;
	        }
	        else{
	            this.Name = malkar.Name;
	        }
	    }
    }

    public static List<Malkar_Report> createMalkarReportList(List<obj> malkarList, string lang){
        List<Malkar_Report> returnList = new List<Malkar_Report>();
        for (obj malkar : malkarList){
            returnList.add(new Malkar_Report(malkar, lang));
        }
        return returnList;
    }

    public static Set<Malkar_Report> createMalkarReportList(Set<obj> malkarList, string lang){
        Set<Malkar_Report> returnList = new Set<Malkar_Report>();
        for (obj malkar : new List<obj>(malkarList)){
            returnList.add(new Malkar_Report(malkar, lang));
        }
        return returnList;
    }
    
    public class GreenInfo{
    	public String faxNumber {get; set;}
    	public Set<String> phoneNumbers {get; set;}
    	
    	public String youtubeUrl {get;set;}
		public String facebookUrl {get;set;}
		public String websiteUrl {get;set;}
		public String volunteeringUrl {get;set;}
		public String donationUrl {get;set;}
		
		public String description {get;set;}
		
		public String city {get;set;}
		public String addressStreet {get; set;}
		public String addressHouseNum {get; set;}
		public String addressZipCode {get; set;}
		public String email {get; set;}
    	
    	public GreenInfo(obj gi, obj malkar){
    		gi = gi != null ? gi : new obj();
    		this.faxNumber = gi.c != null ? gi.c : malkar.c;
			this.PhoneNumbers = new Set<String>();
			//this.PhoneNumbers.Add(malkar.c);
			//this.PhoneNumbers.Add(malkar.c);
			this.PhoneNumbers.Add(gi.c);
			this.PhoneNumbers.Add(gi.c);
			this.PhoneNumbers.remove(null);
			
			this.youtubeUrl = Utils.getStandardUrl(gi.c);
			this.facebookUrl = Utils.getStandardUrl(gi.c);
			this.websiteUrl = Utils.getStandardUrl(gi.c);
			this.volunteeringUrl = Utils.getStandardUrl(gi.c);
			this.donationUrl =  Utils.getStandardUrl(gi.c);
			
			this.description = gi.c;
			
			this.city = gi.c;
			this.addressStreet = gi.c;
			this.addressHouseNum = gi.c;
			this.addressZipCode = gi.c > 0 ? String.valueOf(gi.c) : null;
			
			this.email = gi.c;
    	}
    }
    
    public class TestSupport{
    	public String Id {get; set;}
    	public String OrganType {get; set;}
    	public String Type {get; set;}
    	public String Budget {get; set;}
    	public String FileLink {get; set;}
    	public String SupportName {get; set;}
    	public String Language {get; set;}
    	public String Description {get; set;}
    	public Date StartDate {get; set;}
    	public Date EndDate {get; set;}
    	public Date DateUpdated {get; set;}
    	public Date DateCreated {get; set;}
    	public String YearCreated {get; set;}
    	public Date MaxUpdatedCreatedDate {get; set;}
    	
    	public List<Utils.LabelValue> LinkedTests {get;set;}
    
    	public TestSupport(c ts){
			this.Id = EncodingUtil.base64Encode(Blob.valueOf(ts.Id)); 
			this.OrganType = ts.c;
			this.Type = ts.c;
			this.Budget = ts.c;
			this.FileLink = ts.c;
			this.SupportName = ts.c;
			this.Language = ts.c;
			this.Description = ts.c;
			this.StartDate = ts.c;
			this.EndDate = ts.c;
			this.DateUpdated = ts.c;
			this.DateCreated = ts.c;
			this.YearCreated = ts.c;
			this.MaxUpdatedCreatedDate = ts.c;
    	}
    }
    
    public static c convertToLogObject(FilterWrapper filter){
    	c log = new c();
    	log.c = filter.Search;
		if(filter.CurrentNihulTakinActive != null){
			log.c = filter.CurrentNihulTakinActive;
		}
		if(filter.Approval46 != null){
			log.c = filter.Approval46;
		}
		if(filter.Reported_Last_3_Years != null){
			log.c = filter.Reported_Last_3_Years;
		}
		if(filter.ADMN_GovSupportSum != null){
			log.c = filter.ADMN_GovSupportSum;
		}
		if(filter.ADMN_Gov_Connection_Sum != null){
			log.c = filter.ADMN_Gov_Connection_Sum;
		}
		if(filter.ADMN_Foreign_Entity_Donation_Sum != null){
			log.c = filter.ADMN_Foreign_Entity_Donation_Sum;
		}
		if(filter.Turnover != null && !filter.Turnover.isEmpty()){
			log.c = filter.Turnover[0];
			if(filter.Turnover.size() > 1){
				log.c = filter.Turnover[1];				
			}
		}
		if(filter.Employees != null && !filter.Employees.isEmpty()){
			log.c = filter.Employees[0];
			if(filter.Employees.size() > 1){
				log.c = filter.Employees[1];				
			}
		}
		log.c = filter.Sug_Hitagdut != null && !filter.Sug_Hitagdut.isEmpty() ? json.serialize(filter.Sug_Hitagdut) : null;
		log.c = filter.CLSS_Main_Classification_Num != null && !filter.CLSS_Main_Classification_Num.isEmpty() ? json.serialize(filter.CLSS_Main_Classification_Num) : null;
		log.c = filter.CLSS_Secondary_Classification_Num != null && !filter.CLSS_Secondary_Classification_Num.isEmpty() ? json.serialize(filter.CLSS_Secondary_Classification_Num) : null;
		log.c = filter.MalkarLocation;
    	return log;
    }
    
    @future
    public static void insertGSTARLog(String filterStr, String more){
    	if(String.isNotBlank(filterStr)){
    		FilterWrapper filter = (FilterWrapper) JSON.deserialize(filterStr, FilterWrapper.class);
    		if(!filter.isEmpty()){
    			c log = convertToLogObject(filter);
	    		log.c = more;
	    		insertGSTARLog(log);
    		}
    		else{
    			utils.log('the filter is empty');
    		}
    	}
    }
    
    @future
    public static void insertGSTARLog(String filterStr, Integer counter){
    	if(String.isNotBlank(filterStr)){
    		FilterWrapper filter = (FilterWrapper) JSON.deserialize(filterStr, FilterWrapper.class);
    		if(!filter.isEmpty()){
    			c log = convertToLogObject(filter);
	    		log.c = counter;
    			insertGSTARLog(log);
    		}
    		else{
    			utils.log('the filter is empty');
    		}
    	}
    }
    
    public static void insertGSTARLog(c log){
		if(log != null){
			try{
				insert log;
			}
			catch(Exception e){
				system.debug(e);    				
			}
		}
    }
    
    public static List<TestSupport> createTestSupportList(List<c> testSupportList){
        List<TestSupport> returnList = new List<TestSupport>();
        for (c testSupport : testSupportList){
            returnList.add(new TestSupport(testSupport));
        }
        return returnList;
    }
    
    public class TableListContainer{
    	public String Label;
	    public Decimal Sum;
        public map<String, TableByYear> DataMap;
	    
	    public TableListContainer(String Label, map<String, TableByYear> DataMap){
	    	this.Label = Label;
	    	this.DataMap = DataMap;
	    	Decimal sum = 0;
	    	if(DataMap != null && !DataMap.isEmpty()){
	    		for(TableByYear tby: DataMap.values()){
    				sum += tby.Sum > 0 ? tby.Sum : 0;
	    		}
	    	}
	    	this.Sum = sum;
	    }
    }
    
    public class TableByYear{
	    public String Label;
	    public Decimal Sum;
	    public List<DataByYear> Data;
        public map<String, DataListContainer> DataMap;
	    
	    public TableByYear(String Label){
	    	this.Label = Label;
	    	this.Sum = 0;
	    }
	    public TableByYear(String Label, List<DataByYear> Data){
	    	this.Label = Label;
	    	this.Data = Data;
	    	Decimal sum = 0;
	    	if(Data != null && !Data.isEmpty()){
	    		for(DataByYear dby: Data){
	    			sum += dby.Amount > 0 ? dby.Amount : 0;
	    		}
	    	}
	    	this.Sum = sum;
	    }
	    
	    public void Add(DataByYear dby){
            if(this.Data == null){
                this.Data = new List<DataByYear>();
            }
	    	this.Data.Add(dby);
	    	this.Sum += dby.Amount > 0 ? dby.Amount : 0;
	    }
	    public void Add(DataByYear dby, String key){
            Add(dby, key, false);
	    }
        public void Add(DataByYear dby, String key, boolean addIndexToSubLabel){
            Add(null, dby, key, addIndexToSubLabel);
	    }
	    public void Add(Integer index, DataByYear dby, String key){
            Add(index, dby, key, false);
	    }
	    public void Add(Integer index, DataByYear dby, String key, boolean addIndexToSubLabel){
            if(this.DataMap == null){
                this.DataMap = new map<String, DataListContainer>();
            }
            if(this.DataMap.get(key) == null){
                this.DataMap.put(key, new DataListContainer(key));
            }
            if(index != null){
            	this.DataMap.get(key).Add(index, dby);
            }
            else{
            	this.DataMap.get(key).Add(dby);
            }
	    	if(addIndexToSubLabel == true){
	    		Integer counter = this.DataMap.get(key).Data.size();
	    		dby.SubLabel += ' ' + counter; 
	    	}
	    	this.Sum += dby.Amount > 0 ? dby.Amount : 0;
	    }
	}
	
	public class DataListContainer{
    	public String Label;
	    public Decimal Sum;
        public List<DataByYear> Data;
	    
	    public DataListContainer(String Label){
	    	this.Label = Label;
	    	this.Sum = 0;
	    }
	    
	    public void Add(DataByYear dby){
	    	Add(null, dby);
	    }
	    
	    public void Add(Integer index, DataByYear dby){
	    	if(this.Data == null){
	    		this.Data = new List<DataByYear>();
	    	}
	    	if(index != null && this.Data.size() > index){
	    		this.Data.Add(index, dby);
	    	}
	    	else{
	    		this.Data.Add(dby);
	    	}
	    	
	    	this.Sum += dby.Amount > 0 ? dby.Amount : 0;
	    }
    }
    
    public class DataByYear{
    	public String MainLabel; 
    	public String SubLabel;
    	public Decimal Amount;
    	public String Type;
    	public List<Object> InternalLink;
    	public String CurrencyType;
    	
    	public DataByYear(String MainLabel, String SubLabel, Decimal Amount){
    		this.MainLabel = MainLabel;
    		this.SubLabel = SubLabel;
    		this.Amount = Amount;
    	}
    	public DataByYear(String MainLabel, String SubLabel, Decimal Amount, String CurrencyType){
    		this.MainLabel = MainLabel;
    		this.SubLabel = SubLabel;
    		this.Amount = Amount;
    		this.CurrencyType = CurrencyType;
    	}
    	public DataByYear(String MainLabel, String SubLabel, String Type){
    		//it is a file, type = file type like pdf, link, doc, excel, txt, MainLabel = file name, SubLabel = file link
    		this.MainLabel = MainLabel;
    		this.SubLabel = SubLabel;
    		this.Type = Type;
    		this.InternalLink = null;
    	}
    	public DataByYear(String MainLabel, String SubLabel, String Type, List<Object> InternalLink){
    		this.MainLabel = MainLabel;
    		this.SubLabel = SubLabel;
    		this.Type = Type;
    		this.InternalLink = InternalLink;
    	}
    }
    
    public class ReportsData{
    	public List<TableByYear> tbyData;
    	public List<DataByYear> annualTakins;
    	public List<DataByYear> malkarUserDocuments;
    	public DataByYear regCertificate;
    	
    	public ReportsData(List<TableByYear> tbyData, List<DataByYear> annualTakins, List<DataByYear> malkarUserDocuments, DataByYear regCertificate){
    		this.tbyData = tbyData;
    		this.annualTakins = annualTakins;
    		this.malkarUserDocuments = malkarUserDocuments;
    		this.regCertificate = regCertificate;
    	}
    }
    
    public class TmihotsData{
    	public List<TableByYear> govSupports;
    	public List<TableByYear> nationalInsuranceSupports;
    	
    	public TmihotsData(List<TableByYear> govSupports, List<TableByYear> nationalInsuranceSupports){
    		this.govSupports = govSupports;
    		this.nationalInsuranceSupports = nationalInsuranceSupports;
    	}
    }
    
     
    public static DataByYear getDataByYear(obj report){
    	if(report != null){
    		return new DataByYear(report.RecordType.Name, report.c, 'pdf');
    	}
    	return null;
    }
    public static List<DataByYear> getDataByYear(List<obj> reportList){
    	return getDataByYear(reportList, null);
    }
    public static List<DataByYear> getDataByYear(List<obj> reportList, String labelStr){
    	Map<String, DataByYear> dbyMap = new Map<String, DataByYear>();
    	if(reportList != null){
    		for(obj report : reportList){
    			String key;
    			if(String.isNotBlank(labelStr)){
    				key = labelStr + ' ' + report.c;
    			}
    			else{
    				key = report.RecordType.Name + ' ' + report.c;
    			}
    			
    			if(!dbyMap.containsKey(key)){
					dbyMap.put(key, new DataByYear(key , report.c, report.c ? 'pdf' : 'hidden'));    				
    			}
	    	}
    	}
    	return dbyMap.values();
    }
    
    public static List<DataByYear> getDataByYear(List<c> reportList){
    	Map<String, DataByYear> dbyMap = new Map<String, DataByYear>();
    	if(reportList != null){
    		for(c report : reportList){
    			String label = report.c == GreenDocumentsTermsType ? Label.Terms : report.c;
    			String key = report.c == GreenDocumentsTermsType ? label : label + report.c;
    			if(!dbyMap.containsKey(key)){
    				dbyMap.put(key, new DataByYear(label , report.c, 'pdf'));
    			}
	    	}
    	}
    	return dbyMap.values();
    }
    
    public static map<String, TableByYear> getTableByYear(List<obj> reportList){
    	return getTableByYear(reportList, null, null);
    }
    public static map<String, TableByYear> getTableByYear(List<obj> reportList, List<ReportResult> wageEarnersByYear, String malkarNum){
    	map<String, TableByYear> tbyMap = new map<String, TableByYear>();
    	set<String> keys = new Set<String>();
    	for(obj report : reportList){
    		if(tbyMap.get(report.c) == null){
    			tbyMap.put(report.c, new TableByYear(Label.Malkar_Docs_TableLabel + ' ' + report.c));
    		}
    		String key = report.c + '_' + report.RecordType.Name;
    		if(!keys.contains(key)){
    			String text = report.RecordType.Name + ' ' + report.c;
    			text +=  !report.c ? ' - ' + Label.GSTAR_NonActiveReports : '';
    			tbyMap.get(report.c).Add(new DataByYear(text , report.c, report.c ? 'pdf' : 'hidden'));	
    			keys.Add(key);
    		}
    	}
    	
    	if(wageEarnersByYear != null){
    		List<RecordType> recordTypes = Utils_DAL.getRecordTypeInfo('obj', annualSalaryRecortTypeDeveloperName);
    		if(!recordTypes.isEmpty()){
	    		String wageEarnerRecordTypeName = recordTypes[0].Name;
		    	for(ReportResult rr : wageEarnersByYear){
		    		String reportInTableName = wageEarnerRecordTypeName + ' ' + rr.Label;
		    		List<object> linkToWageEarner = new List<object>{'/', MalkarPageApp, malkarNum, 'people', new map<String, String>{'year' => rr.Label}};
		    		//String linkToWageEarner = '/' + MalkarPageApp + '/' + malkarNum + '/people;year=' + rr.Label;
		    		DataByYear newDBY = new DataByYear(reportInTableName , null, 'link', linkToWageEarner);
		    		String key = rr.Label + '_' + wageEarnerRecordTypeName;
		    		if(tbyMap.get(rr.Label) == null){
		    			tbyMap.put(rr.Label, new TableByYear(Label.Malkar_Docs_TableLabel + ' ' + rr.Label));
		    			tbyMap.get(rr.Label).Add(newDBY);
		    			keys.Add(key);
		    		}
		    		else{ 
			    		Integer indexActive = null;
			    		Integer indexInactive = null;
			    		String reportInTableNameInactive = reportInTableName + ' - ' + Label.GSTAR_NonActiveReports;
			    		for(Integer i = 0 ; i < tbyMap.get(rr.Label).Data.size() ; i++){
			    			if(tbyMap.get(rr.Label).Data[i].MainLabel == reportInTableName){
		    					indexActive = i;
			    			}
			    			if(tbyMap.get(rr.Label).Data[i].MainLabel == reportInTableNameInactive){
		    					indexInactive = i;
			    			}
			    		}
			    		if(indexActive != null){
			    			tbyMap.get(rr.Label).Data.remove(indexActive);
			    		}
			    		if(indexInactive != null){
			    			tbyMap.get(rr.Label).Data.remove(indexInactive);
			    		}
			    		tbyMap.get(rr.Label).Add(newDBY);
		    		}
		    	} 
    		}
    	}
    	return tbyMap;
    }
    
    public static map<String, TableByYear> getTableByYear(List<obj> tmihots){
    	map<String, TableByYear> tbyMap = new map<String, TableByYear>();
    	List<obj> groupedGovSupport = getGroupedGovSupport(tmihots);
    	for(obj tmiha : groupedGovSupport){
    		if(tbyMap.get(tmiha.c) == null){
    			tbyMap.put(tmiha.c, new TableByYear(Label.Malkar_GovSupport_TableLabel + ' ' + tmiha.c));
    		}
			tbyMap.get(tmiha.c).Add(new DataByYear(tmiha.c, tmiha.c, tmiha.c));
    	}
    	return tbyMap;
    }
    
    public static List<obj> getGroupedGovSupport(List<obj> tmihots){
    	map<String, obj> govSupports = new map<String, obj>();
    	for(obj tmiha : tmihots){
    		String key = tmiha.c + '_' + tmiha.c + '_' + tmiha.c;
    		obj tmp = govSupports.get(key);
    		if(tmp == null){
    			govSupports.put(key, tmiha);
    		}
    		else if(tmiha.c > 0){
    			tmp.c += tmiha.c;
    		}
    	}
    	return govSupports.values();
    }
    
    public static map<String, TableListContainer> getTableByYear(List<obj> govConnectionsActive, List<obj> govConnectionsInactive){
    	map<String, TableByYear> tbyMapActive = getTableByYear(govConnectionsActive);
    	map<String, TableByYear> tbyMapInactive = getTableByYear(govConnectionsInactive);
    	
    	TableListContainer tableListContainerActive = new TableListContainer(Label.Malkar_GovServices_TableLabel_Active, tbyMapActive);
    	TableListContainer tableListContainerInactive = new TableListContainer(Label.Malkar_GovServices_TableLabel_Inactive, tbyMapInactive);
    	return new map<String, TableListContainer>{	'active' => tableListContainerActive, 
    												'inactive' => tableListContainerInactive};
    }
    
    public static map<String, TableByYear> getTableByYear(List<obj> govConnections){
    	map<String, TableByYear> tbyMap = new map<String, TableByYear>();
    	for(obj govConnection : govConnections){
    		String key = Label.Malkar_GovServices_TableLabel_Quarter + ' ' + govConnection.c + '/' + govConnection.c;
    		
    		if(tbyMap.get(key) == null){
    			tbyMap.put(key, new TableByYear(key));
    		}
			tbyMap.get(key).Add(new DataByYear(null, govConnection.c, govConnection.c), govConnection.c);
    	}
    	return tbyMap;
    }
    
    public static map<String, TableByYear> getTableByYear(List<obj> donations){
    	map<String, TableByYear> tbyMap = new map<String, TableByYear>();
    	for(obj donation : donations){
    		if(tbyMap.get(donation.c) == null){
    			tbyMap.put(donation.c, new TableByYear(Label.Malkar_Donation_TableLabel + ' ' + donation.c));
    		}
    		if(donation.c == PersonalDonationType){
    			tbyMap.get(donation.c).Add(new DataByYear(null, Label.Malkar_Donation_Donation, donation.c), Label.Malkar_Donation_PersonalTable, true);
    		}
    		else if(donation.c == ForeignEntityDonationType){
    			tbyMap.get(donation.c).Add(new DataByYear(donation.c, donation.c, donation.c), Label.Malkar_Donation_ForeignEntityTable);
    		}
    	}
    	return tbyMap;
    }
    
    public static Map<String, TableByYear> getTableByYear(List<obj> peoples){
    	Map<String, TableByYear> tbyMap = new Map<String, TableByYear>();
        //TableByYear singleTable = new TableByYear(null);
        tbyMap.put(Label.Committee_Members, new TableByYear(null));
        tbyMap.put(Label.Authorized_signatories, new TableByYear(null));
        tbyMap.put(Label.Additional_wage_earners, new TableByYear(null));
        String key;
    	for(obj people : peoples){
            if (people.c == MalkarPeopleCommitteeMemberType){
                key = Label.Committee_Members;
            }
            else if (people.c == '7'){
                key = Label.Authorized_signatories;
            }
            else{
                key = Label.Additional_wage_earners;
            }
            //if (tbyMap.get(key) == null){
            //    tbyMap.put(key, new TableByYear(null));
            //}
            if (people.c == '10'){
            	//CEO
                tbyMap.get(key).Add(0, new DataByYear(people.r.Name, people.c, ''), people.c);
            }
            else{
            	if(people.c == MalkarPeopleCommitteeMemberType){
            		tbyMap.get(key).Add(new DataByYear(people.r.Name, Label.Committee_Member, ''), people.c);
            	}
            	else{
            		tbyMap.get(key).Add(new DataByYear(people.r.Name, people.c, ''), people.c);
            	}
            }
    	}
    	return tbyMap;
    }
    
    public static map<String, DataListContainer> getTableByYear(List<obj> malkarsByContact, List<obj> malkarsFrom, List<obj> malkarsTo){
    	TableByYear singleTable = new TableByYear(null);
    	for(obj malkar : malkarsByContact){
            List<Object> internalLink = new List<Object>{'/', MalkarPageApp, malkar.c, MalkarPeoplePage};
    		singleTable.Add(new DataByYear(malkar.Name, null, 'link', internalLink), 'malkarsByContact');
    	}
    	for(obj malkar : malkarsFrom){
            List<Object> internalLink = new List<Object>{'/', MalkarPageApp, malkar.c, MalkarPeoplePage};
    		singleTable.Add(new DataByYear(malkar.Name, null, 'link', internalLink), 'malkarsFrom');
    	}
    	for(obj malkar : malkarsTo){
            List<Object> internalLink = new List<Object>{'/', MalkarPageApp, malkar.c, MalkarPeoplePage};
    		singleTable.Add(new DataByYear(malkar.Name, null, 'link', internalLink), 'malkarsTo');
    	}
    	return singleTable.DataMap;
    }
    
    public static map<String, TableByYear> getTableByYear(List<c> wageEarners){
    	map<String, TableByYear> tbyMap = new map<String, TableByYear>();
    	for(c wageEarner : wageEarners){
    		if(tbyMap.get(wageEarner.c) == null){
    			tbyMap.put(wageEarner.c, new TableByYear(Label.GLOBAL_SpecificYear + ' ' + wageEarner.c));
    		}
			tbyMap.get(wageEarner.c).Add(new DataByYear(wageEarner.c, null, wageEarner.c));
    	}
    	return tbyMap;
    }
    
    public static TableByYear getTableByYear(List<obj> reportTotals){
    	TableByYear singleTable = new TableByYear(null);
    	for(obj reportTotal : reportTotals){
    		if(reportTotal.c != null){
    			singleTable.Add(new DataByYear(reportTotal.c, reportTotal.c, reportTotal.c, reportTotal.c), reportTotal.c);
    		}
    		else{
				singleTable.Add(new DataByYear(reportTotal.c, reportTotal.c, reportTotal.c), reportTotal.c);    			
    		}
    	}
    	return singleTable;
    }
    
    public static List<ReportResult> getReportResult(String queryStr){
    	return getReportResult(GSTAR_DAL.getReportResult(queryStr));
    }
    
    public static List<ReportResult> getReportResult(List<AggregateResult> result){
    	List<ReportResult> rrList = new List<ReportResult>();
    	if(result != null){
    		for(AggregateResult ar: result){
    			rrList.Add(new ReportResult(String.valueOf(ar.get('Label')), (Decimal)ar.get('Sum')));
    		}
    	}
    	utils.log(rrList);
    	return rrList;
    }
    
    public static List<obj> getRelevantMalkars(String searchWord){
    	return getRelevantMalkars(numOfResultAutoCompleteMalkars, searchWord, neededFieldsAutoCompleteMalkars, null);
    }
    
    public static List<obj> getRelevantMalkars(Integer numOfResult, String searchWord, String neededFields, String moreConditions){
    	return getRelevantMalkars(numOfResult, null, searchWord, neededFields, moreConditions);
    }
    
    public static List<obj> getRelevantMalkars(Integer numOfResult, Integer pageNumber, String searchWord, String neededFields, String moreConditions){
    	String objectName = 'obj';
    	Set<String> setFieldToSearch = new Set<String>{'Name', 'c'};
    	String condition = 'AND c = true ';
    	if(String.isNotBlank(moreConditions)){
    		condition = condition + moreConditions;
    	}

    	List<obj> m = new List<obj>();
    	for(sObject obj: getRelevantObjects(searchWord, numOfResult, pageNumber, neededFields, objectName, condition, setFieldToSearch)){
    		m.Add( (obj) obj);
    	}
    	return m;
    }
    
    public static List<Utils.LabelValue> getRelevantLabelValues(List<obj> malkars, String searchWord){
    	List<Utils.LabelValue> res = new List<Utils.LabelValue>();
    	for(obj malkar: malkars){
    		String strToPut;
	        if (malkar.c != null && malkar.c.contains(searchWord)) {
	        	strToPut = malkar.c + ' - ' + malkar.name;
	        }
	        else if (malkar.name != null && malkar.name.toLowerCase().contains(searchWord.toLowerCase())) {
	        	strToPut = malkar.name;
	        }
	        else{
	        	strToPut = malkar.Name;
	        }
			res.Add(new Utils.LabelValue(strToPut, '/'+ MalkarPageApp +'/' + malkar.c));    		
    	}
    	return res;
    }
    
    public static List<c> getRelevantTestSupports(String searchWord){
    	Integer numOfResult = 4;
    	String neededFields = 'c, c, c';
    	String objectName = 'c';
    	Set<String> setFieldToSearch = new Set<String>{'c' /*, 'c', 'c'*/};
    	String conditionStatusActive = '';

    	List<c> ts = new List<c>();
    	for(sObject obj: getRelevantObjects(searchWord, numOfResult, neededFields, objectName, conditionStatusActive, setFieldToSearch)){
    		ts.Add( (c) obj);
    	}
    	return ts;
    }
    
    public static List<Utils.LabelValue> getRelevantLabelValues(List<c> testSupports, String searchWord){
    	List<Utils.LabelValue> res = new List<Utils.LabelValue>();
    	for(c testSupport: testSupports){
    		String strToPut;
	        if (testSupport.c != null && testSupport.c.contains(searchWord)) {
	        	strToPut = testSupport.c + ' - ' + testSupport.c;
	        }
	        else if (testSupport.c != null && testSupport.c.toLowerCase().contains(searchWord.toLowerCase())) {
	        	strToPut = testSupport.c;
	        }
	        else{
	        	strToPut = testSupport.c;
	        }
			res.Add(new Utils.LabelValue(strToPut, '/'+ TestSupportsPageApp +'/' + EncodingUtil.base64Encode(Blob.valueOf(testSupport.Id))));    		
    	}
    	return res;
    }
	
	public static Set<sObject> getRelevantObjects(String searchWord, Integer numOfResult, String neededFields, String objectName, String moreConditionClause, Set<String> fieldsSearchInside){
		return getRelevantObjects(searchWord, numOfResult, null, neededFields, objectName, moreConditionClause, fieldsSearchInside);
	}    
    public static Set<sObject> getRelevantObjects(String searchWord, Integer numOfResult, Integer pageNumber, String neededFields, String objectName, String moreConditionClause, Set<String> fieldsSearchInside){
    	Set<sObject> sobjs = new Set<sObject>();
    	Integer offset = pageNumber != null && numOfResult != null ? pageNumber * numOfResult : 0;
    	if(fieldsSearchInside.contains('Name')){
	    	try{
		    	List<sObject> sobjsFindName = search.query(getFindQuery(searchWord, numOfResult, pageNumber, offset, neededFields, objectName, moreConditionClause, false))[0];
		    	sobjs.AddAll(sobjsFindName);
	    	}
	    	catch(Exception e){
	    		Utils.log(e.getMessage());
	    	}
    	}
    	else{
	    	try{
		    	List<sObject> sobjsFindAll = search.query(getFindQuery(searchWord, numOfResult, pageNumber, offset, neededFields, objectName, moreConditionClause, true))[0];
		    	sobjs.AddAll(sobjsFindAll);
	    	}
	    	catch(Exception e){
	    		Utils.log(e.getMessage());
	    	}
    	}
    	
    	try{
	    	List<sObject> sobjsSelect = Database.query(getSelectQuery(searchWord, numOfResult, pageNumber, offset, neededFields, objectName, moreConditionClause, fieldsSearchInside));
	    	sobjs.AddAll(sobjsSelect);
    	}
    	catch(Exception e){
    		Utils.log(e.getMessage());
    	}
    	
    	return qualifyRelevantObjects(sobjs, numOfResult, searchWord, fieldsSearchInside);
    	//return qualifyRelevantObjectsByIndex(sobjs, numOfResult, searchWord, fieldsSearchInside);
    	//return sobjs;
    }
    
    public static Set<sObject> qualifyRelevantObjects(Set<sObject> sobjs, Integer numOfResult, String searchWord, Set<String> fieldsSearchInside){
    	Set<sObject> result = new Set<sObject>();
    	for(sObject obj : sObjs){
    		if(result.size() < numOfResult){ 
	    		for(String fieldName : fieldsSearchInside){
    				String fieldValue = (String)obj.get(fieldName);
    				if(fieldValue.contains(searchWord)){
    					result.Add(obj);   					
    				}
    			}
    		}
    	}
    	return result;
    }
    
    public static Set<sObject> qualifyRelevantObjectsByIndex(Set<sObject> sobjs, Integer numOfResult, String searchWord, Set<String> fieldsSearchInside){
    	Map<Id, RelevanceObj> relevance = new Map<Id, RelevanceObj>();
    	for(sObject obj : sObjs){
    		for(String fieldName : fieldsSearchInside){
    			if(!relevance.containsKey(obj.Id)){ 
    				String fieldValue = (String)obj.get(fieldName);
    				if(fieldValue.indexOf(searchWord) > -1){
						relevance.put(obj.Id, new RelevanceObj(obj, fieldValue.indexOf(searchWord), fieldValue.length()));    					
    				}
    			}
    		}
    	}
    	
    	List<RelevanceObj> rels = relevance.values();
    	Utils.log(rels);
    	rels.sort();
    	Utils.log(rels);
    	Set<sObject> result = new Set<sObject>();
    	for(RelevanceObj rel: rels){
    		if(result.size() < numOfResult){
    			result.Add(rel.obj);
    		}
    		else{
    			Utils.log(result);
    			return result;
    		}
    	}
    	return result;
    }
    
    public class RelevanceObj implements Comparable{
    	public SObject obj;
    	public Integer indexOf;
    	public Integer fieldLength;
    	public Decimal coefficient;
    	
    	public RelevanceObj(SObject obj, Integer indexOf, Integer fieldLength){
    		this.obj = obj;
    		this.indexOf = indexOf;
    		this.fieldLength = fieldLength;
    		this.coefficient = indexOf + (fieldLength * 0.2);
    	}
    	
    	public Integer compareTo(Object objectToCompareTo){
    		RelevanceObj compareTo = (RelevanceObj)objectToCompareTo;
    		if (this.coefficient == compareTo.coefficient) return 0;
	        if (this.coefficient > compareTo.coefficient) return 1;
	        return -1;  
    	}
    }
    
    public static String getSelectQuery(String searchWord, Integer numOfResult, String neededFields, String objectName, String moreConditionClause, Set<String> fieldsSearchInside){
    	return getSelectQuery(searchWord, numOfResult, null, 0, neededFields, objectName, moreConditionClause, fieldsSearchInside);
    }
    
    public static String getSelectQuery(String searchWord, Integer numOfResult, Integer pageNumber, Integer offset, String neededFields, String objectName, String moreConditionClause, Set<String> fieldsSearchInside){
    	String filterStr = '%'+ searchWord +'%';
    	String likeFilterStr = ' LIKE \''+ filterStr + '\' ';
    	String queryStr = '';
    	queryStr += ' SELECT Id, Name ' ;
    	queryStr += String.isNotBlank(neededFields) ? ', ' + neededFields : '';
    	queryStr += ' FROM ' + objectName;
    	queryStr += ' WHERE Id != null '; 
    	queryStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
    	if(!fieldsSearchInside.isEmpty()){
    		queryStr += ' AND ( ';
    		for(String field : fieldsSearchInside){
    			queryStr += ' ( ' + field + likeFilterStr  + ' ) OR ';
    		}
    		queryStr += ' Id = null '; //for the last "OR"
    		queryStr += ' ) ';
    	}
    	queryStr += ' LIMIT :numOfResult ';
    	queryStr += ' OFFSET :offset ';
        
    	Utils.log(queryStr);
    	Utils.log(String.format('LIMIT :{0}, OFFSET : {1}', new List<String> {String.valueOf(numOfResult), String.valueOf(offset)}));
    	return queryStr;
    }
    
    public static String getFindQuery(String searchWord, Integer numOfResult, String neededFields, String objectName, String moreConditionClause, boolean isAllFields){
    	return getFindQuery(searchWord, numOfResult, null, 0, neededFields, objectName, moreConditionClause, isAllFields);
    }
    
    public static String getFindQuery(String searchWord, Integer numOfResult, Integer pageNumber, Integer offset, String neededFields, String objectName, String moreConditionClause, boolean isAllFields){
    	String findStr = '';
    	findStr += 'FIND \'' + searchWord + '*\'';
    	findStr += ' IN ';
    	findStr += isAllFields ? ' ALL FIELDS ' : ' Name FIELDS';
    	findStr += ' RETURNING ' + objectName;
    	findStr += ' ( Id, Name ';
    	findStr += String.isNotBlank(neededFields) ? ', ' + neededFields : '';
    	findStr += ' WHERE Id != null '; 
    	findStr += String.isNotBlank(moreConditionClause) ? moreConditionClause : '';
    	findStr += ' LIMIT :numOfResult ';
    	findStr += ' OFFSET :offset ';
    	findStr += ' ) ';
    	
    	Utils.log(findStr);
    	Utils.log(String.format('LIMIT :{0}, OFFSET : {1}', new List<String> {String.valueOf(numOfResult), String.valueOf(offset)}));
    	return findStr;
    }
    
    public class ReportResult{
    	public String Label;
	    public Decimal Sum;
	    
	    public ReportResult(String Label, Decimal Sum){
	    	this.Label = Label;
	    	this.Sum = Sum;
	    }
    }
    
    public static Map<String, List<obj>> toMapList(List<obj> objects, String fieldName) {
        Map<String, List<obj>> myMap = new Map<String, List<obj>>();
        for (obj obj : objects) {
            String key;
            if(fieldName.contains('.')){
                List<String> innerFields = fieldName.split('\\.');
                sObject tmp;
                Integer i = 0;
                for(; i < innerFields.size() -1 ; i++){
                    tmp = obj.getSObject(innerFields[i]);
                }
                key = String.valueOf(tmp.get(innerFields[i]));
            }
            else{
                key = String.valueOf(obj.get(fieldName));
            }

            if(key != null){
                if(!myMap.containsKey(key)){
                    myMap.put(key, new List<obj>());
                }
                myMap.get(key).add(obj);
            }
        }
        Utils.log(myMap);
        return myMap;
    }
}