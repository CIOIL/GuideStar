import { Component, OnInit, OnChanges, Input, ViewChild, ElementRef, SimpleChanges, QueryList, ViewChildren, HostListener, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';
import * as _ from 'lodash';
import { CheckboxComponent } from '../checkbox/checkbox.component';
import { FormGroup, FormControl } from '@angular/forms';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-multi-picklist',
  templateUrl: './multi-picklist.component.html',
  styleUrls: ['./multi-picklist.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('collapsed', style({
        height: 'initial'})),
      state('expanded', style({
        height: AUTO_STYLE,
      })),
      transition('collapsed <=> expanded', animate('0.5s ease'))
    ]),
    trigger('rotateArrow',[
      state('inactive', style({
        transform: 'rotate(0deg)'
      })),
      state('active', style({
        transform: 'rotate(180deg)'
      })),
      transition('inactive => active', animate('0.5s ease')),
      transition('active => inactive', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MultiPicklistComponent implements OnInit, OnChanges, OnDestroy {

  @Input() title: string;
  @Input() fieldName: string;
  @Input() picklistItems: Array<any>; //[{label: 'label', value: 'value', tooltip: 'tooltip', isChecked: false}]
  @Input() hideBorders: boolean = false;
  @Input() titleHeight: string = '2em';
  @Input() maxHeight: string = 'auto';
  @Input() fontSize: string = 'inherit';
  @Input() placeHolderColor: string = '#1f3f4e';
  @Input() tightArrow: boolean = false;

  @Input() parentFormGroup: FormGroup;
  @Input() controlName: string;
  

  @ViewChild('multiPicklistContainer') multiPicklistContainer: ElementRef  ;
  @ViewChild('multiPicklist') multiPicklist: ElementRef  ;
  @ViewChildren('checkboxItems') checkboxItems: QueryList<CheckboxComponent>;
  multiPicklistState: string = 'collapsed';
  arrowState: string = 'inactive';
  picklistItemList: any;
  selectedCount: number;
  $Label: any;

  private parentFormSub: Subscription;
  private picklistFormSub: Subscription;
  picklistFormGroup: FormGroup;

  constructor(private ref: ChangeDetectorRef) { 
    this.picklistFormGroup = new FormGroup({});    
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    this.parentFormSub = this.parentFormGroup.controls[this.controlName].valueChanges.subscribe(o => {
      if (o == null){
        this.picklistFormGroup.reset();
      }
      else{
        let valueList = this.picklistFormGroup.value;
        _.forEach(o, item => {
          if (_.find(this.parentFormGroup.controls[this.controlName].value, x => x === item)){
            valueList[item] = true;
          }
        });
        this.picklistFormGroup.setValue(valueList);
      }
      // this.ref.markForCheck();
    });
    this.picklistFormSub = this.picklistFormGroup.valueChanges.subscribe(o => {
      let tmp = _.filter(this.picklistItemList, item => o[''+item.value]);
      const tempArr = _.map(tmp, item => item.value)
      if (!_.isEqual(tempArr, this.parentFormGroup.controls[this.controlName].value)){
        this.parentFormGroup.controls[this.controlName].setValue(tempArr);
      }
      this.selectedCount = tempArr.length;
      this.ref.markForCheck();
    });
    if (!this.selectedCount && this.parentFormGroup.controls[this.controlName].value){
      this.selectedCount = this.parentFormGroup.controls[this.controlName].value.length;
    }
  }

  ngOnChanges(changes: SimpleChanges){
    if (changes['picklistItems'] && this.picklistItems){
      let filteredObjects = _.filter(this.picklistItemList, item => _.find(this.picklistItems, {value: item.value}) || false );
      this.picklistItemList = filteredObjects && filteredObjects.length > 0 ? _.uniqBy([...filteredObjects, ...this.picklistItems], 'value') : this.picklistItems;
      this.buildForm();      
    }
    if (changes['parentFormGroup'] && this.picklistItems){
    }
  }

  ngOnDestroy(){
    this.parentFormSub.unsubscribe();
    this.picklistFormSub.unsubscribe();
  }

  buildForm(){
    for (let i=0; i<this.picklistItemList.length; i++){
      this.picklistFormGroup.addControl(''+this.picklistItemList[i].value, new FormControl(false));
      if (_.find(this.parentFormGroup.controls[this.controlName].value, x => x === ''+this.picklistItemList[i].value)){
        this.picklistFormGroup.controls[''+this.picklistItemList[i].value].setValue(true);
      }
    }
    const currKeys =_.keys(this.picklistFormGroup.controls);
    for (let i=0; i< currKeys.length; i++){
      if (!_.find(this.picklistItemList, x => ''+x.value === currKeys[i])){
        this.picklistFormGroup.removeControl(currKeys[i]);
      }
    }
  }

  onClick(ev){
    if (this.multiPicklistState === 'expanded' && !this.multiPicklistContainer.nativeElement.contains(ev.target)){
      this.multiPicklistState = 'collapsed';
      this.arrowState = 'inactive';
      this.swapClasses();
    }
  }

  resetClicked(ev){
    this.picklistFormGroup.reset();
  }

  arrowDownHit(ev){
    ev.preventDefault();
    if (!this.multiPicklist.nativeElement.contains(ev.target)){
      this.multiPicklist.nativeElement.firstElementChild.lastElementChild.focus();
    }
    else if(ev.target.parentElement && ev.target.parentElement.nextElementSibling && ev.target.parentElement.nextElementSibling.lastElementChild){
      ev.target.parentElement.nextElementSibling.lastElementChild.focus();
    }
    else if(ev.target.parentElement && ev.target.parentElement.parentElement && ev.target.parentElement.parentElement.firstElementChild && ev.target.parentElement.parentElement.firstElementChild.lastElementChild){
      ev.target.parentElement.parentElement.firstElementChild.lastElementChild.focus();
    }
  }

  arrowUpHit(ev){
    ev.preventDefault();
    if (!this.multiPicklist.nativeElement.contains(ev.target)){
      this.multiPicklist.nativeElement.lastElementChild.lastElementChild.focus();
    }
    else if(ev.target.parentElement && ev.target.parentElement.previousElementSibling && ev.target.parentElement.previousElementSibling.lastElementChild){
      ev.target.parentElement.previousElementSibling.lastElementChild.focus();
    }
    else if(ev.target.parentElement && ev.target.parentElement.parentElement && ev.target.parentElement.parentElement.lastElementChild && ev.target.parentElement.parentElement.lastElementChild.lastElementChild){
      ev.target.parentElement.parentElement.lastElementChild.lastElementChild.focus();
    }
  }

  closeBox(){
    if (this.multiPicklistState === 'expanded'){
      this.multiPicklistState = 'collapsed';
      this.arrowState = 'inactive';
      this.swapClasses();
    }
  }

  trackByFunc(index, item) {
    return index;
  }

  expandPicklist(ev){
    if (!_.isEmpty(_.filter(ev.target.classList, item => _.includes(item, 'reset')))){
      return;
    }
    this.multiPicklistState = this.multiPicklistState === 'collapsed' ? 'expanded' : 'collapsed';
    this.arrowState = this.arrowState === 'inactive' ? 'active' : 'inactive'
    this.swapClasses();
  }

  swapClasses(){
    if (this.multiPicklistState === 'collapsed'){
      this.multiPicklistContainer.nativeElement.classList.remove('multi-picklist-container-expanded');
      this.multiPicklistContainer.nativeElement.firstElementChild.classList.remove('multi-picklist-heading-expanded');
    }
    else{      
      this.multiPicklistContainer.nativeElement.classList.add('multi-picklist-container-expanded');
      this.multiPicklistContainer.nativeElement.firstElementChild.classList.add('multi-picklist-heading-expanded');
    }
  }
}
