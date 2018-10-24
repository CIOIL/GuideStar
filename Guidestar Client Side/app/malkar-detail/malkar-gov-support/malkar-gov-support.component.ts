import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { malkarPages } from '../malkar-detail.pages';
import { MalkarDetailService } from '../malkar-detail.service';
import { TableByYear } from '../../common/components/data-table/TableByYear';
import { CommonService } from '../../common/services/common.service';

@Component({
  selector: 'app-malkar-gov-support',
  templateUrl: './malkar-gov-support.component.html',
  styleUrls: ['./malkar-gov-support.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarGovSupportComponent implements OnInit {

  malkarGovSupports : TableByYear[] | any;
  $Label: any;
  constructor(private malkarDetailService :MalkarDetailService, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
   }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkarGovSupports = malkar[malkarPages.govsupport];
        this.commonService.setMeta(malkar.result.Name + ' - ' + this.$Label.Government_Support /*+ ' | ' + this.$Label.Site_Title*/, null);
        this.ref.markForCheck();
      }
    );
  }

}
