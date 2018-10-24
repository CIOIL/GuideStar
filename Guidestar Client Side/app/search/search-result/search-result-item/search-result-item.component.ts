import { Component, OnInit, Input, Output, EventEmitter, ChangeDetectionStrategy } from '@angular/core';
import { pages } from '../../../../environments/pages';
import { malkarPages } from '../../../malkar-detail/malkar-detail.pages';
import * as _ from 'lodash';

@Component({
  selector: 'app-search-result-item',
  templateUrl: './search-result-item.component.html',
  styleUrls: ['./search-result-item.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SearchResultItemComponent implements OnInit {

  @Input() item : any;
  @Input() isLast : boolean = false;
  @Output() onLast : EventEmitter<any> = new EventEmitter<any>();
  @Input() searchWord: string;

  $Label: any;
  pages: any;
  malkarPages: any;

  areaLabel: string;
  areaValue: any;
  
  constructor() {
    this.$Label = window['$Label'];
    this.pages = pages;
    this.malkarPages = malkarPages;
   }

  ngOnInit() {
    this.areaLabel = this.getAreaLabel(this.item);
    this.areaValue = this.getAreaValue(this.item);
  }

  lastInView(){
    if(this.isLast){
      this.onLast.emit(this.item);
    }
  }

  itemSelected(ev){
    ev.target.click();
  }

  getAreaLabel(item: any): string{
    if (item.cityNums && item.cityNums.length > 1){
      return this.$Label.Activities_area;
    }
    return this.$Label.Activity_place;
  }

  getAreaValue(item: any): string{
    if (item.cityNums && item.cities){
      if (item.cityNums.length > 1){
        if (item.malkarLocationIsNational){
          return this.$Label.Search_National;
        }
        // return _.join(item.malkarDistricts, ', ');
        return item.malkarDistricts;
      }
      return item.cities[0];
    }
    return '';
  }

  getNamePrefixHtml(): string{
    if (this.searchWord){
      return '<b style="font-weight: 900">';
    }
    return '<b>';
  }

}
