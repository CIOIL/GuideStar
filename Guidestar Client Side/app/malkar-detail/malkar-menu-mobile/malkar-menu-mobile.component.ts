import { Component, OnInit, Input, HostListener, OnDestroy, ChangeDetectionStrategy } from '@angular/core';
import { malkarPages } from '../malkar-detail.pages';
import { Location } from '@angular/common';
import * as _ from 'lodash';
import { pages } from '../../../environments/pages';
import { MalkarDetailService } from '../malkar-detail.service';
import { Subscription } from 'rxjs';
import { Router, NavigationEnd } from '@angular/router';

@Component({
  selector: 'app-malkar-menu-mobile',
  templateUrl: './malkar-menu-mobile.component.html',
  styleUrls: ['./malkar-menu-mobile.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarMenuMobileComponent implements OnInit, OnDestroy {

  @HostListener('window:resize', ['$event']) 
  onResize(event){
    let path = this.location.path();
    let locId = path.substr(path.lastIndexOf('/')+1);
    this.showComponent(locId);
  };

  showMap: any = {
    info: {show: false},
    documents: {show: false}, 
    people: {show: false}, 
    govsupport: {show: false}, 
    donations: {show: false}, 
    govservices: {show: false}, 
    contact: {show: false},
    volunteering: {show: false},
    assets: {show: false},
    trustees: {show: false}
  };
  
  currentItem: any;
  $Label: any;
  pages: any;
  malkarPages: any;
  subs: Subscription[] = [];

  private _malkarNum: string;
  get malkarNum(): string {return this._malkarNum};
  @Input() set malkarNum(newmalkarNum: string){
    this._malkarNum = newmalkarNum;
    this.openMenu();
  }

  private _menuItemHideMap: any;
  get menuItemHideMap(): any {return this._menuItemHideMap};
  @Input() set menuItemHideMap(newmenuItemHideMap: any){
    _.forEach(_.keys(newmenuItemHideMap), key => {
      if(_.has(this.showMap, key)){
          this.showMap[key].isHidden = newmenuItemHideMap[key] ? true : false;
      }
    });
  }

  constructor(private location: Location, private malkarService: MalkarDetailService, private router: Router) { 
    this.$Label = window['$Label'];
    this.pages = pages;
    this.malkarPages = malkarPages;
    this.subs.push(router.events.subscribe(event => {
      if(event instanceof NavigationEnd) {
        this.openMenu();
      }
    }));
  }

  ngOnInit() {
    // this.openMenu();
  }

  ngOnDestroy(){
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  closeAll(){
    _.forEach(this.showMap, (value, key) => {
      value.show = false;
    });
  }

  openMenu(){
    this.closeAll();
    let path = this.location.path();
    let locId: string;
    if (path.includes(';')){
      locId = path.slice(path.lastIndexOf('/')+1, path.lastIndexOf(';'));
    }
    else{
      locId = path.substr(path.lastIndexOf('/')+1);
    }
    if (!isNaN(Number(locId))){
      locId = this.malkarPages.info;
    }
    this.showComponent(locId);
  }

  menuClicked(ev, item){
    this.malkarService.resolveData(this.malkarNum, item, false);
    this.toggleComponent(item);
    ev.target.blur();    
  }

  enterHit(ev, item){
    ev.target.click();
  }

  showComponent(item: string){
    if(item){
      if(this.showMap[item]){
        this.showMap[item].show = true;
      }
    }
  }

  toggleComponent(item: string){
    if(item){
      if(this.showMap[item]){
        this.showMap[item].show = !this.showMap[item].show;
      }
    }
  }
}
