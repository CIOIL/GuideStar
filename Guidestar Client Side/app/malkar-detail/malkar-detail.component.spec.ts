import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarDetailComponent } from './malkar-detail.component';

describe('MalkarDetailComponent', () => {
  let component: MalkarDetailComponent;
  let fixture: ComponentFixture<MalkarDetailComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarDetailComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
