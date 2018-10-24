import { Component, OnInit, SimpleChanges, OnDestroy, ViewChild, ElementRef, Renderer2, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { Location, DatePipe } from '@angular/common';
import { SearchService, searchPageFunctions } from './search.service';
import { ActivatedRoute, Params } from '@angular/router';
import { getBackgroundImageObject, getBackgroundImageUrl, pushEventToDataLayerGTM } from '../common/utils/utils';
import { CommonService } from '../common/services/common.service';
import { Observable ,  Subscription ,  BehaviorSubject } from 'rxjs';
import { debounceTime, take, switchMap, map } from 'rxjs/operators';
import { COUNT_MALKARS } from './search.reducer';
import * as _ from 'lodash';
import { SearchFilterComponent } from '../common/components/search-filter/search-filter.component';
import { AppParams } from '../common/enums/app-params';
import { ExcelService } from '../common/services/excel.service';
import { ContentPosition } from '../common/enums/content-position';
import { COMMON_GLOBAL_SETTINGS, COMMON_FILTER_STATE, COMMON_REPORT_MALKARS_SIZE } from '../common/ngrx/common.actions';

declare var jQuery: any;

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss'],
  host: { '(click)': 'onClick($event)'},
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SearchComponent implements OnInit, OnDestroy {

  @ViewChild('sortConfigElement') sortConfigElement: ElementRef  ; 
  @ViewChild('searchFilterElement') searchFilterElement: ElementRef  ; 
  @ViewChild('searchFilterComponent') searchFilterComponent: SearchFilterComponent;
  
  $Label: any;

  filterConfig: any;
  selectedSearchFilters: any;
  searchResult: any[];
  searchWord: string;
  sortConfig: any[] = [];
  iconSortDown: string = 'assets/img/icons/icon-sorting-down-mobile.png';
  iconSortUp: string = 'assets/img/icons/icon-sorting-up-mobile.png';
  excelIcon = 'assets/img/icons/xls-icon.png';
  iconSortDirection: string = this.iconSortUp;
  iconSortLabel: string = '';
  // iconFilter: string = 'assets/img/icons/icon-filter.png';
  showSort: boolean;
  sortDesc: boolean = true;
  sortItem: any;
  displayFilter: boolean;// = true;
  // showFilter: boolean;
  searchMalkarCount: any;
  searchPageFunctions: any;
  searchMalkarIsLast : boolean;

  maxReportSize: number = 3000;
  reportSize: number;

  sheets: any[] = [];
  reservationsSheetData: any[] = [];
  reportColumns: any = {};
  exportFailed: boolean = false;
  discardExport: boolean = false;

  googleRecaptchaPublicKey: any = AppParams.GoogleRecaptchaPublicKey;
  captchaToken: any;
  isCaptchaExpired: boolean = false;

  commonFilterState = AppParams.searchFilterStateStoreKey;
  pushEventToDataLayerGTM: any;

  get commonReportLength(){
    return this.commonService.reportLength;
  }

  get commonIsRetrievingReport(){
    return this.commonService.isRetrievingReport;
  }

  get searchIsSearching(){
    return this.searchService.isSearching;
  }

  public searchMalkarCountLoading$;

  get searchLoadingMalkarCount(){
    return this.searchService.loading[searchPageFunctions.getSeachMalkarCount];
  }

  private subParam: Subscription;
  private subMalkars: Subscription;
  private subSearchConfig: Subscription;
  private subCommonService: Subscription;
  private subsArray: Subscription[] = [];

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  
  constructor(public searchService: SearchService, 
              private route: ActivatedRoute,
              private commonService: CommonService,
              private location: Location,
              private renderer: Renderer2, 
              private ref: ChangeDetectorRef,
              private excelService: ExcelService,
              private datePipe: DatePipe) {
                this.$Label = window['$Label'];
                this.iconSortLabel = this.$Label.Sort_up;
                this.searchPageFunctions = searchPageFunctions;
                this.commonService.setMeta(this.$Label.Site_Search_Title, this.$Label.Description_Search);
                this.searchMalkarCountLoading$ = this.commonService.common.pipe(map(state => state[`${searchPageFunctions.getSeachMalkarCount}_loading`]));  
                this.pushEventToDataLayerGTM = pushEventToDataLayerGTM;
              }

  ngOnInit() {
    this.getReservationSheetData();
    this.commonService.getGlobalSettings()
    this.commonService.getMalkarsReportColumns().then(res =>{
      if (res && res.result){
        this.reportColumns = res.result;
      }
    });
    // this.commonService.common.take(3).subscribe(res => {
    //   if (_.has(res, COMMON_GLOBAL_SETTINGS)){
    //     if (res.COMMON_GLOBAL_SETTINGS[AppParams.reportSizeKey] != null){
    //       this.maxReportSize = parseInt(res.COMMON_GLOBAL_SETTINGS[AppParams.reportSizeKey]);
    //     }
    //   }
    // });
    this.subsArray.push(this.commonService.common.pipe(map( (state : any) => state.COMMON_GLOBAL_SETTINGS)).subscribe(res => {
      if (res && res[AppParams.reportSizeKey] != null){
          this.maxReportSize = parseInt(res[AppParams.reportSizeKey]);
        }
    }));
    this.subsArray.push(this.commonService.common.subscribe(res => {
      if (_.has(res, COMMON_REPORT_MALKARS_SIZE)){
        if (res[COMMON_REPORT_MALKARS_SIZE] instanceof Array && res[COMMON_REPORT_MALKARS_SIZE].length > 0){
          this.reportSize = res[COMMON_REPORT_MALKARS_SIZE][0];
        }
        else{
          this.reportSize = res[COMMON_REPORT_MALKARS_SIZE];
        }
      }
    }));
    this.subsArray.push(this.commonService.common.subscribe(res => {
      if (_.has(res, COMMON_FILTER_STATE) && !_.isEmpty(res[COMMON_FILTER_STATE])){
        this.selectedSearchFilters = res[COMMON_FILTER_STATE];
        this.loadMore();
        this.ref.markForCheck();
      }
    }));
    this.searchService.resetLastResult();
    this.subSearchConfig = this.searchService.searchConfig.subscribe( searchConfig => {
      this.filterConfig = searchConfig.filter;
      this.sortConfig = searchConfig.sort;
      if(!this.sortItem){
        this.sortItem = this.sortConfig[0];
        //load only if needed
        setTimeout(() => this.loadMore(), 200);
      }
      this.ref.markForCheck();
    }); 

    this.subMalkars = this.searchService.malkars.subscribe( res => {
      if(res && res.result){ 
        if(res.result.result){
          this.searchResult = res.result.result;
        }
        if(_.has(res.result, 'isLast')){
          this.searchMalkarIsLast = res.result.isLast;
        }
      }
      if(_.has(res, COUNT_MALKARS)){
        this.searchMalkarCount = res.COUNT_MALKARS;
      }
      this.ref.markForCheck();
    });
    this.subParam = this.route.params.pipe(switchMap((params: Params) => {
                                          this.searchWord = params['str'];
                                          this.sortRelevanceLogic(false);
                                          this.ref.markForCheck();
                                          // this.commonService.addObservable(Observable.of({Search: this.searchWord}), 'searchFilter');
                                          return this.loadMore();
                                        }))
                                      .subscribe((...args) => args); 
  }

  ngOnDestroy() {
    this.closeModal();
    if(this.subParam){
      this.subParam.unsubscribe();
    }
    if (this.subMalkars){
      this.subMalkars.unsubscribe();
    }
    if (this.subSearchConfig){
      this.subSearchConfig.unsubscribe();
    }
    if (this.subCommonService){
      this.subCommonService.unsubscribe();
    }
    if (this.subsArray){
      for (let i=0; i<this.subsArray.length; i++){
        this.subsArray[i].unsubscribe();
      }
    }
  }

  onClick(ev){
    if (this.showSort && !this.sortConfigElement.nativeElement.contains(ev.target)){
      this.toggleSort();
    }
  }

  getSearchSummaryText(){
    let searchSummary = this.$Label.Found + ' <b> ' + (_.max([this.searchMalkarCount/*, this.searchResult.length, 0*/, '-'])) + ' </b> '+ this.$Label.Results;
    if (this.searchWord){
      searchSummary += ' ' + this.$Label.For_search + ' <b> ' + this.searchWord + ' </b> ';
    }
    return searchSummary;
  }

  sortRelevanceLogic(reload: boolean = true){
    if (this.searchWord && this.searchWord.trim()){
      let relevance = {name: 'relevance', apiName: '', label: this.$Label.Relevance};
      this.sortConfig.unshift(relevance);
      this.setSortItem(relevance, reload);
    }
    else{
      this.setSortItem(this.sortConfig[0], reload);
    }
  }

  toggleSort(){
    this.showSort = !this.showSort;
  }

  toggleSortDirection(direction, reload: boolean = true){
    if (direction === 'up'){
      this.iconSortDirection = this.iconSortUp;
      this.iconSortLabel = this.$Label.Sort_up;
      this.sortItem.sortDesc = false;
    }
    else if (direction === 'down'){
      this.iconSortDirection = this.iconSortDown;
      this.iconSortLabel = this.$Label.Sort_down;
      this.sortItem.sortDesc = true;
    }
    if (reload){
      this.loadMore();
    }
  }

  toggleFilter(ev){
    this.displayFilter = ev;
  }

  scrollFilter(ev){
    let offset;
    if (ev && ev.shown == true && ev.ref && ev.offset){
      offset = this.searchFilterElement.nativeElement.scrollHeight - ev.ref.nativeElement.scrollHeight - ev.offset;
    }
    else{
      offset = this.searchFilterElement.nativeElement.scrollHeight;
    }
    this.searchFilterElement.nativeElement.scrollTop = offset;     
  }

  setSortItem(sortItem, reload: boolean = true){
    this.sortItem = sortItem;
    if (this.sortItem.sortDesc){
      this.toggleSortDirection('down', reload);
    }
    else{
      this.toggleSortDirection('up', reload);
    }
  }

  // initSearchFiltersObservable(obs: Observable<any>){
  //   this.commonService.addObservable(obs, AppParams.searchFilterObservableKey);
    
  //   try {
  //     let filterSubject = this.commonService.subjects[AppParams.searchFilterObservableKey];
  //     if(filterSubject){
  //       this.selectedSearchFilters = filterSubject.getValue();
  //     }
  //   } catch (error) {}

  //   this.subsArray.push(this.commonService.subjects[AppParams.searchFilterObservableKey].pipe(debounceTime(500)).subscribe(subFilter =>{
  //     this.selectedSearchFilters = subFilter;
  //     this.loadMore(null);
  //     this.ref.markForCheck();
  //   }));
  // }

  clickLoadMore(item){
    let lastItemName = <HTMLElement> document.getElementsByClassName('search-result-item-name')[document.getElementsByClassName('search-result-item-name').length-1];
    lastItemName.focus();
    // let results = document.getElementById('searchResults');
    // this.renderer.setAttribute(results, 'tabIndex', '-1');
    // results.focus();
    // this.renderer.removeAttribute(results, 'tabIndex');
    return this.loadMore(item);
  }

  loadMore(item = null){
    if(this.sortItem){
      return this.searchService.searchMalkars(this.selectedSearchFilters, this.searchWord, this.sortItem, item);
    }
    return Promise.resolve();
  }

  resetSearchFilter(){
    this.searchFilterComponent.resetForm(null);
  }

  exportResults(){
    if (!this.captchaToken) {return;}
    this.exportFailed = false;
    let reportSize = this.getSearchMalkarCountNum();
    // let rs = this.excelService.createSheet(this.reservationsSheetData, null, true);
    let rs = this.excelService.createStyledSheet(this.reservationsSheetData, null, null, true, [{wpx: 800}], null);
    let wb = this.excelService.appendSheet(rs, null, this.$Label.Reservations);
    this.excelService.setRightToLeft(wb);
    let ws;
    // let reports = this.commonService.getReportMalkars(this.selectedSearchFilters, this.searchWord, this.sortItem, null, this.maxReportSize);
    let reports = this.commonService.getReportMalkars(this.selectedSearchFilters, this.searchWord, this.sortItem, null, reportSize);
    reports.then(result => {
      if (result.length > 0 && !this.discardExport){
        let items = [];
        _.forEach(result, item =>{
          items.push(_.omit(item, ['Id']));
        });
        this.closeModal();
        if (this.reportColumns){
          ws = this.excelService.createSheet(items, Object.keys(this.reportColumns), this.reportColumns);
        }
        else{
          ws = this.excelService.createSheet(items, null, null);
        }
        wb = this.excelService.appendSheet(ws, wb, this.$Label.Sheet_name);
        let dateStr = this.datePipe.transform(Date.now(), 'yyyy-MM-dd HH-mm-ss');
        this.excelService.writeWorkbook(wb, this.$Label.Workbook_name + '_' + dateStr);
      }
      else{
        this.discardExport = false;
      }
    }, error => {
      this.exportFailed = true;
    });
  }

  async getReservationSheetData(){
    let data = await this.commonService.getWebsiteContent('ReportReservations', ContentPosition.Main, AppParams.App);
    let strippedString = data[0].Body.replace(/(<((p)|(ol)|(ul)|(li))>)/ig,'~~!~~');
    strippedString = strippedString.replace(/(<\/((ol)|(ul))>)/ig,'~~!~~');
    strippedString = strippedString.replace(/(<([^>]+)>)/ig,' ');
    strippedString = strippedString.replace(/(&quot;)/ig,'"');
    strippedString = strippedString.replace(/(&#39;)/ig, '\'');
    _.forEach(_.split(strippedString, '~~!~~'), x => {
      this.reservationsSheetData.push({Col1: x});      
    });
  }

  getMinReportResults(){
    return this.reportSize;
  }

  displayDownloadLimit(){
    let display = this.searchMalkarCount && this.searchMalkarCount != this.$Label.Search_2000_Result;
    return display;
  }

  displayAltDownloadLink(){
    let display = this.maxReportSize < this.getSearchMalkarCountNum();
    return display;
  }

  getSearchMalkarCountNum(){
    if (!this.searchMalkarCount){return;}
    let count: number;
    if(isNaN(this.searchMalkarCount)){
      let tempStr = this.searchMalkarCount.replace(/,/, '');
      count = tempStr.match(/\d+/g).map(Number);
    }
    else{
      count = this.searchMalkarCount;
    }
    return count;
  }

  stopExport(){
    this.commonService.retrieveReport = false;
    pushEventToDataLayerGTM('stopExport');
  }

  closeModal(){
    jQuery('#exportModal').modal('hide');
  }

  handleCorrectCaptcha(event){
    this.isCaptchaExpired = false;
    this.captchaToken = event;
  }

  captchaExpired(){
    this.isCaptchaExpired = true;
    this.captchaToken = null;
  }

  cancelExport(){
    this.discardExport = true;
    this.stopExport();
    this.closeModal();
    pushEventToDataLayerGTM('cancelExport');
  }

  showExportError(){
    
  }
}