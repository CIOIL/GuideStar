import { Action } from '@ngrx/store';
import { ActionWithPayload } from '../common/ngrx/ActionWithPayload';
import * as _ from 'lodash';

export const SEARCH_FILTER_CONFIG = 'SearchFilterConfig';
export const SEARCH_SORT_CONFIG = 'SearchSortConfig';

export function searchConfigReducer(state: any = {filter: {}, sort: []}, action : ActionWithPayload) {
	switch (action.type) {
        
		case SEARCH_FILTER_CONFIG:{
			state.filter = action.payload;
			return _.cloneDeep(state);
		}
		case SEARCH_SORT_CONFIG:{
			state.sort = action.payload;
			return _.cloneDeep(state);
		}   
		default:
			return state;
	}
}