import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarGovServicesComponent } from './malkar-gov-services.component';

describe('MalkarGovServicesComponent', () => {
  let component: MalkarGovServicesComponent;
  let fixture: ComponentFixture<MalkarGovServicesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarGovServicesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarGovServicesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
