import { Component, OnInit, OnDestroy, ViewChild, ElementRef, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { TestSupportService, testSupportPageFunctions } from './test-support.service';
import { Subscription ,  Observable } from 'rxjs';
import { TEST_SUPPORT_SEARCH_FILTER_CONFIG, FILTERED_TEST_SUPPORTS } from './test-support.reducer';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../common/utils/utils';
import * as _ from 'lodash';
import { ActivatedRoute } from '@angular/router';
import { CommonService } from '../common/services/common.service';
import { COMMON_TEST_SUPPORT_FILTER_STATE } from '../common/ngrx/common.actions';
import { AppParams } from '../common/enums/app-params';

@Component({
  selector: 'app-test-support',
  templateUrl: './test-support.component.html',
  styleUrls: ['./test-support.component.scss'],
  host: { '(click)': 'onClick($event)'},
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TestSupportComponent implements OnInit, OnDestroy {

  @ViewChild('sortConfigElement') sortConfigElement: ElementRef  ; 

  $Label: any;

  subs: Array<Subscription> = new Array<Subscription>();
  filterConfig: any;
  selectedSearchFilters: any;
  displayFilter: boolean;
  testSupportPageFunctions: any;

  testSupportStoreKey = AppParams.testSupportFilterStateStoreKey;

  sortItem: any;
  showSort: boolean;
  sortConfig: any;
  isLoading: boolean;

  testSupportListCurrent: Array<any>;
  private _testSupportList: Array<any>;
  get testSupportList(): Array<any> {return this._testSupportList};
  set testSupportList(newtestSupportList: Array<any>){
    this._testSupportList = newtestSupportList;
    this.initCurrentList();
  }

  searchWord: string = '';
  filter: any = {};

  iconSortDown: string = 'assets/img/icons/icon-sorting-down-mobile.png';
  iconSortUp: string = 'assets/img/icons/icon-sorting-up-mobile.png';
  iconSortDirection: string = this.iconSortUp;
  iconSortLabel: string = '';
  pdfIcon = 'assets/img/icons/pdf-file-icon-mobile.png';
  docIcon = 'assets/img/icons/doc-file-icon-mobile.png';

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;

  constructor(public testSupportService: TestSupportService, private activatedRoute: ActivatedRoute, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
    this.iconSortLabel = this.$Label.Sort_up;
    this.commonService.setMeta(this.$Label.Site_Test_Supports_Title + ' | ' + this.$Label.Site_Title, this.$Label.Description_Test_Supports);
    this.testSupportService.getSearchSortConfig();
    this.testSupportService.getSearchFilterConfig();
    this.testSupportService.getAllTestSupports();
    // this.testSupportService.getFilteredTestSupports(this.selectedSearchFilters);   
    this.testSupportPageFunctions = testSupportPageFunctions; 
   }

  ngOnInit() {
    this.subs.push(this.testSupportService.testSupports.subscribe(res =>{
      if ((_.has(res, TEST_SUPPORT_SEARCH_FILTER_CONFIG)) && (!this.filterConfig || !_.isEqual(this.filterConfig, res.TEST_SUPPORT_SEARCH_FILTER_CONFIG))){
        this.filterConfig = res.TEST_SUPPORT_SEARCH_FILTER_CONFIG;
      }
      this.sortConfig = res.TEST_SUPPORT_SEARCH_SORT_CONFIG;
      // if(!this.sortItem && res.TEST_SUPPORT_SEARCH_SORT_CONFIG){
      //   this.sortItem = this.sortConfig[0];
      //   this.toggleSortDirection('down');
      // }
      if (_.has(res, FILTERED_TEST_SUPPORTS)){
        if (this.testSupportService.filter){
          this.selectedSearchFilters = this.testSupportService.filter;
        }
        this.testSupportList = res.FILTERED_TEST_SUPPORTS;
        if(!this.sortItem && res.TEST_SUPPORT_SEARCH_SORT_CONFIG){
          this.sortItem = this.sortConfig[0];
          this.toggleSortDirection('down');
        }
      }
      else{
        this.testSupportList = res.TEST_SUPPORTS;
        this.filterTestSupports();
      }
      this.ref.markForCheck();
    }));
    this.subs.push(this.commonService.common.subscribe(res =>{
      if (_.has(res, COMMON_TEST_SUPPORT_FILTER_STATE) && !_.isEmpty(res[COMMON_TEST_SUPPORT_FILTER_STATE])){
        this.filter = res[COMMON_TEST_SUPPORT_FILTER_STATE];
        this.filterTestSupports();
        this.ref.markForCheck();
      }
    }));
    this.subs.push(this.activatedRoute.params.subscribe(params =>{
      if (_.has(params, 'search')){
        this.searchWord = params['search'];
        this.filterTestSupports();
        this.ref.markForCheck();
      }
    }));
  }

  ngOnDestroy(){
    // this.testSupportService.getFilteredTestSupports(this.filter, '');
    this.testSupportService.getFilteredTestSupports({}, '');
    for (let i=0; i< this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  onClick(ev){
    if (this.showSort && !this.sortConfigElement.nativeElement.contains(ev.target)){
      this.toggleSort();
    }
  }

  getSearchSummaryText(){
    return this.$Label.Found + ' ' + this.testSupportList.length + ' '+ this.$Label.Results;
  }

  // initSearchFiltersObservable(obs: Observable<any>){
  //   this.subs.push(obs.subscribe( o =>{
  //     this.filter = o;
  //     this.filterTestSupports();
  //     this.ref.markForCheck();
  //   }));
  // }

  filterTestSupports(){
    this.testSupportService.getFilteredTestSupports(this.filter, this.searchWord, this.sortItem);
  }

  toggleFilter(ev){
    this.displayFilter = ev;
  }

  toggleSort(){
    this.showSort = !this.showSort;
  }

  toggleSortDirection(direction){
    if (direction === 'up' ){
      this.iconSortDirection = this.iconSortUp;
      this.iconSortLabel = this.$Label.Sort_up;
      this.sortItem.sortDesc = false;
      this.getSortedTestSupports();    
    }
    else if (direction === 'down' ){
      this.iconSortDirection = this.iconSortDown;
      this.iconSortLabel = this.$Label.Sort_down;
      this.sortItem.sortDesc = true;
      this.getSortedTestSupports();      
    }
  }

  setSortItem(sortItem){
    if (!this.testSupportList) return;
    if (sortItem && _.isEqual(this.sortItem, sortItem)){
      return;
    }
    if (sortItem){
      this.sortItem = sortItem;
      if (this.sortItem.sortDesc){
        this.toggleSortDirection('down');
      }
      else{
        this.toggleSortDirection('up');
      }
    }
    else{
      this.getSortedTestSupports();
    }
  }

  getSortedTestSupports(){
    this.testSupportService.getSortedTestSupports(this.sortItem);    
  }

  itemSelected(ev){
    ev.target.click();
  }

  getNamePrefixHtml(): string{
    if (this.searchWord){
      return '<b style="font-weight: 900">';
    }
    return '<b>';
  }

  initCurrentList(){
    this.testSupportListCurrent = [];
    this.loadMore();
  }

  lastInView(){
    this.loadMore();
  }

  loadMore(){
    if(this.testSupportList && this.testSupportList.length > this.testSupportListCurrent.length){
      this.isLoading = true;
      let addItems = _.slice(this.testSupportList, this.testSupportListCurrent.length, this.testSupportListCurrent.length + 10);
      this.testSupportListCurrent = _.concat(this.testSupportListCurrent, addItems);
      this.isLoading = false;
    }
  }
}
