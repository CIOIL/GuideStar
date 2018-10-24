import { NgModule }           from '@angular/core';
import { CommonModule }       from '@angular/common';
import { FormsModule }        from '@angular/forms';
import { ReactiveFormsModule } from '@angular/forms'

import { HomeRoutingModule }   from './home.routing';
import { HomeComponent } from './home.component';
import { AppCommonModule } from '../common/app-common.module';

@NgModule({
  imports:      [ CommonModule, FormsModule, AppCommonModule, HomeRoutingModule, ReactiveFormsModule ], 
  declarations: [ HomeComponent ],
  providers:    []
})
export class HomeModule { }