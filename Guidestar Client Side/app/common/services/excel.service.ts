import { Injectable } from '@angular/core';
import { DatePipe } from '@angular/common';
import * as XLSX from 'xlsx';
import * as _ from 'lodash';

@Injectable({
  providedIn: 'root'
})
export class ExcelService {

  workbookName: string = 'Workbook';

  constructor(private datePipe: DatePipe) { }

  writeDataToFile(input: any, fileName: string, rtl: boolean = true){
    // let rs = this.createReservationsSheet();
    let ws = this.createSheet(input, null, null);
    fileName = _.isEmpty(fileName) ? this.getName(this.workbookName) : fileName;
    let wb = this.appendSheet(ws, null);
    // this.appendSheet(ws, wb);
    if (rtl){
      this.setRightToLeft(wb);
    }
    this.writeWorkbook(wb, fileName);
  }

  createSheet(input: any, order:any[], columnHeaders: any, noHeader: boolean = false): XLSX.WorkSheet{
    if (!input){ return null;}
    if (order == null){
      order = Object.keys(input[0]);
    }
    let ws: XLSX.WorkSheet = XLSX.utils.json_to_sheet(input, {header: order, skipHeader: noHeader}); // Change second value to change order of columns
    // To change the values of the header row:
    // let headerRow = {};
    // let i=1;
    // Object.keys(input[0]).forEach(element => {
    //   headerRow[element] = 'Column ' + i++;
    // });
    if (columnHeaders && columnHeaders != null){
      XLSX.utils.sheet_add_json(ws, [columnHeaders], {skipHeader: true});
    }
    return ws;    
  }

  createStyledSheet(input: any, order:any[], columnHeaders: any, noHeader: boolean = true, colStyle: any, rowStyle: any): XLSX.WorkSheet{
    let ws = this.createSheet(input, order, columnHeaders, noHeader);
    if (colStyle && _.size(colStyle) > 0){
      ws['!cols'] = colStyle;
    }
    if (rowStyle && _.size(rowStyle) > 0){
      ws['!rows'] = rowStyle;
    }
    XLSX.utils.sheet_add_json(ws, [], {skipHeader: true});
    return ws;
  }

  appendSheet(ws: XLSX.WorkSheet, wb: XLSX.WorkBook, sheetName: string = ''): XLSX.WorkBook{
    if (!wb){
      wb = XLSX.utils.book_new();
    }
    XLSX.utils.book_append_sheet(wb, ws, sheetName);
    return wb;
  }

  writeWorkbook(wb: XLSX.WorkBook, bookName: string){
    bookName = _.isEmpty(bookName) ? this.getName(this.workbookName) : bookName;
    XLSX.writeFile(wb, bookName + '.xlsx');
  }

  getName(prefix: string):string{
    let dateStr = this.datePipe.transform(Date.now(), 'yyyy-MM-dd HH-mm-ss');
    return prefix + '_' + dateStr;
  }

  setRightToLeft(wb: XLSX.WorkBook) {
    if(!wb.Workbook) wb.Workbook = {};
    if(!wb.Workbook.Views) wb.Workbook.Views = [];
    if(!wb.Workbook.Views[0]) wb.Workbook.Views[0] = {};
    wb.Workbook.Views[0].RTL = true;
  }

}
