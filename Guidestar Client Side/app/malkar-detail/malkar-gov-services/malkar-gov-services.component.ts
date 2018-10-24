import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { TableByYear } from '../../common/components/data-table/TableByYear';
import { MalkarDetailService } from '../malkar-detail.service';
import { malkarPages } from '../malkar-detail.pages';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';
import { CommonService } from '../../common/services/common.service';


@Component({
  selector: 'app-malkar-gov-services',
  templateUrl: './malkar-gov-services.component.html',
  styleUrls: ['./malkar-gov-services.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('collapsed, void', style({
        height: '0px'
      })),
      state('expanded', style({
        height: AUTO_STYLE
      })),
      transition('collapsed <=> expanded', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarGovServicesComponent implements OnInit {

  malkarGovServices : TableByYear[] | any;
  activeKeys: string[];
  currentArray: any[];
  inactiveKeys: string[];

  activeIsCollapsed: Boolean = true;
  activestate: string = 'expanded';
  inactiveIsCollapsed: Boolean = true;
  inactivestate: string = 'expanded';

  $Label: any;

  constructor(private malkarDetailService :MalkarDetailService, private commonService: CommonService, private ref: ChangeDetectorRef) { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    this.malkarDetailService.malkar.subscribe(
      malkar => {
        this.malkarGovServices = malkar[malkarPages.govservices]; 
        this.activeKeys = this.malkarGovServices && this.malkarGovServices.active ? (Object.keys(this.malkarGovServices.active.DataMap)) : [];
        this.inactiveKeys = this.malkarGovServices && this.malkarGovServices.active ? (Object.keys(this.malkarGovServices.inactive.DataMap)) : [];
        this.commonService.setMeta(malkar.result.Name + ' - ' + this.$Label.Government_services /*+ ' | ' + this.$Label.Site_Title*/, null);
        this.ref.markForCheck();
      }
    );
  }

  toggleTableView(active: boolean){
    if (active){
      this.activeIsCollapsed = !this.activeIsCollapsed;
      this.activestate = this.activestate === 'expanded' ? 'collapsed' : 'expanded';
    }
    else{
      this.inactiveIsCollapsed = !this.inactiveIsCollapsed;
      this.inactivestate = this.inactivestate === 'expanded' ? 'collapsed' : 'expanded';
    }
  }

}
