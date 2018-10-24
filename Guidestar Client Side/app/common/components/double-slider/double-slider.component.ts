import { Component, Input, ViewChild, ElementRef, AfterViewInit, ViewEncapsulation, Renderer2, SimpleChanges, OnChanges, OnDestroy, ChangeDetectionStrategy } from '@angular/core';
import * as Slider from 'bootstrap-slider';
import { FormGroup } from '@angular/forms';
import { Subscription } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import * as _ from 'lodash';
import { pushEventToDataLayerGTM } from '../../utils/utils';

@Component({
  selector: 'app-double-slider',
  templateUrl: './double-slider.component.html',
  styleUrls: ['./double-slider.component.scss'],
  encapsulation:ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DoubleSliderComponent implements AfterViewInit, OnDestroy{
  
  @ViewChild('doubleSliderContainer') doubleSliderContainer: any;
  @ViewChild('sliderInput') sliderInput: any;

  @Input() minValue: any = 0;
  @Input() maxValue: any = 100;
  @Input() labelValues: any[];
  @Input() rangeValues: number[]; 
  @Input() sliderId: string;
  @Input() lowValue: any;
  @Input() highValue: any;

  @Input() controlName: string;
  @Input() parentFormGroup: FormGroup;

  currentValues: any;  
  displayValues: any[] = [];
  popoverValues: any[] = [];
  lowHandle: any;
  highHandle: any;
  $Label: any;

  private parentFormSub: Subscription;

  slider: Slider;
  
  constructor(private renderer: Renderer2) {
    this.$Label = window['$Label'];
  }

  ngOnDestroy(){
    this.parentFormSub.unsubscribe();
  }

  ngAfterViewInit() {
    if (this.parentFormGroup && this.controlName){
      this.parentFormSub = this.parentFormGroup.controls[this.controlName].valueChanges.pipe(debounceTime(200)).subscribe((o : any) => {
        if (o == null){
          this.currentValues = [this.minValue, this.maxValue];
          this.slider.setValue(this.currentValues, true, true);
          this.parentFormGroup.controls[this.controlName].setValue([]);
        }
        else if (o.length > 0){
          this.setInitialHandleValues(o[0], o[1]);
          setTimeout(() => pushEventToDataLayerGTM('doubleSlider', {label: this.controlName, value: o, id:this.sliderId}), 100);
        }
      });
    }
    this.buildSliders();
    let sliderHandles = document.getElementsByClassName('slider-handle');
    if (sliderHandles && sliderHandles.length > 0){
      _.forEach(sliderHandles, x => {
        this.renderer.setAttribute(x, 'aria-label', this.$Label.Double_slider_text);
      });
    }
    if (this.lowValue || this.highValue){
      this.setInitialHandleValues(this.lowValue, this.highValue);
    }
  }

  buildSliders(){
    if (this.labelValues){
      this.minValue = 0;
      this.maxValue = this.labelValues.length-1;
    }
    this.rangeValues = [this.minValue, this.maxValue];
    this.currentValues = [... this.rangeValues];
    this.displayValues[0] = [this.labelValues[0].label || this.minValue];
    this.displayValues[1] = [this.labelValues[this.labelValues.length-1].label || this.maxValue];
    this.popoverValues[0] = this.labelValues[0].tooltip || '';
    this.popoverValues[1] = this.labelValues[this.labelValues.length-1].tooltip || '';
    this.slider = new Slider('#'+this.sliderId, {
      value: this.currentValues,
      step: 1, //50000, //(this.maxValue - this.minValue) / 20 ,
      min: this.minValue,
      max: this.maxValue,
      scale: 'linear'//'logarithmic' // 'linear'
    });
    this.slider.on('change', (o) => this.handleMoved(o));
    this.lowHandle = this.doubleSliderContainer.nativeElement.firstElementChild.children[4];
    this.highHandle = this.doubleSliderContainer.nativeElement.firstElementChild.children[5];
    this.displayHandleValue(this.createHandleValue(true), this.lowHandle);
    this.displayHandleValue(this.createHandleValue(false), this.highHandle); 
  }

  handleMoved(value){
    if (!_.isEqual(value.newValue, value.oldValue)){
      if (value.newValue){
        if (this.labelValues){
          this.displayValues[0] = this.labelValues[value.newValue[0]].label || this.labelValues[value.oldValue[0]].label;
          this.displayValues[1] = this.labelValues[value.newValue[1]].label || this.labelValues[value.oldValue[1]].label;
          this.popoverValues[0] = this.labelValues[value.newValue[0]].tooltip || '';
          this.popoverValues[1] = this.labelValues[value.newValue[1]].tooltip || '';
          let tempValues = [];
          tempValues[0] = this.labelValues[value.newValue[0]].value || /*this.labelValues[value.oldValue[0]].value ||*/ null;
          tempValues[1] = this.labelValues[value.newValue[1]].value || /*this.labelValues[value.oldValue[1]].value ||*/ null;
          this.parentFormGroup.controls[this.controlName].reset(tempValues);
        }
        else{
          this.currentValues = value.newValue;
          this.parentFormGroup.controls[this.controlName].reset(this.currentValues);
        }
      }
      else{
        if (this.labelValues){
          this.currentValues[0] = this.labelValues[value[0]].value || null;
          this.currentValues[1] = this.labelValues[value[1]].value || null;
        }
        else{
          this.currentValues = value;      
        }
      }
      this.displayHandleValue(this.createHandleValue(true), this.lowHandle, false);
      this.displayHandleValue(this.createHandleValue(false), this.highHandle, false); 
    }
  }

  createHandleValue(lowValue: boolean){
    let valueDiv = this.renderer.createElement('div');
    let text: string;
    if (lowValue){
      text = this.renderer.createText(String(this.displayValues[0] || this.currentValues[0] ));
    }
    else{
      text = this.renderer.createText(String(this.displayValues[1] || this.currentValues[1] ));
    }
    this.renderer.appendChild(valueDiv, text);
    this.renderer.addClass(valueDiv, 'double-slider-handle-value');
    // this.renderer.setAttribute(valueDiv, 'aria-label', this.$Label.Double_slider_text);
    this.createPopover(valueDiv, lowValue);
    // this.renderer.setAttribute(valueDiv, 'aria-live', 'off');
    // this.renderer.setAttribute(valueDiv, 'role', 'option');
    // this.renderer.setAttribute(valueDiv, 'aria-atomic', 'true');
    return valueDiv;
  }

  displayHandleValue(valueDiv: any, parentHandle: any, init:boolean = true){
    if (!init){
      this.renderer.removeChild(parentHandle, parentHandle.firstElementChild);
    }
    this.renderer.appendChild(parentHandle, valueDiv);      
  }

  setInitialHandleValues(initLow, initHigh){
    let tempValues = [this.minValue, this.maxValue];
    if (this.labelValues){
      let temp = _.findIndex(this.labelValues, x => x.value == initLow);
      let newLow = initLow != null ? temp : this.minValue;
      temp = _.findIndex(this.labelValues, x => x.value == initHigh);
      let newHigh = initHigh != null ? temp : this.maxValue;
      tempValues = [newLow, newHigh];
      this.slider.setValue(tempValues, true, true);
    }
  }

  createPopover(parent: any, low: boolean){
    if (low){
      if (!this.popoverValues[0]){
        return;
      }
    }
    else{
      if (!this.popoverValues[1]){
        return;
      }
    }
    this.renderer.listen(parent, 'mouseover', (event) => this.activatePopover(event));
    this.renderer.listen(parent, 'mouseout', (event) => this.deactivatePopover(event));
    let popoverDiv = this.renderer.createElement('div');
    // this.renderer.appendChild(popoverDiv,  this.renderer.createText('Popover!'));
    this.renderer.addClass(popoverDiv, 'custom-popover');
    this.renderer.setStyle(popoverDiv, 'z-index', 1);
    if (low){
      this.renderer.appendChild(popoverDiv,  this.renderer.createText(this.popoverValues[0]));      
      this.renderer.addClass(popoverDiv, 'custom-popover-right');
    }
    else{
      this.renderer.appendChild(popoverDiv,  this.renderer.createText(this.popoverValues[1]));
      this.renderer.addClass(popoverDiv, 'custom-popover-left');
    }
    this.renderer.appendChild(parent, popoverDiv);
  }

  activatePopover(ev){
    ev.currentTarget.firstElementChild.style.setProperty('display', 'block');
  }

  deactivatePopover(ev){
    ev.currentTarget.firstElementChild.style.setProperty('display', 'none');
  }

}
