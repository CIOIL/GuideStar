import { NgModule }            from '@angular/core';
import { RouterModule }        from '@angular/router';
import { TestSupportComponent } from './test-support.component';
// import { TestSupportResolver } from './test-support.resolver';
import { TestSupportDetailComponent } from './test-support-detail/test-support-detail.component';


@NgModule({
  imports: [RouterModule.forChild([
    { path: ':str', component: TestSupportDetailComponent /*, resolve: {TestSupport: TestSupportResolver} */},
    { path: '', component: TestSupportComponent /*, resolve: {TestSupport: TestSupportResolver} */}
  ])],
  exports: [RouterModule],
  providers: [/*TestSupportResolver*/]
})
export class TestSupportRoutingModule {}