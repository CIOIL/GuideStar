import { Component, OnInit, Input, ChangeDetectionStrategy } from '@angular/core';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../../utils/utils';

declare var jQuery: any;

@Component({
  selector: 'app-info-icon',
  templateUrl: './info-icon.component.html',
  styleUrls: ['./info-icon.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class InfoIconComponent implements OnInit {

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  @Input() label: string;
  @Input() position: string = 'top';
  @Input() icoInfo: string = 'assets/img/icons/info-icon-mobile.png';
  $Label: any;
  isActive: boolean = false;
  constructor() {
    this.$Label = window['$Label'];
   }

  ngOnInit() {
    // jQuery('[data-toggle="tooltip"]').tooltip();
  }

  ngAfterViewInit(){
    jQuery('[data-toggle="tooltip"]').tooltip();
  }

  getLabelClass(){
    let classList = 'custom-popover ';
    switch(this.position){
      case 'top':
      classList += 'custom-popover-top';
      break;
      case 'right':
      classList += 'custom-popover-right';
      break;
      case 'bottom':
      classList += 'custom-popover-bottom';
      break;
      case 'left':
      classList += 'custom-popover-left';
      break;
      default:
      classList += 'custom-popover-top';
    }
    return classList;
  }

  toggleTooltip(ev){
    // jQuery(ev.currentTarget).tooltip('show');
    jQuery(ev.currentTarget.firstElementChild).tooltip('toggle');
  }

  hideTooltip(ev){
    jQuery(ev.currentTarget.firstElementChild).tooltip('hide');
  }

  // activatePopover(ev){
  //   if (ev instanceof MouseEvent && ev.movementX == 0 && ev.movementY == 0){
  //     return;
  //   }
  //   this.isActive = true;
  //   ev.currentTarget.firstElementChild.style.setProperty('display', 'block');
  // }

  // deactivatePopover(ev){
  //   this.isActive = false;
  //   ev.currentTarget.firstElementChild.style.setProperty('display', 'none');
  // }

  // togglePopover(ev){
  //   ev.preventDefault();
  //   if (this.isActive){
  //     this.isActive = false;
  //     ev.currentTarget.firstElementChild.style.setProperty('display', 'none');
  //   }
  //   else{
  //     this.isActive = true;
  //     ev.currentTarget.firstElementChild.style.setProperty('display', 'block');
  //   }
  // }

}
