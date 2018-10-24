import { Injectable } from '@angular/core';
import { remoteFunction } from '../common/utils/remote';
import * as _ from 'lodash';

@Injectable({
  // we declare that this service should be created
  // by the root application injector.
  providedIn: 'root',
})
export class ContactService {

  resolved: any = {}; 
  loading: any = {};

  constructor() { 
  }
	
	submitCase(newCase : string, recaptchaToken: string){
   return this.postGSTAR('submitCase', newCase, [recaptchaToken]);
  }

  getSubjectCasePicklist(){
    return this.get('Utils_RemoteAction.getFieldPicklistValues', ['Case', 'Type']);
  }

  get(functionName : string, [...args] = []){
    if(_.isEmpty(this.resolved[functionName])){
      this.resolved[functionName] = {};
    }
    if (_.isEmpty(this.resolved[functionName])){
      return remoteFunction(functionName, ...args).then(res => {
        this.resolved[functionName] = res;
      });
    }
    else{
      return Promise.resolve(this.resolved[functionName]);
    }
  }

	post(functionName : string, object: any, [...args] = []){
		return remoteFunction(functionName, object, ...args);
	}

  getGSTAR(functionName : string, [...args] = []){
    return this.get('GSTAR_Ctrl.' + functionName, [...args]);  
  }

	postGSTAR(functionName : string, object: any, [...args] = []){
    return this.post('GSTAR_Ctrl.' + functionName, object, [...args]);  
  }
}