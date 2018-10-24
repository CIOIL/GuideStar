@isTest
private class WS_DelegatedSSOTest{

	static TestMethod void testPost(){
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		string uri = 'https://sha-gdnptech.cs88.force.com/services/apexrest/delegated-sso/';

		Test.startTest();
		req.requestURI = uri;  
		req.httpMethod = 'POST';

		RestContext.request = req;
		RestContext.response = res;
        
        String body1 = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><Authenticate xmlns="urn:authentication.soap.sforce.com"><username>';
        String body2 = '</username><password>CAAXgFG8A8zIQPEHxib0m5XWu84ZD</password><sourceIp>10.01.01.01</sourceIp></Authenticate></soapenv:Body></soapenv:Envelope>';
        
        RestContext.request.requestBody = Blob.valueof(body1 + '1234@facebook.com' + body2);
        WS_DelegatedSSO.authenticate();
        WS_DelegatedSSO.getProviderUserIdFromUsername('Test');
        Test.stopTest();
	}


}