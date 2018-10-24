import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarDonationsComponent } from './malkar-donations.component';

describe('MalkarDonationsComponent', () => {
  let component: MalkarDonationsComponent;
  let fixture: ComponentFixture<MalkarDonationsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarDonationsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarDonationsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
