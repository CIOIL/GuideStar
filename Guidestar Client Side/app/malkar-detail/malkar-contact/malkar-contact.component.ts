import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { MalkarDetailService } from '../malkar-detail.service';
import { getBackgroundImageObject, getBackgroundImageUrl, getMalkarAddress, getMalkarActivityArea, getMalkarActivityPlaces} from '../../common/utils/utils';
import { CommonService } from '../../common/services/common.service';

import { LatLngBounds, MapsAPILoader } from '@agm/core';
import * as _ from 'lodash';
declare var google: any;

@Component({
  selector: 'app-malkar-contact',
  templateUrl: './malkar-contact.component.html',
  styleUrls: ['./malkar-contact.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarContactComponent implements OnInit {

  $Label: any;
  malkarData: any;
  latlngBounds: LatLngBounds;
  mapCenterLat: number;
  mapCenterLng: number;

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  public getMalkarAddress = getMalkarAddress;
  public getMalkarActivityArea = getMalkarActivityArea;
  public getMalkarActivityPlaces = getMalkarActivityPlaces;
  iconWebsite: string = 'assets/img/icons/website-icon-mobile.png';
  iconFacebook: string = 'assets/img/icons/facebook-icon-mobile.png';
  iconYoutube: string = 'assets/img/icons/youtube-icon-mobile.png';
  iconPhone: string = 'assets/img/icons/phone-icon-mobile.png';
  iconAddress: string = 'assets/img/icons/address-icon-mobile.png';
  iconEmail: string = 'assets/img/icons/email-icon-mobile.png';

  urlPrefix : string = 'http://';

  constructor(private malkarDetailService :MalkarDetailService, private mapsAPILoader: MapsAPILoader, private commonService: CommonService, private ref: ChangeDetectorRef) { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkarData = malkar.result;
        this.getMalkarLocation();
        this.commonService.setMeta(this.malkarData.Name + ' - ' + this.$Label.Contact_us /*+ ' | ' + this.$Label.Site_Title*/, null);
        this.ref.markForCheck();
      }
    );
  }

  getAddress(): string{
    if(this.malkarData.greenInfo){
      let addressList = [];
      let addr = '';
      
      if (this.malkarData.greenInfo.addressStreet) addressList.push(this.malkarData.greenInfo.addressStreet);
      if (this.malkarData.greenInfo.addressHouseNum) addressList.push(this.malkarData.greenInfo.addressHouseNum);
      if (this.malkarData.greenInfo.city) addressList.push(this.malkarData.greenInfo.city);
      if (this.malkarData.greenInfo.addressZipCode) addressList.push(this.malkarData.greenInfo.addressZipCode);
      addr = addressList.join(', ');
      return addr;
    }
  }

  getLabelValueStyle(){
    return {'margin' : '0 0 0.3em 0'};
  }

  getMalkarLocation(){
    this.mapCenterLat = this.malkarData.lat;
    this.mapCenterLng = this.malkarData.lng;

    this.mapsAPILoader.load().then(map => {
      if(this.malkarData.malkarCities && this.malkarData.malkarCities.length > 1){
        this.latlngBounds = new google.maps.LatLngBounds();
        this.latlngBounds.extend(new google.maps.LatLng(this.malkarData.lat, this.malkarData.lng));
        _.forEach(this.malkarData.malkarCities, city => this.latlngBounds.extend(new google.maps.LatLng(city.lat, city.lng)));
        this.ref.markForCheck();
      }
    });
  }
}
