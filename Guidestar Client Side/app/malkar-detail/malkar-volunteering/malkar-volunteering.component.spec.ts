import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarVolunteeringComponent } from './malkar-volunteering.component';

describe('MalkarVolunteeringComponent', () => {
  let component: MalkarVolunteeringComponent;
  let fixture: ComponentFixture<MalkarVolunteeringComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarVolunteeringComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarVolunteeringComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
