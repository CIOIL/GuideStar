import { Injectable } from '@angular/core';
import { Resolve, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';


import { MalkarDetailService } from './malkar-detail.service';
import { malkarPages } from './malkar-detail.pages';

@Injectable()
export class MalkarDetailResolver implements Resolve<any> {
  constructor(private malkarDetailService: MalkarDetailService) {}
 
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any>|Promise<any>|any {
    return this.malkarDetailService.resolveData(route.params['num'] || route.parent.params['num'], route.url[0].path, route.params['num']);
  }
}