import { Component, OnInit, Input, OnChanges, SimpleChanges, ChangeDetectionStrategy } from '@angular/core';
import { trigger, state, style, transition, animate, keyframes } from '@angular/animations';

@Component({
  selector: 'app-chevron',
  templateUrl: './chevron.component.html',
  styleUrls: ['./chevron.component.scss']
  ,
  animations: [
    trigger('rotateChevron',[
      state('inactive', style({
        transform: 'rotate(0deg)'
      })),
      state('active', style({
        transform: 'rotate(-90deg)'
      })),
      transition('inactive => active', animate('0.5s ease')),
      transition('active => inactive', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ChevronComponent implements OnChanges {

  @Input() clicked: Boolean;
  @Input() styles: any;
  @Input() state: string = 'inactive';
  constructor() { }

  // ngOnInit(){
  //   if (this.clicked){
  //     this.toggleRotate();
  //   }
  // }

  ngOnChanges(changes: SimpleChanges){
    // if(this.clicked){
    if(changes['clicked'] && changes['clicked'].currentValue != undefined){
      this.state = this.state === 'active' ? 'inactive' : 'active';
    }
  }

  // toggleRotate(){
  //   console.log('Chevron clicked! state: '+this.state);
  //   this.state = this.state === 'active' ? 'inactive' : 'active';
  //   console.log(this.state);
  // }

}
