public class Utils_HttpRequests {
    public static final String GeocodeGoogleURL = 'https://maps.googleapis.com/maps/api/geocode/json';
    private static final String RecaptchaGoogleURL = 'https://www.google.com/recaptcha/api/siteverify';
    
    public static Utils.Geolocation getAddressGeolocation(string address){
		HttpResponse res = getAddressGeolocationRequest(EncodingUtil.urlEncode(address, 'UTF-8'));
		if(res != null && String.isNotBlank(res.getBody())){
			AddressGeolocationResult agr;
			try{
				agr = (AddressGeolocationResult) JSON.deserialize(res.getBody(), AddressGeolocationResult.class);
				if(agr != null && agr.results != null && !agr.results.isEmpty()){
					if(agr.results[0].geometry != null){
						utils.log('result for address:  ' + address, agr.results[0].geometry.location);
						return agr.results[0].geometry.location;
					}
				}
			}
			catch(Exception e){
				System.debug(e);
			}
		}
		return null;
	} 
	
    public static HttpResponse getAddressGeolocationRequest(string address){
		obj keySetting = obj.getInstance('Google_maps_publicKey');
		if(keySetting != null && String.isNotBlank(keySetting.field)){
			String params = '?key=' + keySetting.field;
			params += '&address=' + address;
			return HttpRequests.HttpReq('GET', GeocodeGoogleURL + params, null, HttpRequests.getHeaders(null, true));
		}
		else{
			return null;
		}
	} 
	
	public class AddressGeolocationResult{
		public List<AddressGeolocationResultGeometry> results;
	}
	public class AddressGeolocationResultGeometry{
		public AddressGeolocationResultGeometryLocation geometry;
	}
	public class AddressGeolocationResultGeometryLocation{
		public Utils.Geolocation location;
	}
	
	public static boolean verifyRecaptcha(String token) {
		if(String.isNotBlank(token)){
			HttpResponse res = verifyRecaptchaRequest(token);
			map<String, Object> responseMap;
	        if ( res != null && res.getBody() != null) {
	       		responseMap = (map<String, Object>) Json.deserializeUntyped(res.getBody());
	        }
			return responseMap != null && (boolean) responseMap.get('success') == true ? true : false;
		}
        return false;
    }
    
    public static HttpResponse verifyRecaptchaRequest(string token){
		obj secretSetting = obj.getInstance('Google_recaptcha_secretKey');
		if(secretSetting != null && String.isNotBlank(secretSetting.field)){
			String params = 'secret=' + secretSetting.field;
			params += '&response=' + token;
			return HttpRequests.HttpReq('POST', RecaptchaGoogleURL, params, null);
		}
		else{
			return null;
		}
	} 
}