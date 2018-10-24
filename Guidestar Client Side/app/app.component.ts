import { Component, OnInit, OnDestroy, Renderer2, ViewChild, HostListener } from '@angular/core';
import { Router, NavigationEnd, NavigationStart } from '@angular/router';
import { Subscription } from 'rxjs';
import { pages } from '../environments/pages';
import { HeaderComponent } from './common/components/header/header.component';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  providers: []
})
export class AppComponent implements OnInit, OnDestroy{

  @ViewChild(HeaderComponent) headerComponent: HeaderComponent;

  @HostListener('click', ['$event'])
  onClick(event){
    if (!this.headerComponent.headerContainer.nativeElement.contains(event.target)){
      this.headerComponent.closeDialogs();
    }
  }
  
  $Label: any;
  menuItems: any;
  sideItems: any;
  loading: boolean;
  subs: Subscription[] = [];

  constructor(private router: Router, private renderer: Renderer2){
    this.$Label = window['$Label'];
    this.subs.push(router.events.subscribe(event => {
      if(event instanceof NavigationStart) {
        this.loading = true;
        
      }
      if(event instanceof NavigationEnd) {
        this.loading = false;
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
        let skipTo = document.getElementById('dummyLink');
        skipTo.focus();
        skipTo.blur();
      }
    }));
  }

  ngOnInit(){
    this.menuItems = [{'text' : this.$Label.Main, 'link' : [pages.home]}, 
                      {'text' : this.$Label.About, 'link' : [pages.generic, pages.about]}, 
                      {'text' : this.$Label.All_Malkars, 'link' : [pages.searchMalkars, '']}, 
                      {'text' : this.$Label.Support_tests, 'link' : [pages.testSupport]}, 
                      {'text' : this.$Label.KnowledgeBase, 'link' :  [pages.generic, pages.knowledgeBase]},
                      {'text' : this.$Label.Contact_us, 'link' :  [pages.contact]}];

    this.sideItems = [{'text' : this.$Label.Join_Login, 'icon' : 'fa fa-user', 'link' : [pages.generic, pages.login]},
                      {'text' : this.$Label.Accessibility, 'icon' : 'fa fa-universal-access', 'caret' : true}];
                      // {'text' : this.$Label.Accessibility, 'icon' : 'fa fa-wheelchair-alt', 'link' : '#'}];
  }

  ngOnDestroy(){
    for (let i=0; i<this.subs.length; i++){
      this.subs[i].unsubscribe();
    }
  }

  skipToContent(ev){
    ev.preventDefault();
    let content = document.getElementById('mainContent');
    ev.currentTarget.blur();
    this.renderer.setAttribute(content, 'tabindex', '-1');
    content.focus();
    this.renderer.removeAttribute(content, 'tabindex');
  }
}
