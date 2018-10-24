import { Component, OnInit, Input, OnChanges, ChangeDetectionStrategy } from '@angular/core';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../../utils/utils';

@Component({
  selector: 'app-linker',
  templateUrl: './linker.component.html',
  styleUrls: ['./linker.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LinkerComponent implements OnInit, OnChanges {

  @Input() label: string;
  @Input() link: string;
  @Input() type: string;
  @Input() newTab: Boolean;
  @Input() internal: any;

  icon: string;
  $Label: any

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;

  constructor() { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    if (this.type === 'link')
      this.icon = 'assets/img/icons/link-icon-mobile.png';
    else if (this.type === 'pdf')
      this.icon = 'assets/img/icons/pdf-file-icon-mobile.png';
    else if (this.type === 'hidden')
      this.icon = 'assets/img/icons/eye-blacked-file-icon-desktop.png';
    else{
      this.icon = 'assets/img/icons/link-icon-mobile.png';
    }
  }

  ngOnChanges(){
  }

  getTarget(){
    return this.newTab && !this.internal ? '_blank' : '';
  }

  // getIconClasses(){
  //   if (this.type === 'link')
  //     return 'fa fa-arrow-down app-linker-link';
  //   if (this.type === 'pdf')
  //     return 'fa fa-file-pdf-o app-linker-pdf';
  //   if (this.type === 'doc')
  //     return 'fa fa-file-word-o app-linker-doc';
  //   if (this.type === 'excel')
  //     return 'fa fa-file-excel-o app-linker-excel';
  //   if (this.type === 'txt')
  //     return 'fa fa-file-text-o app-linker-txt';
  // }

}
