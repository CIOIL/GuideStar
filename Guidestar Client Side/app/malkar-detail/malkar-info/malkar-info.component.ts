import { Component, OnInit, Input, OnDestroy, ViewChild, ElementRef, ChangeDetectionStrategy, ChangeDetectorRef, AfterViewInit } from '@angular/core';
import { MalkarDetailService } from '../malkar-detail.service';
import { getBackgroundImageObject, getBackgroundImageUrl, getMalkarAddress, getMalkarActivityArea, getMalkarActivityPlaces } from '../../common/utils/utils';
import { MapsAPILoader, AgmMap, LatLngBounds, LatLngBoundsLiteral} from '@agm/core';
declare var google: any;
// import { routerTransition } from '../malkar-detail.router.animation';
import * as _ from 'lodash';
import { Subscription } from 'rxjs';
import { CommonService } from '../../common/services/common.service';
import { COMMON_GRAPH_DISPLAY } from '../../common/ngrx/common.actions';
import { AppParams } from '../../common/enums/app-params';

@Component({
  selector: 'app-malkar-info',
  templateUrl: './malkar-info.component.html',
  styleUrls: ['./malkar-info.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
  // ,
  // animations: [routerTransition()],
  // host: {'[@routerTransition]': ''}
})
export class MalkarInfoComponent implements OnInit, OnDestroy{

  latlngBounds: LatLngBounds;
  malkarData: any;
  chartDataDistrict: any = [];
  $Label: any;
  malkarSub: Subscription;
  subs: Subscription[] =[];
  mapCenterLat: number;
  mapCenterLng: number;
  graphShowList: boolean = false;
  isHekdesh: boolean = false;

  // fullscreenControlOptions: any = {position: 7};

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  public getMalkarAddress = getMalkarAddress;
  public getMalkarActivityArea = getMalkarActivityArea;
  public getMalkarActivityPlaces = getMalkarActivityPlaces;
  iconWebsite: string = 'assets/img/icons/website-icon-mobile.png';
  iconFacebook: string = 'assets/img/icons/facebook-icon-mobile.png';
  iconYoutube: string = 'assets/img/icons/youtube-icon-mobile.png';
  iconPhone: string = 'assets/img/icons/phone-icon-mobile.png';
  iconShowChart: string = 'assets/img/icons/icon-graphs-tables-toggle1.png';
  iconShowList: string = 'assets/img/icons/icon-graphs-tables-toggle2.png';

  @ViewChild('chartActiveIcon')chartActiveIcon: ElementRef  ;
  @ViewChild('listActiveIcon')listActiveIcon: ElementRef  ;

  constructor(private malkarDetailService :MalkarDetailService, private mapsAPILoader: MapsAPILoader, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    this.malkarSub = this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkarData = malkar.result;
        if(this.malkarData.sugHitagdutLabel && this.malkarData.sugHitagdutLabel === AppParams.hekdesh){
          this.isHekdesh = true;
        }
        else{
          this.isHekdesh = false;
        }
        this.getMalkarLocation();
        if(!_.has(malkar, 'chartDataDistrict')){
          this.getChartData();
        }
        else{
          this.chartDataDistrict = malkar.chartDataDistrict || [];
        }
        this.commonService.setMeta(this.malkarData.Name + ' | ' + this.$Label.Site_Title, null);
        this.ref.markForCheck();
      }
    );
    this.subs.push(this.commonService.common.subscribe(res =>{
      if (_.has(res, COMMON_GRAPH_DISPLAY)){
        this.graphShowList = res[COMMON_GRAPH_DISPLAY] === AppParams.graphDisplayList ? true : false;
        this.ref.markForCheck();
      }
    }));
  }

  ngOnDestroy(){
    if (this.malkarSub){
      this.malkarSub.unsubscribe();
    }
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  getLabelValueStyle(){
    return {'margin' : '0 0 0.3em 0'};
  }

  getChartData(){
    if(this.malkarData.tchumPeilutMainNum){
      this.malkarDetailService.getChartDataDistrict(this.malkarData.tchumPeilutMainNum);
    }
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

  showChartClicked(ev, rightActive: boolean){
    let clickSpot = Math.floor(ev.currentTarget.width/2);
    if (ev.currentTarget.getBoundingClientRect().right-clickSpot > ev.clientX){ // left side clicked
      if (this.graphShowList){
        this.toggleShowChart(rightActive);
      }
    }
    else{
      if (!this.graphShowList){
        this.toggleShowChart(rightActive);
      }
    }
  }

  toggleShowChart(rightActive: boolean){
    if (this.graphShowList){
      this.commonService.getGraphDisplay(AppParams.graphDisplayChart);
    }
    else{
      this.commonService.getGraphDisplay(AppParams.graphDisplayList);
    }
    if (rightActive){
      setTimeout(() => this.chartActiveIcon.nativeElement.focus(), 100);
    }
    else{
      setTimeout(() => this.listActiveIcon.nativeElement.focus(), 100);
    }
  }

}
