import { Component, OnInit, Input, OnChanges, SimpleChanges, ChangeDetectionStrategy } from '@angular/core';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';
import * as _ from 'lodash';

import { TableByYear } from './TableByYear';
// import { DataByYear } from '../data-table-old/DataByYear';
import { DataByYear } from './DataByYear';

@Component({
  selector: 'app-data-table',
  templateUrl: './data-table.component.html',
  styleUrls: ['./data-table.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('collapsed, void', style({
        height: '0px',
        visibility: 'hidden'
      })),
      state('expanded', style({
        height: AUTO_STYLE,
        visibility: 'visible'
      })),
      transition('collapsed <=> expanded', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DataTableComponent implements OnInit, OnChanges {

  @Input() tableData: TableByYear;
  @Input() labelSeparator: string;
  @Input() titleSeparator: string;
  @Input() isFile: Boolean;
  @Input() hideSum: Boolean;
  @Input() normalSum: Boolean;
  @Input() headerStyle: any;
  @Input() rowStyle: any;
  @Input() headerLevel: string;
  @Input() ariaLevel: string;
  @Input() nullTitle: string = '';

  theData: DataByYear[];
  tableTitle: string;
  $Label: any;

  @Input() isCollapsed: Boolean = false;
  @Input() state: string = 'collapsed';

  constructor() { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    this.tableTitle = this.tableData && this.tableData.Label ? this.tableData.Label : this.nullTitle;    
  }

  ngOnChanges(change: SimpleChanges){
    if (this.tableData && this.tableData.DataMap){
      this.flattenDataMap();
    }
    else{
      this.theData = this.tableData ? this.tableData.Data : null;
    }
  }

  flattenDataMap(){
    // if (!this.theData){
      this.theData = [];
    // }
    let temp = _.values(this.tableData.DataMap);
    for (let i=0; i< temp.length; i++){
      let row = new DataByYear;
      // row.Amount = temp[i].Sum;
      row.MainLabel = temp[i].Label;
      this.theData.push(row);
      _.forEach(temp[i].Data, x => this.theData.push(x));
    }
  }

  toggleTableView(){
    this.isCollapsed = !this.isCollapsed;
    this.state = this.state === 'expanded' ? 'collapsed' : 'expanded';
  }

  getRowSeparator(){
    return this.labelSeparator ? this.labelSeparator : ',';
  }

  getTitleSeparator(){
    if (this.tableData && this.tableData.Sum){
      return this.titleSeparator ? this.titleSeparator : ':';
    }
  }

  getHeaderStyle(){
    let style = this.headerStyle ? this.headerStyle : '';
    return style;
  }

  getRowStyle(){
    let style = this.rowStyle ? this.rowStyle : '';
    return style;
  }

}
