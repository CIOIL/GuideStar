import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestSupportComponent } from './test-support.component';

describe('TestSupportComponent', () => {
  let component: TestSupportComponent;
  let fixture: ComponentFixture<TestSupportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestSupportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestSupportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
