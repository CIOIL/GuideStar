import { Component, OnInit, Input, ViewChild, ElementRef, ViewContainerRef, ChangeDetectionStrategy, Renderer2 } from '@angular/core';
import * as _ from 'lodash';
import { RouterModule, Router } from '@angular/router';
import { element } from 'protractor';

@Component({
  selector: 'app-main-content',
  templateUrl: './main-content.component.html',
  styleUrls: ['./main-content.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MainContentComponent implements OnInit {

  private _content: any;
  get content(): any {return this._content};
  @Input() set content(newcontent: any){
    this._content = newcontent;
    this.prepareStyles();
    setTimeout(() => this.activateRouterLinksObservers(), 100);
  }

  @ViewChild('mainContent') mainContent: ViewContainerRef;

  @Input() hideTitle: boolean = false;
  @Input() style: any;
  
  listenClickFunc: Function;
  contentBody: string;
  contentStyle: string;
  cmpRef: any;
  $Label: any;

  constructor(private element: ElementRef, private router: Router, private renderer: Renderer2) { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    //this.prepareStyles();
  }

  prepareStyles(){
    const styleImg = 'class="embedded-image" style="height: auto; width: auto;"';
    this.contentBody = _.replace(this.content.Body, /<img/g, '<img ' + styleImg);
    this.contentBody = _.replace(this.contentBody, /<ul/g, '<ul style="padding-right: 40px;"');
    this.contentBody = _.replace(this.contentBody, /<a href="\//g, '<a style="color: #167bad; cursor: pointer" routerLink="/');
    // this.contentBody = _.replace(this.contentBody, /<br>/g, '<br/>');
    this.contentBody = _.replace(this.contentBody, /><\/img>/g, styleImg + '/>');
    this.contentBody = _.replace(this.contentBody, /<p><b>/g, '<p><b role="heading" aria-level="2" style="color: #167bad; font-size: 1.25em; font-weight: bold;">');
    this.contentBody = _.replace(this.contentBody, /<p><br><b>/g, '<p><br><b role="heading" aria-level="2" style="color: #167bad; font-size: 1.25em; font-weight: bold;">');
  }

  getStyle(){
    let style = this.style ? this.style : '';
    return style;
  }

  activateRouterLinksObservers(){
    if(this.element && this.element.nativeElement){ 
      const navigationElements = this.element.nativeElement.querySelectorAll('a[routerLink]');
      if(navigationElements){
        navigationElements.forEach(elem => {
          this.listenClickFunc = this.renderer.listen(elem, 'click', (event) => {
            event.preventDefault();
            this.router.navigate([elem.getAttribute('routerLink')]);
          });
        });
      }
    }
  }

  ngOnDestroy() {
    if(this.listenClickFunc){
      this.listenClickFunc();
    }
  }

}
