import { Injectable } from '@angular/core';
import { Resolve, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';


import { SearchService } from './search.service';

@Injectable()
export class SearchResolver implements Resolve<any> {
  constructor(private searchService: SearchService) {}
 
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any>|Promise<any>|any {
    return Promise.all([this.searchService.getSearchFilterConfig(), this.searchService.getSearchSortConfig()]);
  }
}