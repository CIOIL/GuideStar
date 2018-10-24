import { Component, OnInit, Input, OnChanges, SimpleChanges, ChangeDetectionStrategy } from '@angular/core';
import { TableByYear } from './../data-table/TableByYear';
import * as _ from 'lodash';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-data-table-list',
  templateUrl: './data-table-list.component.html',
  styleUrls: ['./data-table-list.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DataTableListComponent implements OnInit, OnChanges {

  @Input() tableList: Array<TableByYear> | any;
  @Input() labelSeparator: string;
  @Input() titleSeparator: string;
  @Input() isFile: Boolean;
  @Input() hideSum: Boolean;
  @Input() normalSum: Boolean;
  @Input() headerStyle: any;
  @Input() rowStyle: any;
  @Input() totalStyle: any;
  @Input() headerLevel: string;
  @Input() ariaLevel: string;
  @Input() nullTitle: string = '';
  // @Input() expandRow: any;

  // _expandRow: any;
  @Input() set expandRow(newExpandRow: any){
    this.expandTable = _.find(this.tableList, x => x.Label === newExpandRow);;
  }

  selectedTable: TableByYear;
  expandTable: TableByYear;
  $Label: any;

  tableForm: FormGroup;
  tableNames: string[];

  constructor() { 
    this.$Label = window['$Label'];
    this.tableForm = new FormGroup({});
  }

  ngOnInit() {
    this.selectedTable = this.tableList[0];
    this.tableForm.addControl('tableName', new FormControl(''));
    this.tableNames = _.map(this.tableList, x => x.Label);
    // if (this.expandRow){
    //   this.expandTable = _.find(this.tableList, x => x.Label === this.expandRow);
    // }
  }

  ngOnChanges(changes: SimpleChanges){
    if (Array.isArray(this.tableList)){
    }
    else{
       this.tableList = _.values(this.tableList);
    }
  }

  trackByFunc(index, item) {
    return index;
  }

  tableSelected(item){
    this.selectedTable = _.find(this.tableList, x => x.Label === item);
    // this.selectedTable = item;
  }

  getTotalStyle(){
    let style = this.totalStyle ? this.totalStyle : '';
    return style;
  }

}
