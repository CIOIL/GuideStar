import { Injectable, OnDestroy } from '@angular/core';
import { Observable ,  BehaviorSubject ,  Subscription, merge  } from 'rxjs';

import { Store } from '@ngrx/store';
import { AppStore } from '../ngrx/AppStore';
import { remoteFunction } from '../utils/remote';
import * as _ from 'lodash';
import { COMMON_USER_INFO, COMMON_SEARCH_FILTER, COMMON_GRAPH_COLORS, COMMON_GRAPH_DISPLAY, COMMON_GLOBAL_SETTINGS, COMMON_FILTER_STATE, COMMON_REPORT_MALKARS_SIZE } from '../ngrx/common.actions';
import { ContentPosition } from '../enums/content-position';
import { Title, Meta } from '@angular/platform-browser';
import { AppParams } from '../enums/app-params';

  export const commonFunction = {
    getCustomGlobalSettings: 'GSTAR_Ctrl.getCustomGlobalSettings',
    getMalkarReport: 'GSTAR_Ctrl.getMalkarsForReport',
    getMalkarsReportColumns: 'GSTAR_Ctrl.getMalkarsReportColumns'
  };

@Injectable({
  providedIn: 'root'
})
export class CommonService implements OnDestroy{
  common: Observable<any>;
  observables: { [key: string]:Observable<any> } = {} ;
  subjects: { [key: string]:BehaviorSubject<any> } = {};
  subscriptions: { [key: string]:Subscription } = {};;

  isRetrievingReport: boolean = false;
  reportLength: BehaviorSubject<number> = new BehaviorSubject<number>(0);
  retrieveReport: boolean = true;

  resolved: any = {}; 
  loading: any = {};

  constructor(private store: Store<AppStore>, private titleService: Title, private meta: Meta) { 
    this.common = store.select('common');
		this.getUserInfo();
  }

  ngOnDestroy(){
    if (this.subscriptions){
      _.forEach(this.subscriptions, (value, key) => {
        if(value){
          value.unsubscribe();
        }
      });
    }
  }

  getUserInfo(){
    return this.getLocalGSTAR('getUserInfo', COMMON_USER_INFO); 
  }

  getWebsiteContent(page: string, position: ContentPosition, app: AppParams){
    return remoteFunction('Utils_RemoteAction.getWebsiteContent', app, page, position);
  }

	addObservable(obs: Observable<any>, type: string | AppParams){
    if(!type){
      return;
    }
    let primaryObs = this.observables[type];
		if(!primaryObs){
      this.observables[type] = obs;
    }
    else{
      this.observables[type] = merge(primaryObs, obs);
    }
    let primarySubj = this.subjects[type];
    if (!primarySubj){
      this.subjects[type] = new BehaviorSubject({});
    }
    if(this.subscriptions[type]){
      this.subscriptions[type].unsubscribe();
    }
    this.subscriptions[type] = this.observables[type].subscribe(value => {
      this.subjects[type].next(value);
    });
	}

  getLocalGSTAR(functionName : string, storeType: string, [...args] = []){
    return this.getGSTAR(this.resolved, this.loading, functionName, storeType, [...args]);  
  }

  getGSTAR(resolved, loading, functionName : string, storeType: string, [...args] = []){
    return this.get(resolved, loading, 'GSTAR_Ctrl.' + functionName, storeType, [...args]);  
  }

  getLocal(functionName : string, storeType: string, [...args] = []){
    return this.get(this.resolved, this.loading, functionName, storeType, [...args]);  
  }

  getGraphColors(payload: any){
    return this.store.dispatch({type: COMMON_GRAPH_COLORS, payload: payload});
  }

  getGraphDisplay(payload: any){
    return this.store.dispatch({type: COMMON_GRAPH_DISPLAY, payload: payload});
  }

  getGlobalSettings(){
    return this.get(this.resolved, this.loading, commonFunction.getCustomGlobalSettings, COMMON_GLOBAL_SETTINGS, []);
  }

  getFilterState(payload: any, storeType: string){
    return this.store.dispatch({type: storeType, payload: payload});
  }

