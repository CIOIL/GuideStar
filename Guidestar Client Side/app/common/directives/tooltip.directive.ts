import { Directive, Input, ElementRef, HostListener, OnInit, SimpleChanges } from '@angular/core';

@Directive({
  selector: '[tooltip]'
})
export class TooltipDirective  implements OnInit{

  @Input('tooltip') tooltipText;
  
  @HostListener('mouseover', ['$event'])
  handleMouseover(event: Event) {
    // setTimeout(() => alert(event) , 0);
    // alert(event);
    if (this.el.nativeElement.contains(event.target)) {
      // this.activatePopover($event);
    }
  }
  @HostListener('mouseout', ['$event'])
  handleMouseout(event: Event) {
    // setTimeout(() => alert(event) , 0);
    // alert(event);
    if (this.el.nativeElement.contains(event.target)) {
      // this.deactivatePopover($event);
    }
  }

  constructor(public el: ElementRef) { }

  ngOnInit(){

  }

  ngOnChanges(changes: SimpleChanges){
    if(changes['tooltipText']){
        //this.setTextFormatted(this.keyWord , this.el.nativeElement.innerText ); 
    }
  }

  ngAfterViewInit(){
    // this.setTextFormatted(this.keyWord , this.el.nativeElement.innerText );
  }
}
