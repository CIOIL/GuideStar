import { Component, OnInit, OnDestroy, ViewChild, ElementRef, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { HomeService } from './home.service';
import { CHART_CLASSIFICATION, CHART_DISTRICT, CHART_TMIHOT, REPORT_TOTALS, MAIN_CLASSIFICATIONS } from './home.reducer';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';
import { getBackgroundImageObject, getBackgroundImageUrl, pushEventToDataLayerGTM } from '../common/utils/utils';

import * as _ from 'lodash';
import { FormControl, FormGroup, AbstractControl } from '@angular/forms';
import { Subscription ,  Observable, of } from 'rxjs';
import { Router } from '@angular/router';
import { CommonService } from '../common/services/common.service';
import { pages } from '../../environments/pages';
import { AppParams } from '../common/enums/app-params';
import { COMMON_GRAPH_DISPLAY, COMMON_FILTER_STATE_RESET, COMMON_FILTER_STATE, COMMON_SEARCH_WORD_HEADER } from '../common/ngrx/common.actions';

declare var jQuery: any;

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('collapsed, void', style({
        height: '11.5em'
      })),
      state('expanded', style({
        height: AUTO_STYLE
      })),
      transition('collapsed <=> expanded', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HomeComponent implements OnInit, OnDestroy {

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;

  $Label: any;

  home;
  homeClassifications;
  homeDistricts;
  homeTmihot;
  reportTotals;
  mainClassifications : any = {};

  homeServiceSub: Subscription;
  subs: Subscription[] = [];

  searchForm: FormGroup;
  searchWordControlName: string = 'searchWord';

  backgroundImgPath: string = '/assets/img/photos/';
  backgroundImgUrl: string = '';
  iconSearch: string = 'assets/img/icons/icon-magni-white-desktop-home.png';
  iconShowChart: string = 'assets/img/icons/icon-graphs-tables-toggle1.png';
  iconShowList: string = 'assets/img/icons/icon-graphs-tables-toggle2.png';

  countoParams: string[] =[];
  graphShowList: boolean = false;

  popularSearchState: string = 'collapsed';
  illegalSearchRegex: string = (<any> AppParams.illegalSearchRegex);

  @ViewChild('chartActiveIcon')chartActiveIcon: ElementRef  ;
  @ViewChild('listActiveIcon')listActiveIcon: ElementRef  ;
  
  constructor(private homeService: HomeService, private router: Router, private commonService: CommonService, private ref: ChangeDetectorRef) { 
    this.$Label = window['$Label']; 
    this.searchForm = new FormGroup({});
    this.getBackgroundImage();
    this.homeService.getHomeChartMainClassifications();
    this.homeService.getHomeChartDistricts();
    this.homeService.getHomeChartTmihot();
  }

  ngOnInit(){ 
    this.backgroundImgUrl = this.getBackgroundImage();
    this.commonService.setMeta(this.$Label.Site_Title, this.$Label.Description_Home);
    this.commonService.getFilterState({}, COMMON_FILTER_STATE_RESET);
    this.homeServiceSub = this.homeService.home.subscribe(
      home => {
        this.home = home.result;
        if(_.has(home, REPORT_TOTALS) && _.isEmpty(this.reportTotals)){
          this.reportTotals = home[REPORT_TOTALS];
          this.createCountoParams(); 
        }
        this.homeClassifications = home[CHART_CLASSIFICATION];
        this.homeDistricts = home[CHART_DISTRICT];
        this.homeTmihot = home[CHART_TMIHOT];
        if(_.has(home,MAIN_CLASSIFICATIONS)){
          this.mainClassifications = home[MAIN_CLASSIFICATIONS];
        }
        this.buildSearchForm();
        this.ref.markForCheck();
      }
    );
    this.subs.push(this.commonService.common.subscribe(res =>{
      if (_.has(res, COMMON_GRAPH_DISPLAY)){
        this.graphShowList = res[COMMON_GRAPH_DISPLAY] === AppParams.graphDisplayList ? true : false;
        this.ref.markForCheck();
      }
    }));
    // this.commonService.addObservable(of({Search: '' }), AppParams.searchWordObservableKey);
    // this.commonService.addObservable(of({}), AppParams.searchFilterObservableKey);
    this.ref.markForCheck();
  }

  ngOnDestroy(){
    if (this.homeServiceSub){
      this.homeServiceSub.unsubscribe();
    }
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  buildSearchForm(){
    this.searchForm.addControl(this.searchWordControlName, new FormControl(''));
    if(this.mainClassifications.apiName){
      this.searchForm.addControl(this.mainClassifications.apiName, new FormControl([]));
      // this.commonService.addObservable(this.searchForm.controls[this.mainClassifications.apiName].valueChanges, AppParams.searchFilterObservableKey);
      this.ref.markForCheck();
    }
  }

  searchClicked(){
    if (this.searchForm && this.searchForm.controls && this.searchForm.controls['CLSS_Main_Classification_Num'] && this.searchForm.controls['CLSS_Main_Classification_Num'].value){
      //this.commonService.addObservable(of({Search: this.searchForm.controls[this.searchWordControlName].value || '' }), AppParams.searchWordObservableKey);
      //this.commonService.addObservable(of({CLSS_Main_Classification_Num: this.searchForm.controls['CLSS_Main_Classification_Num'].value}), AppParams.searchFilterObservableKey);
      /* 
       * When the search page loads, the header checks its current search word (taken from URL) with the value in the store.
       * If they differ, then it is a new search and the search filter is reset.
       * In this case, searching from home, we need to prevent that, so that the search filter will remain (CLSS_Main_Classification_Num);
       * Therefore we save the search word.
       * The search word must be saved first, because that is the function that resets the search filter.
       * So order of actions:
       * 1.   Save search word.
       * 1.a. Erase old search filter.
       * 2.   Save search filter.
       * 3.   Search page header tries to save search word.
       * 3.a. Sees that it is the same as old search word, does not reset filter.
       */
      let filterHome = {CLSS_Main_Classification_Num: this.searchForm.controls['CLSS_Main_Classification_Num'].value};
      this.commonService.getFilterState(this.searchForm.controls[this.searchWordControlName].value || '', COMMON_SEARCH_WORD_HEADER);
      this.commonService.getFilterState(filterHome, COMMON_FILTER_STATE);
      setTimeout(() => pushEventToDataLayerGTM('searchMalkarsFilterHome', filterHome), 100);
      this.ref.markForCheck();
    }
    pushEventToDataLayerGTM('searchMalkarsHome', this.searchForm.controls[this.searchWordControlName].value);
    this.navigate([pages.searchMalkars, this.searchForm.controls[this.searchWordControlName].value || '']).then(res => res, error => {
      console.log(error);
      this.navigate([pages.error]);
      this.ref.markForCheck();
    });
  }

  popularSearchClicked(item){
    if(item && item.SubLabel){
      // this.commonService.addObservable(of(JSON.parse(item.SubLabel)), AppParams.searchFilterObservableKey);
      this.commonService.getFilterState(JSON.parse(item.SubLabel), COMMON_FILTER_STATE);
      this.ref.markForCheck();
    }
    setTimeout(() => pushEventToDataLayerGTM('popularSearchClicked', {label: this.$Label[item.MainLabel], amount: item.Amount}), 100);
    this.navigate([pages.searchMalkars]).then(res => res, error => {
      console.log(error);
      this.navigate([pages.error]);
      this.ref.markForCheck();
    });
    
  }

  searchItemSelected(ev){
    if (ev && ev.value){
      this.navigate(ev.value.split('/'));
    }
  }

  navigate(link){
    return this.router.navigate(link);
  }

  getBackgroundImage(){
    let baseUrlAssets = window['baseUrlAssets'] || '';
    let num = Math.floor(Math.random() * 10) % 5 +1;
    return 'url('+baseUrlAssets+this.backgroundImgPath + num + '.jpg)';
  }

  createCountoParams(){
    if (this.reportTotals && this.reportTotals.DataMap && this.reportTotals.DataMap.GuidestarHomePageImportant && this.reportTotals.DataMap.GuidestarHomePageImportant.Data){
      let arr = this.reportTotals.DataMap.GuidestarHomePageImportant.Data;
      this.countoParams = _.map(arr, x => x.SubLabel);
    }
  }

  countoFinished(){
    jQuery('.carousel').carousel();
  }

  toggleExpandView(){
    this.popularSearchState = this.popularSearchState === 'expanded' ? 'collapsed' : 'expanded';
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
