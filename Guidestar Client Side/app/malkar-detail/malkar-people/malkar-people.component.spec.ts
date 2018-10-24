import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarPeopleComponent } from './malkar-people.component';

describe('MalkarPeopleComponent', () => {
  let component: MalkarPeopleComponent;
  let fixture: ComponentFixture<MalkarPeopleComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarPeopleComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarPeopleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
