import { NgModule }            from '@angular/core';
import { RouterModule }        from '@angular/router';
import { SearchComponent } from './search.component';
import { SearchResolver } from './search.resolver';


@NgModule({
  imports: [RouterModule.forChild([
    { path: ':str', component: SearchComponent, resolve: {search: SearchResolver} },
    { path: '', component: SearchComponent, resolve: {search: SearchResolver} }
  ])],
  exports: [RouterModule],
  providers: [SearchResolver]
})
export class SearchRoutingModule {}