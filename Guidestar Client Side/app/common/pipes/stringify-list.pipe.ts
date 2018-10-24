import { Pipe, PipeTransform } from '@angular/core';
import * as _ from 'lodash';

@Pipe({
  name: 'stringifyList'
})
export class StringifyListPipe implements PipeTransform {

  transform(items: any, args?: any): any {
    if (Array.isArray(items)){
      return _.join(items, ', ');
    }
    return items;
  }

}
