import { Action } from '@ngrx/store';
import { ActionWithPayload } from '../common/ngrx/ActionWithPayload';
import * as _ from 'lodash';
import { getNewState } from '../common/utils/utils';

export const RESET_LAST_RESULT = 'RESET_LAST_RESULT';
export const SEARCH_MALKARS = 'SEARCH_MALKARS';
export const COUNT_MALKARS = 'COUNT_MALKARS';

function isSamefilter(state, action){
	return _.isEqual(action.payload.filter, state.filter) 
					&& (action.payload.sort && state.sort) 
					&& action.payload.sort.apiName === state.sort.apiName
					&& action.payload.sort.sortDesc === state.sort.sortDesc
}

export function searchReducer(state: any = {filter: {}, sort: {}, result: {result: []}}, action : ActionWithPayload) {
	switch (action.type) {
		case SEARCH_MALKARS:{
				if(isSamefilter(state, action)){
					let newState: any = {};
					newState.filter = action.payload.filter;
					newState.sort = action.payload.sort;
					newState.result = action.payload.result;
					newState.result.result = _.uniqBy([...state.result.result, ...action.payload.result.result], 'Id');
					return _.cloneDeep(newState);
				}
				else{
					return _.cloneDeep(action.payload);
				}
            }
		case RESET_LAST_RESULT:{
			let newState =  _.cloneDeep(state);
			if(newState.result){
				newState.result.result = [];	
			}
			return newState;
		}
		case COUNT_MALKARS:{
			return getNewState(state, action.payload, COUNT_MALKARS);
		}
		default:
			return state;
	}
}