import { Action } from '@ngrx/store';
import { ActionWithPayload } from './ActionWithPayload';
import * as _ from 'lodash';
import { CommonStates } from '../model/common-states.enum';
import { getNewState, getNewEmptyState } from '../utils/utils';
import * as actions from './common.actions';

function resetState(state, key){
	let newState = _.cloneDeep(state);
	delete newState[key];
	return newState;
}

function removeFalseValues(currentValues, newValues : any){
  return _.pickBy(newValues, (value, key) => {
    return valueIsTrue(value) || (currentValues && _.has(currentValues, key) && valueIsTrue(currentValues[key]));
  });
}

function valueIsTrue(value){
  return !!value && (!_.isArray(value) || !_.isEmpty(value));
}

export function commonReducer(state: any = {}, action : ActionWithPayload) {
	switch (action.type) {
		case actions.COMMON_USER_INFO:{
			return getNewState(state, action.payload, CommonStates.userInfo);
		}
		// case actions.COMMON_SEARCH_FILTER:{
		// 	return getNewState(state, action.payload, CommonStates.searchFilter);
		// }
    case actions.COMMON_GRAPH_COLORS:{
      return getNewState(state, action.payload, actions.COMMON_GRAPH_COLORS);
    }
    case actions.COMMON_GRAPH_DISPLAY:{
      return getNewState(state, action.payload, actions.COMMON_GRAPH_DISPLAY);
    }
    case actions.COMMON_GLOBAL_SETTINGS:{
      return getNewState(state, action.payload, actions.COMMON_GLOBAL_SETTINGS);
    }
    case actions.COMMON_FILTER_STATE:{
      //remove null values
      let simplifiedObject  = removeFalseValues(state[actions.COMMON_FILTER_STATE], action.payload);
      return getNewState(state, simplifiedObject, actions.COMMON_FILTER_STATE);
    }
    case actions.COMMON_FILTER_STATE_RESET:{
      let newState = getNewEmptyState(state, actions.COMMON_TEST_SUPPORT_FILTER_STATE);
      newState[actions.COMMON_SEARCH_WORD_HEADER] = '';
      return getNewEmptyState(newState, actions.COMMON_FILTER_STATE);
    }
    case actions.COMMON_SEARCH_WORD_HEADER:{
      if (state[actions.COMMON_SEARCH_WORD_HEADER] === action.payload){
        return state;
      }
      else{
        let newState1 = getNewEmptyState(state, actions.COMMON_FILTER_STATE);
        let newState =  getNewEmptyState(newState1, actions.COMMON_TEST_SUPPORT_FILTER_STATE);
        newState[actions.COMMON_SEARCH_WORD_HEADER] = action.payload;
        return newState;
      }
    }
    case actions.COMMON_TEST_SUPPORT_FILTER_STATE:{
      return getNewState(state, action.payload, actions.COMMON_TEST_SUPPORT_FILTER_STATE);
    }
    case actions.COMMON_REPORT_MALKARS_SIZE:{
      return getNewState(state, action.payload, actions.COMMON_REPORT_MALKARS_SIZE);
    }
		default:{
      if(_.endsWith(action.type, '_loading')){
        return getNewState(state, action.payload, action.type);
      }
      else{
        return state;
      }
	  }
  }
}