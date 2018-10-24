import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Store } from '@ngrx/store';
import { AppStore } from '../common/ngrx/AppStore';
import { remoteFunction } from '../common/utils/remote';
import { CHART_DISTRICT, CHART_CLASSIFICATION, CHART_TMIHOT, REPORT_TOTALS, MAIN_CLASSIFICATIONS } from './home.reducer';
import * as _ from 'lodash';
import { HomeModule } from './home.module';


@Injectable({
  providedIn: 'root'
  // providedIn: HomeModule
})
export class HomeService {
  home: Observable<any>;

  resolved: any = {}; 
  loading: any = {};

  constructor(private store: Store<AppStore>) { 
    this.home = store.select('home');
  }

  getReportTotals(){
    return this.getGSTAR('getReportTotals', REPORT_TOTALS);
  }
  getHomeChartMainClassifications(){
    return this.getGSTAR('getHomeChartMainClassifications', CHART_CLASSIFICATION);
  }
  getHomeChartDistricts(){
    return this.getGSTAR('getHomeChartDistricts', CHART_DISTRICT);
  }
  getHomeChartTmihot(){
    return this.getGSTAR('getHomeChartTmihot', CHART_TMIHOT);
  }

  getMainClassificationsRemote(){
    return this.get('GSTAR_Ctrl_Config.getMainClassificationsRemote', MAIN_CLASSIFICATIONS);
  }

  get(functionName : string, storeType: string, [...args] = []){
    if(_.isEmpty(this.resolved[functionName])){
      this.resolved[functionName] = {};
    }
    if (_.isEmpty(this.resolved[functionName])){
      return remoteFunction(functionName, ...args).then(res => {
        let result = res['result'] || res;
        this.store.dispatch({type: storeType, payload: result});
        this.resolved[functionName] = result;
      });
    }
    else{
      this.store.dispatch({type: storeType, payload: this.resolved[functionName]});
      return Promise.resolve(this.resolved[functionName]);
    }
  }

  getGSTAR(functionName : string, storeType: string, [...args] = []){
    return this.get('GSTAR_Ctrl.' + functionName, storeType, [...args]);  
  }
}
