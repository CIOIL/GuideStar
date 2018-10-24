import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { MalkarDocuments } from './MalkarDocuments';
import { MalkarDetailService } from '../malkar-detail.service';
import { malkarPages } from '../malkar-detail.pages';
// import { routerTransition } from '../malkar-detail.router.animation';
import { CommonService } from '../../common/services/common.service';

@Component({
  selector: 'app-malkar-documents',
  templateUrl: './malkar-documents.component.html',
  styleUrls: ['./malkar-documents.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
  // ,
  // animations: [routerTransition()],
  // host: {'[@routerTransition]': ''}
})
export class MalkarDocumentsComponent implements OnInit {

  malkarDocuments : MalkarDocuments;
  $Label: any;
  constructor(private malkarDetailService :MalkarDetailService, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
   }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkarDocuments = malkar[malkarPages.documents];
        this.commonService.setMeta(malkar.result.Name + ' - ' + this.$Label.Documents_and_Reports /*+ ' | ' + this.$Label.Site_Title*/, null);
        this.ref.markForCheck();
      }
    );
  }

}
