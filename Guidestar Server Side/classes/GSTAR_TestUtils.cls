/*
 * Class to help with writing tests.
 * Created by Mordechai Behar
 *
 * When adding your own function please adhere to the following guidelines:
 *      Do NOT use any DML statements in this class. 
 *      Try not to use any SOQL commands in this class, have the test class feed you all the data you need.
 *      Always try to create and return a list of multiple records.
 *      Keep the record creation as generic as possible, i.e. only create the minimum required fields.
 */

public class GSTAR_TestUtils{

	public static List<User> createUsers(Id profileId, Integer numUsers){
		List<User> users = new List<User>();
		for (Integer i = 0; i < numUsers; i++){
			User user = new User(UserName = 'test'+String.valueOf(i)+'@test_.com',
                LastName = 'lastName_'+String.valueOf(i),
                Email = 'testuser@test.com',
                Alias = 'usr_'+String.valueOf(i),
                CommunityNickname = 'CommunityNickname_'+String.valueOf(i),
                TimeZoneSidKey = 'GMT',
                LocaleSidKey = 'cy_GB',
                EmailEncodingKey = 'UTF-8',
                ProfileId = profileId,
                LanguageLocaleKey = 'en_US');
			users.add(user);
		}
		return users;
	}

	public static List<Account> createAccounts(Integer numAccs){
		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < numAccs; i++){
			Account acc = new Account(Name = 'Test Acount '+String.valueOf(i),
				Phone = '1234567');
			accounts.add(acc);
		}
		return accounts;
	}

	public static List<Contact> createContacts(Integer numContacts, Id parentAccount){
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < numContacts; i++){
			Contact c = new Contact(LastName = 'Test ' + String.valueOf(i),
				Email = 'testContact@test.com',
				AccountId = parentAccount);
			contacts.add(c);
		}
		return contacts;
	}

	public static List<obj> createGlobalSettings(Map<string,string> keyValuePairs){
		List<obj> glblSettings = new List<obj>();
		for (string key : keyValuePairs.keySet()){
			obj glblSetting = new obj();
			glblSetting.Name = key;
			glblSetting.field = keyValuePairs.get(key);
			glblSettings.add(glblSetting);
		}
		return glblSettings;
	}

	public static List<field> createClassificationSettings(Integer numSettings){
		List<Map<string, string>> listItems = getClassSettingListItems(numSettings);
		List<field> customSettings = new List<field>();
		Integer i = 0;
		for (Map<string, string> item : listItems){
			field customSetting = new field();
			customSetting.Name = 'Test Setting ' + String.valueOf(i++);
			for (string key : item.keySet()){
				customSetting.put(key, item.get(key));
			}
			customSettings.add(customSetting);
		}
		return customSettings;
	}

	public static List<obj> createMalkars(Integer numMalkars){
		List<obj> malkars = new List<obj>();
		for (Integer i = 0; i < numMalkars; i++){
			obj malkar = new obj(
				Name = 'Test Malkar '+String.valueOf(i),
				field = '90',
				field = '1',
				field = '1',
				field = '1',
				field = '1',
				field = 'הקדש',
				field = String.valueOf(i));
			malkars.add(malkar);
		}
		return malkars;
	}

	public static List<obj> createNihulTakinStatus(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> nihulList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj nts = new obj(
				field = parentList[i].Id,
				field = Datetime.now().Year());
			nihulList.add(nts);
		}
		return nihulList;
	}

	public static List<obj> creatOrgGreenInfos(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> orgInfoList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj ogi = new obj(
				obj = parentList[i].Id);
			orgInfoList.add(ogi);
		}
		return orgInfoList;
	}

	public static List<obj> createReportsApprovals(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> reportsList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj report = new obj(
				field = parentList[i].Id);
			reportsList.add(report);
		}
		return reportsList;
	}

	public static List<obj> createAdditionalData(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> adList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj ad = new obj(obj = parentList[i].Id);
			ad.field = String.valueOf(i);
			adList.add(ad);
		}
		return adList;
	}
	
	public static List<obj> createReportWageEarner(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> rweList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj ad = new obj(obj = parentList[i].Id);
			ad.field = String.valueOf(i);
			rweList.add(ad);
		}
		return rweList;
	}

	public static List<obj> createDonations(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> donationList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj donation = new obj();
			donation.field = Date.today().Year();
			donation.field = i;
			donation.field = 'Entity ' + String.valueOf(i);
			donation.field = 'Target ' + String.valueOf(i);
			donation.field = i;
			donation.obj = parentList[0].Id;
			donation.field = 1;
			donationList.add(donation);
		}
		return donationList;
	}

	public static List<field> createWagerEarners(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<field> weList = new List<field>();
		for (Integer i = 0; i < num; i++){
			field wageEarner = new field();
			wageEarner.field = i;
			wageEarner.field = Date.today().Year();
			wageEarner.field = 'Tafkid ' + String.valueOf(i);
			wageEarner.obj = parentList[0].Id;
			weList.add(wageEarner);
		}
		return weList;
	}

	public static List<obj> createGovConnections(Integer num, List<obj> parentList){
		if (parentList.size() < num ){
			return null;
		}
		List<obj> gcList = new List<obj>();
		for (Integer i = 0; i < num; i++){
			obj gc = new obj();
			gc.field = String.valueOf(Date.today().Year());
			gc.field = String.valueOf(i);
			gc.field = 'Office ' + String.valueOf(i);
			gc.field = 'Purpose ' + String.valueOf(i);
			gc.field = i;
			gc.field = i;
			gc.obj = parentList[0].Id;
			gcList.add(gc);
		}
		return gcList;
	}

	public static List<obj> createConnectedMalkars(Integer num, List<obj> fromMalkars, List<obj> toMalkars){
		if (fromMalkars.size() < num || toMalkars.size() < num){
			return null;
		}
		List<obj> cmList = new List<obj>();
		for (Integer i=0; i<num; i++){
			obj cm = new obj();
			cm.field = String.valueOf(Date.today().Year());
			cm.field = fromMalkars[i].Id;
			cm.field = toMalkars[i].Id;
			cm.field = 'Other';
			cmList.add(cm);
		}
		return cmList;
	}

	public static List<obj> createMalkarPeople(Integer num, List<obj> parentList, List<Contact> contactList){
		if (parentList.size() < num || contactList.size() < num){
			return null;
		}
		List<obj> mpList = new List<obj>();
		for (Integer i=0; i<num; i++){
			obj mp = new obj();
			mp.field = contactList[i].Id;
			mp.obj = parentList[i].id;
			mpList.add(mp);
		}
		return mpList;
	}

	public static List<field> createCities(Integer num){
		List<field> cityList = new List<field>();
		for (Integer i=0; i<num; i++){
			field city = new field();
			city.Name = 'City ' + String.valueOf(i);
			city.field = String.valueOf(i);
			city.field = 'TestCity' + String.valueOf(i);
			cityList.add(city);
		}
		return cityList;
	}

	public static List<objr> createMalkarCities(Integer num, List<obj> malkarList, List<field> cityList){
		if (malkarList.size() < num || cityList.size() < num){
			return null;
		}
		List<objr> mcList = new List<objr>();
		for (Integer i=0; i<num; i++){
			objr mc = new objr();
			mc.field = cityList[i].Id;
			mc.obj = malkarList[i].Id;
			mc.field = 'Address';
			mcList.add(mc);
		}
		return mcList;
	}

	public static List<Attachment> createAttachments(Integer numAttachments, List<SObject> parentList){
		if (parentList.size() < numAttachments ){return null;}
		List<Attachment> attachments = new List<Attachment>();
		for (Integer i=0; i<numAttachments; i++){
			Attachment att = new Attachment(
				Name = 'Test Attachment ' + String.valueOf(i),
				Body = Blob.valueOf('String o'),
				ParentId = parentList[i].Id
				);
			attachments.add(att);
		}
		return attachments;
	}

	public static List<obj> createTmichot(Integer num, List<obj> parentList){
		if (parentList.size() < num) {return null;}
		List<obj> tmichot = new List<obj>();
		for (Integer i=0; i<num; i++){
			obj tmicha = new obj(
				field = parentList[i].Id,
				field = Date.today().year(),
				field = 9001
				);
			tmichot.add(tmicha);
		}
		return tmichot;
	}

	public static List<field> createTestSupports(Integer num){
		List<field> testSupports = new List<field>();
		for (Integer i=0; i<num; i++){
			field ts = new field(field = 'Test Support test '+i);
			testSupports.add(ts);
		}
		return testSupports;
	}

	public static List<field> createWebsiteContent(Integer num){
		List<field> content = new List<field>();
		for (Integer i=0; i<num; i++){
			field wc = new field(
				field = 'Guidestar',
				field = 'Test Body' + i,
				field = true,
				field = 'About', 
	    		field = 'Main',
	    		field = 'Test Title ' + i
    		);
			content.add(wc);
		}
		return content;
	}

	public static List<Map<string, string>> getClassSettingListItems(Integer numSettings){
		List<Map<string, string>> returnList = new List<Map<string, string>>();
		for (Integer i = 0; i < numSettings; i++){
			Map<string, string> classificationSetting = new Map<string, string>{
				'field' => String.valueOf(i),
				'field' => 'Halamas Text ' + String.valueOf(i),
				'field' => 'Old Rasham ' + String.valueOf(i),
				'field' => String.valueOf(i),
				'field' => String.valueOf(i),
				'field' => 'Primary Text ' + String.valueOf(i),
				'field' => String.valueOf(i),
				'field' => 'Secondary Text ' + String.valueOf(i)
			};
			returnList.add(classificationSetting);
		}
		return returnList;
	}

	public static List<obj> getClassifications(Integer numClassifications, List<obj> malkarList ){
		if (malkarList.size() < numClassifications){
			return null;
		}
		List<obj> classifications = new List<obj>();
		for (Integer i = 0; i < numClassifications; i++){
			obj clss = new obj();
			clss.obj = malkarList[i].Id;
			classifications.add(clss);
		}
		return classifications;
	}

}