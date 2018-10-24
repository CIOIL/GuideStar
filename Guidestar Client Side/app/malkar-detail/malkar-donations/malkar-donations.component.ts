import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { malkarPages } from '../malkar-detail.pages';
import { MalkarDetailService } from '../malkar-detail.service';
import { TableByYear } from '../../common/components/data-table/TableByYear';
import { CommonService } from '../../common/services/common.service';

@Component({
  selector: 'app-malkar-donations',
  templateUrl: './malkar-donations.component.html',
  styleUrls: ['./malkar-donations.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarDonationsComponent implements OnInit {

  malkarDonations : TableByYear[] | any;
  $Label: any;
  constructor(private malkarDetailService :MalkarDetailService, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
   }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkarDonations = malkar[malkarPages.donations];
        this.commonService.setMeta(malkar.result.Name + ' - ' + this.$Label.Donations /*+ ' | ' + this.$Label.Site_Title*/, null);
        this.ref.markForCheck();
      }
    );
  }

}
