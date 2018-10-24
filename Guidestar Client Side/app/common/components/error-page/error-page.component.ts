import { Component, OnInit, OnDestroy, Input, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { Observable ,  Subscription, timer } from 'rxjs';
import { take, map, finalize } from 'rxjs/operators';
import { Router } from '@angular/router';
import { CommonService } from '../../services/common.service';
import { ContentPosition } from '../../enums/content-position';
import { AppParams } from '../../enums/app-params';

@Component({
  selector: 'app-error-page',
  templateUrl: './error-page.component.html',
  styleUrls: ['./error-page.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ErrorPageComponent implements OnInit {

  @Input() counter = AppParams.CountdownTimer;

  countDown: Observable<number>;
  $Label: any;
  sideContent : any;
  mainContent : any;

  countdownSub: Subscription;

  constructor(private router: Router, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
    if(!this.mainContent && !this.sideContent){
      this.getWebsiteContent();
    } 
    this.countDown = timer(0, 1000)
      .pipe(take(this.counter),
            map(() => --this.counter),
            finalize(() => this.router.navigate(['home'])));
  }

  ngOnInit() {
  }

  async getWebsiteContent(){
    let websiteContent = await Promise.all([this.commonService.getWebsiteContent('error', ContentPosition.Side, AppParams.App),
                                            this.commonService.getWebsiteContent('error', ContentPosition.Main, AppParams.App)]);
    this.sideContent = websiteContent[0]; 
    this.mainContent = websiteContent[1];
    this.ref.markForCheck();
  }

}
