import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarInfoComponent } from './malkar-info.component';

describe('MalkarInfoComponent', () => {
  let component: MalkarInfoComponent;
  let fixture: ComponentFixture<MalkarInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
