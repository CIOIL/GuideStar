import { Component, OnInit, ChangeDetectorRef, ChangeDetectionStrategy } from '@angular/core';
import { MalkarDetailService } from '../malkar-detail.service';
import { CommonService } from '../../common/services/common.service';
import * as _ from 'lodash';
import { VOLUNTEER_PROJECTS } from '../malkar-detail.actions';

@Component({
  selector: 'app-malkar-volunteering',
  templateUrl: './malkar-volunteering.component.html',
  styleUrls: ['./malkar-volunteering.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarVolunteeringComponent implements OnInit {

  $Label: any;
  malkar: any;
  volunteerProjects: any[];
  constructor(private malkarDetailService :MalkarDetailService, private commonService: CommonService, private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
   }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkar = malkar.result;
        if (_.has(malkar, VOLUNTEER_PROJECTS)){
          this.volunteerProjects = malkar[VOLUNTEER_PROJECTS].result;
        }
        this.commonService.setMeta(malkar.result.Name + ' - ' + this.$Label.Volunteering, null);
        this.ref.markForCheck();
      }
    );
  }

  getLabelValueStyle(){
    return {'margin' : '0 0 0.3em 0'};
  }

}
