import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarDocumentsComponent } from './malkar-documents.component';

describe('MalkarDocumentsComponent', () => {
  let component: MalkarDocumentsComponent;
  let fixture: ComponentFixture<MalkarDocumentsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarDocumentsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarDocumentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
