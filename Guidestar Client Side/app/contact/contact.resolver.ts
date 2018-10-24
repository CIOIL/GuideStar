import { Injectable } from '@angular/core';
import { Resolve, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';

import { ContactService } from './contact.service';

@Injectable()
export class ContactResolver implements Resolve<any> {
  constructor(private contactService: ContactService) {}
 
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any>|Promise<any>|any {
    return Promise.all([
      this.contactService.getSubjectCasePicklist()
    ]);
  }
}