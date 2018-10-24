import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Store } from '@ngrx/store';
import { AppStore } from '../common/ngrx/AppStore';
import { remoteFunction } from '../common/utils/remote';

import { TEST_SUPPORTS, TEST_SUPPORT_DETAIL, TEST_SUPPORT_SEARCH_FILTER_CONFIG, TEST_SUPPORT_SEARCH_SORT_CONFIG, FILTERED_TEST_SUPPORTS } from './test-support.reducer';

import * as _ from 'lodash';
import { FilterPipe } from '../common/pipes/filter';
import { CommonService } from '../common/services/common.service';
import { take, map } from 'rxjs/operators';
import { TestSupportModule } from './test-support.module';

export const testSupportPageFunctions = {
    getAllTestSupports : 'GSTAR_Ctrl.getAllTestSupports',
    getTestSupportById : 'GSTAR_Ctrl.getTestSupportById',
    getTestSupportSearchFilter : 'GSTAR_Ctrl_Config.getTestSupportSearchFilter',
    getTestSupportSearchSort : 'GSTAR_Ctrl_Config.getTestSupportSearchSort'
}

@Injectable({
  providedIn: 'root'
  // providedIn: TestSupportModule
})
export class TestSupportService {
  testSupports: Observable<any>;
  lastRemote: {};
  waitingRemote : any;
  isSearching: boolean = false;
  filter: any;
  loading: any = {};

  resolved: any ={};

  constructor(private store: Store<AppStore>, private filterPipe : FilterPipe, private commonService : CommonService) { 
    this.testSupports = store.select('testSupports');
  }

  getAllTestSupports(){
    return this.commonService.get(this.resolved, this.loading, testSupportPageFunctions.getAllTestSupports, TEST_SUPPORTS);
  }

  getFilteredTestSupports(filter: any, searchWord: string, sortItem: any = null){
    this.filter = filter;
    this.filterResults(filter, searchWord, sortItem);
  }

  getSortedTestSupports(sortItem: any){
    let filtered;
    this.testSupports.pipe( map((state: any) => state.FILTERED_TEST_SUPPORTS),
                            take(1))
                            .subscribe(res => {
      filtered = res;
      this.sortResults(sortItem, filtered);
    });
  }

  getTestSupportById(id: string){
    this.commonService.get({}, this.loading, testSupportPageFunctions.getTestSupportById, TEST_SUPPORT_DETAIL, [id] );
  }

  getSearchFilterConfig(){
    return this.commonService.get(this.resolved, this.loading, testSupportPageFunctions.getTestSupportSearchFilter, TEST_SUPPORT_SEARCH_FILTER_CONFIG);
  }

  getSearchSortConfig(){
    return this.commonService.get(this.resolved, this.loading, testSupportPageFunctions.getTestSupportSearchSort, TEST_SUPPORT_SEARCH_SORT_CONFIG);    
  }

  filterResults(filter: any, searchWord: string, sortItem: any){
    if (_.isEmpty(this.resolved[testSupportPageFunctions.getAllTestSupports])){
      return;
    }
    let filtered = this.resolved[testSupportPageFunctions.getAllTestSupports];
    if (searchWord){
      filtered = this.filterPipe.transform(filtered, searchWord, true, true);
    }
    let filterKeys = Object.keys(filter);
    if (filterKeys){
      for (let i=0; i<filterKeys.length; i++){
        let filterValue = filter[filterKeys[i]];
        if (filterValue && !_.isEmpty(filterValue) ){
          if (filterValue instanceof Array){
            filtered = _.filter(filtered, item => _.find(filterValue, x => x === item[filterKeys[i]]));
          }
          else{
            filtered = _.filter(filtered, item => item[filterKeys[i]] === filterValue);
          }
        }
        else{
        }
      }
    }
    this.sortResults(sortItem, filtered);
  }

  sortResults(sortItem: any, itemList: any[]){
    if (!itemList){
      return;
    }
    if (!sortItem){
      this.store.dispatch({type: FILTERED_TEST_SUPPORTS, payload: itemList});
      return;      
    }
    let nonNulls = _.reject(itemList, item => !item[sortItem['apiName']]);
    let nulls = _.filter(itemList, item => !item[sortItem['apiName']]);
    let sorted = _.orderBy(nonNulls, item => item[sortItem['apiName']], sortItem.sortDesc ? 'desc' : 'asc');
    sorted = sorted.concat(nulls);
    this.store.dispatch({type: FILTERED_TEST_SUPPORTS, payload: sorted});
  }
  
}
