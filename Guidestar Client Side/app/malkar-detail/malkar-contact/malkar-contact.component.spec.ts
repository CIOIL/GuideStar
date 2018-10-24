import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarContactComponent } from './malkar-contact.component';

describe('MalkarContactComponent', () => {
  let component: MalkarContactComponent;
  let fixture: ComponentFixture<MalkarContactComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarContactComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarContactComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
