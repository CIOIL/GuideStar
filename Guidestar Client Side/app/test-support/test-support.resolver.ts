import { Injectable } from '@angular/core';
import { Resolve, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';


import { TestSupportService } from './test-support.service';

@Injectable()
export class TestSupportResolver implements Resolve<any> {
  constructor(private testSupportService: TestSupportService) {}
 
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any>|Promise<any>|any {
    return Promise.all([
          this.testSupportService.getSearchSortConfig(),
          this.testSupportService.getSearchFilterConfig(),
          this.testSupportService.getAllTestSupports()
        ]);
  }
}