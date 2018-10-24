import { NgModule }      from '@angular/core';
import { CommonModule }  from '@angular/common';

import { MalkarDetailComponent }  from './malkar-detail.component';
import { MalkarDetailRoutingModule }    from './malkar-detail.routing';
import { FormsModule } from '@angular/forms';
import { MalkarMenuComponent } from './malkar-menu/malkar-menu.component';
import { MalkarInfoComponent } from './malkar-info/malkar-info.component';
import { MalkarDocumentsComponent } from './malkar-documents/malkar-documents.component';
import { MalkarGovSupportComponent } from './malkar-gov-support/malkar-gov-support.component';
import { MalkarGovServicesComponent } from './malkar-gov-services/malkar-gov-services.component';
import { MalkarDonationsComponent } from './malkar-donations/malkar-donations.component';
import { MalkarPeopleComponent } from './malkar-people/malkar-people.component';
import { MalkarActivitiesComponent } from './malkar-activities/malkar-activities.component';
import { MalkarContactComponent } from './malkar-contact/malkar-contact.component';
import { AppCommonModule } from '../common/app-common.module';
import { AgmCoreModule } from '@agm/core';
import { AgmJsMarkerClustererModule } from '@agm/js-marker-clusterer';
import { AgmSnazzyInfoWindowModule } from '@agm/snazzy-info-window';
import { ReCaptchaModule } from 'angular2-recaptcha';
import { MalkarMenuMobileComponent } from './malkar-menu-mobile/malkar-menu-mobile.component';
import { AppParams } from '../common/enums/app-params';
import { MalkarVolunteeringComponent } from './malkar-volunteering/malkar-volunteering.component';
import { MalkarMapComponent } from './malkar-map/malkar-map.component';
import { MalkarAssetsComponent } from './malkar-assets/malkar-assets.component';
import { MalkarTrusteesComponent } from './malkar-trustees/malkar-trustees.component';


@NgModule({
  imports:      [ CommonModule, 
                  FormsModule, 
                  AgmCoreModule.forRoot({
                      apiKey: <any>AppParams.GoogleMapsPublicKey
                    }), 
                  AgmJsMarkerClustererModule,
                  AgmSnazzyInfoWindowModule,
                  ReCaptchaModule,
                  MalkarDetailRoutingModule, 
                  AppCommonModule ],
  declarations: [ MalkarDetailComponent, MalkarMenuComponent, MalkarInfoComponent, MalkarDocumentsComponent, MalkarGovSupportComponent, MalkarGovServicesComponent, MalkarDonationsComponent, MalkarPeopleComponent, MalkarActivitiesComponent, MalkarContactComponent, MalkarMenuMobileComponent, MalkarVolunteeringComponent, MalkarMapComponent, MalkarAssetsComponent, MalkarTrusteesComponent ],
  providers:    []
})
export class MalkarDetailModule {}
