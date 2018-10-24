import { Component, OnInit, ChangeDetectionStrategy } from '@angular/core';
import { MalkarDetailService } from '../malkar-detail.service';
import { HEKDESH_TRUSTEES } from '../malkar-detail.actions';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-malkar-trustees',
  templateUrl: './malkar-trustees.component.html',
  styleUrls: ['./malkar-trustees.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarTrusteesComponent implements OnInit {

  public trustees$;

  $Label: any;

  constructor(private malkarDetailService :MalkarDetailService) {
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    this.trustees$ = this.malkarDetailService.malkar.pipe(map(state => state[HEKDESH_TRUSTEES]));
  }

}
