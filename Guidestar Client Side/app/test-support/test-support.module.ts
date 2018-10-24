import { NgModule }      from '@angular/core';
import { CommonModule }  from '@angular/common';

import { AppCommonModule } from '../common/app-common.module';
import { FormsModule } from '@angular/forms'; 
import { TestSupportRoutingModule } from './test-support.routing';
import { TestSupportComponent } from './test-support.component';
import { TestSupportDetailComponent } from './test-support-detail/test-support-detail.component';

@NgModule({
  imports:      [ CommonModule, FormsModule, AppCommonModule, TestSupportRoutingModule ],
  declarations: [ TestSupportComponent, TestSupportDetailComponent ],
  providers:    []
})

export class TestSupportModule {}
