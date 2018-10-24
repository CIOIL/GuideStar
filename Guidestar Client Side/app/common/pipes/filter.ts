import { Pipe, PipeTransform } from '@angular/core';
import * as _ from 'lodash';

@Pipe({
  name: 'filter'
})
export class FilterPipe implements PipeTransform {

  transform(items: any, filter: any, use: boolean = true, searchAllObject: boolean = false): any {
    if (filter && Array.isArray(items) && use) {
        return _.filter(items, item => {
          if(searchAllObject){
            let includes = false;
            _.forEach(Object.keys(item), key => {
              let includesKey = _.includes(item[key], filter);
              if(includesKey){
                includes = true;
              }
            });
            return includes;
          }
          else if(item.label || item.value){
            return _.includes(item.label, filter) || _.includes(item.value, filter);
          }
          else{
            return _.includes(item, filter);
          }
        });
      } 
      else {
          return items;
      }
  }

} 