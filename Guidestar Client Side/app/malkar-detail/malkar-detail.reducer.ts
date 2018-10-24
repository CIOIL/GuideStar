import { Action } from '@ngrx/store';
import { ActionWithPayload } from '../common/ngrx/ActionWithPayload';
import * as _ from 'lodash';
import { malkarPages } from './malkar-detail.pages';
import { getNewState, getNewEmptyState } from '../common/utils/utils';
import * as actions from './malkar-detail.actions';

function resetState(state, key){
	let newState = _.cloneDeep(state);
	delete newState[key];
	return newState;
}

function getDefaultState(){
	return {
		result:{},
		documents:{},
		govsupport:{},
		govservices:{},
		donations:{},
		people: {},
		connected:{},
		wageearners:{},
		chartDataDistrict:{}
	};
}

export function malkarReducer(state: any = {}, action : ActionWithPayload) {
	switch (action.type) {
		case actions.MALKAR_RESET:{
			return getDefaultState();
		}
		case actions.MALKAR_REFRESH:{
			return getNewState(state, action.payload.result, 'result');
		}
		case actions.MALKAR_REPORTS_APPROVAL:{
			return getNewState(state, action.payload.result, malkarPages.documents);
		}
		case actions.MALKAR_SUPPORT:{
			return getNewState(state, action.payload.result, malkarPages.govsupport);
		}
		case actions.MALKAR_GOV_SERVICES:{
			return getNewState(state, action.payload.result, malkarPages.govservices);			
		}
		case actions.MALKAR_DONATION:{
			return getNewState(state, action.payload.result, malkarPages.donations);
		}
		case actions.MALKAR_PEOPLE:{
			return getNewState(state, action.payload.result, malkarPages.people);
		}
		case actions.RESET_MALKAR_PEOPLE:{
			return resetState(state, malkarPages.people);
		}
		case actions.MALKAR_CONNECTED:{
			return getNewState(state, action.payload.result, malkarPages.connected);
		}
		case actions.MALKAR_WAGE_EARNERS:{
			return getNewState(state, action.payload.result, malkarPages.wageearners);
		}
		case actions.CHART_DATA_DISTRICT:{
			return getNewState(state, action.payload.result, 'chartDataDistrict');
		}	
    case actions.HEKDESH_MONEY:{
      return getNewState(state, action.payload, actions.HEKDESH_MONEY);
    }
    case actions.HEKDESH_REAL_ESTATE:{
      return getNewState(state, action.payload, actions.HEKDESH_REAL_ESTATE);
    }
    case actions.HEKDESH_BELONGINGS:{
      return getNewState(state, action.payload, actions.HEKDESH_BELONGINGS);
    }
    case actions.HEKDESH_TRUSTEES:{
      return getNewState(state, action.payload, actions.HEKDESH_TRUSTEES);
    }
    case actions.VOLUNTEER_PROJECTS:{
      return getNewState(state, action.payload, actions.VOLUNTEER_PROJECTS);
    }
		default:  
			return state;
	}
}