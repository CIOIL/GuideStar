import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MalkarMenuComponent } from './malkar-menu.component';

describe('MalkarMenuComponent', () => {
  let component: MalkarMenuComponent;
  let fixture: ComponentFixture<MalkarMenuComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MalkarMenuComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MalkarMenuComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
