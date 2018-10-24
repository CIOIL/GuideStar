import { NgModule } from '@angular/core';
import { Routes, RouterModule, PreloadAllModules } from '@angular/router';
import { pages } from '../environments/pages';
import { ContactComponent } from './contact/contact.component';
import { ContactResolver } from './contact/contact.resolver';
import { DefaultTemplateComponent } from './common/components/default-template/default-template.component';
import { ErrorPageComponent } from './common/components/error-page/error-page.component';
import { environment } from '../environments/environment';

export const routes: Routes = [
  { path: pages.malkar, loadChildren: './malkar-detail/malkar-detail.module#MalkarDetailModule' },
  { path: 'he/' + pages.malkar, redirectTo: pages.malkar },
  { path: pages.searchMalkars, loadChildren: './search/search.module#SearchModule'},
  { path: pages.testSupport, loadChildren: './test-support/test-support.module#TestSupportModule'},
  { path: pages.contact, component: ContactComponent, resolve: {data: ContactResolver}},
  { path: 'page/:pageName', component: DefaultTemplateComponent},
  { path: pages.error, component: ErrorPageComponent},
  { path: '', redirectTo: pages.home, pathMatch: 'full'},  
  { path: '**', redirectTo: pages.error}
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { /*preloadingStrategy: PreloadAllModules,*/ useHash: !environment.production })],
  exports: [RouterModule],
  providers: [ContactResolver]
})
export class AppRoutingModule {}