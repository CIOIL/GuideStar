import { Component, Input, ViewChild, ElementRef, AfterViewInit, ChangeDetectionStrategy, ChangeDetectorRef, AfterViewChecked } from '@angular/core';
import { AUTO_STYLE, trigger, state, style, transition, animate, keyframes } from '@angular/animations';
import * as _ from 'lodash';
import { Observable, Subject, BehaviorSubject } from 'rxjs';

@Component({
  selector: 'long-text',
  templateUrl: './long-text.component.html',
  styleUrls: ['./long-text.component.scss'],
  animations: [
    trigger('expandCollapse',[
      state('collapsed', style({
        height: '{{min_height}}',
      }), {params: {min_height: '4.125em'}}),
      state('expanded', style({
        height: '{{max_height}}',
      }), {params: {max_height: '*'}}),
      transition('collapsed <=> expanded', animate('0.5s ease'))
    ])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LongTextComponent implements AfterViewInit, AfterViewChecked {

  @Input() htmlBody: string;
  @Input() cssClasses: string;
  @Input() minHeight: string = '3em';
  @Input() maxHeight: string = '*';
  @Input() seeAll: boolean = false;
  @Input() notCollapse: boolean = false;
  @Input() showLargeButton: boolean = false;
  @Input() showSmallButton: boolean = false
  @Input() scrollOffset: number = 0;

  @ViewChild('longTextContainer') longTextContainer: ElementRef  ;

  longTextState: string = 'collapsed';
  longTextContainerOffsetHeight: number;
  pixelHeight: number; //Font size in pixels
  isInitiated: boolean = false;
  showButton$ : Subject<boolean> = new BehaviorSubject<boolean>(false);
  $Label: any;
  
  constructor(private ref: ChangeDetectorRef) {
    this.$Label = window['$Label'];
    this.showButton$.next(true);
  }

  ngAfterViewChecked(){
    if (!this.isInitiated && !this.htmlBody && this.longTextContainer.nativeElement.firstElementChild && this.longTextContainer.nativeElement.firstElementChild.firstElementChild){
      if(this.longTextContainer.nativeElement.firstElementChild.firstElementChild.offsetHeight > this.pixelHeight){
        this.setInitial(true);
        this.isInitiated = true;
        setTimeout(() => this.ref.markForCheck(), 100);
      }
    } 
  }

  ngAfterViewInit() {
    if (this.minHeight.endsWith('em') && !this.seeAll){
      let tempNum = window.getComputedStyle(this.longTextContainer.nativeElement).fontSize.length;
      let fontSize = Number(window.getComputedStyle(this.longTextContainer.nativeElement).fontSize.slice(0, tempNum-2));
      this.pixelHeight = fontSize * Number(this.minHeight.slice(0, this.minHeight.length-2));
    }
    this.longTextContainerOffsetHeight = this.longTextContainer.nativeElement.offsetHeight;
    if (this.longTextContainer.nativeElement.offsetHeight > this.pixelHeight){
      this.setInitial(true);
    }
    else if(this.seeAll && !this.notCollapse){
      this.setInitial(false);
    }
    else{
      this.showButton$.next(false);
       setTimeout(() => this.longTextContainer.nativeElement.click(), 100);
    }
    this.computeMaxHeight();
  }

  toggleExpand(ev){    
    if(ev.currentTarget.classList.contains('clicky-element')){
      this.longTextState = this.longTextState === 'collapsed' ? 'expanded' : 'collapsed';
      if (this.longTextState === 'collapsed'){
        this.scrollPage();
      }
      ev.currentTarget.blur();
    }
  }

  computeMaxHeight(){
    if (this.maxHeight === '*'){
      return;
    }
    let maxPixelHeight;
    if (this.maxHeight.endsWith('em')){
      let tempNum = window.getComputedStyle(this.longTextContainer.nativeElement).fontSize.length;
      let fontSize = Number(window.getComputedStyle(this.longTextContainer.nativeElement).fontSize.slice(0, tempNum-2));
      maxPixelHeight = fontSize * Number(this.maxHeight.slice(0, this.maxHeight.length-2));
    }
    else if (this.maxHeight.endsWith('px')){
      maxPixelHeight = Number(this.maxHeight.slice(0, this.maxHeight.length-2));
    }
    this.maxHeight = Math.min(this.longTextContainerOffsetHeight, maxPixelHeight) + 'px';
  }

  getClasses(){
    let classList = 'long-text-body ';
    classList += this.cssClasses ? this.cssClasses+' ' : ' ';
    return classList;
  }

  setInitial(setCollapsed: boolean){
    this.longTextState = setCollapsed ? 'collapsed' : 'expanded';
    this.longTextContainer.nativeElement.classList.add('clicky-element');
    this.showButton$.next(true);
  }

  scrollPage(){
    let offset = this.longTextContainer.nativeElement.getBoundingClientRect().top;
    if (offset < this.scrollOffset){
      this.longTextContainer.nativeElement.scrollIntoView(true);
      let scrolledY = window.scrollY;
      if (scrolledY){
        window.scroll({
          left: 0, 
          top: scrolledY - this.scrollOffset,
          behavior: 'smooth'
        });
      }
    }
  }

}
