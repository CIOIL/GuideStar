import { Component, OnInit, Input, OnDestroy, HostListener, Renderer2, ViewChild, ElementRef, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { Location } from '@angular/common';
import { getBackgroundImageObject, getBackgroundImageUrl, pushEventToDataLayerGTM } from '../../utils/utils';
import * as _ from 'lodash';
import { Router, NavigationEnd, ActivatedRoute, Params, NavigationStart } from '@angular/router';
import { CommonService } from '../../services/common.service';
import { FormGroup, FormControl } from '@angular/forms';
import { Subscription ,  Observable, of } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import { pages } from '../../../../environments/pages';
import { AppParams } from '../../enums/app-params';
import { COMMON_SEARCH_WORD_HEADER } from '../../ngrx/common.actions';

declare var ScrollPosStyler: any;
declare var jQuery: any;

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss', 'hamburgers-settings.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HeaderComponent implements OnInit, OnDestroy {

  @ViewChild('headerContainer') headerContainer: ElementRef  ;

  @HostListener('window:resize', ['$event']) 
  onResize(event){
    if (this.windowWidth != window.innerWidth){
      this.hideMobileSearch();
    }
    this.windowWidth = window.innerWidth;
  };

  @HostListener('click', ['$event'])
  onClick(event){
    this.callFunction(event);
    // event.preventDefault();
  }

  @HostListener('window:keydown', ['$event'])
  onKeydown(event){
    if (event.keyCode == 13){
      this.callFunction(event);
    }
  }

  $Label: any;

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  searchForm: FormGroup;
  searchWord: string;
  searchWordControlName: string = 'searchWord';
  currentSearchWordObservableValue : string;
  remoteActionMalkars : string = 'GSTAR_Ctrl.searchMalkarsAC';
  remoteActionTestSupports : string = 'GSTAR_Ctrl.searchTestSupportsOnlyAC';
  remoteActionAutoComplete: string = this.remoteActionMalkars;
  illegalSearchRegex: string = (<any> AppParams.illegalSearchRegex);
  closeAutoComplete: boolean = false;
  closeIcon: string = 'assets/img/icons/icon-close-accessibility.png';

  subs: Subscription[] = [];
  commonServiceSub: Subscription;

  windowWidth: number;

  @Input() menuItems: Array<any>;
  @Input() sideItems: Array<any>;

  constructor(public location: Location, 
              private router: Router, 
              private commonService: CommonService,
              private route: ActivatedRoute,
              private renderer: Renderer2, 
              private ref: ChangeDetectorRef) { 
                
    this.$Label = window['$Label'];
    this.searchForm = new FormGroup({});
    this.searchForm.addControl(this.searchWordControlName, new FormControl(''));
    this.subs.push(router.events.subscribe(event => {
      if (event instanceof NavigationStart){
        this.closeAutoComplete = true;
      }
      if(event instanceof NavigationEnd) {
        this.onNavigateComplete();
        //the timeout is needed - because if we are staying in the same page, the field is update from false => true => false in the same scope, the the field in the auto complete don't see the change
        setTimeout(() => {this.closeAutoComplete = false;}, 300);
      }
    }));
    this.commonService.getGraphColors(AppParams.graphColorsDefault);
  }

  hamburgerActive: boolean = false;
  showSearch: boolean = true;

  ngOnInit() {
    this.windowWidth = window.innerWidth;
// <<<<<<< HEAD
    // this.subs.push(this.commonService.common.subscribe(res => {
    //   if (_.has(res, COMMON_SEARCH_WORD_HEADER)){
    //     this.searchForm.controls[this.searchWordControlName].setValue(res[COMMON_SEARCH_WORD_HEADER]);
    //     this.ref.markForCheck();
    //   }
    // }));
    // if (!this.commonService.subjects[AppParams.searchWordObservableKey]){
    //   this.commonService.addObservable(Observable.of({Search: '' }), AppParams.searchWordObservableKey);
    // }
    // this.commonServiceSub = this.commonService.subjects[AppParams.searchWordObservableKey].debounceTime(500).subscribe(filter =>{
    //   this.setSearchInput(filter);
    // });
// =======
//     if (!this.commonService.subjects[AppParams.searchWordObservableKey]){
//       this.commonService.addObservable(of({Search: '' }), AppParams.searchWordObservableKey);
//     }
//     this.commonServiceSub = this.commonService.subjects[AppParams.searchWordObservableKey].pipe(debounceTime(500)).subscribe(filter =>{
//       this.setSearchInput(filter);
//     });
// >>>>>>> update-angular6-aot-font5
  }

  isSearchPage(){
    return this.isSearchMalkarsPage() || this.isSearchTestSupportPage();
  }
  isSearchMalkarsPage(){
    return _.startsWith(this.location.path(), '/' + pages.searchMalkars);
  }
  isSearchTestSupportPage(){
    return _.startsWith(this.location.path(), '/' + pages.testSupport);
  }

  ngAfterViewInit(){
    jQuery('[data-toggle="popover"]').popover({
      html: true,
      container: '#accessibilityAnchor',
      content: function(){
        return jQuery('#accessibilityMenuContent').html();
      }
    });
  }

  ngOnDestroy(){
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
    if (this.commonServiceSub){
      this.commonServiceSub.unsubscribe();
    }
  }

  onNavigateComplete(){
    this.remoteActionAutoComplete = this.remoteActionMalkars;
    if (this.isSearchPage()){
      this.searchForm.controls[this.searchWordControlName].setValue('');
      let path = this.location.path();
      let searchWord: string;
      if (this.isSearchMalkarsPage()){
        searchWord = path.slice(_.lastIndexOf(path, '/')+1);
      }
      else if (this.isSearchTestSupportPage()){
        searchWord = path.slice(_.lastIndexOf(path, '=')+1);
        this.remoteActionAutoComplete = this.remoteActionTestSupports;
      }
      let hebWord = decodeURIComponent(searchWord.replace(/\+/g,  " "));     
      hebWord = hebWord ? hebWord.trim() : '';
      if (!_.startsWith(hebWord,'/' + pages.testSupport) && hebWord != pages.searchMalkars){
        this.searchForm.controls[this.searchWordControlName].setValue(hebWord);
        // this.commonService.addObservable(of({Search: hebWord || ''}), AppParams.searchWordObservableKey);
        this.commonService.getFilterState(hebWord || '', COMMON_SEARCH_WORD_HEADER);
      }
      else{
        this.searchForm.controls[this.searchWordControlName].setValue('');
        this.commonService.getFilterState('', COMMON_SEARCH_WORD_HEADER);
      }
    }
    else{
      this.searchForm.controls[this.searchWordControlName].setValue('');
      // this.commonService.getFilterState('', COMMON_SEARCH_WORD_HEADER);
    }
    this.hideMobileSearch();
    this.closeDialogs();
  }

  getSearchPlaceholder(){
    if (_.startsWith(this.location.path(), '/' + pages.testSupport)){
      return this.$Label.Test_Support_Placeholder;
    }
    return this.$Label.Enter_search_term;
  }

  getSearchAriaLabel(){
    return _.trimEnd(this.getSearchPlaceholder(), '.');
  }

  setSearchInput(filter: any){
    if (_.has(filter, 'Search')){
      this.currentSearchWordObservableValue = filter['Search'];
      if(!this.isSearchPage()){
        // this.searchForm.controls[this.searchWordControlName].setValue(filter['Search']);
      }
    }
  }

  clearFiltersIfNewSearch(){
    if (!this.isSearchMalkarsPage() && !this.isSearchTestSupportPage()){
      this.commonService.getFilterState(this.searchForm.controls[this.searchWordControlName].value || '', COMMON_SEARCH_WORD_HEADER);
    }
    // if(!this.isSearchMalkarsPage() && this.searchForm.controls[this.searchWordControlName].value !== this.currentSearchWordObservableValue){
    //   this.clearFilters();
    // }
  }

  // clearFilters(){
  //   this.commonService.addObservable(of({Search: '' }), AppParams.searchWordObservableKey);
  //   this.commonService.addObservable(of({}), AppParams.searchFilterObservableKey);
  // }

  goToSearch(){
    this.clearFiltersIfNewSearch();
    if (this.isSearchTestSupportPage()){
      pushEventToDataLayerGTM('testSupportSearch', this.searchForm.controls[this.searchWordControlName].value);
      this.navigate([pages.testSupport, {search: this.searchForm.controls[this.searchWordControlName].value || ''}]).then(res => res, error => {
        console.log(error);
        this.navigate(pages.error);
      });
    }
    else{
      pushEventToDataLayerGTM('searchMalkars', this.searchForm.controls[this.searchWordControlName].value);
      this.navigate([pages.searchMalkars, this.searchForm.controls[this.searchWordControlName].value || '']).then(res => res, error => {
        console.log(error);
        this.navigate([pages.error]);
      });
    }
  }

  searchItemSelected(ev){
    if (ev && ev.value){
      if(_.isArray(ev.value)){
        this.navigate(ev.value);
      }
      else{
        this.navigate(ev.value.split('/'));
      }
    }
  }

  navigate(link){
    return this.router.navigate(link);
  }

  menuClicked(event){
    let prevItem = _.find(this.menuItems, {'isCurrent': true});
    if (prevItem){
      prevItem.isCurrent = false;
    }
    event.isCurrent = true;
    let hamburgerMenu = document.getElementById('hamburger-menu');
    hamburgerMenu.classList.remove('menu-open');
    hamburgerMenu.classList.remove('menu-closed');
  }

  hamburgerClicked(){
    if (this.hamburgerActive){
      this.hamburgerActive = false;
    }
    else{
      this.hamburgerActive = true;
    }
  }

  searchIconClicked(event){
    let searchIcon = document.getElementById('search-icon-container-green');
    let searchBar = document.getElementById('header-search-bar');
    if (this.showSearch){
      searchBar.style.setProperty('display', 'flex');// .classList.remove('sps--blw');
      this.showSearch = false;
    }
    else{
      searchBar.style.setProperty('display', 'none');//.classList.add('sps--blw');
      this.showSearch = true;
    }
    this.closeDialogs();
  }

  hideMobileSearch(){
    let searchBar = document.getElementById('header-search-bar');
    if (_.startsWith(this.location.path(), '/' + pages.home)){
      searchBar.style.setProperty('display', 'none');
      this.showSearch = true;
    }
    else{
      if (window.innerWidth <= 640){
        searchBar.style.setProperty('display', 'none');
        this.showSearch = true;
      }
      else{
        searchBar.style.setProperty('display', 'flex');
        this.showSearch = false;
      }
    }
  }

  callFunction(event){
    let funcName = event.target.getAttribute('functionname');
    if (funcName && this[funcName]){
      this[funcName]();
    }
  }

  closePopover(){
    jQuery('[data-toggle="popover"]').popover('hide');
  }

  contrastClicked(){
    let htmlElem = <HTMLElement> document.getElementsByTagName('html')[0];
    this.renderer.addClass(htmlElem, 'high-contrast');
  }

  fontClicked(){
    let htmlElem = <HTMLElement> document.getElementsByTagName('html')[0];
    this.renderer.addClass(htmlElem, 'large-font');
  }

  colorsClicked(){
    this.commonService.getGraphColors(AppParams.graphColorsAccessible);
  }
  
  resetAccessibilityClicked(){
    let htmlElem = <HTMLElement> document.getElementsByTagName('html')[0];
    this.renderer.removeClass(htmlElem, 'high-contrast');
    this.renderer.removeClass(htmlElem, 'large-font');
    this.commonService.getGraphColors(AppParams.graphColorsDefault);
  }

  accessibilityStatementClicked(){
    this.navigate([pages.generic, pages.accessibilityStatement]).then(res => {
      this.closePopover();
    }, 
    error => {
        console.log(error);
        this.navigate(pages.error);
      });
  }

  closeDialogs(){
    // this.closePopover();
    this.hamburgerActive = false;
  }

}
