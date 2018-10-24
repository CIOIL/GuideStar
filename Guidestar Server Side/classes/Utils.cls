public class Utils {
	
	public static final string CHATTER_DELEGATED_PROFILE_NAME = 'Chatter Delegated';
	public static final string CHATTER_USERNAME_SUFFIX = '.j@chatter.com';
	
	public class MyException extends Exception{}
	
	public virtual class Geolocation{
		public decimal lat;
		public decimal lng;
		public String description;
		
		public Geolocation(decimal lat, decimal lng, String description){
			this.lat = lat;
			this.lng = lng;
			this.description = description;
		}
	}
	
	public class CityGeolocation extends Geolocation{
		public String cityName;
		
		public CityGeolocation(decimal lat, decimal lng, String description){
			super(lat, lng, description);
		}
		
		public CityGeolocation(decimal lat, decimal lng, String description, String cityName){
			super(lat, lng, description);
			this.cityName = cityName;
		}
	}
	
	public virtual class LabelValue{
    	public String label;
    	public object value;
    	
    	public LabelValue(string label, object value){
    		this.label = label;
    		this.value = value;
    	}
    	
    	public LabelValue(object label, object value){
    		this.label = String.valueOf(label);
    		this.value = value;
    	}
    }
    
    public class LabelValueSlider extends LabelValue{
    	public String tooltip;
    	
    	public LabelValueSlider(String label, object value, String tooltip){
    		super(label, value);
    		this.tooltip = tooltip;
    	}
    	
    	public LabelValueSlider(object label, object value, String tooltip){
    		super(label, value);
    		this.tooltip = tooltip;
    	}
    }
    
    public class LabelValueParent extends LabelValue{
    	public object parent;
    	
    	public LabelValueParent(String label, object value, object parent){
    		super(label, value);
    		this.parent = parent;
    	}
    	
    	public LabelValueParent(object label, object value, object parent){
    		super(label, value);
    		this.parent = parent;
    	}
    }
    
    public static List<LabelValue> getListLabelValue(List<sObject> sobjs, String fieldNameLabel, String fieldNameValue){
    	return getListLabelValue(sobjs, fieldNameLabel, fieldNameValue, null, true);
    }
    
    public static List<LabelValue> getListLabelValue(List<sObject> sobjs, String fieldNameLabel, String fieldNameValue, boolean needUnique){
    	return getListLabelValue(sobjs, fieldNameLabel, fieldNameValue, null, needUnique);
    }
    
    public static List<LabelValue> getListLabelValue(List<sObject> sobjs, String fieldNameLabel, String fieldNameValue, String fieldNameParent){
    	return getListLabelValue(sobjs, fieldNameLabel, fieldNameValue, fieldNameParent, true);
    }
    
    public static List<LabelValue> getListLabelValue(List<sObject> sobjs, String fieldNameLabel, String fieldNameValue, String fieldNameParent, boolean needUnique){
    	Map<object, LabelValue> myMap = new Map<object, LabelValue>();
    	List<LabelValue> myList = new List<LabelValue>();
    	if(sobjs != null && !sobjs.isEmpty()){
    		for(sObject sobj : sobjs){
    			object value = sobj.get(fieldNameValue);
    			object label = sobj.get(fieldNameLabel);
    			object parent = String.isNotBlank(fieldNameParent) ? sobj.get(fieldNameParent) : null;
    			if(parent != null){
    				if(value != null){
    					// without filtering the value if exist because the filtering will be in the client side
    					//i.e. the secondary classification has some different parents for the same value
	    				if(needUnique){
				    		myMap.put(value, new LabelValueParent(label, value, parent));
				    	}
				    	else{
				    		myList.add(new LabelValueParent(label, value, parent));
				    	}
	    			}
    			}
    			else{
	    			if(needUnique){
	    				if(value != null && !myMap.containsKey(value)){
		    				myMap.put(value, new LabelValue(label, value));
		    			}
			    	}
			    	else{
			    		myList.add(new LabelValue(label, value));
			    	}
    			}
    		}
    	}
    	
    	if(needUnique){
    		return myMap.values();
    	}
    	else{
    		return myList;
    	}
    }
    
    public static List<LabelValue> getListLabelValueSlider(List<> sobjs){
    	List<LabelValue> myList = new List<LabelValue>();
    	if(sobjs != null && !sobjs.isEmpty()){
    		for( sobj : sobjs){
    			myList.add(new LabelValueSlider(sobj.MasterLabel, sobj.field, sobj.c));
    		}
    	}
		return myList;
    }
    
    public static List<LabelValue> getListLabelValue(List<Schema.PicklistEntry> entries){
    	List<LabelValue> lst = new List<LabelValue>();
    	if(entries != null && !entries.isEmpty()){
    		for(Schema.PicklistEntry entry : entries){
    			lst.Add(new LabelValue(entry.getLabel(), entry.getValue()));
    		}
    	}
    	return lst;
    }
		
	public static void log(Object info) {
        System.debug('\n\n\n\n\n\n'+ json.serialize(info) +'\n\n\n\n\n\n');
    }
    
    public static void log(String description, Object info) {
        System.debug('\n'+ description +'\n');
        log(info);
    }
    
    public static String removeAllUnexpectedCharacters(String input){
    	String output = input;
    	if(String.isNotBlank(input)){
    		output = input.replaceAll('[()}{|><#^~]', '');
    	}
    	return output;
    }

    public static string getStandardUrl(string url){
        if (String.isBlank(url) || url.startsWithIgnoreCase('http')){
            return url;
        }
        return 'http://' + url;
    }

    public static Decimal SafeDecimal(Object value) { return SafeDecimal(value, 2); }
    public static Decimal SafeDecimal(Object value, Integer scale) { return (value == null || string.valueOf(value).length() == 0 ? 0.0 : Decimal.valueOf(Double.valueOf(value))).setScale(scale); }

    public static Double SafeDouble(Object value) { return SafeDouble(value, 2); }
    public static Double SafeDouble(Object value, Integer scale) { return SafeDecimal(value, scale).doubleValue(); }

    public static Integer SafeInteger(Object i) { return i == null || string.valueOf(i).length() == 0 ? 0 : Integer.valueOf(i); }

    public static String SafeString(Object x) { return x == null ? '' : String.valueOf(x); }
    
    public static List<String> split(String input, Integer separatorChar) {
		
		List<String> resultList = new List<String>();
		List<Integer> buffer = new List<Integer>();
		List<Integer> inputChars = input.getChars();
		Integer length = inputChars.size();

		for (Integer i = 0; i < length; i++) {
			if (inputChars[i] == separatorChar) {
				resultList.add(String.fromCharArray(buffer));
				buffer = new List<Integer>();
			} else {
				buffer.add(inputChars[i]);
			}
		}
		if (buffer.size() > 0) {
			resultList.add(String.fromCharArray(buffer));
		}
		return resultList;
	}

    public static string getGUID(string uniqueString){
        string str = '';
        Blob blobText = Blob.valueOf(String.valueOf(Crypto.getRandomInteger()));
        Blob hashed = Crypto.generateDigest('SHA-256',blobText);
        string tmp = EncodingUtil.convertToHex(hashed);
        System.debug(tmp);
        str += tmp.substring(0,15);
        str += '-';
        str += tmp.substring(15, 31);
        str += '-';
        str += String.isNotBlank(uniqueString) ? EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256',Blob.valueOf(uniqueString))) + '-' : '';
        str += tmp.substring(31, 47);
        str += '-';
        str += tmp.substring(47, 64);
        return str;
    }

	/**
	 * Sorts a List of sObjects into a map.
	 * It gets a list of sObjects, and returns a map containing the sObject whose *sortField* has the highest value for every group of *keyField*.
	 * For example: sortSObjects(contactList, c, AccountId) will return a map of sorted contacts.
	 * Each Account will have one Contact in the map, and that Contact record will be the contact who is the oldest.
	 * @param  objList   The list of sObjects to be sorted.
	 * @param  sortField The field on the sObject that will be used to sort the list.
	 * @param  keyField  The field on the sObject that will be used as the key in the returned map.
	 * @return           A map containing a single sObject for every key. That sObject has the highest value of *sortField* for that key.
	 */
	public static Map<Object, SObject> sortSObjects(List<SObject> objList, string sortField, string keyField){
		Map<Object, SObject> returnMap = new Map<Object, SObject>();
		Object key;
		for (SObject sobj : objList){
			key = sobj.get(keyField);
			if (returnMap.containsKey(key)){
				if (string.valueOf(returnMap.get(key).get(sortField)) < string.valueOf(sobj.get(sortField))){
					returnMap.put(key, sobj);
				}
			}
			else{
				returnMap.put(key, sobj);
			}
		}
		return returnMap;
	}
	
	public static map<String, object> deserializeUntypedMap(String jsonStr){
        map<String, object> myMap = new map<String, Object>();
        try{
            if(!String.isEmpty(jsonStr)){
                myMap = (map<String, Object>) JSON.deserializeUntyped(jsonStr.replaceAll('&quot;','"'));
            }
        }
        catch(Exception e){Utils.log('ERROR: deserializeUntypedMap not success');}
        return myMap;
    }

    public static list<object> deserializeUntypedList(String jsonStr){
        list<object> myList = new list<object>();
        try{
            if(!String.isEmpty(jsonStr)){
                myList = (list<object>) JSON.deserializeUntyped(jsonStr.replaceAll('&quot;','"'));
            }
        }
        catch(Exception e){Utils.log('ERROR: deserializeUntypedList not success');}
        return myList;
    }

    public static string getPicklistDefaultValue(string objectName, string fieldName){
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> pickVals = fieldMap.get(fieldName).getDescribe().getPickListValues();
        String defaultVal;

        for (Schema.PicklistEntry av: pickVals) {
            if (av.isDefaultValue()) {
                return av.getValue();
            }
        }
        return '';
    }

    public static set<String> getAllMapValues(map<String, set<String>> myMap){
        if(myMap == null){return null;}
        set<String> mySet = new set<String>();
        for(set<String> s : myMap.values()){
            mySet.addAll(s);
        }
        return mySet;
    }
    
    public static map<String,sObject> mapList(List<sObject> myList, String fieldName_unique) {

        map<String,sObject> myMap = new map<String,sObject>();

        String key;
        for (sObject obj: myList) {
            key = (String)obj.get(fieldName_unique);
            if(key != null){
                myMap.put(key, obj);
            }
        }
        return myMap;
    }
    
    public static void addKeyValueToList(List<object> myList, String key, String value) {
		if(myList != null && !String.isEmpty(key)){
	        for (object obj: myList) {
	        	Map<String, Object> myMap = (Map<String, Object>) obj;
	        	myMap.put(key, value);
	        }
		}
    }
    
    public static Set<String> splitToSet(String str, String separator) {
        if (str == null)
            return new Set<String>();

        if (String.isEmpty(separator))
            return new Set<String> { str };

        List<String> values = str.split(separator);
        return new Set<String>(values);
    }

    public static Set<Id> getSetIDs(List<SObject> lst){
        if(lst == null){return null;}
        Set<Id> ids = new Set<Id>();
        for(SObject obj : lst){
            ids.add(obj.Id);
        }
        return ids;
    }
    
    public static Set<Id> getSetIDs(List<sObject> lst, String fieldName) {
    	Set<Id> mySet = new Set<Id>();
        for (sObject obj : lst) {
    		mySet.add(String.valueOf(obj.get(fieldName)));
        }
        return mySet;
    }

    public static Integer getDurationInMinutes(DateTime endTime, DateTime startTime) {
        return Integer.valueOF((endTime.getTime() - startTime.getTime()) / 60 / 1000);
    }
    
    public static Set<String> getValuesSet(List<Object> objects, String fieldName) {
    	Set<String> mySet = new Set<String>();
        for (Object obj : objects) {
        	if(obj instanceof map<String, object>){
        		mySet.add(String.valueOf(((map<String, object>)obj).get(fieldName)));
        	}
        }
        return mySet;
    }
    
    public static Set<String> getValuesSet(List<sObject> objects, String fieldName) {
    	Set<String> mySet = new Set<String>();
        for (sObject obj : objects) {
    		mySet.add(String.valueOf(obj.get(fieldName)));
        }
        return mySet;
    }

    public static Map<String, Object> toMap(List<Object> objects, String fieldName) {
        Map<String, Object> myMap = new Map<String, Object>();
        for (Object obj : objects) {
        	if(obj instanceof map<String, object>){
        		myMap.put(String.valueOf(((map<String, object>)obj).get(fieldName)), obj);
        	}
        }
        return myMap;
    }

    public static Map<String, List<SObject>> toMapList(List<SObject> objects, String fieldName) {
        Map<String, List<SObject>> myMap = new Map<String, List<SObject>>();
        for (SObject obj : objects) {
            String key = String.valueOf(obj.get(fieldName));
            if(!myMap.containsKey(key)){
                myMap.put(key, new List<SObject>());
            }
            myMap.get(key).add(obj);
        }
        return myMap;
    }

    public static Long getMinutes(DateTime startDate, DateTime endDate){
        if(startDate != null && endDate != null && endDate > startDate){
            return ( endDate.getTime() - startDate.getTime() ) / (1000 * 60) ;
        }
        return 0;
    }

    public static Street getStreet(String str){
        Street myStreet = new Street();
        if(!String.isEmpty(str)){
            if(str.contains(' ')){
                List<String> strLst = str.split(' ');
                if(strLst[0].replaceAll('/', '').isNumeric()){
                    myStreet.streetNumber = strLst[0];
                    strLst.remove(0);
                }
                else if(strLst[strLst.size() - 1].replaceAll('/', '').isNumeric()){
                    myStreet.streetNumber = strLst[strLst.size() - 1];
                    strLst.remove(strLst.size() - 1);
                }

                myStreet.streetName = String.join(strLst, ' ');
            }
        }
        return myStreet;
    }

    public class Street{
        public String streetName {set;get;}
        public String streetNumber {set;get;}
    }
    
    public class UserInfoWrapper{
        public String username {set;get;}
        public String email {set;get;}
        public String firstName {set;get;}
        public String lastName {set;get;}
        public String communityNickname {set;get;}
        public String profileName {set;get;}
        
        public UserInfoWrapper(){}
    }
    
    public static User createUserChatterDelegated(String email, String firstName, String lastName, String groupId){
    	if(!String.isEmpty(email) && !String.isEmpty(firstName) && !String.isEmpty(lastName)){
    		UserInfoWrapper myUserInfo = new UserInfoWrapper();
	    	myUserInfo.username = email.replaceAll('@', '.') + CHATTER_USERNAME_SUFFIX;
	    	myUserInfo.email = email;
	    	myUserInfo.firstName = firstName;
	    	myUserInfo.lastName = lastName;
	    	myUserInfo.profileName = CHATTER_DELEGATED_PROFILE_NAME;
	    	User newUser = getUser(myUserInfo);
	    	insert newUser;
	    	
	    	if(!String.isEmpty(groupId)){
	    		createCollaborationGroupMember(groupId, newUser.Id);
	    	}
    	}
    	return null;
    }
    
    public static User getUser(UserInfoWrapper myUserInfo){
        try{
            User u = new User();
            Profile p = [SELECT Id FROM profile WHERE name = : myUserInfo.profileName ];
            u.Username = myUserInfo.username;
            u.Email = myUserInfo.email;
            u.FirstName = myUserInfo.firstName;
            u.LastName = myUserInfo.lastName;
            u.CommunityNickname = !String.isEmpty(myUserInfo.communityNickname) ? myUserInfo.communityNickname : myUserInfo.username;
            if(u.CommunityNickname.Length() > 40){
            	u.CommunityNickname = u.CommunityNickname.substring(0, 40);
            }
            u.ProfileId = p.Id;
            String alias = u.Username;
            //Alias must be 8 characters or less
            if(alias.length() > 8) {
                alias = alias.substring(0, 8);
            }
            u.alias = alias;
           	u.languagelocalekey = 'iw';
            u.localesidkey = 'iw_IL';
            u.emailEncodingKey = 'UTF-8';
            u.timeZoneSidKey = 'Asia/Jerusalem';
            u.UserPreferencesShowProfilePicToGuestUsers = true;
            System.debug('\n\n user -----------'  + u + '\n\n');
            return u;
        }catch(Exception e) {	Utils.log(e);	return null;	}
    }
    
    public static CollaborationGroupMember createCollaborationGroupMember(String groupId, String userId){
    	CollaborationGroupMember cgm = new CollaborationGroupMember();
    	cgm.CollaborationGroupId = groupId;
    	cgm.MemberId = userId;
    	insert cgm;
    	return cgm;
    }
    
    public static void formatToDateTimeIfNeeded(object value, String objType, String fieldName){
    	Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType loadSchema = schemaMap.get(objType);
		Map<String, Schema.SObjectField> fieldMap = loadSchema.getDescribe().fields.getMap();
		Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
        if( value != null && fielddataType==Schema.DisplayType.DateTime){
        	
        	long l= long.valueOf(String.valueof(value));
        	DateTime d = DateTime.newInstance(l);
        	value= d;
        }
    }
    
    public static void sendEmailToAdmins(String subject, String body) {
    	Profile sys_adm_profile = [SELECT Id FROM Profile WHERE Name Like 'System Administrator'];
		List<User> sys_adm = [SELECT id, Email FROM User WHERE ProfileId = :sys_adm_profile.Id and IsActive = true];
		Set<String> emails = getValuesSet(sys_adm, 'Email');
		String[] recipients = new List<String>(emails);
        sendEmail('', '', recipients, subject, body, null);
    }
    
    public static void sendEmail(String recipient, String subject, String body) {
        sendEmail('', '', new String[] { recipient }, subject, body, null);
    }

    public static void sendEmail(String recipient, String subject, String body, Attachment attachment) {
        sendEmail('', '', new String[] { recipient }, subject, body, attachment);
    }
    
    public static void sendEmail(String senderName, String senderEmail, String[] recipients, String subject, String body, Attachment attachment) {
        try {
            // create message object
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setUseSignature(true);

            // set message deatils
            message.setSubject(subject);
            message.setPlainTextBody(body);
            message.setToAddresses(recipients);
            if (String.isNotEmpty(senderName))
                message.setSenderDisplayName(senderName);
            if (String.isNotEmpty(senderEmail))
                message.setReplyTo(senderEmail);
            if (attachment != null) {
                Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
                fileAttachment.setFileName(attachment.Name);
                fileAttachment.setBody(attachment.Body);

                message.setFileAttachments(new Messaging.EmailFileAttachment[] { fileAttachment });
            }

            // send message
            Messaging.SingleEmailMessage[] messages = new Messaging.SingleEmailMessage[] { message };
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        } catch (EmailException ce) {
            log('Utils.sendEmail', ce.getDmlMessage(0));
        }
    }
}