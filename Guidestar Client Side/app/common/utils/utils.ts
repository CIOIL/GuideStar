import * as _ from 'lodash';

export function getBackgroundImageObject(src){
    let baseUrlAssets = window['baseUrlAssets'] || '';
    return {
            'background-size': '100% 100%', 
            'background-repeat': 'no-repeat', 
            'background-image': `url(${baseUrlAssets}/${src})`
        };
}

export function getBackgroundImageUrl(src){
    let baseUrlAssets = window['baseUrlAssets'] || '';
    return `${baseUrlAssets}/${src}`;
}

export function getNewState(state, result, key){
	let newState = _.cloneDeep(state);
	newState[key] = _.cloneDeep(result);
	return newState;
}

export function getNewEmptyState(state, key){
  let newState = _.cloneDeep(state);
  newState[key] = {};
  return newState;
}

export function getMalkarAddress(malkarData: any){
  let addressList = [];
  let addr = '';
  
  if (malkarData.addressStreet) addressList.push(malkarData.addressStreet);
  if (malkarData.addressHouseNum) addressList.push(malkarData.addressHouseNum);
  if (malkarData.city) addressList.push(malkarData.city);
  if (malkarData.addressZipCode) addressList.push(malkarData.addressZipCode);
  addr = addressList.join(', ');
  return addr;
}

export function getMalkarActivityArea(malkarData: any, nationalLabel: string){
  if (malkarData.malkarLocationIsNational){
    return nationalLabel;
  }
  if (!_.isEmpty(malkarData.malkarDistricts)){
    return malkarData.malkarDistricts;
  }
  return '';
}

export function getMalkarActivityPlaces(malkarData: any){
  if (!_.isEmpty(malkarData.cities)){
    return malkarData.cities;
  }
  return '';
}

export function pushEventToDataLayerGTM(event: string, data: any = null){
  if(window['dataLayer']){
    window['dataLayer'].push({
      event: event,
      data: data
    });
  }
}

export function getGeoWKTPoint(point: any[], isLatLng: boolean = true){
  if (!_.isEmpty(point) && point.length === 2){
    if(isLatLng){
      point = convertLatLngToIsraelTm(point[0], point[1]);
    }
    return `POINT (${point[0]} ${point[1]})`;
    //return `POINT (179256.24 665670.71)`;
  }
  return '';
}

export function convertLatLngToIsraelTm(lat, lng){
  if(lat && lng){
    return WgsToIsrael(lat, lng);
  }
}


//////////////////////////////////////////
// convert wgs84 to israel tm grid...
//////////////////////////////////////////
function degreesToRadians(degrees) {
  return degrees * Math.PI / 180;
}

function pow2(x) {
  return x*x;
}

function pow3(x) {
  return x*x*x;
}

function pow4(x) {
  return x*x*x*x;
}

/*function ITMLocation(easting, northing) {
  this.easting = easting;
  this.northing = northing;
  this.eastingInOldGrid = function() {
    return easting - 50000;
  }
  this.northingInOldGrid = function() {
    var retval = northing - 500000;
    if (retval<0) {
      retval += 1000000;
    }
    return retval;
  }
}*/

function WgsToIsrael(latitude, longitude)
{
  longitude = degreesToRadians(longitude);
  latitude = degreesToRadians(latitude);
  //LatLongToITM(latitude, longitud);
  // Projection parameters
  let centralMeridian = degreesToRadians(35.2045169444444);  // central meridian of ITM projection
  let scaleFactor = 1.0000067;  // scale factor

  // Ellipsoid constants (WGS 80 datum)
  let equatorialRadius = 6378137;  // equatorial radius
  let polarRadius = 6356752.3141; // polar radius
  let eccentricity = Math.sqrt(1 - polarRadius*polarRadius/equatorialRadius/equatorialRadius);  // eccentricity
  let e1sq = eccentricity*eccentricity/(1-eccentricity*eccentricity);
  let n = (equatorialRadius-polarRadius)/(equatorialRadius+polarRadius);

  // Curvature at specified location
  let tmp = eccentricity*Math.sin(latitude);
  let nu = equatorialRadius/Math.sqrt(1 - tmp*tmp);

  // Meridional arc length
  let n3 = pow3(n);
  let n4 = pow4(n);
  let A0 = equatorialRadius*(1-n+(5*n*n/4)*(1-n) +(81*n4/64)*(1-n));
  let B0 = (3*equatorialRadius*n/2)*(1 - n - (7*n*n/8)*(1-n) + 55*n4/64);
  let C0 = (15*equatorialRadius*n*n/16)*(1 - n +(3*n*n/4)*(1-n));
  let D0 = (35*equatorialRadius*n3/48)*(1 - n + 11*n*n/16);
  let E0 = (315*equatorialRadius*n4/51)*(1-n);
  let S = A0*latitude - B0*Math.sin(2*latitude) + C0*Math.sin(4*latitude)
  - D0*Math.sin(6*latitude) + E0*Math.sin(8*latitude);

  // Coefficients for ITM coordinates
  let p = longitude-centralMeridian;
  let Ki = S*scaleFactor;
  let Kii = nu*Math.sin(latitude)*Math.cos(latitude)*scaleFactor/2;
  let Kiii = ((nu*Math.sin(latitude)*pow3(Math.cos(latitude)))/24)*(5-pow2(Math.tan(latitude))+9*e1sq*pow2(Math.cos(latitude))+4*e1sq*e1sq*pow4(Math.cos(latitude)))*scaleFactor;
  let Kiv = nu*Math.cos(latitude)*scaleFactor;
  let Kv = pow3(Math.cos(latitude))*(nu/6)*(1-pow2(Math.tan(latitude))+e1sq*pow2(Math.cos(latitude)))*scaleFactor;

  let easting = Math.round(219529.58+ Kiv*p+Kv*pow3(p) - 60);
  let northing = Math.round(Ki+Kii*p*p+Kiii*pow4(p) - 3512424.41+ 626907.39 - 45);
  return [easting, northing];
}