import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { ReCaptchaModule } from 'angular2-recaptcha';


import { LabelValueComponent } from './components/label-value/label-value.component';
import { DemoComponent } from './components/demo/demo.component';
import { HeaderComponent } from './components/header/header.component';
import { DataTableComponent } from './components/data-table/data-table.component';
import { ChevronComponent } from './components/chevron/chevron.component';
import { DataTableListComponent } from './components/data-table-list/data-table-list.component';
import { LinkerComponent } from './components/linker/linker.component';
import { LongTextComponent } from './components/long-text/long-text.component';
import { BooleanIndicatorComponent } from './components/boolean-indicator/boolean-indicator.component';
import { InfoIconComponent } from './components/info-icon/info-icon.component';
import { ChartPieComponent } from './components/chart-pie/chart-pie.component';
import { TooltipDirective } from './directives/tooltip.directive';
import { MarkerDirective } from './directives/marker.directive';
import { AutoCompleteComponent } from './components/auto-complete/auto-complete.component';
import { DoubleSliderComponent } from './components/double-slider/double-slider.component';
import { CheckboxComponent } from './components/checkbox/checkbox.component';
import { MultiPicklistComponent } from './components/multi-picklist/multi-picklist.component';
import { FilterPipe } from './pipes/filter';
import { AppearDirective } from './directives/appear.directive';
import { FooterComponent } from './components/footer/footer.component';
import { RecaptchaComponent } from './components/recaptcha/recaptcha.component';
import { SearchFilterComponent } from './components/search-filter/search-filter.component';

import { RouterModule } from '@angular/router';
import { CountoDirective } from './directives/counto.directive';
import { SideContentComponent } from './components/side-content/side-content.component';
import { DefaultTemplateComponent } from './components/default-template/default-template.component';
import { LoaderComponent } from './components/loader/loader.component';
import { PicklistComponent } from './components/picklist/picklist.component';
import { ErrorPageComponent } from './components/error-page/error-page.component';
import { StringifyListPipe } from './pipes/stringify-list.pipe';
import { SafeHtmlPipe } from './pipes/safe-html.pipe';
import { MainContentComponent } from './components/main-content/main-content.component';

@NgModule({
  declarations: [
    AutoCompleteComponent,
    BooleanIndicatorComponent,
    ChartPieComponent,
    CheckboxComponent,
    ChevronComponent,
    DataTableComponent,
    DataTableListComponent,
    DemoComponent,
    DoubleSliderComponent,
    HeaderComponent,
    InfoIconComponent,
    LabelValueComponent,
    LinkerComponent,
    LongTextComponent,
    MarkerDirective,
    MultiPicklistComponent,
    TooltipDirective,
    FilterPipe,
    AppearDirective,
    FooterComponent,
    RecaptchaComponent,
    CountoDirective,
    SideContentComponent,
    DefaultTemplateComponent,
    SearchFilterComponent,
    LoaderComponent,
    PicklistComponent,
    ErrorPageComponent,
    StringifyListPipe,
    SafeHtmlPipe,
    MainContentComponent
  ],
  exports:[
    AutoCompleteComponent,
    BooleanIndicatorComponent,
    ChartPieComponent,
    CheckboxComponent,
    ChevronComponent,
    DataTableComponent,
    DataTableListComponent,
    DemoComponent,
    DoubleSliderComponent,
    HeaderComponent,
    InfoIconComponent,
    LabelValueComponent,
    LinkerComponent,
    LongTextComponent,
    MarkerDirective,
    MultiPicklistComponent,
    TooltipDirective,
    FilterPipe,
    AppearDirective,
    FooterComponent,
    RecaptchaComponent,
    CountoDirective,
    SideContentComponent,
    DefaultTemplateComponent,
    SearchFilterComponent,
    LoaderComponent,
    PicklistComponent,
    ErrorPageComponent,
    StringifyListPipe,
    SafeHtmlPipe,
    MainContentComponent
  ],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    ReCaptchaModule,
    RouterModule
  ],
  providers: []
})
export class AppCommonModule { }
