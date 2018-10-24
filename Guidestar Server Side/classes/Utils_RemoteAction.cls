public class Utils_RemoteAction {
	
	public static final String DISTRICT_LABEL_CODE = '';
	public static final String National_Similar_Type = 'National';
	public static final String District_Similar_Type = 'District';
	
	public Utils_RemoteAction(CTRL ctrl){}
    public class MyException extends Exception{}
	
    @RemoteAction
	public static void deleteObject(String objId){
		Id sobjId = objId;
		SObjectType stype = sobjId.getSObjectType();
		SObject sobj = stype.newSObject(sobjId);
		try{
			delete sobj;
		}
		catch(DMLException e){
			throw new MyException(e.getDmlMessage(0));
		}
	}
	
	@RemoteAction
	public static map<String, List<Utils.LabelValue>> getPicklistValues(String objectName, Set<String> fieldNameList){
        map<String, List<Utils.LabelValue>> optionMap = new map<String, List<Utils.LabelValue>>();
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        for(String fieldName : fieldNameList){
            list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
            optionMap.put(fieldName, new List<Utils.LabelValue>());
            for (Schema.PicklistEntry a : values){
	            if(a.isActive()){
	                optionMap.get(fieldName).add(new Utils.LabelValue(a.getLabel(), a.getValue()));
	            }
            }
        }
        return optionMap;
    }
    
    @RemoteAction
	public static List<Utils.LabelValue> getFieldPicklistValues(String objectName, String fieldName){
        map<String, List<Utils.LabelValue>> optionMap = getPicklistValues(objectName, new Set<String>{ fieldName });
        if(optionMap.containsKey(fieldName)){
        	return optionMap.get(fieldName);
        }
        return null;
    }
	
	@RemoteAction
	public static User getCurrentUser(){
		return Utils_DAL.getCurrentUser();
	}

	@RemoteAction 
	public static boolean isUserLoggedIn(){
		return !UserInfo.getUserType().containsIgnoreCase('guest');
	}
	
	@RemoteAction
	public static boolean verifyRecaptcha(string token){
		return Utils_HttpRequests.verifyRecaptcha(token);
	}

	@RemoteAction
	public static void updateUser(UserWrapper usr){
		if (usr != null && usr.Id != null){
			User toUpdate = new User(
				Id = usr.Id,
				FirstName = usr.FirstName,
				LastName = usr.LastName,
				c = usr.EBOX_Company_Name,
				Email = usr.Email,
				Phone = usr.Phone,
				Street = usr.Street,
				City = usr.City,
				Country = usr.Country,
				PostalCode = usr.PostalCode
				);
			update toUpdate;
		}
		else{
			throw new MyException(Label.Global_InvalidObject);
		}
	}
	
	@RemoteAction
    public static List<c> searchCity(String searchInput){
    	Map<Id, c> cities = new Map<Id, c>();
    	if(String.isNotBlank(searchInput)){
    		searchInput.replaceAll('\\*',' ');
    		String searchInputLike = '%' + searchInput + '%'; 
			cities = new Map<Id, c>([select Name, c from c where Name like :searchInputLike limit 20]);
			
			if(cities.size() < 10 && searchInput.length() > 1){
				String searchquery = 'FIND \'' + searchInput + '*\'IN Name FIELDS RETURNING c(Id, Name, c where id not in :cityIds Limit 10 )';
				Set<Id> cityIds = cities.keySet();
				cities.PutAll(new Map<Id, c>( (List<c>) search.query(searchquery)[0]));
			}	
    	}
    	Utils.log(cities.values());
    	return cities.values();
    }
    
    @RemoteAction
    public static List<Utils.LabelValue> searchCityAC(String searchInput){
    	Map<String, c> cities = new Map<String, c>();
    	if(String.isNotBlank(searchInput)){
    		searchInput = searchInput.trim();
    		searchInput.replaceAll('\\*',' ');
    		String searchInputLike = '%' + searchInput + '%'; 
			cities = new Map<String, c>([select Name, c from c where Name like :searchInputLike OR c like :searchInputLike limit 20]);
			
			if(cities.size() < 10 && searchInput.length() > 1){
				String searchquery = 'FIND \'' + searchInput + '*\'IN Name FIELDS RETURNING c(Id, Name, c where id not in :cityIds Limit 10 )';
				Set<String> cityIds = cities.keySet();
				cities.PutAll(new Map<String, c>( (List<c>) search.query(searchquery)[0]));
			}
			
			//search in the districts
			for(AggregateResult agr : [select count(id), c districtNum, max(c) district from c where c like :searchInputLike group by c ]){
				cities
					.put((string) agr.get('district'), 
						new c(
							Name = Label.Search_DistrictPrefix + (string)agr.get('district'), 
							c = DISTRICT_LABEL_CODE + String.valueOf(agr.get('districtNum'))));
			}
			
			List<> similarNational = Utils_DAL.getSimilarWords(National_Similar_Type , searchInput);
	        if(!similarNational.isEmpty()){ 
	        	cities
					.put(National_Similar_Type, 
						new c(
							Name = Label.Search_National, 
							c = National_Similar_Type));
	        }
	        List<> similarDistricts = Utils_DAL.getSimilarWords(District_Similar_Type , searchInput);
	        if(!similarDistricts.isEmpty()){ 
	        	for(AggregateResult agr : [select count(id), c districtNum, max(c) district from c group by c ]){
					cities
						.put((string) agr.get('district'), 
							new c(
								Name = Label.Search_DistrictPrefix + (string)agr.get('district'), 
								c = DISTRICT_LABEL_CODE + String.valueOf(agr.get('districtNum'))));
				}
	        }
    	}
    	
    	return Utils.getListLabelValue(cities.values(), 'Name','c');
    }
    
    @RemoteAction
    public static String searchCityCodeAC(String cityCode){
    	if(String.isNotBlank(cityCode)){
    		if(cityCode.toUpperCase().startsWith(DISTRICT_LABEL_CODE)){
    			cityCode = cityCode.right(cityCode.length() - DISTRICT_LABEL_CODE.length());
    			List<c> cities = [select Name, c, c, c from c where c like :cityCode limit 1];
    			if(!cities.isEmpty()){
    				return Label.Search_DistrictPrefix + cities[0].c;
    			}
    		}
    		else if(cityCode.equalsIgnoreCase(National_Similar_Type)){
    			return Label.Search_National;	
    		}
    		else{
    			List<c> cities = [select Name, c from c where c like :cityCode limit 1];
    			if(!cities.isEmpty()){
    				return cities[0].Name;
    			}
    		}
    	}
    	return '';
    }

    @RemoteAction
    public static void createJSError(String url, String fullMessage, String description){
    	obj jse = new obj(
    		c = url,
    		c = fullMessage,
    		c = description
    		);
    	insert jse;
    }

    @RemoteAction
    public static ApiResult uploadFile(Blob data, String fileName){
    	ApiResult result;
    	if (data == null || fileName == null){
    		result = new ApiResult(false, 'No file object or name', null);
    		return result;
    	}
    	ContentVersion c = new ContentVersion();
    	c.versionData = data;
    	c.pathOnClient = fileName;
    	try {
    		insert c;
    		result = new ApiResult(true, null, c.Id);
    	}
    	catch(Exception e){
    		result = new ApiResult(false, e.getMessage(), null);
    	}
    	return result;
    }
    
    @RemoteAction
    public static List<Website_Content> getWebsiteContent(String app, String page, String position){
    	System.debug(app);
    	System.debug(page);
    	System.debug(position);
    	List<c> wsContents = [Select Id, c, c, c, c, c, c, c, 
    														c, c, c, c
													From c 
									    			Where c LIKE : app 
									    			And c INCLUDES (:page)
									    			And c LIKE : position
									    			And c = true
									    			Order By c asc];
		return getWebsiteContents(wsContents);
    }
    
    public static List<Website_Content> getWebsiteContents(List<c> wsContents){
    	List<Website_Content> wscs = new List<Website_Content>();
    	for(c wsc: wsContents){
    		wscs.Add(new Website_Content(wsc));
    	}
    	return wscs;
    }
    
    public class Website_Content{
    	public String Id {get; set;}
		public String App {get; set;}
		public String Body {get; set;}
		public Decimal Index {get; set;}
		public Boolean IsActive {get; set;}
		public String Language {get; set;}
		public String Link {get; set;}
		public String Pages {get; set;}
		public String Position {get; set;}
		public String Title {get; set;}
		public String H1 {get;set;}
		public String Description {get; set;}
		
		public Website_Content(c wsc){
			this.Id = wsc.Id;
			this.App = wsc.c;
			this.Body = wsc.c;
			this.Index = wsc.c;
			this.IsActive = wsc.c;
			this.Language = wsc.c;
			this.Link = wsc.c;
			this.Pages = wsc.c;
			this.Position = wsc.c;
			this.Title = wsc.c;
			this.H1 = wsc.c;
			this.Description = wsc.c;
		}
    }

    @RemoteAction
    public static String createCommunityUser(CommunityUser cu){
    	String accountName = (string)c.getAll().get('SubmitterAccount').get('field');
    	List<Account> accs = [SELECT Id, Name FROM Account WHERE Name = :accountName];
    	if (accs.size() > 0){
    		cu.accountId = accs[0].Id;
    	}
    	else{
    		return null;
    	}
    	String profileName = (string)c.getAll().get('SubmitterProfile').get('field');
    	List<Profile> profiles = Utils_DAL.getProfilesByName(profileName);
    	if (profiles.size() == 0){
    		return null;
    	}
    	else{
    		cu.profileId = profiles[0].Id;
    	}
    	List<RecordType> recordTypes = Utils_DAL.getRecordTypeInfo('Contact', 'Standard');
    	if (recordTypes.size() == 0){
    		return null;
    	}
    	User u;
    	try{
	    	Contact c = createContact(cu, recordTypes[0].Id);
	    	insert c;
	    	cu.contactId = c.Id;
	    	u = createUser(cu);
	    	//insert u;
	    	String userId = Site.createExternalUser(u, cu.accountId, cu.password);//u.Id;//Site.createExternalUser(u, cu.accountId, cu.password);
	    	if (userId == null){
	    		delete c;
	    	}
	    	return userId;
	    }
	    catch(Exception e){
	    	System.debug('Caught exception!');
	    	System.debug(e);
	    }
    	return '';
    }

    public static Contact createContact(CommunityUser cu, Id recordTypeId){
    	Contact c = new Contact();
    	c.AccountId = cu.accountId;
    	c.FirstName = cu.FirstName;
    	c.LastName = cu.LastName;
    	c.Email = cu.email;
    	c.RecordTypeId = recordTypeId;
    	c.c = cu.ExtId;
    	c.Phone = cu.phone;
    	return c;
    }

    public static User createUser(CommunityUser cu){
    	User u = new User();
    	u.Id = cu.Id;
		u.UserName = cu.userName;
		u.Email = cu.email;
		u.FirstName = cu.FirstName;
		u.LastName = cu.LastName;
		u.CommunityNickname = String.isNotBlank(cu.communityNickname) ? cu.communityNickname : String.valueOf(Datetime.now());
		u.ProfileId = cu.profileId;
		u.ContactId = cu.contactId;
		u.Alias = String.isNotBlank(cu.alias) ? cu.alias : cu.userName.substring(0, 8);
		u.LocaleSidKey = String.isNotBlank(cu.localeSidKey) ? cu.localeSidKey : 'iw';
		u.LanguageLocalekey = String.isNotBlank(cu.languageLocalekey) ? cu.languageLocalekey : 'iw';
		u.EmailEncodingKey = String.isNotBlank(cu.emailEncodingKey) ? cu.emailEncodingKey : 'UTF-8';
		u.TimeZoneSidKey = String.isNotBlank(cu.timeZoneSidKey) ? cu.timeZoneSidKey : 'Asia/Jerusalem';
		return u;
    }

    public class CommunityUser{
    	public String Id{get;set;}
    	public String userName{get;set;}
    	public String password{get; set;}
    	public String accountName{get; set;}
    	public String accountId{get; set;}
    	public String FirstName{get; set;}
    	public String LastName{get; set;}
    	public String contactId{get; set;}
    	public String ExtId {get;set;}
    	public String email{get; set;}
    	public String phone{get;set;}
    	public String communityNickname{get; set;}
    	public String profileName{get; set;}
    	public String profileId{get; set;}
    	public String alias{get; set;}
    	public String localeSidKey{get; set;}
    	public String languageLocalekey{get; set;}
    	public String emailEncodingKey{get; set;}
    	public String timeZoneSidKey{get; set;}

    }

}