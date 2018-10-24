import { Component, OnInit, Input, Output, EventEmitter, ViewChildren, QueryList, ElementRef, ViewChild , ChangeDetectionStrategy} from '@angular/core';
import { FormGroup } from '@angular/forms';
import * as _ from 'lodash';

@Component({
  selector: 'app-picklist',
  templateUrl: './picklist.component.html',
  styleUrls: ['./picklist.component.scss'],
  host: { '(document:click)': 'onClick($event)'},
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class PicklistComponent implements OnInit {

  @Input() valueList: Array<any> = [];
  @Input() placeholder: string;
  @Input() notShowPlaceHolderOption: boolean = false;
  @Input() caretStyle: any;
  @Input() inputStyle: any;
  @Input() itemsContainerStyle: any;
  @Input() itemListStyle: any;
  @Input() itemStyle: any;
  @Input() selectStyle: any;
  @Input() errorStyle: any;
  @Input() required: boolean = false;
  @Input() nullLabel: string = '';

  @Input() controlName: string;
  @Input() parentFormGroup: FormGroup;

  @Output() onSelect: EventEmitter<any> = new EventEmitter<any>();

  @ViewChild('picklistInput') picklistInput: ElementRef  ;
  @ViewChild('picklistWrapper') picklistWrapper: ElementRef  ;
  @ViewChildren('picklistItems') picklistItems: QueryList<ElementRef>;

  showItems: boolean;

  constructor() { }

  ngOnInit() {
    this.valueList = _.map(this.valueList, x => x == null ? this.nullLabel : x);
  }

  getInputStyle(){
    if (this.errorStyle){
      return this.errorStyle;
    }
    return this.inputStyle;
  }

  onClick(ev){
    if (this.showItems && !this.picklistWrapper.nativeElement.contains(ev.target)){
      this.showItems = false;
    }
  }

  trackByFunc(index, item){
    if (!item){
      return index;
    }
    return item.value || item;
  }

  clicked(ev){
    ev.preventDefault();
    if (this.valueList.length > 0){
      this.showItems = !this.showItems;
    }
  }

  itemSelected(ev, item = null){
    if (!item){
      item = _.find(this.valueList, x => x.label === ev.target.value || x.value === ev.target.value || x === ev.target.value);
    }
    if (item){
      this.picklistInput.nativeElement.value = item.label || item;
      this.showItems = false;
      this.parentFormGroup.controls[this.controlName].setValue(item.value || item);
      this.onSelect.emit(item.value || item);
    }
  }

  keyDown(ev){
    if (ev.code != 'Tab' && ev.code != 'ArrowDown' && ev.code != 'ArrowUp' && ev.code != 'Escape' && ev.code != 'Enter'){
      ev.preventDefault();
    }
  }

  arrowDownHit(ev, i = null){
    ev.preventDefault();
    let elems = this.picklistItems.toArray();
    if (!isNaN(i) && elems[i+1]){
      elems[i+1].nativeElement.focus();
    }
    else{
      elems[0].nativeElement.focus();
    }
  }

  arrowUpHit(ev, i = null){
    ev.preventDefault();
    let elems = this.picklistItems.toArray();
    if (i && elems[i-1]){
      elems[i-1].nativeElement.focus();
    }
    else{
      elems[elems.length-1].nativeElement.focus();
    }
  }

  clearList(){
    this.showItems = false;
    this.picklistInput.nativeElement.value = '';
     this.parentFormGroup.controls[this.controlName].setValue(null);
  }

}
