import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestSupportDetailComponent } from './test-support-detail.component';

describe('TestSupportDetailComponent', () => {
  let component: TestSupportDetailComponent;
  let fixture: ComponentFixture<TestSupportDetailComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestSupportDetailComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestSupportDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
