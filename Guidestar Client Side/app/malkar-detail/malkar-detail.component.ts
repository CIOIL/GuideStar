
import { Component, OnInit, ViewContainerRef, HostListener, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Params, Router, NavigationStart, NavigationEnd, UrlSegment } from '@angular/router';
import { Location }                 from '@angular/common';
import { MalkarDetailService } from './malkar-detail.service';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../common/utils/utils';
import * as _ from 'lodash';
import { malkarPages } from './malkar-detail.pages';
import { pages } from '../../environments/pages';
import { Title, Meta } from '@angular/platform-browser';
import { CommonService } from '../common/services/common.service';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-malkar-detail', 
  templateUrl: './malkar-detail.component.html',
  styleUrls: ['./malkar-detail.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})

export class MalkarDetailComponent implements OnInit {

  // @HostListener('window:scroll', ['$event']) 
  // onScroll(event){
  //   console.log(event);
  // };

  // @HostListener('document:wheel', ['$event'])
  // onWheel(event){
  //   this.scrollBetweenPages(event)   ;
  // }
  $Label: any;
  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;

  public malkar: any;
  subParam: any;
  private _malkarNum: string;
  get malkarNum(): string {return this._malkarNum};
  set malkarNum(newMalkarNum: string){
    if(this._malkarNum !== newMalkarNum){
      this._malkarNum = newMalkarNum;
      this.malkarDetailService.getMalkarDetails(this._malkarNum);
      this.malkarDetailService.resetMalkarPeople(this._malkarNum);
    }
  }
  routerPath: string;

  private menuItems: Array<string> = ['info', 'documents', 'govsupport', 'govservices', 'donations', 'people', 'contact'];
  constructor(private malkarDetailService :MalkarDetailService,
              // private generalService :GeneralService,
              public vRef: ViewContainerRef,
              private route: ActivatedRoute,
              private location: Location,
              private router: Router,
              private commonService: CommonService, 
              private ref: ChangeDetectorRef) 
  {
    this.$Label = window['$Label'];
    this.commonService.setMeta(this.$Label.Site_Title, this.$Label.Description_Home);
    
    
    /*
    router.events.subscribe(event => {
      if(event instanceof NavigationEnd) {
        if(event && event.url){
          let urlSegments = _.split(event.url, '/').filter(n => n);
          if(urlSegments.length >= 3 && urlSegments[0] === pages.malkar){
            this.malkarNum = urlSegments[1];
            if(urlSegments[2] === people){
              Promise.all([this.malkarDetailService.getMalkarConnected(this.malkarNum),
                          this.malkarDetailService.getMalkarWageEarners(this.malkarNum)]);
            }
          }
        }
      }
    });
    */
  }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkar = malkar.result;
        this.setMeta();
        this.ref.markForCheck();
      });
    this.loadMalkar();
  }

  setMeta(){
    let title = this.$Label.Site_Title;
    if (this.malkar && this.malkar.Name){
      title = this.malkar.Name + ' | '+ title;
    }
    let description = this.malkar && this.malkar.orgGoal ? this.$Label.MalkarDescriptionPrefix + ' ' + this.malkar.orgGoal : this.$Label.Description_Home;
    this.commonService.setMeta(title, description);
  }

  loadMalkar(event = {}){
    this.subParam = this.route.params.pipe(switchMap((params: Params) => {
                                          this.malkarNum = params['num'];
                                          this.ref.markForCheck();
                                          return Promise.resolve();//this.malkarDetailService.getMalkarDetails(this.malkarNum);
                                        }))
                                      .subscribe((...args) => args); 
  }

  scrollBetweenPages(event){
    let windowHeight = "innerHeight" in window ? window.innerHeight : document.documentElement.offsetHeight;
    let body = document.body, html = document.documentElement;
    let docHeight = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
    let windowBottom = windowHeight + window.pageYOffset;
    let direction = event.deltaY > 0 ? 'down' : 'up';
    let path = this.location.path();
    let menuIndex = this.menuItems.indexOf(path.substr(path.lastIndexOf('/')+1));
    if (direction === 'down' && windowBottom >= docHeight) {
      if (this.menuItems.length > menuIndex){
        this.router.navigate(['/', pages.malkar, this.malkarNum , this.menuItems[menuIndex+1]]);
      }
    }
    else if(direction === 'up' && window.pageYOffset == 0){
      if (menuIndex != 0){
        this.router.navigate(['/', pages.malkar, this.malkarNum , this.menuItems[menuIndex-1]]);
      }
      else{
        this.router.navigate(['/', pages.malkar, this.malkarNum , this.menuItems[this.menuItems.length-1]]);   
      }
    } 
  }

}
