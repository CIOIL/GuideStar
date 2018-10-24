import { Component, OnInit, Input, ViewChild, ViewContainerRef, ChangeDetectionStrategy, ElementRef, Renderer2 } from '@angular/core';
import * as _ from 'lodash';
import { RouterModule, Router } from '@angular/router';

@Component({
  selector: 'app-side-content',
  templateUrl: './side-content.component.html',
  styleUrls: ['./side-content.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SideContentComponent implements OnInit {

  private _content: any;
  get content(): any {return this._content};
  @Input() set content(newcontent: any){
    this._content = newcontent;
    this.prepareStyles();
    setTimeout(() => this.activateRouterLinksObservers(), 100);
  }

  @ViewChild('sideContent', { read: ViewContainerRef }) sideContent: ViewContainerRef;

  listenClickFunc: Function;
  contentBody: string;
  contentStyle: string;
  $Label: any;
  cmpRef: any;

  constructor(private element: ElementRef, private router: Router, private renderer: Renderer2) { 
    this.$Label = window['$Label'];
  }

  ngOnInit() {
    //this.prepareStyles();
  }

  prepareStyles(){
    // this.contentBody = '<style>ul{list-style: none;} li{margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0.5em; border-top: 1px dashed #aec8ca;} li:first-child{border: none}</style>';
    // this.contentBody += this.content.Body;
    // this.content.Body = '<ul style="list-style: none"><li style="margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0; border-top: 1px dashed #aec8ca;">List Item 1</li><li style="margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0; border-top: 1px dashed #aec8ca;">List Item 2</li><li style="margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0; border-top: 1px dashed #aec8ca;">List Item 3</li></ul>';
    this.contentBody = _.replace(this.content.Body, '<ul>', '<ul style="list-style: none">');
    this.contentBody = _.replace(this.contentBody, /<li>/g, '<li style="margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0.5em; border-top: 1px dashed #aec8ca;">');
    this.contentBody = _.replace(this.contentBody, '<li style="margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0.5em; border-top: 1px dashed #aec8ca;">', '<li style="margin: 0 0 0.875em 0; padding: 0.75em 1em 0 0.5em;">');
    this.contentBody = _.replace(this.contentBody, /<div>/g, '<div style="padding: 0 1em 0 0.5em;">');
    this.contentBody = _.replace(this.contentBody, /<a href="\//g, '<a style="color: #167bad; cursor: pointer" routerLink="/');
    // this.contentBody = _.replace(this.contentBody, /&gt;/g, '>');
    // this.contentBody = _.replace(this.contentBody, /&lt;/g, '<');
    // this.contentBody = _.replace(this.contentBody, /&quot;/g, '"');
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
