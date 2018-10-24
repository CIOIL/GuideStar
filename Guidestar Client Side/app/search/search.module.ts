import { NgModule }      from '@angular/core';
import { CommonModule }  from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms'

import { SearchComponent }  from './search.component';
import { SearchRoutingModule }    from './search.routing';
import { SearchResultComponent }  from './search-result/search-result.component';
import { AppCommonModule } from '../common/app-common.module';
import { FormsModule } from '@angular/forms'; 
import { SearchResultItemComponent } from './search-result/search-result-item/search-result-item.component';
import { ReCaptchaModule } from 'angular2-recaptcha';

@NgModule({
  imports:      [ CommonModule, FormsModule, AppCommonModule, SearchRoutingModule, ReactiveFormsModule, ReCaptchaModule ],
  declarations: [ SearchComponent, SearchResultComponent, SearchResultItemComponent ],
  providers:    []
})

export class SearchModule {}
