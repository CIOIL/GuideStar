import { Injectable } from '@angular/core';
import { Resolve, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';

import { HomeService } from './home.service';

@Injectable()
export class HomeResolver implements Resolve<any> {
  constructor(private homeService: HomeService) {}
 
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any>|Promise<any>|any {
    return Promise.all([
        this.homeService.getReportTotals(),
        this.homeService.getMainClassificationsRemote()
        // this.homeService.getHomeChartMainClassifications(),
        // this.homeService.getHomeChartDistricts(),
        // this.homeService.getHomeChartTmihot(),
    ]);
  }
}