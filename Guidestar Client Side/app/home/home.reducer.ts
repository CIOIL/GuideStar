import { Action } from '@ngrx/store';
import { ActionWithPayload } from '../common/ngrx/ActionWithPayload';
import * as _ from 'lodash';
import { getNewState } from '../common/utils/utils';

export const REPORT_TOTALS = 'REPORT_TOTALS';
export const CHART_CLASSIFICATION = 'CHART_CLASSIFICATION';
export const CHART_DISTRICT = 'CHART_DISTRICT';
export const CHART_TMIHOT = 'CHART_TMIHOT';
export const MAIN_CLASSIFICATIONS = 'MAIN_CLASSIFICATIONS';

function getDefaultState(){
	return {
		result:{},
		CHART_DISTRICT:{}
	};
}

export function homeReducer(state: any = getDefaultState(), action : ActionWithPayload) {
	switch (action.type) {
		case REPORT_TOTALS:{
			return getNewState(state, action.payload, REPORT_TOTALS);
		}
		case CHART_CLASSIFICATION:{
			return getNewState(state, action.payload, CHART_CLASSIFICATION);
		}
        case CHART_DISTRICT:{
			return getNewState(state, action.payload, CHART_DISTRICT);
		}
        case CHART_TMIHOT:{
			return getNewState(state, action.payload, CHART_TMIHOT);
		}
		case MAIN_CLASSIFICATIONS:{
			return getNewState(state, action.payload, MAIN_CLASSIFICATIONS);
		}
		case MAIN_CLASSIFICATIONS:{
			return getNewState(state, action.payload, MAIN_CLASSIFICATIONS);
		}
		default:  
			return state;
	}
}