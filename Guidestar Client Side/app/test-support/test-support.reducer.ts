import { Action } from '@ngrx/store';
import { ActionWithPayload } from '../common/ngrx/ActionWithPayload';
import * as _ from 'lodash';
import { getNewState } from '../common/utils/utils';

export const TEST_SUPPORTS = 'TEST_SUPPORTS';
export const FILTERED_TEST_SUPPORTS = 'FILTERED_TEST_SUPPORTS';
export const TEST_SUPPORT_CONFIG = 'TEST_SUPPORT_CONFIG';
export const TEST_SUPPORT_DETAIL = 'TEST_SUPPORT_DETAIL';
export const TEST_SUPPORT_SEARCH_FILTER_CONFIG = 'TEST_SUPPORT_SEARCH_FILTER_CONFIG';
export const TEST_SUPPORT_SEARCH_SORT_CONFIG = 'TEST_SUPPORT_SEARCH_SORT_CONFIG';

function resetState(state, key){
	let newState = _.cloneDeep(state);
	delete newState[key];
	return newState;
}

export function testSupportReducer(state: any = {filter: {}, sort: {}, result: {result: []}}, action : ActionWithPayload) {
	switch (action.type) {
        
		case TEST_SUPPORTS:{
      return getNewState(state, action.payload, TEST_SUPPORTS);
    }
		case TEST_SUPPORT_CONFIG:{
			return getNewState(state, action.payload, TEST_SUPPORT_CONFIG);
		}
    case TEST_SUPPORT_DETAIL:{
			return getNewState(state, action.payload, TEST_SUPPORT_DETAIL);
		}
    case TEST_SUPPORT_SEARCH_FILTER_CONFIG:{
			return getNewState(state, action.payload, TEST_SUPPORT_SEARCH_FILTER_CONFIG);
		}
		case TEST_SUPPORT_SEARCH_SORT_CONFIG:{
			return getNewState(state, action.payload, TEST_SUPPORT_SEARCH_SORT_CONFIG);
		}
    case FILTERED_TEST_SUPPORTS:{
      return getNewState(state, action.payload, FILTERED_TEST_SUPPORTS);
    }
		default:
			return state;
	}
}