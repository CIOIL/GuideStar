import { Component, OnInit, Input, ChangeDetectionStrategy } from '@angular/core';
import { pages } from '../../../environments/pages';
import { malkarPages } from '../malkar-detail.pages';

@Component({
  selector: 'app-malkar-menu',
  templateUrl: './malkar-menu.component.html',
  styleUrls: ['./malkar-menu.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MalkarMenuComponent implements OnInit {

  @Input() menuItemHideMap: any;
  @Input() malkarNum: string;
  @Input() currentMenuItem: string;

  showMenu: boolean = true;
  currentItem: any;
  $Label: any;
  pages: any;
  malkarPages: any;

  constructor() { 
    this.$Label = window['$Label'];
    this.pages = pages;
    this.malkarPages = malkarPages;
  }

  ngOnInit() {
    
  }

  menuClicked(ev){
    ev.target.blur();
  }

  enterHit(ev){
    ev.target.click();
  }

  getClasses(id){
    let classList = ' malkar-menu-item ';
    let locId = window.location.href.substr(window.location.href.lastIndexOf('/')+1);
    this.currentItem = document.getElementById(id);
    if (id === locId || locId.startsWith(id) || (!isNaN(Number(locId)) && id === malkarPages.info) ){
      classList +=' malkar-menu-item-active ';
      if (this.currentItem ){
        if (this.currentItem.previousElementSibling){
          this.currentItem.previousElementSibling.classList.add('bottom-border-transparent');
        }
        else{
          this.currentItem.classList.add('top-border-transparent');
        }
      }
    }
    else{
      if (this.currentItem ){
        if (this.currentItem.previousElementSibling){
          this.currentItem.previousElementSibling.classList.remove('bottom-border-transparent');
        }
        else{
          this.currentItem.classList.remove('top-border-transparent');
        }
      }
    }
    return classList;
  }

  mobileMenuClicked(ev){
    let menuItems = document.getElementsByClassName('malkar-menu-item'); 
    if (this.showMenu){
      for (let i=0; i< menuItems.length; i++){
        (menuItems[i] as HTMLElement).style.display = 'block';
      }
    }
    else{
      for (let i=0; i< menuItems.length; i++){
        if (menuItems[i].id != ev.target.id){
          (menuItems[i] as HTMLElement).style.display = 'none';
        }
      }
    }
    this.showMenu = !this.showMenu;
  }

}
