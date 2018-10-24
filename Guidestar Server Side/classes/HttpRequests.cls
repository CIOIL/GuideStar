global with sharing class HttpRequests {
	
	public final static String OauthToken = 'https://login.salesforce.com/services/oauth2/token';
	public final static String OauthAuthorize = 'https://login.salesforce.com/services/oauth2/authorize';
	public final static String sandboxURL = 'https://test.salesforce.com';
	public final static String productionURL = 'https://login.salesforce.com';
	public final static String PushNotification = 'https://boxcar-api.io/api/push';
	
	public static HttpResponse HttpReq(String Method, String Endpoint, String Body, Map<String,String> Headers){
		try{
			Utils.log('++Body++' + Body);
			Utils.log('++Headers++' + Headers);
			Http h = new Http();
	    	HttpRequest req = new HttpRequest();
	 		req.setEndpoint(Endpoint);
	 		req.setMethod(Method);
	 		req.setTimeout(2 * 60 * 1000);
	 		if(Method != 'GET' && Body != null){
	 			req.setBody(Body);
	 		}
	 		if(Headers != null && !Headers.isEmpty()){
		 		for(String headerK : Headers.keySet()){
		 			req.setHeader(headerK, Headers.get(headerK));
		 		}
	 		}
			HttpResponse res = h.send(req);
			Utils.log('++++' + res.getBody());
			return res;
		}
		catch(Exception e){
            Utils.log('HttpReq: ' , e);
            /*if(e.getMessage() != null && e.getMessage().contains('Setup->Security->Remote')){
            	system.debug('\n\n sendMail \n\n');
	        	Utils.log(emailResult);
	        }*/
            return null;
        }
	}
	
	public static Map<String,Object> returnMapFromResponse(HttpResponse res){
		if(res == null)
			return null;
		return returnMapFromString(res.getBody());	
	}
	
	public static map<String,Object> returnMapFromString(String str){
		if(str == null)
			return null;
		return (map<String,Object>) JSON.deserializeUntyped(str);
	}
	
	public static Map<String,String> getHeaders(String Token, Boolean urlEncoded){
		return getHeaders(Token, urlEncoded, true);
	}
	
	public static Map<String,String> getHeaders(String Token, Boolean urlEncoded, Boolean isBearer){
		Map<String,String> Headers = new Map<String,String>();
		Headers.put('Accept', '*/*');
		if(urlEncoded)
			Headers.put('Content-Type', 'application/x-www-form-urlencoded');
		else
			Headers.put('Content-Type', 'application/json');
			
		if(Token != null && Token != ''){
			String tok = isBearer ? 'Bearer ' + Token : Token;
			Headers.put('Authorization', tok);
		}
		return Headers;
	}
	
	public static HttpResponse soapLogin(string username, string token){
		string body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com"><soapenv:Header><urn:LoginScopeHeader> <urn:organizationId>' + UserInfo.getOrganizationId() + '</urn:organizationId></urn:LoginScopeHeader> </soapenv:Header> <soapenv:Body><urn:login><urn:username>' + username + '</urn:username><urn:password>' + token + '</urn:password></urn:login></soapenv:Body></soapenv:Envelope>';
		map<String,String> Headers = new map<String,String>();
		Headers.put('Content-Type', 'text/xml');
        Headers.put('SoapAction', 'SoapAction');
        String url = false ? sandboxURL : productionURL;
		return HttpReq('POST', url +'/services/Soap/c/33.0', body, Headers);
	} 
	
	public static String getSessionFromSoapResponse(HttpResponse res){
		if(res != null && res.getBody() != null){
			return getSessionFromSoapResponseString(res.getBody());
		}
		else
			return null;
	}
	
	public static String getSessionFromSoapResponseString(String res){
		try{
			if(res != null){
				Dom.Document doc = new Dom.Document();
		      	doc.load(res);
		        Dom.XMLNode loginResult = doc.getRootElement().getChildElements()[0].getChildElements()[0].getChildElements()[0];
				for(Dom.XMLNode child : loginResult.getChildElements()) {
					if(child.getName() == 'sessionId'){
  						return child.getText();
					}
				}
		        return null;
			}
			return null;
        }
        catch(Exception e){
        	Utils.log(e);
        	return null;
        }
	}
	
	
}