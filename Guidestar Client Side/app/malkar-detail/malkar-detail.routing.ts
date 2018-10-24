import { NgModule }            from '@angular/core';
import { RouterModule }        from '@angular/router';
import { MalkarDetailComponent } from './malkar-detail.component';
import { MalkarInfoComponent } from './malkar-info/malkar-info.component';
import { MalkarDocumentsComponent } from './malkar-documents/malkar-documents.component';
import { MalkarGovSupportComponent } from './malkar-gov-support/malkar-gov-support.component';
import { MalkarGovServicesComponent } from './malkar-gov-services/malkar-gov-services.component';
import { MalkarDonationsComponent } from './malkar-donations/malkar-donations.component';
import { MalkarPeopleComponent } from './malkar-people/malkar-people.component';
import { MalkarActivitiesComponent } from './malkar-activities/malkar-activities.component';
import { MalkarContactComponent } from './malkar-contact/malkar-contact.component';
import { MalkarDetailResolver } from './malkar-detail.resolver';
import { MalkarVolunteeringComponent } from './malkar-volunteering/malkar-volunteering.component';
import { malkarPages } from './malkar-detail.pages';
import { MalkarAssetsComponent } from './malkar-assets/malkar-assets.component';
import { MalkarTrusteesComponent } from './malkar-trustees/malkar-trustees.component';

@NgModule({
  imports: [RouterModule.forChild([
    { path: ':num', component: MalkarDetailComponent, resolve: {MalkarDetailResolver},
      children:[
        {path: '', component: MalkarInfoComponent},
        {path: malkarPages.info, redirectTo: ''},
        {path: malkarPages.documents, component: MalkarDocumentsComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.govsupport, component: MalkarGovSupportComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.govservices, component: MalkarGovServicesComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.donations, component: MalkarDonationsComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.people, component: MalkarPeopleComponent, resolve: {MalkarDetailResolver}},
        // {path: malkarPages.activities, component: MalkarActivitiesComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.contact, component: MalkarContactComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.volunteering, component: MalkarVolunteeringComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.assets, component: MalkarAssetsComponent, resolve: {MalkarDetailResolver}},
        {path: malkarPages.trustees, component: MalkarTrusteesComponent, resolve: {MalkarDetailResolver}},
        {path: '**', redirectTo: 'info'}
      ],
    }
  ])],
  exports: [RouterModule],
  providers: [MalkarDetailResolver]
})
export class MalkarDetailRoutingModule {}