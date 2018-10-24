import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarActivitiesComponent } from './malkar-activities.component';

describe('MalkarActivitiesComponent', () => {
  let component: MalkarActivitiesComponent;
  let fixture: ComponentFixture<MalkarActivitiesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarActivitiesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarActivitiesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
