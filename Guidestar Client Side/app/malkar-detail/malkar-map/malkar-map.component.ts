import { Component, OnInit, AfterViewInit, Input, OnDestroy, ChangeDetectionStrategy } from '@angular/core';
import { govmap } from '../../../assets/scripts/govmap.api.js';
import { Observable, Subscription } from 'rxjs';
import { MalkarDetailService } from '../malkar-detail.service';
import * as _ from 'lodash';
import { AppParams } from '../../common/enums/app-params';
import { getGeoWKTPoint } from '../../common/utils/utils';

@Component({
  selector: 'app-malkar-map',
  templateUrl: './malkar-map.component.html',
  styleUrls: ['./malkar-map.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarMapComponent implements OnInit, AfterViewInit, OnDestroy {
  
  $Label: any;
  malkarSub: Subscription;
  subs: Subscription[] = [];
  govmap: any;
  malkar: any;
  isMapLoaded: boolean = false;
  isMarkersLoaded: boolean = false;
  points: any[];
  pointsNames: any[];
  pointsTooltips: any[];

  constructor(private malkarDetailService: MalkarDetailService) { 
    this.$Label = window['$Label'];
    this.govmap = govmap();
  }

  ngOnInit() {
    this.malkarSub = this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkar = malkar.result;
        this.getMalkarLocation();
      }
    );
  }

  ngAfterViewInit(){
    this.govmap.createMap('map_div',
                {
                    token: '2cd08dde-304d-4f73-9514-6ada666127de',
                    visibleLayers: [AppParams.govmapLayers[0]],
                    //layers: [AppParams.govmapLayers[0]],
                    showXY: false,
                    isEmbeddedToggle: false,
                    identifyOnClick: true,
                    zoomButtons: false,
                    onLoad: () => { return this.mapLoaded() }
                });
  }

  mapLoaded(){
    this.isMapLoaded = true;
    if(!this.isMarkersLoaded){
      this.getMalkarLocation();
    }
  }

  getMalkarLocation(){
    /*this.mapsAPILoader.load().then(map => {
      if(this.malkar.malkarCities && this.malkar.malkarCities.length > 1){
        this.latlngBounds = new google.maps.LatLngBounds();
        this.latlngBounds.extend(new google.maps.LatLng(this.malkar.lat, this.malkar.lng));
        _.forEach(this.malkar.malkarCities, city => this.latlngBounds.extend(new google.maps.LatLng(city.lat, city.lng)));
        this.ref.markForCheck();
      }
    });*/
    if(this.isMapLoaded && this.malkar){
      let whereClause = `NUMBER_ in (${this.malkar.regNum})`;
      //in order to highlight the places with bubble option
      this.govmap.searchInLayer({
        layerName: AppParams.govmapLayers[0],
        fieldName: 'NUMBER_',
        fieldValues: [this.malkar.regNum],
        highlight: true, 
        showBubble: false,
        outLineColor: [255, 0, 0, 1],
        fillColor: [255, 255, 0, 0.5]
      });
      //show only the places of the malkar
      this.govmap.filterLayers({ layerName: AppParams.govmapLayers[0], whereClause: whereClause, zoomToExtent: true});

      this.points = [getGeoWKTPoint([this.malkar.lat, this.malkar.lng]), ... _.map(this.malkar.malkarCities, (city) => {
          return getGeoWKTPoint([city.lat, city.lng]);
        })];
      this.pointsNames = [this.$Label.Address, ... _.map(this.malkar.malkarCities, (city) => {
          return city.cityName;
        })];
      this.pointsTooltips = [this.malkar.geolocationDescription, ... _.map(this.malkar.malkarCities, (city) => {
          return city.description;
        })];

      this.govmap.displayGeometries({
        wkts: this.points,
        names: this.pointsNames,
        geometryType: this.govmap.drawType.Point,
        defaultSymbol:{
          url: 'https://new.govmap.gov.il/images/marker.png',
          width: '32',
          height: '32'
        },
        symbols: [],
        clearExistings: false,
        data: {
          tooltips: this.pointsTooltips,
          bubbles: this.pointsTooltips,
          bubbleUrl: 'http://govmap.gov.il'
        }
      });
      setTimeout(() => this.govmap.zoomToDrawing(), 4500);
      // this.govmap.zoomToXY({x: this.malkar.lat, y: this.malkar.lng, level: 0, marker: true});
      this.isMarkersLoaded = true;
    }
  }

  ngOnDestroy(){
    if (this.malkarSub){
      this.malkarSub.unsubscribe();
    }
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

}
