import { APP_BASE_HREF, CommonModule, DecimalPipe, DatePipe } from '@angular/common';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { Title, Meta } from '@angular/platform-browser';
import { NgModule, ApplicationRef, ErrorHandler } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { AgmCoreModule } from '@agm/core';
import { HttpModule } from '@angular/http';
import { StoreModule } from '@ngrx/store';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { ReactiveFormsModule } from '@angular/forms';

import { AppCommonModule } from './common/app-common.module';
import { HomeModule } from './home/home.module';
import { SearchModule } from './search/search.module';
import { MalkarDetailModule } from './malkar-detail/malkar-detail.module';

import { AppRoutingModule } from './app.routing';
import { AppComponent } from './app.component';

import { environment } from '../environments/environment';
import { searchReducer } from './search/search.reducer';
import { malkarReducer }  from './malkar-detail/malkar-detail.reducer';
import { searchConfigReducer } from './search/search-config.reducer';
import { homeReducer } from './home/home.reducer';
import { ContactComponent } from './contact/contact.component';
import { RouterModule } from '@angular/router';
import { ReCaptchaModule } from 'angular2-recaptcha';
import { ContactService } from './contact/contact.service';
import { commonReducer } from './common/ngrx/common.reducer';
import { testSupportReducer } from './test-support/test-support.reducer';
import { FilterPipe } from './common/pipes/filter';
import { GlobalErrorHandler } from './common/utils/global-error-handler';
import { ExcelService } from './common/services/excel.service';


@NgModule({
  declarations: [
    AppComponent,
    ContactComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    HttpModule,
    RouterModule,
    ReactiveFormsModule,
    ReCaptchaModule,
    StoreModule.forRoot({
      common: commonReducer, 
      malkar: malkarReducer, 
      malkars: searchReducer, 
      searchConfig: searchConfigReducer, 
      testSupports: testSupportReducer,
      home: homeReducer
    }),
    !environment.production ? StoreDevtoolsModule.instrument({ maxAge: 50 }) : [],
    BrowserAnimationsModule,
    AppCommonModule,
    HomeModule,
    AppRoutingModule
  ],
  providers: [
    {provide: ErrorHandler, useClass: GlobalErrorHandler},
    DecimalPipe,
    FilterPipe,
    DatePipe,
    Title,
    Meta
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
