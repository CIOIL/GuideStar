import { Component, OnInit, Input, ViewChild, ElementRef, HostListener, ChangeDetectionStrategy } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { pushEventToDataLayerGTM } from '../../utils/utils';

@Component({
  selector: 'app-checkbox',
  templateUrl: './checkbox.component.html',
  styleUrls: ['./checkbox.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CheckboxComponent implements OnInit{

  @Input() label: string;
  @Input() chckbxId: string;
  @Input() fieldName: string;
  @Input() tooltip: string;
  @Input() tooltipPosition: string = 'left';
  @Input() isChecked: boolean;

  @Input() controlName: string;
  @Input() parentFormGroup: FormGroup;

  @ViewChild('checkboxBox') checkboxBox : ElementRef  ;

  constructor() { 
  }

  ngOnInit() {  }

  checkboxLabelHit(ev){
    this.checkboxBox.nativeElement.click();
    ev.preventDefault();
    this.pushEvent(event.target['checked']);
  }

  onChange(event){
    console.log(this.controlName);
    this.pushEvent(event.target['checked']);
  }
  
  pushEvent(value){
    if(value){
      setTimeout(() => pushEventToDataLayerGTM('checkboxChecked', {label: this.label, value:value , id:this.chckbxId}), 100);
    }
  }

}
