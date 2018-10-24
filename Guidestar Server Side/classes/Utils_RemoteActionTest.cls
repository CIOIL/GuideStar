@isTest
private class Utils_RemoteActionTest{

	static TestMethod void testGets(){
		Utils_RemoteAction.getFieldPicklistValues('User', 'LanguageLocaleKey');
		Utils_RemoteAction.getCurrentUser();
		List<c> contentList = GSTAR_TestUtils.createWebsiteContent(1);
		insert contentList;
		Utils_RemoteAction.getWebsiteContent(contentList[0].c, contentList[0].c,  contentList[0].c);
	}

	static TestMethod void testVerifyRecaptcha(){
		Map<string, string> settingsMap = new Map<string, string>{
            'Google_recaptcha_secretKey'=> 'key1'
        };
        List<obj> settings = GSTAR_TestUtils.createGlobalSettings(settingsMap);
        insert settings;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new GooglereCaptchaMockImpl());
		Utils_RemoteAction.verifyRecaptcha('String token');
		Test.stopTest();
	}

	static TestMethod void testDeleteObject(){
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0].Id;
        List<User> users = GSTAR_TestUtils.createUsers(profileId, 3);
        insert users;
        List<obj> malkars = GSTAR_TestUtils.createMalkars(3);
        System.runAs(users[0]){
        	insert malkars;
        	Utils_RemoteAction.deleteObject(malkars[0].Id);
        	try{
                Utils_RemoteAction.deleteObject(malkars[0].Id);
            }
            catch(Exception e){}
        }
        System.runAs(users[1]){
        	try{
                Utils_RemoteAction.deleteObject(malkars[1].Id);
            }
            catch(Exception e){}
        }
	}

	static TestMethod void testSearchCity(){
		List<c> cities = GSTAR_TestUtils.createCities(5);
		cities[1].c = '1';
		insert cities;
		Utils_RemoteAction.searchCity(cities[0].name);
		Utils_RemoteAction.searchCityAC(cities[0].Name);
		Utils_RemoteAction.searchCityAC('ירוש');
		Utils_RemoteAction.searchCityCodeAC(cities[0].c);
		Utils_RemoteAction.searchCityCodeAC(cities[1].c);
	}

	static TestMethod void testJError(){
		Utils_RemoteAction.createJSError('test.com/site/1', 'String fullMessage', 'String description');
		Utils_RemoteAction.createJSError('test.com/site/2', 'String fullMessage', 'String description');
		Utils_RemoteAction.createJSError('test.com/site/3', 'String fullMessage', 'String description');
		List<obj> jsErrors = [SELECT c FROM obj WHERE c = 'test.com/site/1'];
		for (obj jse : jsErrors){
			jse.c = 'new.url.com';
		}
		update jsErrors;
	}
}