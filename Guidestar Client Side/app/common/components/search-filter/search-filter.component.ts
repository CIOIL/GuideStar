import { Component, OnInit, Input, Output, EventEmitter, ViewChildren, QueryList, SimpleChanges, ElementRef, OnChanges, ViewChild, HostListener, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import * as _ from 'lodash';
import { MultiPicklistComponent } from '../../components/multi-picklist/multi-picklist.component';
import { AutoCompleteComponent } from '../../components/auto-complete/auto-complete.component';
import { Observable ,  Subscription } from 'rxjs';

import { getBackgroundImageObject, getBackgroundImageUrl, pushEventToDataLayerGTM } from '../../utils/utils';
import { FormControl, FormGroup, Validators, AbstractControl, ValidationErrors, FormArray } from '@angular/forms';
import { AppParams } from '../../enums/app-params';
import { CommonService } from '../../services/common.service';
import { COMMON_FILTER_STATE } from '../../ngrx/common.actions';
import { take } from 'rxjs/operators';

@Component({
  selector: 'app-search-filter',
  templateUrl: './search-filter.component.html',
  styleUrls: ['./search-filter.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SearchFilterComponent implements OnInit, OnChanges, OnDestroy {
  private _initSearchFilter: any;

  @Input() filterConfig: any;
  @Input() storeKey: any;
  // @Input() set initSearchFilter(filter :any){
  //   if(!this._initSearchFilter && filter){
  //     this._initSearchFilter = filter;
  //     // this.resetForm(filter);
  //     this.presetValues = true;
  //     this.buildFormGroup();
  //     this.ref.markForCheck();
  //   }
  // }

  // @Output() initSearchFiltersObservable: EventEmitter<Observable<any>> = new EventEmitter<Observable<any>>();
  @Output() displayed: EventEmitter<boolean> = new EventEmitter<boolean>();
  @Output() scrollFilter: EventEmitter<any> = new EventEmitter<any>();

  @ViewChildren('dropdownComponent') dropdownComponent: QueryList<MultiPicklistComponent>;
  @ViewChildren('autoCompleteBoxes') autoCompleteBoxes: QueryList<AutoCompleteComponent>;
  @ViewChild('searchFilterTab') searchFilterTab: ElementRef  ; 
  @ViewChild('searchFilterHeader') searchFilterHeader: ElementRef  ;
  @ViewChild('searchFilterContainer') searchFilterContainer: ElementRef  ;

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  iconFilter: string = 'assets/img/icons/icon-filter.png';
  iconClose: string = 'assets/img/icons/icon-close-mobile.png';

  searchFilters: any = {};
  checkboxList: any;
  sliderList: any;
  dropdownList: any;
  searchBoxList: any;
  isReset: boolean = false;
  mainActivityIndex: number;
  secondActivityIndex: number;
  showFilter: boolean;
  isDesktop: boolean;
  presetValues: boolean;
  illegalSearchRegex: string = (<any> AppParams.illegalSearchRegex);
  doubleSliderValues: any[] = [];

  filterForm: FormGroup;
  checkboxArray: FormArray;
  private formGroupSub: Subscription;
  subs: Subscription[] =[];
  initializingForm: boolean = true;

  windowWidth: number;
  headerHeight: number;
  windowHeight: number;

  keyEvent: Event;

  $Label: any;

  @HostListener('window:resize', ['$event'])
  onresize(event){
    if (window.innerWidth != this.windowWidth){
      this.testShowFilter();
    }
    if (window.innerHeight != this.windowHeight){
      // this.scrollToEndOfFilter(null);
    }
    this.windowWidth = window.innerWidth;
    this.windowHeight = window.innerHeight;
  }

  constructor(private ref: ChangeDetectorRef, private commonService: CommonService) { 
    this.$Label = window['$Label'];
    this.filterForm = new FormGroup({});
    this.formGroupSub = this.filterForm.valueChanges.subscribe(o => {
      // if (o['CLSS_Main_Classification_Num']) console.log(o['CLSS_Main_Classification_Num']);
      this.valuesChanged(o);
    });
    this.testShowFilter();
  }

  ngOnInit() { 
    // this.initSearchFiltersObservable.emit(this.filterForm.valueChanges);    
    this.windowWidth = window.innerWidth;
    this.commonService.common.pipe<any>(take(1)).subscribe(res => {
      if (_.has(res, this.storeKey) && this.filterForm && !_.isEmpty(res[this.storeKey])){
        // this.filterForm.setValue(res[this.storeKey]);
        _.forEach(res[this.storeKey], (value, key) => {
          if (this.filterForm.controls[key]){
            this.filterForm.controls[key].setValue(res[this.storeKey][key]);
          }
        });
        if (this.filterConfig.sliders){
          for (let i=0; i<this.filterConfig.sliders.length; i++){
            let sliderName = this.filterConfig.sliders[i].apiName;
            this.doubleSliderValues.push(this.filterForm.controls[sliderName].value);
          }
        }
        this.ref.markForCheck();
      }
    });
  }

  ngOnChanges(changes: SimpleChanges){
    if (changes['filterConfig']){
      this.initConfigLists();
      this.initSecondClassification();
      this.buildFormGroup();      
    }
  }

  ngAfterViewInit(){
    this.headerHeight = this.searchFilterHeader.nativeElement.scrollHeight + 120;
  }

  ngOnDestroy(){
    this.formGroupSub.unsubscribe();
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  buildFormGroup(){
    if (this.filterConfig.checkboxes){
      for (let i=0; i<this.filterConfig.checkboxes.length; i++){
        this.filterForm.addControl(this.filterConfig.checkboxes[i].apiName, new FormControl(false));
      }
    }
    if (this.filterConfig.searchBoxes){
      for (let i=0; i<this.filterConfig.searchBoxes.length; i++){
        this.filterForm.addControl(this.filterConfig.searchBoxes[i].apiName, new FormControl(''));
      }
    }
    if (this.filterConfig.sliders){
      for (let i=0; i<this.filterConfig.sliders.length; i++){
        this.filterForm.addControl(this.filterConfig.sliders[i].apiName, new FormControl([]));
      }
    }
    if (this.filterConfig.dropdowns){
      for (let i=0; i<this.filterConfig.dropdowns.length; i++){
        this.filterForm.addControl(this.filterConfig.dropdowns[i].apiName, new FormControl([]));
      }
    }
    if (this.presetValues && this._initSearchFilter){
      this.presetValues = false;
      _.forEach(Object.keys(this._initSearchFilter), x => {
        if (this.filterForm.controls[x] && this._initSearchFilter[x]){
          this.filterForm.controls[x].setValue(this._initSearchFilter[x]);
        }
      });
    }
    this.initializingForm = false;
  }

  valuesChanged(ev){
    if (ev['CLSS_Main_Classification_Num']){
      if (_.isEmpty(this.filterForm.controls['CLSS_Main_Classification_Num'].value) 
          && this.filterForm.controls['CLSS_Secondary_Classification_Num'] 
          && !_.isEmpty(this.filterForm.controls['CLSS_Secondary_Classification_Num'].value)){
        this.filterForm.controls['CLSS_Secondary_Classification_Num'].reset();
      }
      else{
        this.initSecondClassification();
      }
    }
    if (!this.initializingForm){
      this.commonService.getFilterState(ev, this.storeKey);
      // setTimeout(() => pushEventToDataLayerGTM('searchFilter', ev), 100);
    }
  }
  
  testShowFilter(){
    if(window.innerWidth >= 641){
      this.showFilter = true;
      this.isDesktop = true;
    }
    else{
      this.showFilter = false;
      this.isDesktop = false;
    }
    this.displayed.emit(this.showFilter);
  }

  scrollToEndOfFilter(ev){
    let offset = 0;
    if (this.headerHeight){
      offset += this.headerHeight;
    }
    if (this.searchFilterContainer && this.searchFilterContainer.nativeElement){
      let computed = window.getComputedStyle(this.searchFilterContainer.nativeElement).paddingBottom;
      offset += Number.parseInt(computed.substring(0, computed.length-2));
    }
    // if (this.mobileSpacer && this.mobileSpacer.nativeElement && this.mobileSpacer.nativeElement.scrollHeight){
    //   let computedMargin = window.getComputedStyle(this.mobileSpacer.nativeElement).marginTop;
    //   offset += Number.parseInt(computedMargin.substring(0, computedMargin.length-2));
    //   computedMargin = window.getComputedStyle(this.searchFilterContainer.nativeElement).paddingBottom;
    //   offset += Number.parseInt(computedMargin.substring(0, computedMargin.length-2));
    // }
    // if (this.searchFilterHeader && this.searchFilterHeader.nativeElement && this.searchFilterHeader.nativeElement.scrollHeight){
    //   offset += this.searchFilterHeader.nativeElement.scrollHeight;
    // }
    if (ev && ev.shown == true && ev.ref){
      let evObj = {shown: ev.shown, ref: ev.ref, offset: offset};
      this.scrollFilter.emit(evObj);
    }
    if (!ev){
      this.scrollFilter.emit(null);
    }
  }

  resetForm(filter: {} = null){
    if(filter){
      this.filterForm.reset(filter);
    }
    else{
      this.filterForm.reset();
    }
  }

  initConfigLists(){
    this.checkboxList = this.filterConfig.checkboxes ? [... this.filterConfig.checkboxes] : [];
    this.sliderList = this.filterConfig.sliders ? [... this.filterConfig.sliders] : [];
    this.dropdownList = this.filterConfig.dropdowns ? _.cloneDeep(this.filterConfig.dropdowns) : [];
    for(var i=0; i < this.dropdownList.length; i++){
      this.dropdownList[i].changedEvents = [];
      if(this.dropdownList[i].apiName.toLowerCase().includes('main_classification')){
        this.mainActivityIndex = i;
      }
      else if(this.dropdownList[i].apiName.toLowerCase().includes('secondary_classification')){
        this.secondActivityIndex = i;
      }
    }
    this.searchBoxList = this.filterConfig.searchBoxes ? [... this.filterConfig.searchBoxes] : [];
    for (var i=0; i < this.searchBoxList.length; i++){
      this.searchBoxList[i].value = '';
    }
  }



  initSecondClassification(){
    if (!this.secondActivityIndex){
      this.initConfigLists();
    }
    if (this.filterForm.controls['CLSS_Main_Classification_Num']){
      let fullSecondOptions = this.filterConfig.dropdowns[this.secondActivityIndex].options;
      let filteredOptions = _.cloneDeep(fullSecondOptions);
      let parentSelection = this.filterForm.controls['CLSS_Main_Classification_Num'].value;
      filteredOptions = _.filter(filteredOptions, item => {
        return _.includes(parentSelection, item.parent);
      });
      filteredOptions = _.uniqBy(filteredOptions, 'value');
      if(!parentSelection || filteredOptions.length === 0){
        this.dropdownList[this.secondActivityIndex].hidden = true;
      }
      else{
        this.dropdownList[this.secondActivityIndex].options = [... filteredOptions];
        this.dropdownList[this.secondActivityIndex].hidden = false;
      }
    }
  }

  trackByFunc(index, item) {
    return index;
  }

  toggleFilter(){
    if (!this.isDesktop){
      this.showFilter = !this.showFilter;
      this.displayed.emit(this.showFilter);
    }
  }

}
