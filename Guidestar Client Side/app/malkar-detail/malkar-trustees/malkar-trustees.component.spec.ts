import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarTrusteesComponent } from './malkar-trustees.component';

describe('MalkarTrusteesComponent', () => {
  let component: MalkarTrusteesComponent;
  let fixture: ComponentFixture<MalkarTrusteesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarTrusteesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarTrusteesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
