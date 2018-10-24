import { Component, OnInit, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { TestSupportService } from '../test-support.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { CommonService } from '../../common/services/common.service';
import { ContentPosition } from '../../common/enums/content-position';
import { TEST_SUPPORT_DETAIL } from '../test-support.reducer';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../../common/utils/utils';
import { pages } from '../../../environments/pages';
import * as _ from 'lodash';


@Component({
  selector: 'app-test-support-detail',
  templateUrl: './test-support-detail.component.html',
  styleUrls: ['./test-support-detail.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TestSupportDetailComponent implements OnInit, OnDestroy {

  testSupport: any;
  pageParams: Subscription;
  testSupportSub: Subscription;
  testSupportId: string;

  sideContent: any;

  pdfIcon = 'assets/img/icons/pdf-file-icon-mobile.png';
  docIcon = 'assets/img/icons/doc-file-icon-mobile.png';

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;

  $Label: any;

  constructor(private testSupportService: TestSupportService, 
              private router: Router, 
              private route: ActivatedRoute, 
              private commonService: CommonService, 
              private ref: ChangeDetectorRef) {

    this.$Label = window['$Label'];        
    this.commonService.setMeta(this.$Label.Site_Test_Supports_Title + ' | ' + this.$Label.Site_Title, this.$Label.Description_Test_Supports);

  }

  ngOnInit() {
    this.pageParams = this.route.params.subscribe(o => {
      this.testSupportId = o['str'];
      this.testSupportService.getTestSupportById(this.testSupportId);
      this.testSupportService.getAllTestSupports();
    });
    this.testSupportSub = this.testSupportService.testSupports.subscribe(res => {
      this.testSupport = res.TEST_SUPPORT_DETAIL;
      if (this.testSupport){
        // this.commonService.setMeta(this.$Label.Site_Test_Supports_Title + ' | ' + this.$Label.Site_Title, this.testSupport.SupportName);
        this.commonService.setMeta(this.testSupport.SupportName, this.$Label.TestSupportDescriptionPrefix + ' ' + this.testSupport.Description);
      }
      else if (_.has(res, TEST_SUPPORT_DETAIL)){
        this.router.navigate([pages.error]);
      }
      this.ref.markForCheck();
    });
  }

  ngOnDestroy(){
    if (this.pageParams){
      this.pageParams.unsubscribe();
    }
    if (this.testSupportSub){
      this.testSupportSub.unsubscribe();
    }
  }

  findAllRelated(){
    if (this.testSupport.LinkedTests){
      this.testSupportService.getFilteredTestSupports({OrganType: [this.testSupport.OrganType]}, '');
    }
    this.router.navigate([pages.testSupport]);
  }

  getMoreLabel(){
    let label = this.testSupport.LinkedTests ? this.$Label.All_office_tests : this.$Label.All_tests;
    return label;
  }

}
