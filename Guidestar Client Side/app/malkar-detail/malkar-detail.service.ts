import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Store } from '@ngrx/store';
import { AppStore } from '../common/ngrx/AppStore';
import { remoteFunction } from '../common/utils/remote';

import { MALKAR_REFRESH, MALKAR_REPORTS_APPROVAL, MALKAR_SUPPORT, MALKAR_DONATION, MALKAR_GOV_SERVICES, MALKAR_CONNECTED, MALKAR_WAGE_EARNERS, MALKAR_PEOPLE, CHART_DATA_DISTRICT, RESET_MALKAR_PEOPLE, HEKDESH_MONEY, HEKDESH_REAL_ESTATE, HEKDESH_BELONGINGS, HEKDESH_TRUSTEES, VOLUNTEER_PROJECTS } from './malkar-detail.actions';
import { malkarPages } from './malkar-detail.pages';
import { MalkarDetailModule } from './malkar-detail.module';

@Injectable({
  providedIn: 'root'
  // providedIn: MalkarDetailModule
})
export class MalkarDetailService {
  malkar: Observable<any>;

  resolved: any = {}; 
  loading: any = {};

  constructor(private store: Store<AppStore>) { 
    this.malkar = store.select('malkar');
  }

  getMalkarDetails(malkarId: string){
    return this.get('getMalkarDetails', malkarId, MALKAR_REFRESH); 
  }

  getMalkarReportsApproval(malkarId: string){
    return this.get('getMalkarReportsApproval', malkarId, MALKAR_REPORTS_APPROVAL);
  }

  getMalkarSupport(malkarId: string){
    return this.get('getMalkarSupport', malkarId, MALKAR_SUPPORT);
  }

  getMalkarDonations(malkarId: string){
    return this.get('getMalkarDonations', malkarId, MALKAR_DONATION);
  }

  getMalkarGovServices(malkarId: string){
    return this.get('getMalkarGovServices', malkarId, MALKAR_GOV_SERVICES);
  }

  getMalkarPeople(malkarId: string, recaptchaToken: string){
    return this.get('getMalkarPeople', malkarId, MALKAR_PEOPLE, [recaptchaToken]);
  }
  
  resetMalkarPeople(malkarId: string){
    return this.reset('getMalkarPeople', malkarId, RESET_MALKAR_PEOPLE);
  }

  getMalkarConnected(malkarId: string){
    return this.get('getMalkarConnected', malkarId, MALKAR_CONNECTED);
  }

  getMalkarWageEarners(malkarId: string){
    return this.get('getMalkarWageEarners', malkarId, MALKAR_WAGE_EARNERS);
  }

  getHekdeshMonies(malkarId: string){
    return this.get('getHekdeshMoney', malkarId, HEKDESH_MONEY);
  }

  getHekdeshRealEstate(malkarId: string){
    return this.get('getHekdeshRealEstate', malkarId, HEKDESH_REAL_ESTATE);
  }

  getHekdeshBelongings(malkarId: string){
    return this.get('getHekdeshBelongings', malkarId, HEKDESH_BELONGINGS);
  }

  getHekdeshTrustees(malkarId: string){
    return this.get('getHekdeshTrustees', malkarId, HEKDESH_TRUSTEES);
  }

  getVolunteerProjects(malkarId: string){
    return this.get('getVolunteerProjects', malkarId, VOLUNTEER_PROJECTS);
  }

  getChartDataDistrict(tchumPeilutMainNum: string){
    return this.get('getChartDataDistrict', tchumPeilutMainNum, CHART_DATA_DISTRICT);
  }

  get(functionName : string, malkarId: string, storeType: string, [...args] = []){
    if(!this.resolved[functionName] || Object.keys(this.resolved[functionName]).length > 5){
      this.resolved[functionName] = {};
    }
    if (!this.resolved[functionName][malkarId]){
      return remoteFunction('GSTAR_Ctrl.' + functionName, malkarId, ...args).then(res => {
        this.store.dispatch({type: storeType, payload: res});
        this.resolved[functionName][malkarId] = res;
      });
    }
    else{
      this.store.dispatch({type: storeType, payload: this.resolved[functionName][malkarId]});
      return Promise.resolve(this.resolved[functionName][malkarId]);
    }
  }

  reset(functionName : string, malkarId: string, storeType: string, [...args] = []){
    if(this.resolved[functionName] && this.resolved[functionName][malkarId]){
      delete this.resolved[functionName][malkarId];
    }
    this.store.dispatch({type: storeType, payload: null});
    return Promise.resolve();
  }

  resolveData(malkarNum: string, path: string, fromRouting: boolean){
    if (malkarNum){
      if(fromRouting){
        return this.getMalkarDetails(malkarNum);
      }
      else if(path === malkarPages.documents){
        return this.getMalkarReportsApproval(malkarNum);
      }
      else if(path === malkarPages.govsupport){
        return this.getMalkarSupport(malkarNum);
      }
      else if(path === malkarPages.govservices){
        return this.getMalkarGovServices(malkarNum);
      }
      else if(path === malkarPages.donations){
        return this.getMalkarDonations(malkarNum);
      }
      else if(path === malkarPages.people){
        return Promise.all([this.getMalkarConnected(malkarNum),
                            this.getMalkarWageEarners(malkarNum)]);
      }
      else if(path === malkarPages.assets){
        return Promise.all([this.getHekdeshRealEstate(malkarNum),
                            this.getHekdeshBelongings(malkarNum)]);
      }
      else if(path === malkarPages.trustees){
        return this.getHekdeshTrustees(malkarNum);
      }
      else if(path === malkarPages.volunteering){
        return this.getVolunteerProjects(malkarNum);
      }
      else{
        return Promise.resolve();
      }
    }
    else{
      return Promise.resolve();
    }
  }
}