  get(resolved, loading, functionName : string, storeType: string, [...args] = []){
    if(_.isEmpty(resolved[functionName])){
      resolved[functionName] = {};
    }
    if (_.isEmpty(resolved[functionName])){
      this.startLoading(loading, functionName);
      return remoteFunction(functionName, ...args).then(res => {
        let result = res['result'] || res;
        resolved[functionName] = result;
        if(storeType){
          this.store.dispatch({type: storeType, payload: result});
        }
        this.stopLoading(loading, functionName);
      }, 
      error => {
        console.log(error);
        this.stopLoading(loading, functionName);
      });/**/
    }
    else{
      if(storeType){
        this.store.dispatch({type: storeType, payload: resolved[functionName]});
      }
      return Promise.resolve(resolved[functionName]);
    }
  }

  startLoading(loading, functionName){
    loading[functionName] = true;
    loading[`${functionName}_counter`] = loading[`${functionName}_counter`] ? loading[`${functionName}_counter`] + 1 : 1;
    this.store.dispatch({type: `${functionName}_loading`, payload: true});
  }
  stopLoading(loading, functionName){
    loading[`${functionName}_counter`] = loading[`${functionName}_counter`] ? loading[`${functionName}_counter`]- 1 : 0;
    if(!loading[`${functionName}_counter`]){
      loading[functionName] = false;
      this.store.dispatch({type: `${functionName}_loading`, payload: false});
    }
  }

  reset(functionName : string, storeType: string, [...args] = []){
    if(this.resolved[functionName] && this.resolved[functionName]){
      delete this.resolved[functionName];
    }
    this.store.dispatch({type: storeType, payload: null});
    return Promise.resolve();
  }

  setMeta(title: string, description: string){
    if (title){
      this.titleService.setTitle(title);
    }
    if (description){
      if (this.meta.getTag('name=description')){
        this.meta.updateTag({name: 'description', content: description});
      }
      else{
        this.meta.addTag({name: 'description', content: description});
      }
    }
  }

  getTitle(){
    return this.titleService.getTitle();
  }

  async getReportMalkars(filter: any, searchWord: string, sortObject:any, lastRecord:any = null, maxRecords: number):Promise<any[]>{
    filter = filter || {};
    filter.Search = searchWord;
    this.store.dispatch({type: COMMON_REPORT_MALKARS_SIZE, payload: maxRecords});
    let sort : any = {};
    if(sortObject){
      sort.apiName = sortObject.apiName;
      sort.sortDesc = sortObject.sortDesc ? true : false;
    }
    if(sortObject && lastRecord){
      sort.value = lastRecord[sortObject.name];
      sort.lastId = lastRecord.Id;
    }
    if (filter && filter.pageNumber){
      filter.pageNumber = null;
    }
    let returnArray = [];
    
    try{
      this.retrieveReport = true;
      while (this.retrieveReport && maxRecords != 0 && returnArray.length < maxRecords){
        this.isRetrievingReport = true;
        let result = await remoteFunction(commonFunction.getMalkarReport, filter, sort);
        if (result && result.result && result.result instanceof Array){
          if (result.result.length == 0){
            break;
          }
          returnArray = _.concat(returnArray, result.result);
          this.reportLength.next(returnArray.length);
          if (sortObject && returnArray.length > 0 && !_.isEmpty(returnArray[returnArray.length-1])){
            let lastElem = result.result[result.result.length-1];
            sort.value = lastElem[sortObject.name];
            sort.lastId = lastElem.Id;
          }
          if(result.filter){
            filter.isSearchByNameFinished = result.filter.isSearchByNameFinished;
            filter.pageNumber = result.filter.pageNumber;
          }
          returnArray = _.uniqBy(returnArray, 'regNum'); //Uniqby arfter so that if last was removed will re-appear
        }
      }
    }
    catch(error){
      console.log(error);
      this.isRetrievingReport = false;
      this.reportLength.next(0);
      return Promise.reject(error);
    }
    this.isRetrievingReport = false;
    this.reportLength.next(0);
    return Promise.resolve(returnArray);
  }

  getMalkarsReportColumns(){
    return remoteFunction(commonFunction.getMalkarsReportColumns);
  }
}
