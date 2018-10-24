import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarGovSupportComponent } from './malkar-gov-support.component';

describe('MalkarGovSupportComponent', () => {
  let component: MalkarGovSupportComponent;
  let fixture: ComponentFixture<MalkarGovSupportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarGovSupportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarGovSupportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
