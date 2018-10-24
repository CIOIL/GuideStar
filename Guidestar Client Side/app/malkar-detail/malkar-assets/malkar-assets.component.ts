import { Component, OnInit, ChangeDetectionStrategy, OnDestroy } from '@angular/core';
import { MalkarDetailService } from '../malkar-detail.service';
import { HEKDESH_MONEY, HEKDESH_REAL_ESTATE, HEKDESH_BELONGINGS } from '../malkar-detail.actions';
import { map } from 'rxjs/operators';
import { Subscription } from 'rxjs';
import * as _ from 'lodash';

@Component({
  selector: 'app-malkar-assets',
  templateUrl: './malkar-assets.component.html',
  styleUrls: ['./malkar-assets.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarAssetsComponent implements OnInit, OnDestroy {

  public realEstates$;
  public belongings$;

  subs: Subscription[] = [];
  malkarData: any;

  $Label: any;

  constructor(private malkarDetailService :MalkarDetailService) {
    this.$Label = window['$Label'];
    this.malkarDetailService.malkar.subscribe(malkar => {
        this.malkarData = malkar.result;
    });
  }

  ngOnInit() {
    this.realEstates$ = this.malkarDetailService.malkar.pipe(map(state => state[HEKDESH_REAL_ESTATE]));
    this.belongings$ = this.malkarDetailService.malkar.pipe(map(state => state[HEKDESH_BELONGINGS]));
  }

  ngOnDestroy(){
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

}
