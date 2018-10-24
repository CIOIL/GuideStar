import { Component, OnInit, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonService } from '../../services/common.service';
import { Subscription } from 'rxjs';
import { ContentPosition } from '../../enums/content-position';
import { pages } from '../../../../environments/pages';
import * as _ from 'lodash';
import { AppParams } from '../../enums/app-params';

@Component({
  selector: 'app-default-template',
  templateUrl: './default-template.component.html',
  styleUrls: ['./default-template.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DefaultTemplateComponent implements OnInit, OnDestroy {

  pageParams: Subscription;
  pageName: string;
  sideContent : any;
  mainContent : any;
  mainContentBody: string[] = [];

  $Label: any;

  constructor(private commonService: CommonService, private route: ActivatedRoute, private router: Router, private ref: ChangeDetectorRef) { 
    this.$Label = window['$Label'];
    this.commonService.setMeta(this.$Label.Site_Title, this.$Label.Description_Home);
    this.pageParams = this.route.params.subscribe(o => {
      this.pageName = o['pageName'];
      this.getWebsiteContent();    
      this.ref.markForCheck();  
    });
  }

  ngOnInit() {
  }

  ngOnDestroy(){
    this.pageParams.unsubscribe();
  }

  async getWebsiteContent(){
    let websiteContent = await Promise.all([this.commonService.getWebsiteContent(this.pageName, ContentPosition.Side, AppParams.App),
                                            this.commonService.getWebsiteContent(this.pageName, ContentPosition.Main, AppParams.App)]);
    this.sideContent = websiteContent[0]; 
    this.mainContent = websiteContent[1];
    if (this.mainContent && this.mainContent[0]){
      this.commonService.setMeta(this.mainContent[0].Title /*+ ' | ' + this.$Label.Site_Title*/, this.mainContent[0].Description);
      this.prepareStyles();
    }
    else{
      this.router.navigate([pages.error]);
    }
    this.ref.markForCheck();
  }

  prepareStyles(){
    this.mainContentBody = [];
    for (let i=0; i<this.mainContent.length; i++){
      let tempContent = _.replace(this.mainContent[i].Body, /<img/g, '<img style="max-width: 100%; width: auto; height: auto; border: 1px solid #b2cbcd; padding: 0.8em;"');
      tempContent = _.replace(tempContent, /<ul/g, '<ul style="padding-right: 40px;"');
      this.mainContentBody.push(tempContent)
    }
  }

}
