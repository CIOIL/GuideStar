import { Component, Input, OnInit, ChangeDetectionStrategy } from '@angular/core';
import { NgClass } from '@angular/common';

@Component({
  selector: 'app-label-value',
  templateUrl: './label-value.component.html',
  styleUrls: ['./label-value.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LabelValueComponent implements OnInit {

  @Input() label: string;
  @Input() value: string;
  @Input() separator: string;
  @Input() isCurrency: boolean;
  @Input() isNumber: boolean;
  @Input() isEmail: boolean;
  @Input() isDate: boolean;
  @Input() valueClass: string;
  @Input() labelClass: string;
  @Input() customStyle: any;
  @Input() addendum: string;
  @Input() ariaLevel: string;
  @Input() tooltip: string;
  @Input() tooltipPosition: string = 'top';

  constructor() { 
    this.separator = this.separator? this.separator: ':';
  }

  ngOnInit() {
  }

  getLabelClasses(){
    let classList = 'label-value-label ';
    if (this.labelClass){
      classList += this.labelClass;
    }
    return classList;
  }

  getValueClasses(){
    let classList = 'label-value-value '
    if (this.valueClass){
      classList += this.valueClass;
    }
    return classList;
  }

  getSeparatorClass(){
    return this.getLabelClasses() + ' label-value-separator';
  }

  getEmailLink(){
    return 'mailto:'+this.value;
  }

}
