import { Directive, Input, ElementRef, HostListener, OnInit, SimpleChanges } from '@angular/core';
import * as _ from 'lodash';

@Directive({
  selector: '[appMarker]'
})
export class MarkerDirective implements OnInit {

  @Input('appMarker') keyWord;
  @Input('appMarkerPrefixHtml') prefixHtml = '<b>';
  @Input('appMarkerSuffixHtml') suffixHtml = '</b>';
  constructor(public el: ElementRef) {}

  ngOnInit(){
  }

  ngOnChanges(changes: SimpleChanges){
    if(changes['keyWord']){
        this.setTextFormatted(this.keyWord , this.el.nativeElement.innerText ); 
    }
  }

  ngAfterViewInit(){
    this.setTextFormatted(this.keyWord , this.el.nativeElement.innerText );
  }

  setTextFormatted(search:string, text:string){ 
    if (!this.keyWord) {
      this.el.nativeElement.innerHTML = text;
      return;
    }

    // console.info('innerText Onchange = ' + this.el.nativeElement.innerText);
    let newHtmlText = text;
    let strings = _.words(search);
    _.forEach(strings, str =>{
      let reg = new RegExp(str, 'gi');
      newHtmlText = newHtmlText.replace(reg, this.prefixHtml + str + this.suffixHtml);
    });
    this.el.nativeElement.innerHTML = newHtmlText;
  }
}