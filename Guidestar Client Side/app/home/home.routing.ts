import { NgModule }            from '@angular/core';
import { RouterModule }        from '@angular/router';
import { HomeComponent } from './home.component';
import { HomeResolver } from './home.resolver';
import { pages } from '../../environments/pages';


@NgModule({
  imports: [RouterModule.forChild([
    { path: pages.home, component: HomeComponent, resolve: {HomeResolver}}
  ])],
  exports: [RouterModule],
  providers: [ HomeResolver ]
})
export class HomeRoutingModule {}