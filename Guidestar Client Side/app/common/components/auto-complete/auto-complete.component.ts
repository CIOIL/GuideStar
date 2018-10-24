import { Component, OnInit, Input, ViewChild, ElementRef, ViewChildren, QueryList, HostListener, OnDestroy, Output, EventEmitter, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { remoteFunction } from '../../utils/remote';
import { pushEventToDataLayerGTM } from '../../utils/utils';
import { FormGroup } from '@angular/forms';
import { Subscription ,  Observable, fromEvent } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import * as _ from 'lodash';

@Component({
  selector: 'app-auto-complete',
  templateUrl: './auto-complete.component.html',
  styleUrls: ['./auto-complete.component.scss'],
  host: { '(document:click)': 'onClick($event)'},
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AutoCompleteComponent implements OnInit, OnDestroy {
  
  @Input() remoteAction: any; //resolves to: ['str1', 'str2', 'str3',...] OR {key1: ['str1', 'str2', 'str3',...], key2: ['str1', 'str2', 'str3',...], ...}
  @Input() searchList: Array<string> = [];
  @Input() labelClass: string;
  @Input() maxHeight: string;
  @Input() fontSize: string;
  @Input() allowExtValue: boolean;
  @Input() topOffset: string;
  @Input() rightOffset: string;
  @Input() reverseFunction: any;
  @Input() showSelection: boolean = true;
  @Input() posRelative: boolean = false;
  @Input() illegalSearchRegex: string = '';
  private _discardResults:boolean;
  get discardResults(): boolean{ return this._discardResults;}
  @Input() set discardResults(value: boolean){
    if (!this.loading){
      this._discardResults = value;
    }
  }

  @Input() controlName: string;
  @Input() parentFormGroup: FormGroup;
  @Input() initialValue: any;

  @Output() onSelect: EventEmitter<any> = new EventEmitter<any>();
  @Output() showToggled: EventEmitter<any> = new EventEmitter<any>();

  @ViewChildren('autoCompleteResultItems') autoCompleteResultItems: QueryList<ElementRef>;
  @ViewChild('ngContentWrapper') ngContentWrapper: ElementRef  ;
  @ViewChild('autoCompleteWrapper') autoCompleteWrapper: ElementRef  ;

  searchWord: string = '';
  lastSearchWord: string = '';
  isList : boolean = false;
  result : any;
  loading : boolean = false;

  searchValue: any;
  valueSelected: boolean;
  showList: boolean = true;
  _ : any;

  private parentFormSub: Subscription;
  private keyupSub: Subscription;

  keys:string[];

  $Label: any;
  
  constructor(private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
    this._ = _;
  }

  ngOnInit() {  
    if (this.initialValue){
      this.setInitialValue();
    }
    this.keyupSub = fromEvent(this.ngContentWrapper.nativeElement, 'keyup')
                              .pipe(debounceTime(300))
                              .subscribe(ev => this.getSearchWord(ev));
    this.parentFormSub = this.parentFormGroup.controls[this.controlName].valueChanges.subscribe(o => {
      if (o == null){
        this.ngContentWrapper.nativeElement.firstElementChild.value = '';
        this.searchWord = '';
        this.searchValue = '';
      }
      else if (o === ''){
        this.searchWord = '';
      }
      else{
        if (this.reverseFunction && !this.searchValue){
          remoteFunction(this.reverseFunction, o).then(res => {
            this.ngContentWrapper.nativeElement.firstElementChild.value = <string>res;
          });
        }
        else{
        }
      }
      this.ref.markForCheck();
    });
  }

  ngOnDestroy(){
    this.parentFormSub.unsubscribe();
    this.keyupSub.unsubscribe();
  }

  setInitialValue(){
    if (this.reverseFunction){
      remoteFunction(this.reverseFunction, this.initialValue).then(res => {
        this.ngContentWrapper.nativeElement.firstElementChild.value = <string>res;
      });
    }
  }

  onClick(ev){
    if (!this.searchValue && this.searchWord && !this.autoCompleteWrapper.nativeElement.contains(ev.target)){
      this.showList = false;
    }
  }

  showListResults(): boolean{
    let show = (this.showList && !this.searchValue && this.searchWord && this.result && this.result.length > 0 && this.isList) || 
            (this.showList && !this.searchValue && this.result && this.result.length > 0 && this.searchList && this.searchList.length>0);
    this.showToggled.emit({shown: show, ref: this.autoCompleteWrapper});
    return show;
  }

  showMapResults(): boolean{
    let show = this.showList && !this.searchValue && this.searchWord && this.keys && this.keys.length > 0 && this.result && !this.isList;
    this.showToggled.emit({shown: show, ref: this.autoCompleteWrapper});
    return show;
  }
  
  trackByFunc(index, item){
    return item.value || item;
  }

  getSearchWord(ev){
    let regex = new RegExp(this.illegalSearchRegex, 'g');
    if (ev && ev.target && ev.target.value){
     let cleanInput = ev.target.value.replace(regex, '');
      cleanInput = _.trimEnd(cleanInput, '.');
      cleanInput = _.trimEnd(cleanInput, ' ');
      if (ev.keyCode != 27 && ev.keyCode != 40 && ev.keyCode != 38 && ev.keyCode != 13){
        let isChanged = this.searchWord != cleanInput;
        this.searchWord = cleanInput;
        this.searchValue = '';
        if(isChanged){
          this.getkeys();
        }
      } 
    }
  }

  getkeys(){
    this.showList = true;
    if (this.remoteAction){
      if(this.searchWord && (_.isEmpty(this.result) || !_.isEqual(this.searchWord, this.lastSearchWord))){
        if(!_.startsWith(this.searchWord, this.lastSearchWord)){
          this.result = null;
        }
        this.loading = true;
        remoteFunction(this.remoteAction, this.searchWord).then(res => {
          this.loading = false;
          if (this.discardResults){
            this.discardResults = false;
            this.result = null;
          }
          else{
            this.result = res;
            this.lastSearchWord = _.clone(this.searchWord);
            if( this.result instanceof Array){
                this.isList = true;
            }
            else{
              this.keys = Object.keys(this.result);
            }
          }
          this.ref.markForCheck();
        },
        err =>{
          this.loading = false;
          this.ref.markForCheck();
        });
      }
    }
    else if (this.searchList){
      this.isList = true;
      this.result = [... this.searchList];
    }
  }

  clearResults(){
    this.searchWord = '';
    this.searchValue = '';
    this.ngContentWrapper.nativeElement.firstElementChild.value = '';
    this.parentFormGroup.controls[this.controlName].setValue('');
  }

  itemSelected(ev, item = null){   
    if (this.allowExtValue && !item){
      this.searchValue = this.searchWord;
    }
    else{
      this.searchValue = item;
    }
    this.valueSelected = true;
    if (this.showSelection){
      if (this.searchValue){
        this.parentFormGroup.controls[this.controlName].setValue(this.searchValue.value || this.searchValue);
        setTimeout(() => pushEventToDataLayerGTM(this.controlName, this.searchValue), 100);
        let tempValue = this.searchValue.label || this.searchValue;
        this.ngContentWrapper.nativeElement.firstElementChild.value = tempValue;
        this.searchWord = tempValue;
      }
      else{
        this.parentFormGroup.controls[this.controlName].setValue(null);
      }
    }
    setTimeout(() => pushEventToDataLayerGTM('ac_itemSelected', {id: this.controlName, value: item}), 100);
    this.onSelect.emit(item);
  }

  clicked(ev){
    this.searchValue = '';
    this.getkeys();
  }

  arrowDownHit(ev, i = null, obj = null){
    ev.preventDefault();
    let elems = this.autoCompleteResultItems.toArray();
    if (obj){
      if (obj.nextElementSibling){
        obj.nextElementSibling.focus();
      }
      else if(obj.parentElement.nextElementSibling && obj.parentElement.nextElementSibling.firstElementChild){
        if (obj.parentElement.nextElementSibling.firstElementChild.tagName.toLocaleLowerCase() === 'span'
            && obj.parentElement.nextElementSibling.firstElementChild.nextElementSibling){
          obj.parentElement.nextElementSibling.firstElementChild.nextElementSibling.focus();
        }
        else{
          obj.parentElement.nextElementSibling.firstElementChild.focus();
        }
      }
      else if (obj.parentElement.parentElement && obj.parentElement.parentElement.firstElementChild && obj.parentElement.parentElement.firstElementChild.firstElementChild){
        obj.parentElement.parentElement.firstElementChild.firstElementChild.focus();
      }
    }
    else if ((i || i === 0)  && elems[i+1]){
      elems[i+1].nativeElement.focus();
    }
    else if (elems[0]){
      elems[0].nativeElement.focus();
    }
  }

  arrowUpHit(ev, i = null, obj = null){
    ev.preventDefault();
    let elems = this.autoCompleteResultItems.toArray();
    if (obj){
      if (obj.previousElementSibling && obj.previousElementSibling.tagName.toLocaleLowerCase() != 'span'){
        obj.previousElementSibling.focus();
      }
      else if(obj.parentElement.previousElementSibling && obj.parentElement.previousElementSibling.lastElementChild){
        obj.parentElement.previousElementSibling.lastElementChild.focus();
      }
      else if (obj.parentElement.parentElement && obj.parentElement.parentElement.lastElementChild && obj.parentElement.parentElement.lastElementChild.lastElementChild){
        obj.parentElement.parentElement.lastElementChild.lastElementChild.focus();
      }
    }
    else if (i && elems[i-1]){
      elems[i-1].nativeElement.focus();
    }
    else if (elems[elems.length-1]){
      elems[elems.length-1].nativeElement.focus();
    }
  }

  getLabelClasses(){
      let classList = '';
      if (this.labelClass){
        classList += this.labelClass;
      }
      return classList;
  }

  getSeparatorClass(){
      return this.getLabelClasses() + ' auto-complete-separator';
  }
    
}
