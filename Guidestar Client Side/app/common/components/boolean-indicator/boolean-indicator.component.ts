import { Component, OnInit, Input, ChangeDetectionStrategy } from '@angular/core';
import { getBackgroundImageObject, getBackgroundImageUrl } from '../../utils/utils';

@Component({
  selector: 'app-boolean-indicator',
  templateUrl: './boolean-indicator.component.html',
  styleUrls: ['./boolean-indicator.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class BooleanIndicatorComponent implements OnInit {

  public getBackgroundImageObject = getBackgroundImageObject;
  public getBackgroundImageUrl = getBackgroundImageUrl;
  @Input() icoChecked: string = 'assets/img/icons/docs-existing-icon-mobile.png';
  @Input() icoUnchecked: string = 'assets/img/icons/docs-missing-icon-mobile.png';
  @Input() label: string;
  @Input() titleText: string;
  @Input() tooltipPosition: string = 'top';
  @Input() isChecked: boolean;
  @Input() customStyle: any;

  $Label: any;
  constructor() { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
  }

}
