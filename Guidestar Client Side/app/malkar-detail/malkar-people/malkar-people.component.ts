import { Component, OnInit, Input, OnDestroy, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { MalkarDetailService } from '../malkar-detail.service';
import { malkarPages } from '../malkar-detail.pages';
import { ActivatedRoute, Params, Router, NavigationStart } from '@angular/router';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';
import * as _ from 'lodash';
import { Subscription } from 'rxjs';
import { pages } from '../../../environments/pages';
import { AppParams } from '../../common/enums/app-params';
import { CommonService } from '../../common/services/common.service';

@Component({
  selector: 'app-malkar-people',
  templateUrl: './malkar-people.component.html',
  styleUrls: ['./malkar-people.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('collapsed, void', style({
        height: '6.8em'
      })),
      state('expanded', style({
        height: AUTO_STYLE
      })),
      transition('collapsed <=> expanded', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarPeopleComponent implements OnInit, OnDestroy{

  malkarPeoples : any = {};
  malkarConnected : any = {};
  malkarWageEarners : any = {};
  malkar : any = {};
  subParam: any;
  malkarNum : string;
  googleRecaptchaPublicKey : AppParams = AppParams.GoogleRecaptchaPublicKey;
  needRecaptchPeople: boolean = true;

  peopleGroups: any[];
  peopleGroupMap: any = {};
  peopleGroupsContainsData: boolean = false;
  // peoplestate: string ='collapsed';
  peoplestate: any = {};
  orgsState: string = 'collapsed';
  // showPeopleCollapse: boolean = true;
  showPeopleCollapse: any = {};
  showOrgCollapse: boolean = true;
  // mobileShowPeopleCollapse: boolean = true;
  mobileShowPeopleCollapse: any = {};
  mobileShowOrgCollapse: boolean = true;
  minNumCollapseDesktop : number = 21;
  minNumCollapseMobile : number = 6;
  foundersList: string[];

  malkarSub: Subscription;
  pageParams: Subscription;
  wageEarnersYear: string;
  wageEarnersExpandLabel: string;
  

  $Label: any;
  pages: any;
  malkarPages: any;

  constructor(private malkarDetailService :MalkarDetailService, public route: ActivatedRoute, private commonService: CommonService, private ref: ChangeDetectorRef) { 
    this.$Label = window['$Label'];
    this.pages = pages;
    this.malkarPages = malkarPages;
  }

  ngOnInit() {
    this.malkarSub = this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.commonService.setMeta(malkar.result.Name + ' - ' + this.$Label.Malkar_people /*+ ' | ' + this.$Label.Site_Title*/, null);
        this.showOrgCollapse = true;
        this.orgsState = 'collapsed';
        this.mobileShowOrgCollapse = true;
        this.malkar = malkar.result; 
        this.malkarPeoples = malkar[malkarPages.people];
        // if (_.has(this.malkarPeoples, 'DataMap')){
        //   this.flattenPeopleList(this.malkarPeoples);
        // }
        // else{
          this.managePeopleLists();
        // }
        if(_.has(malkar,'people')){
          this.needRecaptchPeople = false;
        }
        else{
          this.needRecaptchPeople = true;
        }

        if(_.has(this.malkar, 'founderNames')){
          this.foundersList = _.split(this.malkar.founderNames, '\n');
        }
        else{
          this.foundersList = [];
        }
        this.malkarConnected = malkar[malkarPages.connected];
        if (this.malkarConnected){
          if (_.has(malkar, 'connected') && (!this.malkarConnected.malkarsByContact || !this.malkarConnected.malkarsByContact.Data || this.malkarConnected.malkarsByContact.Data.length < this.minNumCollapseDesktop)){
            this.showOrgCollapse = false;
            this.orgsState = 'expanded';
            if (!this.malkarConnected.malkarsByContact || !this.malkarConnected.malkarsByContact.Data || this.malkarConnected.malkarsByContact.Data.length < this.minNumCollapseMobile){
              this.mobileShowOrgCollapse = false;
            }
          }
        }
        this.malkarWageEarners = malkar[malkarPages.wageearners];
        this.ref.markForCheck();
      }
    );
     this.pageParams = this.route.params.subscribe(o => {
       this.wageEarnersYear = o['year'];
       if (this.wageEarnersYear){
         this.findWageEarnerYear();
       }
       this.ref.markForCheck();
     });
  }

  ngOnDestroy(){
    this.malkarSub.unsubscribe();
    this.pageParams.unsubscribe();
  }

  handleCorrectCaptcha(event){
    if(event && this.malkar){
      this.malkarDetailService.getMalkarPeople(this.malkar.regNum, event);
    }
  }

  flattenPeopleList(item: any, key: string): any[]{
    if (!this.peoplestate[key]){
      this.peoplestate[key] = 'collapsed';
    }
    if (!this.showPeopleCollapse[key]){
      this.showPeopleCollapse[key] = true;
    }if (!this.mobileShowPeopleCollapse[key]){
      this.mobileShowPeopleCollapse[key] = true;
    }
    let peopleList = [];
    if(item && item.DataMap){
      let temp = _.values(item.DataMap);
      for (let i=0; i< temp.length; i++){
        _.forEach(temp[i].Data, x => peopleList.push(x));
      }
      if (peopleList.length < this.minNumCollapseDesktop){
        this.showPeopleCollapse[key] = false;
        this.peoplestate[key] = 'expanded';
        if (peopleList.length < this.minNumCollapseMobile){
          this.mobileShowPeopleCollapse[key] = false;
        }
      }
    }
    return peopleList;
  }

  managePeopleLists(){
    if (this.malkarPeoples){
      this.peopleGroups = Object.keys(this.malkarPeoples);
      for (let group of this.peopleGroups){
        this.peopleGroupMap[group] = this.flattenPeopleList(this.malkarPeoples[group], group);
        if(!_.isEmpty(this.peopleGroupMap[group])){
          this.peopleGroupsContainsData = true;
        }
      }
    }
  }

  showPeopleGroup(group: string):boolean{
    return this.peopleGroupMap[group] && this.peopleGroupMap[group].length > 0
  }

  showExpandButton(group: string, mobile: boolean): boolean{
    if (!group){
      return false;
    }
    if (mobile){
      return this.mobileShowPeopleCollapse[group] && !this.needRecaptchPeople && this.peopleGroupMap[group] && this.peopleGroupMap[group].length > 0;
    }
    else{
      return this.showPeopleCollapse[group] && !this.needRecaptchPeople && this.peopleGroupMap[group] && this.peopleGroupMap[group].length > 0;
    }
  }

  toggleExpandView(peopleGroup){
    if (peopleGroup){
      this.peoplestate[peopleGroup] = this.peoplestate[peopleGroup] === 'expanded' ? 'collapsed' : 'expanded';
    }
    else{
      this.orgsState = this.orgsState === 'expanded' ? 'collapsed' : 'expanded';
    }
  }

  findWageEarnerYear(){
    if (!this.wageEarnersYear){
      return;
    }
    let wageEarnersTitles = _.map(this.malkarWageEarners, x => x.Label);
    _.forEach(wageEarnersTitles, item => {
      if (_.includes(item, this.wageEarnersYear)){
        this.wageEarnersExpandLabel = item;
      }
    });
  }

}
