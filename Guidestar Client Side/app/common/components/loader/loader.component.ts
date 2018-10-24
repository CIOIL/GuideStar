import { Component, OnInit, Input, OnChanges, ChangeDetectionStrategy } from '@angular/core';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';

@Component({
  selector: 'app-loader',
  templateUrl: './loader.component.html',
  styleUrls: ['./loader.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('false', style({
        height: '{{min_height}}',
      }), {params: {min_height: '0'}}),
      state('true', style({
        height: AUTO_STYLE,
      })),
      transition('false <=> true', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LoaderComponent implements OnInit, OnChanges {

  @Input() position: string = 'relative';
  @Input() top: string = 'auto';
  @Input() left: string = 'auto';
  @Input() zIndex: string = 'auto';
  @Input() showLoader: boolean = false;
  @Input() animate: boolean = true;

  constructor() { }

  ngOnInit() {
  }

  ngOnChanges(changes){
  }

}
