import { Injectable } from '@angular/core';
import { Observable ,  BehaviorSubject } from 'rxjs';
import { Store } from '@ngrx/store';
import { AppStore } from '../common/ngrx/AppStore';
import { remoteFunction } from '../common/utils/remote';

import { SEARCH_MALKARS, COUNT_MALKARS, RESET_LAST_RESULT } from './search.reducer';
import { SEARCH_FILTER_CONFIG, SEARCH_SORT_CONFIG } from './search-config.reducer';

import * as _ from 'lodash';
import { CommonService } from '../common/services/common.service';
import { SearchModule } from './search.module';
import { take } from 'rxjs/operators';

export const searchPageFunctions = {
    searchMalkars : 'GSTAR_Ctrl.searchMalkars',
    getSearchFilter: 'GSTAR_Ctrl_Config.getSearchFilter',
    getSearchSort: 'GSTAR_Ctrl_Config.getSearchSort',
    getSeachMalkarCount: 'GSTAR_Ctrl.getSeachMalkarCount'
}

@Injectable({
  providedIn: 'root'
  // providedIn: SearchModule
})
export class SearchService {
  malkars: Observable<any>;
  searchConfig: Observable<any>;
  malkarReports: any[] = [];
  resolved: any = {}; 
  loading: any = {};
  lastRemote: any;
  currentFilter: any;
  waitingRemote : any;
  isSearching: boolean = false;
  store$ : Store<AppStore>;
  pageNumber: any;
  isSearchByNameFinished: any;

  constructor(private store: Store<AppStore>, private commonService : CommonService) { 
    this.store$ = store;
    this.malkars = store.select('malkars');
    this.searchConfig = store.select('searchConfig');
  }

  resetLastResult(){
    this.lastRemote = null;
    this.store.dispatch({type: RESET_LAST_RESULT});
  }

  searchMalkarsFilterSort(filter: any, sort: any){
    if(!this.isSearching){
      this.currentFilter = _.cloneDeep({filter, sort});
      filter.isSearchByNameFinished = this.isSearchByNameFinished;
      filter.pageNumber = this.pageNumber; 

      if(_.isEqual({filter, sort}, this.lastRemote)){
        return Promise.resolve();
      }
      else{
        this.isSearching = true;
        if(!sort.lastId){
          if(!this.lastRemote || !_.isEqual(filter, this.lastRemote.filter) || !_.isEqual(sort.apiName, this.lastRemote.sort.apiName)){
            setTimeout(() => this.getSeachMalkarCount(filter, sort), 100); // the timeout is to dispatch the remote actions of the search and the number
          }
          delete filter.isSearchByNameFinished;
          delete filter.pageNumber;
        }
        return remoteFunction(searchPageFunctions.searchMalkars, filter, sort).then(result => {
          delete filter.isSearchByNameFinished;
          delete filter.pageNumber;
          this.store.dispatch({type: SEARCH_MALKARS, payload: {filter, sort, result}});
          this.isSearching = false;
          if(result.filter){
            this.isSearchByNameFinished = filter.isSearchByNameFinished = result.filter.isSearchByNameFinished;
            this.pageNumber = filter.pageNumber = result.filter.pageNumber;
          }
          this.lastRemote = _.cloneDeep({filter, sort});
          this.currentFilter = null;

          if(this.waitingRemote){
            this.searchMalkarsFilterSort(this.waitingRemote.filter, this.waitingRemote.sort);
            this.waitingRemote = null;
          }
        }, 
        error => {
          console.log(error);
          this.isSearching = false;
        });
      }
    }
    else{
      if(!(_.isEqual({filter, sort}, this.lastRemote)) && !(_.isEqual({filter, sort}, this.currentFilter))){
        this.waitingRemote = _.cloneDeep({filter, sort});
      }
      return Promise.resolve();
    }
  }

  searchMalkars(filter: any, searchWord: string, sortObject:any, lastRecord:any = null){
    filter = filter || {};
    filter.Search = searchWord;

    let sort : any = {};
    if(sortObject){
      sort.apiName = sortObject.apiName;
      sort.sortDesc = sortObject.sortDesc ? true : false;
    }
    if(sortObject && lastRecord){
      sort.value = lastRecord[sortObject.name];
      sort.lastId = lastRecord.Id;
    }
    return this.searchMalkarsFilterSort(filter, sort);
  }

  

  getSearchFilterConfig(){
    return this.commonService.get(this.resolved, this.loading, searchPageFunctions.getSearchFilter, SEARCH_FILTER_CONFIG);
  }

  getSearchSortConfig(){
    return this.commonService.get(this.resolved, this.loading, searchPageFunctions.getSearchSort, SEARCH_SORT_CONFIG);
  }

  getSeachMalkarCount(filter, sort){
    return this.commonService.get({}, this.loading, searchPageFunctions.getSeachMalkarCount, COUNT_MALKARS, [filter, sort]);
  }
}
